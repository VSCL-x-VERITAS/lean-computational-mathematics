"""Reviewed, append-only direct-role transport recovery for one recorded unstarted failure.

prepare is read-only on the task. execute requires a pinned plan and separate root review.
If adjudication is required, execute stops after capturing the released trigger calculation.
It never relabels the original wrapper exit or guesses an audit decision.
"""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,importlib.util,json,os,re,subprocess,sys,time
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
SHIM=D.parent/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
import transport
TID='LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
T=S/'audits'/TID;O=T/'faithfulness';P=O/'orchestration'
LIMIT=1048576
PRECEDENT=D.parent/'adjudicator-transport-recovery-v3/recovery-v3.py'
assert hashlib.sha256(PRECEDENT.read_bytes()).hexdigest()=='a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887'
spec=importlib.util.spec_from_file_location('pinned_adjudicator_precedent',PRECEDENT)
v3=importlib.util.module_from_spec(spec);spec.loader.exec_module(v3)
digest=v3.digest;sha=v3.sha;decode=v3.decode;read=v3.read;ref=v3.ref;verify=v3.verify
create=v3.create;write=v3.write;now=v3.now

def absent_attempt(path,stem):
 assert re.fullmatch(r'd[2-9][0-9]*',stem)
 assert not [p for p in path.iterdir() if p.name.startswith(stem+'_')],'Attempt ID already used'

def fresh_completed(events,transport_record,prior_ids):
 assert type(transport_record['exit_code']) is int and transport_record['exit_code']==0
 threads=[x for x in events if x.get('type')=='thread.started'];assert len(threads)==1
 uid=threads[0]['thread_id'];assert uid and uid not in prior_ids
 assert sum(x.get('type')=='turn.started' for x in events)==1
 assert sum(x.get('type')=='turn.completed' for x in events)==1
 assert not any(x.get('type') in ('error','turn.failed') for x in events)
 assert all(x['item']['type']=='agent_message' for x in events if x.get('type')=='item.completed')
 return uid

def append_role(before,after,role,uid):
 assert {k:v for k,v in before.items() if k!='runs'}=={k:v for k,v in after.items() if k!='runs'}
 assert len(after['runs'])==len(before['runs'])+1 and after['runs'][:-1]==before['runs']
 assert after['runs'][-1]['role']==role and after['runs'][-1]['agent_id']==uid
 assert uid not in {x['agent_id'] for x in before['runs']}

def direct_isolation(original,inputs):
 names=[Path(x['path']).name for x in inputs]
 expected=['direct_judge.md','direct_judge.schema.json','source_locator.json','source_contract.json',
  'METHODOLOGY.md','core.json','numerical-analysis.json','user-interpretation-packet.json',
  'inherited-source-interpretation-packet.json','direct_review_packet.md','dependency_inventory.json',
  'dependency-environment-packet.json','page-026.png','page-027.png','page-028.png','page-125.png','page-126.png']
 assert names==expected,'Direct input inventory changed or contains other-role evidence'
 assert b'Direct isolation: do not read blind translation, roundtrip judgment, or prior judgments.' in original
 assert b'Tools are forbidden in this fresh role session.' in original
 for x in inputs:
  body=verify({'path':x['path'],'sha256':x['sha256']}).read_bytes();assert len(body)==x['bytes']
  if Path(x['path']).suffix!='.png':assert original.count(transport.header(x)+body)==1

def original_state():
 wrapper=read(T/'role-run-receipt.json')
 assert type(wrapper['exit_code']) is int and wrapper['exit_code']==1
 assert sha(T/'role-run-output.txt')==wrapper['stdout_sha256']
 assert sha(T/'role-run-stderr.txt')==wrapper['stderr_sha256']
 assert sha(T/'role-transport-preflight.json')==wrapper['prepared_transport_sha256']
 preflight=read(T/'role-transport-preflight.json');assert preflight['blind_isolation_verified']
 for x in preflight['helpers']:assert sha(P/x['file'])==x['successor_sha256']
 manifest=read(O/'manifest.json');assert manifest['status']=='prepared'
 runs=read(O/'agent_outputs/agent_runs.json')
 assert runs['task_id']==TID and [x['role'] for x in runs['runs']]==['source-contract','blind-translation']
 assert len({x['agent_id'] for x in runs['runs']})==2
 for p in [P/'d_final.json',O/'agent_outputs/direct_judge.json',O/'agent_outputs/roundtrip_judge.json',
           O/'agent_outputs/adjudicator.json',O/'decision.json',P/'adjudication_triggers.json',P/'r_runtime.json']:
  assert not p.exists(),str(p)
 original=(P/'d_input.txt').read_bytes();tr=read(P/'d_transport.json')
 events=[decode(x) for x in (P/'d_events.jsonl').read_bytes().splitlines()]
 failed_uid=v3.unstarted_failure(events,(P/'d_stderr.txt').read_text(),tr,original)
 direct_isolation(original,tr['inputs'])
 assert tr['fork'] is False and tr['cwd']=='C:/Windows/Temp' and tr['transport']=='fresh Codex CLI exec stdin'
 command=tr['command']
 assert command[1:12]==['exec','--ignore-user-config','--skip-git-repo-check','--json','--color','never','-C','C:/Windows/Temp','-s','read-only','-o']
 assert Path(command[12]).resolve()==(P/'d_final.json').resolve()
 images=[Path(x['path']) for x in tr['inputs'] if Path(x['path']).suffix=='.png']
 assert len(command[13:])==2*len(images)+1 and command[-1]=='-'
 for i,p in enumerate(images):assert command[13+2*i]=='-i' and Path(command[14+2*i]).resolve()==p.resolve()
 rtr=read(P/'r_transport.json');revents=[decode(x) for x in (P/'r_events.jsonl').read_bytes().splitlines()]
 ruid=fresh_completed(revents,rtr,{failed_uid}|{x['agent_id'] for x in runs['runs']})
 assert (P/'r_final.json').is_file() and sha(P/'r_input.txt')==rtr['stdin_sha256']
 assert (P/'r_input.txt').stat().st_size==rtr['stdin_bytes']
 return original,tr,manifest,runs,failed_uid,ruid

def prepare(destination):
 assert destination.parent.resolve()==D.resolve() and not destination.exists()
 original,tr,manifest,runs,failed_uid,ruid=original_state();absent_attempt(P,'d2')
 compact,mapping=transport.encode(original,tr['inputs'])
 assert len(compact.decode())<=LIMIT
 assert transport.reconstruct(compact,mapping)==original
 config=D.parent/(TID+'.config.json')
 paths=[T/'audit-task.json',T/'role-run-receipt.json',T/'role-run-output.txt',T/'role-run-stderr.txt',
  T/'role-transport-preflight.json',config,SHIM,PRECEDENT,Path(__file__),D/'transport.py',D/'compact.py',
  Path(tr['command'][0]),R.parent/'workflow-v5.0.1-local/run_workflow_posix.py']
 paths.extend(p for p in P.iterdir() if p.is_file())
 paths.extend(Path(x['path']) for x in tr['inputs'])
 paths.extend([O/'agent_outputs/source_contract.json',O/'agent_outputs/blind_translation.json'])
 locator=read(O/'inputs/source_locator.json');paths.append(R/locator['source_path'])
 paths.extend(p for p in (R/'.faithfulness-audit').rglob('*') if p.is_file() and p.suffix in ('.py','.json','.md'))
 pins={str(p.resolve()):ref(p) for p in paths}
 assert sha(R/locator['source_path'])==locator['source_sha256']
 destination.mkdir()
 create(destination/'input.txt',compact);write(destination/'mapping.json',mapping)
 create(destination/'manifest-before.json',(O/'manifest.json').read_bytes())
 create(destination/'agent-runs-before.json',(O/'agent_outputs/agent_runs.json').read_bytes())
 plan={'format':'direct-unstarted-input-limit-recovery-plan-1','task_id':TID,'prepared_at_utc':now(),
  'failed_stem':'d','new_stem':'d2','failed_thread_id':failed_uid,'roundtrip_thread_id':ruid,
  'original_wrapper_exit_code':1,'static_inputs':list(pins.values()),'runner':ref(Path(__file__)),
  'source_config':ref(config),'input':ref(destination/'input.txt'),'mapping':ref(destination/'mapping.json'),
  'original_input':ref(P/'d_input.txt'),'original_transport':ref(P/'d_transport.json'),
  'manifest_before':ref(destination/'manifest-before.json'),'runs_before':ref(destination/'agent-runs-before.json'),
  'original_characters':len(original.decode()),'compact_characters':len(compact.decode()),
  'full_direct_packet_verbatim':True,'all_unique_evidence_retained':True,'reconstruction_byte_equal':True,
  'source_images':[ref(Path(x['path'])) for x in tr['inputs'] if Path(x['path']).suffix=='.png'],
  'roles_invoked':False,'adjudicator_launch_authorized':False}
 write(destination/'plan.json',plan)
 print(json.dumps({'plan':ref(destination/'plan.json'),'original_characters':len(original.decode()),
  'compact_characters':len(compact.decode()),'margin_characters':LIMIT-len(compact.decode()),'roles_invoked':False},indent=2))

def execute(plan_path,expected_sha):
 assert sha(plan_path)==expected_sha
 plan=read(plan_path);assert plan['format']=='direct-unstarted-input-limit-recovery-plan-1' and plan['task_id']==TID
 assert sha(Path(__file__))==plan['runner']['sha256']
 E=plan_path.parent;assert not (E/'execution-receipt.json').exists()
 for pin in plan['static_inputs']:verify(pin)
 for key in ('input','mapping','manifest_before','runs_before'):verify(plan[key])
 original,tr,manifest,runs,failed_uid,ruid=original_state();absent_attempt(P,'d2')
 assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
 assert (O/'agent_outputs/agent_runs.json').read_bytes()==verify(plan['runs_before']).read_bytes()
 assert failed_uid==plan['failed_thread_id'] and ruid==plan['roundtrip_thread_id']
 compact,mapping=transport.encode(original,tr['inputs'])
 assert compact==verify(plan['input']).read_bytes() and mapping==read(verify(plan['mapping']))
 assert len(compact.decode())<=LIMIT and transport.reconstruct(compact,mapping)==original
 config=verify(plan['source_config']);env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/'+config.as_posix()[3:])
 wrapper=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
 receipt={'format':'direct-unstarted-input-limit-recovery-execution-1','task_id':TID,'plan':ref(plan_path),
  'started_at_utc':now(),'original_role_run_receipt':ref(T/'role-run-receipt.json'),
  'original_role_run_exit_code':1,'original_attempt_retained':True,'steps':[],
  'exit_code':2,'audit_completed':False,'adjudicator_invoked':False,'guard_error':None}
 def stable():
  for pin in plan['static_inputs']:verify(pin)
 def step(name,command,allowed=(0,)):
  out=E/(name+'-output.txt');err=E/(name+'-stderr.txt');started=now();clock=time.monotonic()
  with out.open('xb') as stdout,err.open('xb') as stderr:
   result=subprocess.run(command,cwd=R,env=env,stdout=stdout,stderr=stderr)
  record={'name':name,'command':command,'started_at_utc':started,'completed_at_utc':now(),
   'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,'stdout':ref(out),'stderr':ref(err)}
  write(E/(name+'-exit.json'),record);receipt['steps'].append(record)
  if result.returncode not in allowed:raise subprocess.CalledProcessError(result.returncode,command)
  return record
 def released(name,script,*args,allowed=(0,)):
  return step(name,[sys.executable,'-X','utf8','-B',str(wrapper),'.faithfulness-audit/scripts/'+script,TID,*args],allowed)
 try:
  released('prepared-validation','validate_audit.py','--phase','prepared');stable()
  command=list(tr['command']);command[12]=str(Path(command[12]).with_name('d2_final.json'))
  create(P/'d2_input.txt',compact)
  meta={k:tr[k] for k in ('transport','fork','cwd')}
  meta.update(command=command,stdin_sha256=digest(compact),stdin_bytes=len(compact),inputs=tr['inputs'],
   started_at=now(),lossless_recovery_plan=ref(plan_path),original_expanded_stdin_sha256=digest(original),
   lossless_mapping=ref(E/'mapping.json'),direct_isolation_preserved=True)
  write(P/'d2_transport-start.json',meta);started=now();clock=time.monotonic()
  with (P/'d2_events.jsonl').open('xb') as ev,(P/'d2_stderr.txt').open('xb') as err:
   result=subprocess.run(command,input=compact,stdout=ev,stderr=err,cwd=R,env=env)
  meta.update(completed_at=now(),exit_code=result.returncode);write(P/'d2_transport.json',meta)
  record={'name':'native-direct','command':command,'started_at_utc':started,'completed_at_utc':now(),
   'elapsed_seconds':time.monotonic()-clock,'exit_code':result.returncode,
   'events':ref(P/'d2_events.jsonl'),'stderr':ref(P/'d2_stderr.txt'),'transport':ref(P/'d2_transport.json')}
  write(E/'native-direct-exit.json',record);receipt['steps'].append(record)
  if result.returncode:raise subprocess.CalledProcessError(result.returncode,command)
  uid=fresh_completed([decode(x) for x in (P/'d2_events.jsonl').read_bytes().splitlines()],meta,
    {failed_uid,ruid}|{x['agent_id'] for x in runs['runs']})
  stable();assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
  step('collect-direct',[sys.executable,'-X','utf8','-B',str(P/'c.py'),TID,'d2','direct-judge','direct_judge.json'])
  current=read(O/'agent_outputs/agent_runs.json');append_role(runs,current,'direct-judge',uid);stable()
  step('collect-roundtrip',[sys.executable,'-X','utf8','-B',str(P/'c.py'),TID,'r','roundtrip-judge','roundtrip_judge.json'])
  append_role(current,read(O/'agent_outputs/agent_runs.json'),'roundtrip-judge',ruid);stable()
  assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
  completed={str(p):sha(p) for p in [O/'agent_outputs/direct_judge.json',O/'agent_outputs/roundtrip_judge.json',O/'agent_outputs/agent_runs.json']}
  check=released('check-adjudication','finalize_audit.py','--check-adjudication',allowed=(0,3))
  triggers=read(verify(check['stdout']));assert type(triggers['required']) is bool
  assert check['exit_code']==(3 if triggers['required'] else 0);stable()
  receipt.update(new_direct_agent_id=uid,roundtrip_agent_id=ruid,adjudication_required=triggers['required'],
   direct_output=ref(O/'agent_outputs/direct_judge.json'),roundtrip_output=ref(O/'agent_outputs/roundtrip_judge.json'))
  if triggers['required']:
   receipt.update(exit_code=0,status='direct-and-roundtrip-validated-awaiting-adjudication')
   assert not (P/'adjudication_triggers.json').exists() and not (O/'decision.json').exists()
   assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
  else:
   released('finalize','finalize_audit.py');stable();v3.manifest_transition(manifest,read(O/'manifest.json'))
   final_hash=sha(O/'manifest.json')
   released('complete-validation','validate_audit.py','--phase','complete');stable()
   assert sha(O/'manifest.json')==final_hash
   decision=read(O/'decision.json')
   receipt.update(exit_code=0,status='released-complete-validation-passed',audit_completed=True,
    decision=ref(O/'decision.json'),completed_manifest=ref(O/'manifest.json'),report=ref(O/'report.md'),
    classification=decision['classification'],accepted=decision['accepted'])
  assert all(sha(Path(p))==h for p,h in completed.items())
 except Exception as error:
  receipt['guard_error']=repr(error)
  if isinstance(error,subprocess.CalledProcessError):receipt['exit_code']=error.returncode
 finally:
  receipt['completed_at_utc']=now();write(E/'execution-receipt.json',receipt)
  print(json.dumps(receipt,indent=2),flush=True)
 return receipt['exit_code']

def main():
 p=argparse.ArgumentParser(description=__doc__);s=p.add_subparsers(dest='mode',required=True)
 a=s.add_parser('prepare');a.add_argument('--destination',type=Path,required=True)
 a=s.add_parser('execute');a.add_argument('plan',type=Path);a.add_argument('--plan-sha256',required=True)
 a=p.parse_args()
 if a.mode=='prepare':prepare(a.destination.resolve());return 0
 return execute(a.plan.resolve(),a.plan_sha256)
if __name__=='__main__':raise SystemExit(main())
