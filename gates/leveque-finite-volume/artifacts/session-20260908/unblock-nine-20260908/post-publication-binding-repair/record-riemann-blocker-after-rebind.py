"""Record the user's unresolved source choice after the guarded 39-row rebind."""
from pathlib import Path
from datetime import datetime, timezone
import copy
import hashlib
import json
import os
import re
import sys
import tempfile

assert os.name == 'posix'
P = Path(__file__).resolve().parent
D = P.parent
R = next(p for p in P.parents if (p / 'lakefile.toml').is_file())
gate_path = R / 'gates/leveque-finite-volume/chapter-01.json'
sha = lambda raw: hashlib.sha256(raw).hexdigest()
observed = {}


def observe(path):
    path = path.resolve()
    assert path.is_relative_to(R)
    data = path.read_bytes()
    if path in observed:
        assert observed[path] == data, 'Evidence changed during validation: ' + str(path)
    observed[path] = data
    return data


def file_ref(path):
    path = path.resolve()
    return {'path': path.relative_to(R).as_posix(), 'sha256': sha(observe(path))}


def bound(reference):
    assert isinstance(reference, dict) and set(reference) == {'path', 'sha256'}
    assert isinstance(reference['path'], str) and not Path(reference['path']).is_absolute()
    assert isinstance(reference['sha256'], str) and re.fullmatch(r'[0-9a-f]{64}', reference['sha256'])
    path = (R / reference['path']).resolve()
    assert path.is_relative_to(R) and path.relative_to(R).as_posix() == reference['path']
    data = observe(path)
    assert sha(data) == reference['sha256'], 'Evidence hash mismatch: ' + str(path)
    return path, data


def unchanged():
    for path, expected in observed.items():
        assert path.read_bytes() == expected, 'Evidence changed before mutation: ' + str(path)
    assert gate_path.read_bytes() == raw


observe(Path(__file__))
row_id = 'LEV-CH01-RIEMANN-INTERFACE-FLUX'
response_path = P / 'riemann-interpretation-user-response.json'
response_raw = observe(response_path)
assert sha(response_raw) == 'abed7057c9ed39ed7d4cc39ff22d5a0e601312393bb50bf2a802b06b7362ac06'
response = json.loads(response_raw)
assert response['row_id'] == row_id
assert response['question_item_id'] == '["request_user_input_async","call_YMbpTOu88wd34dRqXfAjwd0g",0]'
assert response['question'] == (
    'One source interpretation remains unanswered: for the Riemann-interface claim, should I require '
    'every admitted problem to have a reference solution satisfying rectangle conservation with its '
    'actual endpoint fluxes, together with a numerical-flux error bound? I would preserve the book\u2019s '
    'ambiguity in the audit record.')
assert response['answer'] == 'Keep the interpretation unresolved'
assert response['interpretation_adopted'] is False and response['source_acceptance'] is False
assert len(sys.argv) == 2, 'Supply the actual applied rebind receipt path'
rebind_path = Path(sys.argv[1]).resolve()
assert rebind_path.parent.parent == D / 'accepted-row-rebind-runs' and rebind_path.name == 'receipt.json'
rebind_raw = observe(rebind_path)
rebind = json.loads(rebind_raw)
assert type(rebind['schema']) is int and rebind['schema'] == 1
assert rebind['status'] == 'PASS' and rebind['mode'] == 'APPLIED_GLOBAL_CHECKS_OPEN'
assert rebind['gate_mutated'] is True and rebind['terminal_acceptance'] is False
assert type(rebind['closed_rows_rebound']) is int and rebind['closed_rows_rebound'] == 39
assert rebind['new_semantic_judgment'] is False
assert rebind['qualified_requests_copied'] == 7 and rebind['artifact_count'] == 156
consumer = D / 'gate-helpers/rebind-accepted-row-batch-package-command-v1.py'
consumer_sha = '398e4eba8074602b5c870d1ccb677be8f1306398b399c208998531ccb15be30c'
assert sha(observe(consumer)) == consumer_sha and rebind['helper_sha256'] == consumer_sha
input_path, input_raw = bound(rebind['input'])
assert input_path == P / 'input39.json'
request = json.loads(input_raw)
plan_path, plan_raw = bound(rebind['plan'])
assert plan_path == rebind_path.parent / 'plan.json'
plan = json.loads(plan_raw)
validation_path, validation_raw = bound(rebind['complete_validation'])
assert validation_path == rebind_path.parent / 'complete-validation-receipt.json'
validation = json.loads(validation_raw)
assert type(validation['exit_code']) is int and validation['exit_code'] == 0
candidate_path, candidate_raw = bound(validation['candidate'])
assert candidate_path == rebind_path.parent / 'candidate-gate.json'
assert sha(candidate_raw) == rebind['candidate_gate_sha256'] == rebind['actual_gate_sha256']
validator = D / 'gate-helpers/validate-closed-row-audits-rebind-package-command-v1.py'
assert sha(observe(validator)) == '8b34ee90f8c3f81454dd2e6fdbcd87d611fbede1ceb6b635fb0ff5b45464f0ca'
command = validation['command']
assert isinstance(command, list) and len(command) == 8
assert Path(command[0]).resolve() == Path(sys.executable).resolve()
assert command[1:] == ['-B', str(validator), '--validate', '--gate-input', str(candidate_path),
                       '--gate-input-sha256', sha(candidate_raw)]
validation_output_path = rebind_path.parent / 'complete-validation-output.json'
validation_output_raw = observe(validation_output_path)
assert sha(validation_output_raw) == validation['output_sha256']
validation_output = json.loads(validation_output_raw)
assert validation_output['mode'] == 'released-complete-validation'
assert validation_output['closed_rows'] == 39
assert validation_output['validated_gate_input'] == validation['candidate']
assert plan['complete_validation'] == rebind['complete_validation']
assert plan['source_acceptance'] is False
assert request['expected_gate_sha256'] == plan['prior_gate_sha256'] == rebind['prior_gate_sha256']
assert plan['candidate_gate_sha256'] == sha(candidate_raw)
assert plan['current_native'] == request['current_native']
for reference in request['current_native'].values():
    bound(reference)
bound(request['runtime_pins'])
raw = gate_path.read_bytes()
assert raw == candidate_raw
before = json.loads(raw)
assert before['chapter_gate'] == 'ACTIVE'
closed_ids = sorted(r['id'] for r in before['rows'] if r['status'] in ('PROVED', 'REUSED'))
assert len(before['rows']) == 57 and len(closed_ids) == 39
assert sum(r['status'] == 'SKIPPED' for r in before['rows']) == 16
assert {r['id'] for r in before['rows'] if r['status'] == 'IN_PROGRESS'} == {
    row_id, 'LEV-CH01-DIMENSIONAL-SPLITTING'}
assert request['expected_closed_row_ids'] == plan['rows'] == closed_ids
assert request['current_bindings'] == plan['bindings'] == before['bindings'] == validation_output['current_bindings']
records = validation_output['records']
assert len(records) == 39 and sorted(item['row'] for item in records) == closed_ids
assert all(type(item['exit_code']) is int and item['exit_code'] == 0 for item in records)
after = copy.deepcopy(before)
row = next(r for r in after['rows'] if r['id'] == row_id)
assert row['status'] == 'IN_PROGRESS'
row.update(status='HARD_BLOCKED', blocker_kind='material-user-choice',
    obstruction='The printed source leaves the reference representative and approximate-solver certificate convention implicit. The user explicitly chose to keep that interpretation unresolved; the proposed convention has not been adopted.',
    attempted_routes='The rectangle-conservation and certified-routine foundations compile, and the existing independent certified-routine audit retained an unresolved source interpretation. A separately scoped explicit reference/endpoint-flux/error-bound convention was offered; the user selected Keep the interpretation unresolved.',
    blocking_evidence='User response '+response_path.relative_to(R).as_posix()+' SHA256 '+sha(response_raw)+'. Existing unaccepted certified-routine decision SHA256 0ac08662a5a89231c70add2f6706e855f86704a7d57206cff558d8f2addd0308 is preserved; no adoption or acceptance is inferred.',
    resume_condition='A later explicit source clarification or adopted representative/certificate interpretation permits a fresh independent audit; retain the present source ambiguity until then.',
    current_target='Preserve the unresolved source interpretation expressly retained by the user on 2026-09-09.',
    next_action='Continue independent dimensional-splitting and binding work. Resume this source obligation only when the recorded interpretation is explicitly resolved.')
assert [(r['id'], r) for r in before['rows'] if r['id'] != row_id] == [(r['id'], r) for r in after['rows'] if r['id'] != row_id]
assert {k:v for k,v in before.items() if k != 'rows'} == {k:v for k,v in after.items() if k != 'rows'}
payload = (json.dumps(after, indent=2, ensure_ascii=False)+'\n').encode()
consumer_reference = file_ref(consumer)
validation_output_reference = file_ref(validation_output_path)
directory = P / 'riemann-blocker-01'
directory.mkdir(exist_ok=False)
(directory/'prior-gate.json').write_bytes(raw)
(directory/'candidate-gate.json').write_bytes(payload)
unchanged()
fd, temp = tempfile.mkstemp(prefix='chapter-01-user-choice-', dir=gate_path.parent)
try:
    with os.fdopen(fd, 'wb') as stream:
        stream.write(payload)
        stream.flush()
        os.fsync(stream.fileno())
    unchanged()
    os.replace(temp, gate_path)
    assert gate_path.read_bytes() == payload
finally:
    if os.path.exists(temp):
        os.unlink(temp)
record = {'kind':'actual-user-choice-blocker-update', 'recorded_at_utc':datetime.now(timezone.utc).isoformat(),
          'row_id':row_id, 'before_gate_sha256':sha(raw), 'after_gate_sha256':sha(payload),
          'user_response':{'path':response_path.relative_to(R).as_posix(),'sha256':sha(response_raw)},
          'applied_rebind':{'path':rebind_path.relative_to(R).as_posix(),'sha256':sha(rebind_raw)},
          'rebind_consumer':consumer_reference, 'rebind_input':rebind['input'],
          'rebind_plan':rebind['plan'], 'complete_validation':rebind['complete_validation'],
          'complete_validation_output':validation_output_reference,
          'closed_39_and_skipped_16_unchanged':True, 'chapter_remains_active':True,
          'new_source_acceptance':False, 'closure_check_still_required':True}
(directory/'receipt.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps(record,indent=2))
