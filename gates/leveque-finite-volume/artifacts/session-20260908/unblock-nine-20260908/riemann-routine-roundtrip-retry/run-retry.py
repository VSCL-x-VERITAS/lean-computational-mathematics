"""Fresh r2 only. Never collects or writes canonical audit outputs."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,subprocess,sys,time
F=Path(__file__).resolve().parent;D=F.parent;S=D.parent
R=next(p for p in F.parents if (p/'lean-toolchain').exists())
SHIM=D/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
TASK='LEV-CH01-LOCAL-RIEMANN-ROUTINE-INTERFACE-PRODUCTION-20260908'
T=S/'audits'/TASK;O=T/'faithfulness';P=O/'orchestration'
wrapper=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:dict(path=str(p.resolve()),sha256=sha(p))
read=lambda p:json.loads(p.read_bytes())
def now():return datetime.now(timezone.utc).isoformat()
def write(path,value):
 with path.open('x',encoding='utf-8') as out:json.dump(value,out,indent=2,ensure_ascii=False);out.write('\n')
def step(name,args,expected):
 command=[sys.executable,'-X','utf8','-B',*map(str,args)]
 out=F/(name+'-output.txt');err=F/(name+'-stderr.txt');start=now();clock=time.monotonic()
 with out.open('xb') as stdout,err.open('xb') as stderr:
  result=subprocess.run(command,cwd=R,stdout=stdout,stderr=stderr)
 receipt={'command':command,'started_at_utc':start,'completed_at_utc':now(),
  'elapsed_seconds':time.monotonic()-clock,'actual_exit_code':result.returncode,
  'stdout':ref(out),'stderr':ref(err)}
 write(F/(name+'-exit.json'),receipt)
 assert result.returncode==expected,(name,result.returncode)
 print(json.dumps(receipt),flush=True)
 return receipt
assert not any(p.name.startswith('r2_') for p in P.iterdir())
assert not (O/'decision.json').exists()
oldfiles=[p for p in P.iterdir() if p.name.startswith('r_')]
required={'r_input.txt','r_events.jsonl','r_stderr.txt','r_transport.json','r_final.json'}
assert required<={p.name for p in oldfiles}
transport=read(P/'r_transport.json');assert transport['exit_code']==0
oldpins=[ref(p) for p in oldfiles]+[ref(P/name) for name in ('q.py','r.py','c.py')]
assert sha(P/'r_input.txt')==transport['stdin_sha256']
assert sha(O/'agent_outputs/blind_translation.json')==next(x['sha256'] for x in transport['inputs'] if x.get('label','').startswith('Complete blind translation'))
route=step('route',[wrapper,Path('C:/Users/qed_s/.codex/skills/formalization-faithfulness-audit/scripts/route_audit.py'),T/'audit-task.json'],0)
diagnosis=step('invalid-r-diagnosis',[wrapper,F/'diagnose-uncollected.py','r'],2)
bad=read(F/'invalid-r-diagnosis-output.txt')
assert bad['source_sha256_expected']=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
assert len(bad['source_sha256_actual'])==63 and bad['source_sha256_actual']!=bad['source_sha256_expected']
assert 'roundtrip-judge: source hash mismatch' in bad['errors']
# Execute only the unchanged runner's input-assembly prefix, before its first input write.
# All expected source images already exist, so this makes no audit-file writes.
runner=(P/'r.py').read_bytes();split=runner.index(b'\ninp=tr/')
for page in ('026','027','028'):assert (P/('page-'+page+'.png')).is_file()
saved=list(sys.argv);sys.argv=[str(P/'r.py'),TASK,'roundtrip-judge','r2','26,27,28']
namespace={'__name__':'exact_runner_input_preflight','__file__':str(P/'r.py')}
try:exec(compile(runner[:split],str(P/'r.py'),'exec'),namespace)
finally:sys.argv=saved
assert namespace['message']==(P/'r_input.txt').read_bytes()
assert namespace['records']==transport['inputs']
for pin in oldpins:assert sha(Path(pin['path']))==pin['sha256']
preflight={'task_id':TASK,'prepared_at_utc':now(),'old_attempt_files':oldpins,
 'invalid_output':ref(P/'r_final.json'),'diagnosis':ref(F/'invalid-r-diagnosis-output.txt'),
 'runner':ref(P/'r.py'),'expected_input':ref(P/'r_input.txt'),
 'same_exact_input_verified_before_launch':True,'same_exact_images_and_inline_inputs':True,
 'failed_output_or_feedback_in_retry_prompt':False,'new_stem':'r2',
 'scope':'Fresh stateless roundtrip retry only. No collector, canonical output, finalizer, or q restart.',
 'canonical_roundtrip_present_at_preflight':(O/'agent_outputs/roundtrip_judge.json').exists()}
write(F/'preflight.json',preflight)
role_receipt=step('fresh-r2',[P/'r.py',TASK,'roundtrip-judge','r2','26,27,28'],0)
fresh=read(P/'r2_transport.json')
assert fresh['exit_code']==0
assert (P/'r2_input.txt').read_bytes()==(P/'r_input.txt').read_bytes()
assert fresh['inputs']==transport['inputs']
for pin in oldpins:assert sha(Path(pin['path']))==pin['sha256']
events=[json.loads(line) for line in (P/'r2_events.jsonl').read_bytes().splitlines()]
threads=[e for e in events if e.get('type')=='thread.started']
oldthreads=[e for e in (json.loads(line) for line in (P/'r_events.jsonl').read_bytes().splitlines()) if e.get('type')=='thread.started']
assert len(threads)==len(oldthreads)==1 and threads[0]['thread_id']!=oldthreads[0]['thread_id']
assert sum(e.get('type')=='turn.started' for e in events)==sum(e.get('type')=='turn.completed' for e in events)==1
assert not any(e.get('type') in ('error','turn.failed') for e in events)
assert all(e['item']['type']=='agent_message' for e in events if e.get('type')=='item.completed')
check=step('fresh-r2-validation',[wrapper,F/'diagnose-uncollected.py','r2'],0)
write(F/'fresh-retry-receipt.json',{'task_id':TASK,'completed_at_utc':now(),
 'preflight':ref(F/'preflight.json'),'actual_native_invocation':ref(F/'fresh-r2-exit.json'),
 'actual_native_transport':ref(P/'r2_transport.json'),'actual_agent_id':threads[0]['thread_id'],
 'prior_invalid_agent_id':oldthreads[0]['thread_id'],'events':ref(P/'r2_events.jsonl'),
 'fresh_output':ref(P/'r2_final.json'),'released_uncollected_validation':ref(F/'fresh-r2-validation-exit.json'),
 'original_r_files_unchanged':True,'input_byte_equal':True,'canonical_collection_performed':False})
print(json.dumps({'fresh_retry_receipt':ref(F/'fresh-retry-receipt.json'),
 'actual_agent_id':threads[0]['thread_id'],'validated':True,'canonical_collection_performed':False}),flush=True)
