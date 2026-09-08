"""Bind a completed, validated successor audit to one integrated reused row.

This adapter never generates a semantic decision or changes an audit input.
It validates the sealed audit before projecting its accepted evidence into
the legacy chapter gate. Global checks remain explicitly open after a row edit.
"""
from __future__ import annotations

import argparse
import copy
import hashlib
import importlib.util
import json
import os
from pathlib import Path
import re
import subprocess
import sys


def read(path: Path):
    return json.loads(path.read_text(encoding='utf-8'))


def encode(value) -> bytes:
    return (json.dumps(value, indent=2, ensure_ascii=False) + '\n').encode('utf-8')


def immutable_write(path: Path, value) -> None:
    payload = encode(value)
    if path.exists():
        if path.read_bytes() != payload:
            raise ValueError(f'will not overwrite different immutable evidence: {path}')
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(payload)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gate-checker', type=Path, required=True)
    parser.add_argument('--gate', type=Path, required=True)
    parser.add_argument('--task', type=Path, required=True)
    parser.add_argument('--row', required=True)
    parser.add_argument('--resolution-log', type=Path, required=True)
    args = parser.parse_args()
    gate_path = args.gate.resolve()
    task_path = args.task.resolve()
    spec = importlib.util.spec_from_file_location('leveque_gate', args.gate_checker.resolve())
    checker = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(checker)
    context = checker.current_context(gate_path, 1)
    root = context['lean_root']
    task = read(task_path)
    output = root / task['audit_output']
    if not os.environ.get('FAITHFULNESS_AUDIT_CONFIG'):
        raise ValueError('select the exact successor audit configuration explicitly')
    # The unchanged sealed validator, not this adapter, decides completeness.
    subprocess.run([sys.executable, str(root / '.faithfulness-audit/scripts/validate_audit.py'),
                    str(task_path), '--phase', 'complete'], cwd=root, check=True)
    decision = read(output / 'decision.json')
    if decision.get('accepted') is not True or decision.get('classification') != 'faithful-equivalent':
        raise ValueError('ordinary reuse adapter requires an accepted equivalent audit')
    for direction in ('lean_implies_source', 'source_implies_lean'):
        if decision['implications'][direction]['verdict'] != 'yes':
            raise ValueError(f'audit does not establish {direction}')
    source_path = root / task['source']['path']
    if hashlib.sha256(source_path.read_bytes()).hexdigest() != checker.PINNED_SOURCE_SHA256:
        raise ValueError('selected source hash mismatch')
    declaration = task['target']['declaration']
    resolution = args.resolution_log.read_text(encoding='utf-8-sig')
    if declaration not in resolution or f"'{declaration}' depends on axioms:" not in resolution:
        raise ValueError('missing exact declaration and axiom resolution evidence')
    axiom_match = re.search(
        re.escape(f"'{declaration}' depends on axioms:") + r"\s*\[([^\]]*)\]",
        resolution)
    if axiom_match is None:
        raise ValueError('cannot parse declaration-specific axiom evidence')
    actual_axioms = {a.strip() for a in axiom_match.group(1).split(',') if a.strip()}
    if not actual_axioms <= {'propext', 'Classical.choice', 'Quot.sound'}:
        raise ValueError(f'unexpected axioms: {sorted(actual_axioms)}')
    resolution_sha = hashlib.sha256(args.resolution_log.read_bytes()).hexdigest()
    baseline = context['bindings']['lean_git_head']
    subprocess.run(['git', 'merge-base', '--is-ancestor', baseline, 'HEAD'], cwd=root, check=True)
    subprocess.run(['git', 'cat-file', '-e', baseline + ':' + task['target']['path']], cwd=root, check=True)
    subprocess.run(['git', 'diff', '--exit-code', baseline, '--', task['target']['path']], cwd=root, check=True)

    gate = read(gate_path)
    original_bytes = gate_path.read_bytes()
    row = next(r for r in gate['rows'] if r['id'] == args.row)
    if row['status'] not in ('READY', 'IN_PROGRESS'):
        raise ValueError('row is not an open audited-reuse candidate')
    source = read(output / 'agent_outputs/source_contract.json')
    contract = {
        'statement': source['contract_plain_english'],
        'assumptions': source['statement']['hypotheses'] + source['statement']['implicit_context'],
        'quantifiers': source['statement']['binders'],
    }
    for field in ('next_foundation', 'next_action', 'current_target', 'open_reason'):
        row.pop(field, None)
    row.update({
        'status': 'REUSED', 'lean_declarations': [declaration],
        'reuse_source': f"Integrated baseline {baseline}; unchanged {task['target']['path']}::{declaration}",
        'reuse_audit': f"Fresh complete-phase validated {task['task_id']}; {task['audit_output']}/decision.json",
        'contract_hash': checker.canonical_sha256(contract),
        'blind_pass': 'PASS', 'direct_pass': 'PASS', 'round_trip_pass': 'PASS',
        'lean_implies_source': 'yes', 'source_implies_lean': 'yes',
        'classification': 'faithful-equivalent',
        'faithfulness_task': task_path.relative_to(root).as_posix(),
        'faithfulness_decision': (output / 'decision.json').relative_to(root).as_posix(),
    })
    if decision.get('adjudicated') is True:
        row['adjudication_required'] = True
        row['adjudication_status'] = 'resolved'
        row['adjudication_audit'] = ('The complete sealed decision accepts both directions after fresh independent adjudication. '
            + (output / 'decision.json').relative_to(root).as_posix()
            + '; original direct/roundtrip classifications: ' + str(decision.get('judge_classifications', {})))
    binding = checker.row_artifact_bindings(row, 1, context)
    binding_dir = task_path.parent / 'gate-bindings' / checker.canonical_sha256(binding)
    common = {k: row[k] for k in ('contract_hash', 'classification', 'lean_implies_source', 'source_implies_lean')}
    roles = {'blind': 'blind_translation', 'direct': 'direct_judge', 'round-trip': 'roundtrip_judge'}
    for check, (path_field, hash_field) in checker.ROW_ARTIFACT_REFS.items():
        if check == 'source-contract':
            payload = {k: row[k] for k in ('contract_hash', 'source_label', 'printed_page', 'pdf_page')}
            payload['contract'] = contract
            procedure = 'Project the validated independent source contract from the immutable successor audit; retain its full source evidence, conventions and ambiguities in the sealed output.'
        else:
            role_path = output / 'agent_outputs' / (roles[check] + '.json')
            role_sha = hashlib.sha256(role_path.read_bytes()).hexdigest()
            decision_sha = hashlib.sha256((output / 'decision.json').read_bytes()).hexdigest()
            payload = {**common, 'decision': 'PASS', 'analysis':
                f"Validated {roles[check]} output SHA-256 {role_sha}; final decision SHA-256 {decision_sha}; declaration/axiom output SHA-256 {resolution_sha}. Final PASS projects the accepted sealed conclusion, including adjudication when required; original role outcomes remain unchanged. {decision['rationale']}"}
            procedure = 'Project the complete-phase validated independent role and final audit decision, including any required adjudication; no semantic judgment is generated by this adapter.'
        artifact = {'schema_version': 1, 'check': check, 'bindings': binding,
                    'procedure': procedure, 'exit_code': 0, 'payload': payload}
        path = binding_dir / ('gate-' + check + '.json')
        immutable_write(path, artifact)
        row[path_field] = path.relative_to(gate_path.parent).as_posix()
        row[hash_field] = hashlib.sha256(path.read_bytes()).hexdigest()
    defects = checker.row_artifact_defects(row, 1, context, gate_path.parent, set(), location=args.row)
    if defects:
        raise ValueError('; '.join(defects))
    closed = [r for r in gate['rows'] if r['status'] in checker.CLOSED_LEAN_STATUSES]
    semantic = gate['verification_loops']['semantic_equivalence']
    semantic['rows_requiring_check'] = len(closed)
    for field, pass_field in [('blind_recorded', 'blind_pass'), ('direct_recorded', 'direct_pass'),
                              ('round_trip_recorded', 'round_trip_pass')]:
        semantic[field] = sum(r.get(pass_field) == 'PASS' for r in closed)
    semantic['unresolved_adjudications'] = sum(r.get('adjudication_required', False)
        and r.get('adjudication_status') != 'resolved' for r in closed)
    for name in gate['verification_evidence']:
        gate['verification_evidence'][name] = {'command': '', 'artifact': '', 'artifact_sha256': '',
                                             'exit_code': None, 'count': 0}
    gate['bindings'] = copy.deepcopy(context['bindings'])
    prior = binding_dir / ('prior-gate-' + hashlib.sha256(original_bytes).hexdigest() + '.json')
    if prior.exists() and prior.read_bytes() != original_bytes:
        raise ValueError('prior gate snapshot collision')
    prior.write_bytes(original_bytes)
    gate_path.write_bytes(encode(gate))
    print(json.dumps({'row': args.row, 'status': 'REUSED', 'declaration': declaration,
                      'binding_directory': str(binding_dir), 'global_verification': 'OPEN'}))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
