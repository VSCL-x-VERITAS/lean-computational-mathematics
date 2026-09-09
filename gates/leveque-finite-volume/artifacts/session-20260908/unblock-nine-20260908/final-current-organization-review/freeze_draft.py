"""Freeze a draft snapshot; never run measurement or adopt review statuses."""
from pathlib import Path
import ast, hashlib, json

P = Path(__file__).resolve().parent
R = P.parents[5]
sha = lambda p: hashlib.sha256(p.read_bytes()).hexdigest()
read = lambda p: json.loads(p.read_bytes())
def resolve(s):
    if s.startswith('/c/'):
        return Path('C:/' + s[3:])
    p = Path(s)
    return p if p.is_absolute() else R / p
def pin(p):
    return {'path': p.relative_to(R).as_posix(), 'sha256': sha(p)}
def write(name, value):
    with (P / name).open('x', encoding='utf-8', newline='\n') as f:
        f.write(json.dumps(value, indent=2) + '\n')
count = 0
def check(value):
    global count
    if isinstance(value, dict):
        if isinstance(value.get('path'), str) and isinstance(value.get('sha256'), str):
            assert sha(resolve(value['path'])) == value['sha256'], value['path']
            count += 1
        for v in value.values(): check(v)
    elif isinstance(value, list):
        for v in value: check(v)
for f in sorted(P.glob('*.json')):
    check(read(f))
for f in P.glob('*.py'): ast.parse(f.read_text(encoding='utf-8'))
summary = read(P / 'draft-summary.json')
assert summary['status'] == 'root-review-required'
assert summary['final_measurement_run'] is False
assert summary['source_files'] == 185
assert summary['inputs_sha256'] == sha(P / 'organization-inputs.draft.json')
for f in P.glob('*.draft.json'):
    assert read(f)['status'] == 'root-review-required', f
receipts = read(P / 'actual-four-executions.json')['executions']
assert set(receipts) == {'layout','tiers','compatibility','hygiene'}
for entry in receipts.values():
    receipt = read(resolve(entry['receipt']['path']))
    assert receipt['exit_code'] == 0
    assert receipt['output_sha256'] == entry['output']['sha256']
write('freeze-validation.json', {
    'status': 'draft-integrity-verified-root-review-required',
    'verified_file_ref_occurrences': count,
    'python_syntax_checked': sorted(f.name for f in P.glob('*.py')),
    'current_source_pin_verification': 'All captured production pins and every referenced current file matched at this run.',
    'four_actual_zero_exits': True, 'final_measurement_run': False,
    'new_source_or_import_change_invalidates_snapshot': True})
write('manifest.json', {'status': 'frozen-current-snapshot-root-review-required',
    'files': [pin(f) for f in sorted(P.iterdir()) if f.is_file() and f.name != 'manifest.json']})
write('final-receipt.json', {
    'status': 'frozen-current-snapshot-root-review-required',
    'manifest': pin(P / 'manifest.json'), 'review': pin(P / 'REVIEW.md'),
    'organization_inputs_draft': pin(P / 'organization-inputs.draft.json'),
    'validation': pin(P / 'freeze-validation.json'),
    'actual_execution_observations': [
        {'script': 'capture_current.py', 'runtime': 'released POSIX launcher', 'tool_session_id': 87859, 'exit_code': 0,
         'raw_stdout_file': None, 'note': 'Execution observed in tool; no raw stdout file was captured.'},
        {'script': 'prepare_draft.py', 'runtime': 'native Python 3.12 with -X utf8 -B', 'exit_code': 0,
         'raw_stdout_file': None, 'note': 'Execution observed in tool; draft-summary.json is semantic result, not claimed raw stdout.'}],
    'final_measurement_run': False, 'organization_status_adopted': False,
    'source_gate_ref_audit_mutation': False})
print(json.dumps({'manifest': pin(P / 'manifest.json'), 'receipt': pin(P / 'final-receipt.json'),
                  'verified_refs': count, 'status': 'root-review-required'}, indent=2))
