"""Bind only the pinned, adjudicated stronger smooth-bridge audit to its reused row.

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


ROW_ID = 'LEV-CH01-INTEGRAL-TO-DIFFERENTIAL-SMOOTH'
TASK_ID = ROW_ID + '-CANONICAL-20260908'
SESSION = 'gates/leveque-finite-volume/artifacts/session-20260908'
TARGET = {
    'path': 'ComputationalMathematics/Source/LeVeque/Chapter01/IntegralToDifferential.lean',
    'declaration': 'NumStability.leveque01_integralLaw_impliesDifferentialLaw_of_smooth',
}
DECISION_SHA = '923861c4036334a4c9cff5e5ebb3f3ffc9329c40c1fab4f1f0ad9559a0c58b53'
MANIFEST_SHA = '6698cd2c6c95a98f5b117005dcf11f9f2e0addb1dd79066e0c86751d2442720b'
EVIDENCE_SHA = 'da9c905658fa2c02bf375df219fb7c9718fca8cc4c1c0e92b232da103f6274d7'
EVIDENCE_PATH = SESSION + '/smooth-bridge-strengthening-evidence.json'
GATE_CHECKER_SHA = '3e9cc58beb58f9f63f2736c4d50125ca6c42116104b64982f3dfc2d3f8afb104'
WITNESS = 'NumStability.Chapter01Evidence.smoothBridge_additionalInstance'
ALLOWED_AXIOMS = {'propext', 'Classical.choice', 'Quot.sound'}


def require(condition, message: str) -> None:
    if not condition:
        raise ValueError(message)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def repository_path(root: Path, relative: str) -> Path:
    require(isinstance(relative, str) and bool(relative), 'missing repository-relative path')
    require(not Path(relative).is_absolute(), 'expected a repository-relative path')
    path = (root / relative).resolve()
    require(path.is_relative_to(root.resolve()), f'path escapes repository: {relative}')
    return path


def bound_file(root: Path, item: dict) -> Path:
    require(isinstance(item, dict), 'file binding must be an object')
    path = repository_path(root, item.get('path'))
    require(re.fullmatch(r'[0-9a-f]{64}', item.get('sha256', '')) is not None,
            f'invalid hash binding: {path}')
    require(path.is_file() and sha(path) == item['sha256'], f'file binding mismatch: {path}')
    return path


def exact_manifest_config(root: Path, manifest: dict) -> Path:
    """Check every sealed setup file, then select its unique v1 configuration."""
    configs = []
    validator = repository_path(root, '.faithfulness-audit/scripts/validate_audit.py')
    validator_bound = False
    for item in manifest['audit_setup']:
        path = bound_file(root, item)
        validator_bound = validator_bound or path == validator
        if path.suffix == '.json' and 'config' in path.name:
            if read(path).get('schema_version') == 'formalization-faithfulness-config-1':
                configs.append(path)
    require(validator_bound, 'complete validator is absent from the sealed setup')
    require(len(configs) == 1, 'expected one exact manifest-bound sealed-v1 configuration')
    return configs[0]


def declaration_axioms(output: str, declaration: str) -> set[str]:
    require(re.search(r'^' + re.escape(declaration) + r'(?:\.\{[^}]*\})?(?:\s|:)',
                      output, re.MULTILINE) is not None,
            f'missing exact declaration resolution: {declaration}')
    matches = re.findall(re.escape(f"'{declaration}' depends on axioms:")
                         + r'\s*\[([^\]]*)\]', output)
    require(len(matches) == 1, f'expected one declaration-specific axiom report: {declaration}')
    axioms = {name.strip() for name in matches[0].split(',') if name.strip()}
    require(axioms <= ALLOWED_AXIOMS, f'unexpected axioms for {declaration}: {sorted(axioms)}')
    return axioms


def strengthening_fields(root: Path, evidence_path: Path, evidence: dict) -> dict:
    reference = {'path': evidence_path.relative_to(root).as_posix(), 'sha256': EVIDENCE_SHA}
    provenance = f"Strengthening evidence {reference['path']} SHA-256 {EVIDENCE_SHA}; sealed decision SHA-256 {DECISION_SHA}."
    witness_bindings = '; '.join(f"{item['path']} SHA-256 {item['sha256']}"
                                 for item in evidence['witness_files'])
    return {
        'strengthening_evidence': reference,
        'applicability_audit': evidence['applicability_audit'] + ' ' + provenance,
        'nonvacuity_witness': evidence['independent_nonstationary_example']
            + ' Supplementary native witness ' + evidence['formal_nonvacuity_declaration']
            + ': ' + evidence['formal_nonvacuity_scope']
            + ' Native Lean exited 0 with only propext, Classical.choice, Quot.sound. '
            + witness_bindings + '. ' + provenance,
    }


def validate_strengthening_evidence(root: Path, task_path: Path, task: dict,
                                   manifest: dict, decision: dict, evidence_path: Path,
                                   row: dict | None = None) -> dict:
    """Read-only checks for this one exact stronger result; no decision generation."""
    root, task_path, evidence_path = root.resolve(), task_path.resolve(), evidence_path.resolve()
    expected_task = repository_path(root, SESSION + f'/audits/{TASK_ID}/audit-task.json')
    require(task_path == expected_task and task.get('task_id') == TASK_ID,
            'stronger support is restricted to the pinned smooth-bridge task')
    require(task.get('target') == TARGET, 'unexpected stronger target')
    output = repository_path(root, task['audit_output'])
    require(output == expected_task.parent / 'faithfulness', 'unexpected stronger audit output')
    require(sha(output / 'manifest.json') == MANIFEST_SHA, 'pinned stronger manifest mismatch')
    require(sha(output / 'decision.json') == DECISION_SHA, 'pinned stronger decision mismatch')
    require(manifest == read(output / 'manifest.json') and decision == read(output / 'decision.json'),
            'supplied audit objects do not match their sealed bytes')
    require(manifest['task_id'] == TASK_ID and bound_file(root, manifest['task_metadata']) == task_path,
            'task is not bound by the sealed manifest')
    require(manifest['target']['declaration'] == TARGET['declaration']
            and bound_file(root, manifest['target']) == repository_path(root, TARGET['path']),
            'target is not bound by the sealed manifest')
    require(decision.get('task_id') == TASK_ID and decision.get('accepted') is True
            and decision.get('adjudicated') is True
            and decision.get('classification') == 'faithful-stronger',
            'expected the accepted independently adjudicated stronger decision')
    require(tuple(decision['implications'][key]['verdict'] for key in
                  ('lean_implies_source', 'source_implies_lean')) == ('yes', 'no'),
            'stronger decision must establish exactly yes/no')
    require(evidence_path == repository_path(root, EVIDENCE_PATH)
            and sha(evidence_path) == EVIDENCE_SHA, 'exact strengthening evidence is required')
    evidence = read(evidence_path)
    require(type(evidence.get('schema')) is int and evidence['schema'] == 1
            and evidence.get('task_id') == TASK_ID
            and evidence.get('classification') == 'faithful-stronger'
            and evidence.get('decision_sha256') == DECISION_SHA,
            'strengthening evidence has the wrong identity')
    require(evidence['applicability_audit'] == decision['implications']['lean_implies_source']['reasoning'],
            'applicability evidence differs from the independent sealed decision')
    require(evidence['independent_nonstationary_example']
            == decision['implications']['source_implies_lean']['reasoning'],
            'nonstationary strengthening evidence differs from the independent decision')
    require(evidence['formal_nonvacuity_declaration'] == WITNESS
            and bool(evidence['formal_nonvacuity_scope'].strip()), 'missing formal nonvacuity scope')
    files = evidence['witness_files']
    expected_files = {SESSION + '/smooth-bridge-additional-instance' + suffix
                      for suffix in ('.lean', '-output.txt', '-exit.json')}
    require(len(files) == 3 and {item['path'] for item in files} == expected_files,
            'expected the three exact witness source/output/exit bindings')
    paths = {item['path']: bound_file(root, item) for item in files}
    lean_relative = SESSION + '/smooth-bridge-additional-instance.lean'
    native_output = paths[SESSION + '/smooth-bridge-additional-instance-output.txt']
    native_exit = read(paths[SESSION + '/smooth-bridge-additional-instance-exit.json'])
    argv = ['lake', 'env', 'lean', lean_relative]
    require(native_exit == evidence['native_exit'], 'native witness receipt differs from evidence')
    require(type(native_exit.get('exit_code')) is int and native_exit['exit_code'] == 0,
            'native witness did not actually exit zero')
    require(native_exit.get('argv') == argv and native_exit.get('command') == ' '.join(argv),
            'native witness command did not check the exact witness source')
    require(native_exit.get('output_sha256') == sha(native_output), 'native witness output binding mismatch')
    require(re.fullmatch(r'[0-9a-f]{40}', native_exit.get('input_commit', '')) is not None,
            'missing native witness commit provenance')
    require(isinstance(native_exit.get('native_lake'), str)
            and native_exit['native_lake'].lower().endswith('lake.exe'), 'missing native Lake provenance')
    native_text = native_output.read_text(encoding='utf-8-sig')
    require(re.search(r'\b(?:error|warning):|sorryAx', native_text) is None,
            'native witness output contains an error, warning, or sorry axiom')
    axioms = declaration_axioms(native_text, WITNESS)
    require(axioms == set(evidence['axioms']) == ALLOWED_AXIOMS,
            'native witness axiom report differs from the pinned three-axiom evidence')
    reuse = evidence['reuse_search']
    require(type(reuse.get('exit_code')) is int and reuse['exit_code'] == 0, 'reuse search failed')
    bound_file(root, {'path': reuse['output_path'], 'sha256': reuse['output_sha256']})
    for item in reuse['sources']:
        bound_file(root, item)
    fields = strengthening_fields(root, evidence_path, evidence)
    if row is not None:
        require(row.get('id') == ROW_ID, 'stronger evidence belongs to a different row')
        for key, value in fields.items():
            require(row.get(key) == value, f'row {key} is not the exact hash-bound stronger evidence')
    return fields


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
    parser.add_argument('--strengthening-evidence', type=Path, required=True)
    parser.add_argument('--rebind', action='store_true',
                        help='Rebind only the same already-REUSED task and target')
    args = parser.parse_args()
    require(args.row == ROW_ID, 'this additive adapter supports only the smooth-bridge row')
    gate_path = args.gate.resolve()
    task_path = args.task.resolve()
    require(sha(args.gate_checker.resolve()) == GATE_CHECKER_SHA, 'released gate checker hash mismatch')
    spec = importlib.util.spec_from_file_location('leveque_gate', args.gate_checker.resolve())
    checker = importlib.util.module_from_spec(spec)
    require(spec.loader is not None, 'cannot load the selected gate checker')
    spec.loader.exec_module(checker)
    context = checker.current_context(gate_path, 1)
    root = context['lean_root'].resolve()
    require(gate_path == repository_path(root, 'gates/leveque-finite-volume/chapter-01.json'),
            'this adapter only binds the selected Chapter 1 gate')
    task = read(task_path)
    output = repository_path(root, task['audit_output'])
    manifest = read(output / 'manifest.json')
    decision = read(output / 'decision.json')
    stronger = validate_strengthening_evidence(root, task_path, task, manifest, decision,
                                               args.strengthening_evidence)
    config = exact_manifest_config(root, manifest)
    selected_config = os.environ.get('FAITHFULNESS_AUDIT_CONFIG')
    require(selected_config and Path(selected_config).resolve() == config,
            'select the exact manifest-bound successor configuration explicitly')
    gate = read(gate_path)
    original_bytes = gate_path.read_bytes()
    rows = [row for row in gate['rows'] if row['id'] == args.row]
    require(len(rows) == 1, 'expected one matching gate row')
    row = rows[0]
    if args.rebind:
        require(row['status'] == 'REUSED'
                and row.get('faithfulness_task') == task_path.relative_to(root).as_posix()
                and row.get('faithfulness_decision') == (output / 'decision.json').relative_to(root).as_posix()
                and row.get('lean_declarations') == [TARGET['declaration']],
                '--rebind requires the same already-REUSED task and target')
    else:
        require(row['status'] in ('READY', 'IN_PROGRESS'), 'row is not an open audited-reuse candidate')
    # The unchanged sealed validator, not this adapter, decides completeness.
    subprocess.run([sys.executable, '-B', str(root / '.faithfulness-audit/scripts/validate_audit.py'),
                    str(task_path), '--phase', 'complete'], cwd=root,
                   env=dict(os.environ, FAITHFULNESS_AUDIT_CONFIG=str(config)), check=True)
    source_path = root / task['source']['path']
    if hashlib.sha256(source_path.read_bytes()).hexdigest() != checker.PINNED_SOURCE_SHA256:
        raise ValueError('selected source hash mismatch')
    declaration = task['target']['declaration']
    resolution = args.resolution_log.read_text(encoding='utf-8-sig')
    require(re.search(r'\berror:|sorryAx', resolution) is None,
            'declaration resolution contains an error or sorry axiom')
    declaration_axioms(resolution, declaration)
    resolution_sha = hashlib.sha256(args.resolution_log.read_bytes()).hexdigest()
    baseline = context['bindings']['lean_git_head']
    subprocess.run(['git', 'merge-base', '--is-ancestor', baseline, 'HEAD'], cwd=root, check=True)
    subprocess.run(['git', 'cat-file', '-e', baseline + ':' + task['target']['path']], cwd=root, check=True)
    subprocess.run(['git', 'diff', '--exit-code', baseline, '--', task['target']['path']], cwd=root, check=True)

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
        'lean_implies_source': 'yes', 'source_implies_lean': 'no',
        'classification': 'faithful-stronger',
        'faithfulness_task': task_path.relative_to(root).as_posix(),
        'faithfulness_decision': (output / 'decision.json').relative_to(root).as_posix(),
        **stronger,
    })
    if decision.get('adjudicated') is True:
        row['adjudication_required'] = True
        row['adjudication_status'] = 'resolved'
        row['adjudication_audit'] = ('The complete sealed decision accepts genuine nonvacuous regularity strengthening: '
            'Lean implies source yes; source implies Lean no. Independent adjudication preserves smooth source applicability '
            'and identifies additional discontinuous instances. '
            + (output / 'decision.json').relative_to(root).as_posix()
            + f'; decision SHA-256 {DECISION_SHA}; strengthening evidence SHA-256 {EVIDENCE_SHA}'
            + '; original direct/roundtrip classifications: ' + str(decision.get('judge_classifications', {})))
    for field in ('applicability_audit', 'nonvacuity_witness'):
        require(checker.meaningful(row, field), f'missing meaningful {field}')
    validate_strengthening_evidence(root, task_path, task, manifest, decision,
                                   args.strengthening_evidence, row=row)
    require(not checker.faithfulness_defects(row, 'REUSED', args.row),
            'proposed stronger row fails the released faithfulness requirements')
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
                f"Validated {roles[check]} output SHA-256 {role_sha}; final decision SHA-256 {decision_sha}; declaration/axiom output SHA-256 {resolution_sha}; strengthening evidence SHA-256 {EVIDENCE_SHA}. Final PASS projects the accepted faithful-stronger yes/no conclusion after independent adjudication; original role outcomes remain unchanged. {decision['rationale']}"}
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
    require(gate_path.read_bytes() == original_bytes, 'gate changed during validation; refusing a stale write')
    require(checker.current_context(gate_path, 1)['bindings'] == context['bindings'],
            'source/environment bindings changed during validation')
    validate_strengthening_evidence(root, task_path, task, manifest, decision,
                                   args.strengthening_evidence, row=row)
    exact_manifest_config(root, manifest)
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
