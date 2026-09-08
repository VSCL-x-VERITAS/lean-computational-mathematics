"""Bind an independently accepted audit to an exact newly proved producer.

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
    parser.add_argument('--resolution-exit', type=Path, required=True)
    parser.add_argument('--resolution-manifest', type=Path, required=True)
    parser.add_argument('--check-file', type=Path, required=True)
    parser.add_argument('--interpretation', type=Path, required=True)
    parser.add_argument('--interpretation-sha256', required=True)
    parser.add_argument('--rebind', action='store_true')
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
        raise ValueError('ordinary proof adapter requires an accepted equivalent audit')
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
    target = root / task['target']['path']
    manifest = read(args.resolution_manifest)
    matches = [f for f in manifest['files'] if f['path'] == task['target']['path']]
    if len(matches) != 1 or matches[0]['sha256'] != hashlib.sha256(target.read_bytes()).hexdigest():
        raise ValueError('proof manifest does not bind the exact current target bytes')
    if declaration not in matches[0]['declarations']:
        raise ValueError('proof manifest does not enumerate the selected declaration')
    check_bytes = args.check_file.read_bytes()
    if hashlib.sha256(check_bytes).hexdigest() != manifest['check_file_sha256']:
        raise ValueError('declaration check file differs from the proof manifest')
    check_text = check_bytes.decode('utf-8-sig')
    for line in ('#check ' + declaration, '#print axioms ' + declaration):
        if line not in check_text.splitlines():
            raise ValueError('check input omits selected declaration: ' + line)
    exit_record = read(args.resolution_exit)
    if exit_record.get('exit_code') != 0 or isinstance(exit_record.get('exit_code'), bool):
        raise ValueError('declaration check did not complete successfully')
    expected_command = 'lake env lean ' + args.check_file.resolve().relative_to(root).as_posix()
    if exit_record.get('command') != expected_command:
        raise ValueError('exit receipt names a different declaration check')
    if re.search(r'(?m)^.*\.lean:\d+:\d+: error:', resolution):
        raise ValueError('declaration output contains a Lean error')
    index_bytes = subprocess.check_output(['git', '-c', 'core.longpaths=true',
        'show', ':' + task['target']['path']], cwd=root)
    if index_bytes != target.read_bytes():
        raise ValueError('target must have exact staged bytes before gate binding')
    resolution_manifest_sha = hashlib.sha256(args.resolution_manifest.read_bytes()).hexdigest()
    resolution_exit_sha = hashlib.sha256(args.resolution_exit.read_bytes()).hexdigest()

    gate = read(gate_path)
    original_bytes = gate_path.read_bytes()
    row = next(r for r in gate['rows'] if r['id'] == args.row)
    if args.rebind:
        if row['status'] != 'PROVED' or row.get('faithfulness_task') != task_path.relative_to(root).as_posix() or row.get('lean_declarations') != [declaration]:
            raise ValueError('rebind requires the unchanged already-proved interpreted row')
    elif row['status'] not in ('READY', 'IN_PROGRESS'):
        raise ValueError('row is not an open audited-proof candidate')
    source = read(output / 'agent_outputs/source_contract.json')
    contract = {
        'statement': source['contract_plain_english'],
        'assumptions': source['statement']['hypotheses'] + source['statement']['implicit_context'],
        'quantifiers': source['statement']['binders'],
    }
    receipt_bytes = args.interpretation.read_bytes()
    receipt_sha = hashlib.sha256(receipt_bytes).hexdigest()
    if receipt_sha != args.interpretation_sha256:
        raise ValueError('user interpretation receipt hash mismatch')
    interpretation = read(args.interpretation)
    if (receipt_sha != 'b27e7d260e93edcd5408daa8c5d291ba8bfefd9e66a079480ae6b940aa869030'
        or args.row != 'LEV-CH01-DISCONTINUITY-INTEGRAL-LAW'
        or interpretation['scope'] != 'Chapter 1 discontinuity discussion around equation (1.10), particularly LEV-CH01-DISCONTINUITY-INTEGRAL-LAW.'
        or interpretation['source_sha256'] != checker.PINNED_SOURCE_SHA256):
        raise ValueError('this adapter requires the exact recorded discontinuity reply and row')
    config = read(Path(os.environ['FAITHFULNESS_AUDIT_CONFIG']))
    receipt_relative = args.interpretation.resolve().relative_to(root).as_posix()
    if receipt_relative not in config['lean']['environment_files']:
        raise ValueError('receipt was not an environment-bound input to this audit')
    if not any('interpretation-qualified' in f.get('category', '') for f in decision['findings']):
        raise ValueError('audit does not explicitly qualify its acceptance by interpretation')
    source_sha = hashlib.sha256((output / 'agent_outputs/source_contract.json').read_bytes()).hexdigest()
    qualification = ('This contract is audited only under the explicit user-adopted interpretation, recorded at '
        + receipt_relative + ' (SHA-256 ' + receipt_sha + '). '
        + 'The original source-only contract and its ambiguity remain preserved (SHA-256 ' + source_sha + '). ')
    contract['statement'] = qualification + 'Original source account: ' + contract['statement']
    contract['assumptions'] += ['Adopted interpretation: ' + x for x in interpretation['adopted_interpretation']]
    contract['assumptions'] += ['Preserved limitation: ' + x for x in interpretation['preservation']]
    contract['assumptions'] += ['Exact user reply: ' + interpretation['answer']]
    if args.rebind and row['contract_hash'] != checker.canonical_sha256(contract):
        raise ValueError('rebind would change the interpreted contract')
    for field in ('next_foundation', 'next_action', 'current_target', 'open_reason'):
        row.pop(field, None)
    row.update({
        'status': 'PROVED', 'lean_declarations': [declaration],
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
            procedure = 'Project the validated independent source account together with the separately environment-bound, explicitly scoped user interpretation. Acceptance is qualified by that interpretation; the PDF-only ambiguity and original role outcomes remain unchanged.'
        else:
            role_path = output / 'agent_outputs' / (roles[check] + '.json')
            role_sha = hashlib.sha256(role_path.read_bytes()).hexdigest()
            decision_sha = hashlib.sha256((output / 'decision.json').read_bytes()).hexdigest()
            payload = {**common, 'decision': 'PASS', 'analysis':
                f"Validated {roles[check]} output SHA-256 {role_sha}; final decision SHA-256 {decision_sha}; declaration/axiom output SHA-256 {resolution_sha}; exact proof-input manifest SHA-256 {resolution_manifest_sha}; successful native exit receipt SHA-256 {resolution_exit_sha}. Final PASS is explicitly qualified by user interpretation SHA-256 {receipt_sha}, and projects the accepted sealed conclusion, including adjudication when required; original role outcomes remain unchanged. {decision['rationale']}"}
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
    print(json.dumps({'row': args.row, 'status': 'PROVED', 'declaration': declaration,
                      'binding_directory': str(binding_dir), 'global_verification': 'OPEN'}))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
