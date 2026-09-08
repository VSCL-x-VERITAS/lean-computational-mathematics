"""Revalidate closed rows with their exact manifest-bound sealed-v1 configurations.

Inventory mode is read-only preparation, not audit validation. Validation mode
runs the unchanged complete validator. Stronger support additionally requires
the exact pinned smooth-bridge or production applicability and native nonvacuity evidence.
Neither mode writes a gate, judgment, or audit artifact.
"""
from pathlib import Path
import argparse
import hashlib
import importlib.util
import json
import os
import subprocess
import sys


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--validate', action='store_true')
    parser.add_argument('--require-all-closed', action='store_true')
    args = parser.parse_args()
    session = Path(__file__).resolve().parent
    root = session.parents[3]
    spec = importlib.util.spec_from_file_location(
        'stronger_evidence_checks', session / 'bind-audited-stronger-reused-row.py')
    stronger = importlib.util.module_from_spec(spec)
    if spec.loader is None:
        raise ValueError('cannot load local stronger-evidence checks')
    spec.loader.exec_module(stronger)  # Importing does not invoke its mutation entry point.
    read, sha, require = stronger.read, stronger.sha, stronger.require
    production_path = session / 'bind-audited-stronger-production-rows.py'
    require(sha(production_path) == '2b6e6d26931f831970479cfdae30f066d3712586363ef08e6ce0b830306782d6',
            'Pinned production stronger checker changed')
    pspec = importlib.util.spec_from_file_location('production_stronger_checks', production_path)
    production = importlib.util.module_from_spec(pspec)
    require(pspec.loader is not None, 'Missing production evidence loader')
    pspec.loader.exec_module(production)
    gate = read(root / 'gates/leveque-finite-volume/chapter-01.json')
    closed_statuses = {'PROVED', 'REUSED', 'DISCREPANCY'}
    rows = sorted([row for row in gate['rows'] if row['status'] in closed_statuses],
                  key=lambda row: row['id'])
    require(bool(rows), 'no closed Lean rows')
    if args.require_all_closed:
        require(all(row['status'] in closed_statuses | {'SKIPPED'} for row in gate['rows']),
                'the chapter still has open inventory rows')
    inventory = []
    expected_pairs = {'faithful-equivalent': ('yes', 'yes'), 'faithful-stronger': ('yes', 'no')}
    directions = ('lean_implies_source', 'source_implies_lean')
    for row in rows:
        require(row['status'] != 'DISCREPANCY',
                'Discrepancy acceptance requires its separate witness/correction protocol.')
        task_path = stronger.repository_path(root, row['faithfulness_task'])
        task = read(task_path)
        output = stronger.repository_path(root, task['audit_output'])
        manifest = read(output / 'manifest.json')
        require(manifest['task_id'] == task['task_id']
                and stronger.bound_file(root, manifest['task_metadata']) == task_path,
                f"{row['id']}: task metadata is not the exact sealed task")
        require(stronger.repository_path(root, row['faithfulness_decision']) == output / 'decision.json',
                f"{row['id']}: decision path differs from the task")
        require(row['lean_declarations'] == [task['target']['declaration']]
                and manifest['target']['declaration'] == task['target']['declaration'],
                f"{row['id']}: target declaration mismatch")
        require(stronger.bound_file(root, manifest['target'])
                == stronger.repository_path(root, task['target']['path']),
                f"{row['id']}: target source mismatch")
        decision = read(output / 'decision.json')
        classification = decision.get('classification')
        require(decision.get('task_id') == task['task_id'] and decision.get('accepted') is True
                and classification in expected_pairs, f"{row['id']}: audit is not accepted")
        expected = expected_pairs[classification]
        require(tuple(decision['implications'][key]['verdict'] for key in directions) == expected,
                f"{row['id']}: sealed classification and implication pair disagree")
        require(row.get('classification') == classification
                and tuple(row.get(key) for key in directions) == expected,
                f"{row['id']}: row classification/implications differ from the sealed decision")
        config = stronger.exact_manifest_config(root, manifest)
        record = {
            'row': row['id'], 'task': task['task_id'], 'declaration': task['target']['declaration'],
            'classification': classification,
            'lean_implies_source': expected[0], 'source_implies_lean': expected[1],
            'config': {'path': config.relative_to(root).as_posix(), 'sha256': sha(config)},
            'manifest_sha256': sha(output / 'manifest.json'),
            'decision_sha256': sha(output / 'decision.json'),
        }
        if classification == 'faithful-stronger':
            require(decision.get('adjudicated') is True
                    and row.get('adjudication_required') is True
                    and row.get('adjudication_status') == 'resolved',
                    f"{row['id']}: stronger acceptance requires resolved independent adjudication")
            evidence_path = stronger.bound_file(root, row.get('strengthening_evidence'))
            selected = stronger if row['id'] == stronger.ROW_ID else production
            selected.validate_strengthening_evidence(root, task_path, task, manifest, decision,
                                                     evidence_path, row=row)
            adjudication = row.get('adjudication_audit', '')
            require(isinstance(adjudication, str) and sha(output / 'decision.json') in adjudication
                    and sha(evidence_path) in adjudication and 'both directions' not in adjudication.lower(),
                    f"{row['id']}: adjudication prose must acknowledge the bound strengthening")
            record['strengthening_evidence'] = row['strengthening_evidence']
            record['native_nonvacuity_checks'] = 'exact source/output/exit hashes, command, actual zero exit and allowed axioms verified'
        if args.validate:
            env = dict(os.environ, FAITHFULNESS_AUDIT_CONFIG=str(config))
            command = [sys.executable, '-B', str(root / '.faithfulness-audit/scripts/validate_audit.py'),
                       str(task_path), '--phase', 'complete']
            run = subprocess.run(command, cwd=root, env=env, stdout=subprocess.PIPE,
                                 stderr=subprocess.STDOUT)
            record.update({'command': command, 'exit_code': run.returncode,
                           'output_sha256': hashlib.sha256(run.stdout).hexdigest()})
            if run.returncode:
                sys.stdout.buffer.write(run.stdout)
                print(json.dumps(record))
                return run.returncode
        inventory.append(record)
    print(json.dumps({'mode': 'released-complete-validation' if args.validate else 'inventory-only-not-validation',
                      'closed_rows': len(rows), 'records': inventory}, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
