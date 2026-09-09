"""Pinned malformed-roundtrip handoff. Prepare is read-only outside this folder.

Execute requires the reviewed plan SHA. It archives the invalid canonical bytes,
collects the already completed fresh r2 with unchanged c.py, and continues unchanged
q.py. Original failed-wrapper receipt and every prior runtime remain intact.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse, hashlib, json, os, subprocess, sys, time

F = Path(__file__).resolve().parent
D = F.parent
S = D.parent
R = next(p for p in F.parents if (p / 'lean-toolchain').exists())
SHIM = D / 'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(), str(SHIM), 'exec'), globals())
TASK = 'LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908'
T = S / 'audits' / TASK
O = T / 'faithfulness'
P = O / 'orchestration'
CONFIG = D / (TASK + '.config.json')
WRAPPER = R.parent / 'workflow-v5.0.1-local/run_workflow_posix.py'
SOURCE_HASH = 'b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
INVALID_HASH = '9a7140d20fa162a9a00d71127fb5c9c64822c8e7dee432e3cf90f75dbf0cf7e4'
ORIGINAL_STDOUT = '50a2105fdfba5e3e1219e08d79325bdaf2526f0b3c1068b5351396b726d9089e'
ORIGINAL_STDERR = 'f296ccb7e8a28efa15248ff685134d75f89043f78670fc4541668154a3943c1a'

def digest(data): return hashlib.sha256(data).hexdigest()
def sha(path): return digest(path.read_bytes())
def read(path): return json.loads(path.read_bytes())
def now(): return datetime.now(timezone.utc).isoformat()
def ref(path): return {'path': str(path.resolve()), 'sha256': sha(path)}
def verify(pin):
    path = Path(pin['path'])
    assert sha(path) == pin['sha256'], ('Changed pinned bytes', pin['path'])
    return path
def create(path, data):
    with path.open('xb') as stream: stream.write(data)
def write(path, data): create(path, (json.dumps(data, indent=2, ensure_ascii=False) + '\n').encode())
def native_path(path):
    value = os.path.abspath(os.fspath(path))
    if value.startswith('\\\\?\\'): return value
    if value.startswith('\\\\'): return '\\\\?\\UNC\\' + value[2:]
    return '\\\\?\\' + value
def files(path):
    for item in path.iterdir():
        if item.is_dir(): yield from files(item)
        elif item.is_file(): yield item
def environment():
    return dict(os.environ, FAITHFULNESS_AUDIT_CONFIG='/c/' + CONFIG.as_posix()[3:])
def native(*args): return [sys.executable, '-X', 'utf8', '-B', *map(str, args)]
def released(script, *args):
    return native(WRAPPER, '.faithfulness-audit/scripts/' + script, TASK, *args)

def original_failure(receipt, stdout, stderr, invalid):
    assert receipt['exit_code'] == 1
    assert receipt['stdout_sha256'] == digest(stdout) == ORIGINAL_STDOUT
    assert receipt['stderr_sha256'] == digest(stderr) == ORIGINAL_STDERR
    assert digest(invalid) == INVALID_HASH
    bad = json.loads(invalid)
    assert len(bad['source_sha256']) == 63 and bad['source_sha256'] != SOURCE_HASH
    assert "roundtrip-judge.source_sha256: string does not match '^[0-9a-f]{64}$'" in stderr.decode()
    assert 'roundtrip-judge: source hash mismatch' in stderr.decode()
    assert receipt['completed_at_utc'] == '2026-09-08T19:26:10.827816+00:00'

def append_check(before, after, uid):
    assert {k:v for k,v in before.items() if k != 'runs'} == {k:v for k,v in after.items() if k != 'runs'}
    assert len(after['runs']) == len(before['runs']) + 1
    assert after['runs'][:-1] == before['runs']
    assert uid not in {x['agent_id'] for x in before['runs']}
    assert after['runs'][-1]['role'] == 'roundtrip-judge'
    assert after['runs'][-1]['agent_id'] == uid

def manifest_transition(before, after):
    allowed = {'status', 'completed_at_utc', 'outputs'}
    assert {k:v for k,v in before.items() if k not in allowed} == {k:v for k,v in after.items() if k not in allowed}
    assert after.get('status') == 'completed'
    assert isinstance(after.get('completed_at_utc'), str) and after['completed_at_utc']
    assert isinstance(after.get('outputs'), dict) and after['outputs']

def untouched_boundary():
    assert not (O / 'decision.json').exists()
    assert not (O / 'agent_outputs/adjudicator.json').exists()
    assert not (P / 'adjudication_triggers.json').exists()
    assert not any(p.name.startswith('a_') for p in P.iterdir())
    assert not (P / 'r2_runtime.json').exists()
    assert read(O / 'manifest.json')['status'] == 'prepared'

def session_preflight():
    # Exact unchanged collector guards, stopping immediately before its first
    # canonical output write. No final/invalid judgment is inserted in a prompt.
    raw = (P / 'c.py').read_bytes()
    prefix = raw[:raw.index(b'\ndest=out/')]
    saved = sys.argv
    sys.argv = [str(P / 'c.py'), TASK, 'r2', 'roundtrip-judge', 'roundtrip_judge.json']
    scope = {'__name__': 'unchanged_collector_read_only_prefix', '__file__': str(P / 'c.py')}
    try: exec(compile(prefix, str(P / 'c.py'), 'exec'), scope)
    finally: sys.argv = saved
    return {'agent_id': scope['uid'], 'session': ref(scope['paths'][0]),
            'collector_prefix_sha256': digest(prefix), 'tool_calls': len(scope['calls'])}

def step(destination, name, command, expected=0):
    out, err = destination / (name + '-output.txt'), destination / (name + '-stderr.txt')
    start, clock = now(), time.monotonic()
    with out.open('xb') as stdout, err.open('xb') as stderr:
        result = subprocess.run(command, cwd=R, env=environment(), stdout=stdout, stderr=stderr)
    receipt = {'name': name, 'command': command, 'started_at_utc': start,
        'completed_at_utc': now(), 'elapsed_seconds': time.monotonic()-clock,
        'exit_code': result.returncode, 'stdout': ref(out), 'stderr': ref(err)}
    write(destination / (name + '-exit.json'), receipt)
    print(json.dumps(receipt), flush=True)
    if expected is not None and result.returncode != expected:
        raise subprocess.CalledProcessError(result.returncode, command)
    return receipt

def manifest_pins(value):
    if isinstance(value, dict):
        if isinstance(value.get('path'), str) and isinstance(value.get('sha256'), str):
            candidates = [R / value['path'], O / value['path']]
            matching = [p for p in candidates if p.is_file() and sha(p) == value['sha256']]
            assert matching, ('Manifest pin unresolved', value['path'])
            yield matching[0]
        for item in value.values(): yield from manifest_pins(item)
    elif isinstance(value, list):
        for item in value: yield from manifest_pins(item)

def prepare(destination):
    destination = destination.resolve()
    assert destination.parent == F.resolve() and destination.name == 'handoff-plan'
    assert not destination.exists()
    untouched_boundary()
    receipt = read(T / 'role-run-receipt.json')
    invalid = (O / 'agent_outputs/roundtrip_judge.json').read_bytes()
    original_failure(receipt, (T/'role-run-output.txt').read_bytes(), (T/'role-run-stderr.txt').read_bytes(), invalid)
    assert invalid == (P / 'r_final.json').read_bytes()
    assert sha(T / 'role-transport-preflight.json') == receipt['prepared_transport_sha256']
    for helper in read(T / 'role-transport-preflight.json')['helpers']:
        assert sha(P / helper['file']) == helper['successor_sha256']
    fresh = read(F / 'fresh-retry-receipt.json')
    assert fresh['input_byte_equal'] and fresh['original_r_files_unchanged']
    assert fresh['canonical_collection_performed'] is False
    assert read(verify(fresh['actual_native_invocation']))['actual_exit_code'] == 0
    assert read(verify(fresh['released_uncollected_validation']))['actual_exit_code'] == 0
    for pin in read(F / 'preflight.json')['old_attempt_files']: verify(pin)
    old_transport, new_transport = read(P/'r_transport.json'), read(P/'r2_transport.json')
    assert new_transport['exit_code'] == old_transport['exit_code'] == 0
    assert (P/'r_input.txt').read_bytes() == (P/'r2_input.txt').read_bytes()
    assert new_transport['inputs'] == old_transport['inputs']
    assert sha(P/'r2_input.txt') == new_transport['stdin_sha256']
    actual = session_preflight()
    assert actual['agent_id'] == fresh['actual_agent_id'] != fresh['prior_invalid_agent_id']
    before_runs = read(O / 'agent_outputs/agent_runs.json')
    assert len(before_runs['runs']) == 4 and len({x['agent_id'] for x in before_runs['runs']}) == 4
    assert [x['role'] for x in before_runs['runs']] == ['source-contract','blind-translation','direct-judge','roundtrip-judge']
    assert before_runs['runs'][-1]['agent_id'] == fresh['prior_invalid_agent_id']
    assert actual['agent_id'] not in {x['agent_id'] for x in before_runs['runs']}
    manifest = read(O/'manifest.json')
    dynamic = {(O/'manifest.json').resolve(), (O/'agent_outputs/agent_runs.json').resolve(),
               (O/'agent_outputs/roundtrip_judge.json').resolve()}
    static = [p for p in files(T) if p.resolve() not in dynamic]
    static += list(manifest_pins(manifest))
    static += list(files(R/'.faithfulness-audit/scripts'))
    static += list(files(R/'.faithfulness-audit/schemas'))
    static += [p for p in F.iterdir() if p.is_file() and p.name.startswith((
        'route-', 'invalid-r-diagnosis-', 'fresh-r2-', 'fresh-retry-', 'preflight.',
        'run-retry.', 'diagnose-uncollected.', 'test_recover.', 'guard-tests-'))]
    static += [Path(__file__), SHIM, WRAPPER, CONFIG, verify(actual['session'])]
    static += [Path(item['path']) for item in new_transport['inputs']]
    pins = list({str(p.resolve()): ref(p) for p in static}.values())
    destination.mkdir()
    for name, source in [('manifest-before.json', O/'manifest.json'),
                         ('agent-runs-before.json', O/'agent_outputs/agent_runs.json'),
                         ('invalid-roundtrip-before.json', O/'agent_outputs/roundtrip_judge.json')]:
        create(destination/name, source.read_bytes())
    step(destination, 'prepared-validation', released('validate_audit.py','--phase','prepared'))
    for role in ('source-contract','blind-translation','direct-judge'):
        step(destination, role+'-validation', released('validate_agent_output.py',role))
    step(destination, 'invalid-canonical-validation', released('validate_agent_output.py','roundtrip-judge'), 2)
    step(destination, 'fresh-r2-validation', native(WRAPPER,F/'diagnose-uncollected.py','r2'))
    untouched_boundary()
    for pin in pins: verify(pin)
    assert (O/'manifest.json').read_bytes() == (destination/'manifest-before.json').read_bytes()
    assert (O/'agent_outputs/agent_runs.json').read_bytes() == (destination/'agent-runs-before.json').read_bytes()
    assert (O/'agent_outputs/roundtrip_judge.json').read_bytes() == invalid
    plan = {'format':'malformed-roundtrip-handoff-1', 'task_id':TASK, 'prepared_at_utc':now(),
        'original_wrapper_exit_code':1, 'original_role_run_receipt':ref(T/'role-run-receipt.json'),
        'prior_invalid_agent_id':fresh['prior_invalid_agent_id'], 'new_agent_id':actual['agent_id'],
        'fresh_retry_receipt':ref(F/'fresh-retry-receipt.json'), 'session_preflight':actual,
        'runner':ref(Path(__file__)), 'collector':ref(P/'c.py'), 'continuation':ref(P/'q.py'),
        'static_inputs':pins, 'manifest_before':ref(destination/'manifest-before.json'),
        'agent_runs_before':ref(destination/'agent-runs-before.json'),
        'invalid_canonical_before':ref(destination/'invalid-roundtrip-before.json'),
        'new_output':ref(P/'r2_final.json'),
        'prepared_checks':[ref(p) for p in destination.iterdir() if p.name.endswith('-exit.json')],
        'canonical_collection_performed':False, 'operational_execution_authorized_by_this_file':False}
    write(destination/'plan.json', plan)
    print(json.dumps({'plan':ref(destination/'plan.json'), 'prepared_only':True}),flush=True)

def execute(plan_path, expected_sha):
    assert sha(plan_path) == expected_sha
    plan = read(plan_path)
    assert plan['format'] == 'malformed-roundtrip-handoff-1' and plan['task_id'] == TASK
    assert plan_path.resolve().parent == (F/'handoff-plan').resolve()
    assert sha(Path(__file__)) == plan['runner']['sha256']
    E = plan_path.parent
    for pin in plan['static_inputs']: verify(pin)
    for key in ('manifest_before','agent_runs_before','invalid_canonical_before','new_output'): verify(plan[key])
    untouched_boundary()
    for live, key in [(O/'manifest.json','manifest_before'),
                      (O/'agent_outputs/agent_runs.json','agent_runs_before'),
                      (O/'agent_outputs/roundtrip_judge.json','invalid_canonical_before')]:
        assert live.read_bytes() == verify(plan[key]).read_bytes()
    assert session_preflight() == plan['session_preflight']
    before_manifest, before_runs = read(verify(plan['manifest_before'])), read(verify(plan['agent_runs_before']))
    create(E/'execution-started.json', (json.dumps({'started_at_utc':now(),'plan':ref(plan_path)})+'\n').encode())
    receipt = {'format':'malformed-roundtrip-recovery-execution-1','task_id':TASK,
        'plan':ref(plan_path),'started_at_utc':now(),'original_wrapper_exit_code':1,
        'original_role_run_receipt':ref(T/'role-run-receipt.json'),'steps':[],
        'canonical_collection_performed':False,'exit_code':2,'guard_error':None}
    def stable():
        for pin in plan['static_inputs']: verify(pin)
    def checked_step(name, command):
        record = step(E,name,command,expected=None)
        receipt['steps'].append(record)
        if record['exit_code']: raise subprocess.CalledProcessError(record['exit_code'],command)
        return record
    try:
        # Same-volume Windows rename fails if the new archive path already exists.
        # All paths are fixed by the reviewed plan and remain under this workspace.
        source = O/'agent_outputs/roundtrip_judge.json'
        archive = E/'invalid-canonical-archived.json'
        assert source.resolve().is_relative_to(T.resolve())
        assert archive.resolve().is_relative_to(F.resolve()) and not archive.exists()
        assert sha(source) == plan['invalid_canonical_before']['sha256']
        os.rename(native_path(source),native_path(archive))
        assert sha(archive) == plan['invalid_canonical_before']['sha256'] and not source.exists()
        receipt['invalid_canonical_archive'] = ref(archive)
        checked_step('collect-r2', native(P/'c.py',TASK,'r2','roundtrip-judge','roundtrip_judge.json'))
        stable()
        append_check(before_runs,read(O/'agent_outputs/agent_runs.json'),plan['new_agent_id'])
        assert source.read_bytes() == verify(plan['new_output']).read_bytes()
        assert (O/'manifest.json').read_bytes() == verify(plan['manifest_before']).read_bytes()
        after_collect = read(O/'agent_outputs/agent_runs.json')
        create(E/'agent-runs-after-r2.json',(O/'agent_outputs/agent_runs.json').read_bytes())
        receipt.update(canonical_collection_performed=True,new_runtime=ref(P/'r2_runtime.json'),
            new_canonical=ref(source),agent_runs_after_retry=ref(E/'agent-runs-after-r2.json'))
        # Original q validates the four current role outputs, then performs the
        # ordinary required adjudication/finalization/complete-validation flow.
        checked_step('continuation',native(P/'q.py',TASK,'26,27,28','2'))
        stable()
        final_runs = read(O/'agent_outputs/agent_runs.json')
        assert final_runs['runs'][:len(after_collect['runs'])] == after_collect['runs']
        assert len(final_runs['runs']) in (len(after_collect['runs']),len(after_collect['runs'])+1)
        if len(final_runs['runs']) > len(after_collect['runs']):
            assert final_runs['runs'][-1]['role'] == 'adjudicator'
            assert final_runs['runs'][-1]['agent_id'] not in {x['agent_id'] for x in after_collect['runs']}
        manifest_transition(before_manifest,read(O/'manifest.json'))
        completed_pins = [ref(p) for p in [O/'manifest.json',O/'decision.json',O/'report.md',
            O/'agent_outputs/agent_runs.json',O/'agent_outputs/roundtrip_judge.json']]
        checked_step('complete-validation',released('validate_audit.py','--phase','complete'))
        stable()
        for pin in completed_pins: verify(pin)
        decision=read(O/'decision.json')
        receipt.update(exit_code=0,decision=ref(O/'decision.json'),manifest=ref(O/'manifest.json'),
            report=ref(O/'report.md'),classification=decision['classification'],accepted=decision['accepted'],
            released_complete_validation_exit_code=0,manifest_transition_verified=True)
    except Exception as error:
        receipt['guard_error']=repr(error)
        if isinstance(error,subprocess.CalledProcessError):receipt['exit_code']=error.returncode
    finally:
        receipt['completed_at_utc']=now()
        write(E/'execution-receipt.json',receipt)
        print(json.dumps(receipt,indent=2),flush=True)
    return receipt['exit_code']

def main():
    parser=argparse.ArgumentParser(description=__doc__)
    sub=parser.add_subparsers(dest='mode',required=True)
    p=sub.add_parser('prepare');p.add_argument('--destination',type=Path,required=True)
    p=sub.add_parser('execute');p.add_argument('plan',type=Path);p.add_argument('--plan-sha256',required=True)
    args=parser.parse_args()
    if args.mode=='prepare':prepare(args.destination);return 0
    return execute(args.plan,args.plan_sha256)

if __name__=='__main__':sys.exit(main())
