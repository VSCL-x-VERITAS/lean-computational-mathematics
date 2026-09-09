"""Revalidate closed rows with their exact manifest-bound sealed-v1 configurations.

Inventory mode is read-only preparation, not audit validation. Validation mode
runs the unchanged complete validator. Stronger support additionally requires
the exact pinned smooth-bridge or production applicability and native nonvacuity evidence.
The additive nine-row branch checks explicit coordinator attribution, native evidence and exact interpretation bindings.
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

import qualified_row_support_dim_roots_v1 as qualified


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--validate', action='store_true')
    parser.add_argument('--require-all-closed', action='store_true')
    parser.add_argument('--gate-input', type=Path)
    parser.add_argument('--gate-input-sha256')
    args = parser.parse_args()
    session = Path(__file__).resolve().parents[2]
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
    consensus_path = session / 'bind-variable-consensus-stronger-row.py'
    require(sha(consensus_path) == 'e4b0e2d242e7fc7e91e955e3c828bc43992cc4748493c2f4b0d2bea2716f8b4c',
            'Pinned stronger consensus checker changed')
    cspec = importlib.util.spec_from_file_location('variable_consensus_checks', consensus_path)
    consensus = importlib.util.module_from_spec(cspec)
    require(cspec.loader is not None, 'Missing consensus evidence loader')
    cspec.loader.exec_module(consensus)
    gate_path = root / 'gates/leveque-finite-volume/chapter-01.json'
    require((args.gate_input is None) == (args.gate_input_sha256 is None),
            'proposal path and exact hash must be supplied together')
    proposal = None
    if args.gate_input is not None:
        require(args.validate, 'proposal validation requires --validate')
        selected_gate = args.gate_input.resolve()
        require(selected_gate.is_relative_to(root.resolve()) and selected_gate != gate_path.resolve(),
                'proposal must be separate repository evidence')
        require(sha(selected_gate) == args.gate_input_sha256, 'proposal hash mismatch')
        proposal = {'path': selected_gate.relative_to(root).as_posix(), 'sha256': sha(selected_gate)}
    else:
        selected_gate = gate_path
    gate = read(selected_gate)
    qualified.validate_preserved_rows(gate)
    _, selected_rows = qualified.choices()
    checker = qualified.gate_checker() if args.validate else None
    context = checker.current_context(gate_path, 1) if checker else None
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
        if row['id'] in selected_rows:
            checked = qualified.validate_bound_row(row)
            require(checked['config'] == config, 'qualified exact configuration mismatch')
            if args.validate:
                require(checked['request']['current_bindings'] == context['bindings'],
                        'qualified request requires a current-fingerprint rebind')
                require(not checker.row_artifact_defects(row, 1, context, gate_path.parent, set(), location=row['id']),
                        'qualified row artifacts do not bind current context')
            record['qualified_binding_request'] = row['qualified_binding_request']
            record['coordinator_selected_interpretation'] = row['coordinator_selected_interpretation']
            record['native_evidence'] = row['native_evidence']
            record['native_axioms'] = checked['axioms']
            if checked['refinement'] is not None:
                record['interpretation_refinement_ref'] = checked['refinement']['reference']
            if checked['source_context'] is not None:
                record.update(checked['source_context']['refs'])
            if classification == 'faithful-stronger':
                record['strengthening_evidence'] = row['strengthening_evidence']
        elif classification == 'faithful-stronger' and row['id'] == 'LEV-CH01-VARIABLE-COEFFICIENT-NONCONSERVATION':
            require(decision.get('adjudicated') is False
                    and row.get('adjudication_required') is False
                    and not row.get('adjudication_status') and not row.get('adjudication_audit'),
                    'The pinned agreeing audit must preserve the absence of adjudication')
            evidence_path = stronger.bound_file(root, row.get('strengthening_evidence'))
            consensus.validate_strengthening_evidence(root, task_path, task, manifest, decision,
                                                      evidence_path, row=row)
            record['strengthening_evidence'] = row['strengthening_evidence']
            record['native_nonvacuity_checks'] = 'exact source/output/exit hashes, command, actual zero exit and allowed axioms verified'
            record['independent_consensus'] = 'Both original judges agree on yes/no faithful-stronger; no adjudication trigger or adjudicator was recorded.'
        elif classification == 'faithful-stronger':
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
    if proposal is not None:
        require(sha(selected_gate) == proposal['sha256'], 'proposal changed during validation')
    result = {'mode': 'released-complete-validation' if args.validate else 'inventory-only-not-validation',
              'closed_rows': len(rows), 'records': inventory}
    if proposal is not None:
        result['validated_gate_input'] = proposal
        result['current_bindings'] = context['bindings']
    print(json.dumps(result, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
