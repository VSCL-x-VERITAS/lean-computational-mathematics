"""Read-only evidence checks for an independent nine-row local-completion review.
Only this new folder receives output. No Lean/released/gate/audit/Git mutation.
"""
from pathlib import Path
from datetime import datetime, timezone
from collections import Counter
import hashlib
import json
import re
import subprocess

HERE = Path(__file__).resolve().parent
S = HERE.parent
R = S.parents[3]
EXPECTED_HEAD = '80f5d4340d507dbc347a806717ff31c5a9aace72'
OUT = HERE / 'verification.json'
assert not OUT.exists()
seen = {}


def sha(data):
    return hashlib.sha256(data).hexdigest()


def bind(path, expected=None):
    path = path.resolve()
    name = path.relative_to(R).as_posix()
    data = path.read_bytes()
    digest = sha(data)
    assert expected is None or digest == expected, ('hash mismatch', name, expected, digest)
    assert name not in seen or seen[name] == digest, ('concurrent change', name)
    seen[name] = digest
    return data


def read(path, expected=None):
    return json.loads(bind(path, expected))


def refs(value, base=R):
    if isinstance(value, dict):
        if isinstance(value.get('path'), str) and isinstance(value.get('sha256'), str):
            bind(base / value['path'], value['sha256'])
        for sub in value.values():
            refs(sub, base)
    elif isinstance(value, list):
        for sub in value:
            refs(sub, base)


git_checks = []


def git(args):
    command = ['git'] + args
    run = subprocess.run(command, cwd=R, capture_output=True, check=True)
    git_checks.append({'command': command, 'exit_code': run.returncode,
        'stdout': run.stdout.decode('utf-8'), 'stderr': run.stderr.decode('utf-8')})
    return run.stdout.decode('utf-8').strip()


started = datetime.now(timezone.utc).isoformat()
assert git(['rev-parse', 'HEAD']) == EXPECTED_HEAD
route = read(S / 'final-material-choice-review-80f5/route-manifest.json',
    '968a467fb9554e1bb464c7e753af19f72fdef86a1198127c6e525a5c66dff3c4')
proposed = read(S / 'final-material-choice-review-80f5/proposed-rows.json',
    'd406dce613a5c17101ac553f7304d42c7a012199803973094726e43cab2541ae')
assert route['input_commit'] == EXPECTED_HEAD
refs(route)
prior = read(S / 'nine-row-local-route-review-batch10/local-route-review.json',
    'a1f573c281e28f67b42bc22cf01a3209a659eea74c8cf92a86efe401d23ad2cd')
supplement = read(S / 'nine-row-production-supplement-batch10/supplement.json',
    '2373e464e507f1ad541cb25199518ba3aaffcc56d0d405bb9ab4584f12d9c8c0')
for directory, digest in [
    ('nine-row-local-route-review-batch10', '270b25158f597e519dfba22957ec89c7afa94941e7035a06b2e2c20a173fb804'),
    ('nine-row-production-supplement-batch10', 'b6396391f90f147610de38849cfcec09a3607a726db39d99eedc48458517525f')]:
    manifest = read(S / directory / 'manifest.json', digest)
    for item in manifest['files']:
        bind(S / directory / item['path'], item['sha256'])
old_verification = read(S / 'nine-row-local-route-review-batch10/evidence-verification-v3.json')
for item in old_verification['bindings']:
    assert item['matches'] is True
    bind(R / item['path'], item['expected_sha256'])
production_verification = read(S / 'nine-row-production-supplement-batch10/verification.json')
refs(production_verification['observed_files'])
source_manifest = read(R / prior['source_manifest']['path'], route['source_manifest_sha256'])
projection = read(S / 'current-thread-question-provenance-v2-batch10/projection.json', route['question_projection_sha256'])
refs(projection)
questions = {q['question_id']: q for q in projection['questions']}
replies = {q['question_id'] for q in projection['replies']}
assert len(questions) == 11 and len(replies) == 2
route_ids = {row['row_id'] for row in route['rows']}
assert route_ids == {row['row_id'] for row in prior['rows']} and len(route_ids) == 9
for row in route['rows']:
    q = questions[row['question_id']]
    assert q['status'] == 'pending' and q['question_id'] not in replies
    assert row['row_id'] in q['row_ids']
    assert q['question_id'] == json.dumps(['request_user_input_async', q['call_id'], q['question_index']], separators=(',', ':'))
    assert row['all_local_work_complete'] is True and row['remaining_local_actions'] == []
    assert {v['kind'] for v in row['routes']} == {
        'source-review', 'canonical-reuse', 'mathematical-alternatives',
        'native-checks', 'organization', 'consumer-checks', 'review'}
    assert all(v['outcome'] == 'completed' and v['evidence'] for v in row['routes'])
q7 = next(q for q in questions.values() if q['call_id'] == 'call_1UY4fVuKrjpIIQfhLdeuFoRH')
q11 = next(q for q in questions.values() if q['call_id'] == 'call_gBZtG6Mn328LLCQ5DfzmFZtV')
assert set(q7['row_ids']) == {'LEV-CH01-FINITE-VOLUME-FLUX-UPDATE', 'LEV-CH01-RIEMANN-INTERFACE-FLUX'}
assert q11['row_ids'] == [] and all(row['question_id'] != q11['question_id'] for row in route['rows'])
gate = read(R / 'gates/leveque-finite-volume/chapter-01.json')
base = read(S / 'final-material-choice-review-80f5/base-active-gate.json')
assert gate == base
before = {row['id']: row for row in gate['rows']}
after = {row['id']: row for row in proposed['rows']}
assert before.keys() == after.keys() and len(before) == 57
assert Counter(v['status'] for v in before.values()) == {'REUSED': 17, 'PROVED': 15, 'READY': 9, 'SKIPPED': 16}
assert Counter(v['status'] for v in after.values()) == {'REUSED': 17, 'PROVED': 15, 'HARD_BLOCKED': 9, 'SKIPPED': 16}
assert {k for k in before if before[k] != after[k]} == route_ids
for key in before:
    if key not in route_ids:
        assert before[key] == after[key]
    else:
        assert after[key]['blocker_kind'] == 'material-user-choice'
        rr = next(x for x in route['rows'] if x['row_id'] == key)
        for field in ['obstruction', 'attempted_routes', 'resume_condition']:
            assert rr[field] == after[key][field]

integration = read(S / 'root-batch10-checkpoint-verification.json')
refs(integration)
recorded_checks = []
for item in integration['checks']:
    receipt = read(R / item['receipt']['path'], item['receipt']['sha256'])
    assert receipt['exit_code'] == 0, item['label']
    output = bind(R / item['output']['path'], item['output']['sha256'])
    if 'output_sha256' in receipt:
        assert sha(output) == receipt['output_sha256']
    recorded_checks.append({'label': item['label'], 'receipt': item['receipt'],
        'output': item['output'], 'exit_code': 0,
        'command': receipt.get('argv', receipt.get('command'))})
imports = read(S / 'batch10-analysis-imports.json')
aggregate = bind(R / imports['path'], imports['after_sha256']).decode('utf-8')
assert len(imports['added_imports']) == 9
for module in imports['added_imports']:
    assert aggregate.splitlines().count('import ' + module) == 1
refs(imports)
bind(R / integration['tiers']['path'], integration['tiers']['sha256'])
assert git(['diff', '--name-only', 'HEAD', '--', 'ComputationalMathematics',
    'docs/architecture/tiers.json', 'tools/architecture', 'lakefile.toml', 'lakefile.lean',
    'lean-toolchain', 'lake-manifest.json']) == ''

closed_ids = {key for key,row in before.items() if row['status'] in ['REUSED','PROVED']}
rebind = read(S / 'batch7-rebind-preparation/batch10-closed-rows-current/summary.json')
assert rebind['exit_code'] == 0 and rebind['closed_count'] == 32
assert rebind['closed_status_task_declaration_classification_contract_and_scope_preserved'] is True
assert len(rebind['steps']) == 32 and {x['row'] for x in rebind['steps']} == closed_ids
assert all(x['exit_code'] == 0 for x in rebind['steps'])
audit = read(S / 'batch10-closed-audits-output.txt')
assert audit['mode'] == 'released-complete-validation' and audit['closed_rows'] == 32
assert len(audit['records']) == 32 and {x['row'] for x in audit['records']} == closed_ids
for item in audit['records']:
    assert item['exit_code'] == 0 and item['command'][-2:] == ['--phase', 'complete']
    assert item['declaration'] in before[item['row']]['lean_declarations']
audit_receipt = read(S / 'batch10-closed-audits-exit.json')
assert audit_receipt['command'][-1] == '--validate'

final_inputs = read(S / 'chapter01-final-current-80f5-inputs.json')
refs(final_inputs)
assert final_inputs['input_commit'] == EXPECTED_HEAD
assert final_inputs['source_gate_sha256'] == sha(bind(R / 'gates/leveque-finite-volume/chapter-01.json'))
decls = {d for key in closed_ids for d in before[key]['lean_declarations']}
assert set(final_inputs['declarations']) == decls and len(decls) == 32
check_text = bind(R / final_inputs['check_file'], final_inputs['check_file_sha256']).decode('utf-8')
assert set(re.findall(r'^#check (\S+)\s*$', check_text, re.M)) == decls
assert set(re.findall(r'^#print axioms (\S+)\s*$', check_text, re.M)) == decls
final_native = []
for label in ['chapter01-final-declarations-80f5-retry', 'chapter01-final-focused-build-80f5', 'chapter01-final-full-build-80f5']:
    receipt = read(S / (label + '-exit.json'))
    output = bind(S / (label + '-output.txt'), receipt['output_sha256']).decode('utf-8')
    assert receipt['exit_code'] == 0 and receipt['input_commit'] == EXPECTED_HEAD
    assert not re.search(r'\b(?:error|warning):|\bsorryAx\b', output)
    final_native.append({'label': label, **receipt})
    if 'declarations' in label:
        reports = re.findall(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)", output, re.S)
        assert len(reports) == 32 and {name for name,ax in reports} == decls
        assert all({a.strip() for a in ax.split(',') if a.strip()} <= {'propext','Classical.choice','Quot.sound'} for name,ax in reports)

cache = read(S / 'generated-capstone-cache-preservation/preservation.json')
cache_checks = []
for item in cache['files']:
    original = bind(R / item['original_path'], item['original_sha256'])
    snapshot = bind(R / item['snapshot_path'], item['snapshot_sha256'])
    assert original == snapshot and len(original) == item['bytes']
    assert git(['ls-files', '--', item['original_path'], item['snapshot_path']]) == item['snapshot_path']
    assert git(['check-ignore', '--', item['original_path']]) == item['original_path']
    cache_checks.append(item)
freshness_receipt = read(S / 'chapter01-final-question-projection-80f5-exit.json')
assert freshness_receipt['exit_code'] == 0
freshness = read(S / 'chapter01-final-question-projection-80f5-output.txt')
assert freshness['projection_sha256'] == route['question_projection_sha256']
assert freshness['no_later_relevant_records'] is True and freshness['no_later_user_messages'] is True

for name,digest in seen.items():
    assert sha((R / name).read_bytes()) == digest, ('concurrent change', name)
assert git(['rev-parse','HEAD']) == EXPECTED_HEAD
result = {'schema_version':1, 'kind':'read-only-independent-local-completion-evidence-check',
    'started_at_utc':started,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
    'status':'PASS_WITHIN_STATED_CHECKS','input_commit':EXPECTED_HEAD,
    'observed_file_count':len(seen),'observed_files':[{'path':p,'sha256':h} for p,h in sorted(seen.items())],
    'prior_453_bindings_current':True,'prior_257_bindings_current':True,
    'original_packets_unchanged':True,'all_observed_inputs_unchanged':True,
    'proposed_changed_rows':sorted(route_ids),'accepted_32_and_skipped_16_identical':True,
    'mapped_questions':[{k:q[k] for k in ['question_id','call_id','row_ids','status']} for q in questions.values()],
    'question_freshness_receipt_reviewed':freshness,'live_transcript_rerun':False,
    'recorded_integration_checks':recorded_checks,'final_native_receipts':final_native,
    'exact32_rebind_and_complete_audit_validation':True,'final32_declarations_and_allowed_axioms':True,
    'cache_preservation':cache_checks,'read_only_git_checks':git_checks,
    'new_lean_or_released_execution':False,'source_faithfulness_verdict':'NOT ASSIGNED',
    'operational_terminal_state':'NOT ASSERTED','operational_mutations':[]}
with OUT.open('x',encoding='utf-8',newline='\n') as stream:
    stream.write(json.dumps(result,indent=2,ensure_ascii=False)+'\n')
print(json.dumps({'status':result['status'],'observed_file_count':len(seen),'verification_sha256':sha(OUT.read_bytes())}))
