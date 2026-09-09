"""DIM a -> a2 lossless plaintext recovery. Prepare is read-only in the audit.

Execution requires the exact separately reviewed plan hash. It preserves the
original failures and runs one fresh native adjudicator, the unchanged collector,
then released finalization and complete validation. No verdict is requested.
"""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,importlib.util,json,os,re,subprocess,sys,time
D=Path(__file__).resolve().parent
U=D.parent;S=U.parent;R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
SHIM=U/'fv-local-domain-review/native-long-path-io.py'
exec(compile(SHIM.read_bytes(),str(SHIM),'exec'),globals())
V3=U/'adjudicator-transport-recovery-v3/recovery-v3.py'
assert hashlib.sha256(V3.read_bytes()).hexdigest()=='a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887'
spec=importlib.util.spec_from_file_location('pinned_v3_mechanical_guards',V3)
old=importlib.util.module_from_spec(spec);spec.loader.exec_module(old)
import plaintext,visible
digest=old.digest;sha=old.sha;read=old.read;decode=old.decode;ref=old.ref;verify=old.verify
create=old.create;write=old.write;now=old.now
TID='LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908'
T=S/'audits'/TID;O=T/'faithfulness';P=O/'orchestration'
CONT=U/'dim-original-adjudication-continuation-01'
DIRECT=U/'direct-transport-recovery-v1/dim-d2-01'
CONFIG=U/(TID+'.config.json')
WRAPPER=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
Q_SHA='cb4de37169eabf1a3ad35ed84806d1218c35c72bc67f93abf4386189a250a44f'
ORIGINAL_SHA='697c9141544f9726e7d147d440ebc693665758f53089a6d0ba491ff862492f82'
DIRECT_SHA='ff748b4eabd174f08c839c82978233240bcd6f0eb95d951e465d15c85a2f68ad'
INPUT_SHA='095cd9d4e4fea185e53bad591727277922c544705f83ca45986d5920e356390c'
ROLE_HASHES={
 'source_contract.json':'309dbd468cfea1593dfded144b9f82694e53f1af719b09018670ba5b3bd80da0',
 'blind_translation.json':'f5e87fed3d138ca0ff2a10a67a9076a1af600ef17dd35fb63ef960ad00ca72b8',
 'direct_judge.json':'8de843b40e27cd6e54950d17f0887e46fbbf371d2a13fb7d1682efbd8b635097',
 'roundtrip_judge.json':'f2af3cf76f5d8a870c41e454fd175ab2f1e637732725c140c82db523d2fb75b4'}
ROLES=['source-contract','blind-translation','direct-judge','roundtrip-judge']
LIMIT=1048576

def native_path(p):return '\\\\?\\'+str(p.resolve())
def receipt_pins(value):
 """Enumerate explicit path/SHA records without interpreting judgment payloads."""
 if isinstance(value,dict):
  if isinstance(value.get('path'),str) and re.fullmatch('[0-9a-f]{64}',str(value.get('sha256',''))):
   yield {'path':value['path'],'sha256':value['sha256']}
  for v in value.values():yield from receipt_pins(v)
 elif isinstance(value,list):
  for v in value:yield from receipt_pins(v)

def lineage_contract(original,direct,continuation,runs):
 assert type(original['exit_code']) is int and original['exit_code']==1
 assert direct['task_id']==TID and direct['exit_code']==0 and direct['guard_error'] is None
 assert direct['original_role_run_exit_code']==1
 assert direct['original_role_run_receipt']['sha256']==ORIGINAL_SHA
 assert direct['original_attempt_retained'] is True
 assert direct['audit_completed'] is False and direct['adjudicator_invoked'] is False
 assert direct['adjudication_required'] is True
 assert [(x['name'],x['exit_code']) for x in direct['steps']]==[
  ('prepared-validation',0),('native-direct',0),('collect-direct',0),('collect-roundtrip',0),('check-adjudication',3)]
 assert direct['direct_output']['sha256']==ROLE_HASHES['direct_judge.json']
 assert direct['roundtrip_output']['sha256']==ROLE_HASHES['roundtrip_judge.json']
 assert type(continuation['exit_code']) is int and continuation['exit_code']==1
 assert continuation['original_wrapper']['exit_code']==1
 assert continuation['original_wrapper']['sha256']==ORIGINAL_SHA
 assert continuation['unchanged_q_sha256']==Q_SHA
 assert continuation['roles_before']==ROLE_HASHES
 assert continuation['original_four_roles_unchanged'] is True
 assert continuation['original_wrapper_unchanged'] is True
 assert runs['task_id']==TID and [x['role'] for x in runs['runs']]==ROLES
 assert len({x['agent_id'] for x in runs['runs']})==4
 assert runs['runs'][2]['agent_id']==direct['new_direct_agent_id']
 assert runs['runs'][3]['agent_id']==direct['roundtrip_agent_id']

def command_contract(transport,images):
 command=transport['command']
 assert transport['transport']=='fresh Codex CLI exec stdin' and transport['fork'] is False
 assert transport['cwd']=='C:/Windows/Temp'
 assert command[1:12]==['exec','--ignore-user-config','--skip-git-repo-check','--json',
  '--color','never','-C','C:/Windows/Temp','-s','read-only','-o']
 assert Path(command[12]).resolve()==(P/'a_final.json').resolve()
 tail=command[13:];assert len(tail)==2*len(images)+1 and tail[-1]=='-'
 for i,image in enumerate(images):
  assert tail[2*i]=='-i' and Path(tail[2*i+1]).resolve()==image.resolve()
 assert [x.name for x in images]==['page-026.png','page-027.png','page-028.png','page-125.png','page-126.png']
 return Path(command[0]).resolve()

def events(path):return [decode(x) for x in path.read_bytes().splitlines()]
def lineage():
 assert sha(T/'role-run-receipt.json')==ORIGINAL_SHA
 assert sha(DIRECT/'execution-receipt.json')==DIRECT_SHA
 assert sha(P/'q.py')==Q_SHA
 assert sha(P/'r.py')=='d74a9fdb6572c7345037941eab5f0b582cbaf21bc63c7b450fe8db784521c135'
 original=read(T/'role-run-receipt.json');direct=read(DIRECT/'execution-receipt.json')
 continuation=read(CONT/'receipt.json');runs=read(O/'agent_outputs/agent_runs.json')
 lineage_contract(original,direct,continuation,runs)
 assert sha(T/'role-run-output.txt')==original['stdout_sha256']
 assert sha(T/'role-run-stderr.txt')==original['stderr_sha256']
 assert sha(CONT/'output.txt')==continuation['stdout_sha256']=='87ba1ec49c644044fc1722e60d7abe7e3924e007bebac46c990b2398eed662d0'
 assert sha(CONT/'stderr.txt')==continuation['stderr_sha256']=='2e17b157dbedd6f1add621d03bbca983c2d6991058b6a42c78b33cd54b0dc5c1'
 c=continuation['command'];assert c[1:4]==['-X','utf8','-B']
 assert Path(c[4]).resolve()==(P/'q.py').resolve() and c[5:]==[TID,'26,27,28,125,126','2']
 assert original['command']==c
 for pin in receipt_pins(direct):verify(pin)
 before=read(verify(read(verify(direct['plan']))['runs_before']))
 assert len(before['runs'])==2 and runs['runs'][:2]==before['runs']
 for name,h in ROLE_HASHES.items():assert sha(O/'agent_outputs'/name)==h
 assert sha(T/'role-transport-preflight.json')==original['prepared_transport_sha256']
 prepared=read(T/'role-transport-preflight.json');assert prepared['blind_isolation_verified'] is True
 for h in prepared['helpers']:assert sha(P/h['file'])==h['successor_sha256']
 d_uid=old.unstarted_failure(events(P/'d_events.jsonl'),(P/'d_stderr.txt').read_text(),
  read(P/'d_transport.json'),(P/'d_input.txt').read_bytes())
 transport=read(P/'a_transport.json');raw=(P/'a_input.txt').read_bytes()
 assert digest(raw)==INPUT_SHA
 a_uid=old.unstarted_failure(events(P/'a_events.jsonl'),(P/'a_stderr.txt').read_text(),transport,raw)
 assert d_uid!=a_uid and a_uid not in {x['agent_id'] for x in runs['runs']}
 assert not (P/'d_final.json').exists() and not (P/'a_final.json').exists()
 assert not (O/'decision.json').exists() and not (O/'agent_outputs/adjudicator.json').exists()
 assert read(O/'manifest.json')['status']=='prepared'
 assert not any(p.name.startswith('a2_') for p in P.iterdir())
 for x in transport['inputs']:
  assert sha(Path(x['path']))==x['sha256'] and len(Path(x['path']).read_bytes())==x['bytes']
 images=[Path(x['path']) for x in transport['inputs'] if Path(x['path']).suffix=='.png']
 exe=command_contract(transport,images)
 assert sha(exe)=='77f792476fe0def726503f02a7c55f485e562dd7ad8801fe61dc8f4bf9991d20'
 trigger=read(P/'adjudication_triggers.json');assert trigger['required'] is True
 assert sha(P/'adjudication_triggers.json')==direct['steps'][-1]['stdout']['sha256']
 return {'original_wrapper':ref(T/'role-run-receipt.json'),'original_wrapper_exit_code':1,
  'direct_recovery':ref(DIRECT/'execution-receipt.json'),'direct_recovery_exit_code':0,
  'adjudicator_continuation':ref(CONT/'receipt.json'),'adjudicator_continuation_exit_code':1,
  'original_q':ref(P/'q.py'),'failed_direct_thread_id':d_uid,'failed_adjudicator_thread_id':a_uid,
  'completed_roles':{name:ref(O/'agent_outputs'/name) for name in ROLE_HASHES},
  'native_executable':ref(exe),'images':[ref(x) for x in images]}

def prepare(destination):
 bound=lineage();transport=read(P/'a_transport.json');raw=(P/'a_input.txt').read_bytes()
 small,mapping=plaintext.encode(raw,transport['inputs'])
 assert plaintext.reconstruct(small,mapping)==raw
 assert plaintext.reconstruct(small,decode(json.dumps(mapping,ensure_ascii=False)))==raw
 assert visible.reconstruct(small,transport['inputs'])==raw,'Independent displayed-grammar reconstruction failed'
 assert len(small.decode())<=LIMIT
 static=[Path(__file__),D/'plaintext.py',D/'visible.py',plaintext.BASE,V3,SHIM,WRAPPER,CONFIG,
  T/'audit-task.json',T/'role-run-receipt.json',T/'role-run-output.txt',T/'role-run-stderr.txt',
  T/'role-transport-preflight.json',CONT/'receipt.json',CONT/'output.txt',CONT/'stderr.txt',CONT/'before.json',
  DIRECT/'execution-receipt.json',Path(bound['native_executable']['path'])]
 static += [Path(x['path']) for x in transport['inputs']]
 # Every pre-existing orchestration file is immutable in this recovery; only a2_* may be added.
 static += [p for p in P.iterdir() if p.is_file()]
 static += [verify(x) for x in receipt_pins(read(DIRECT/'execution-receipt.json'))]
 for folder in ['scripts','schemas','prompts','checks','templates']:
  static += [p for p in (R/'.faithfulness-audit'/folder).rglob('*') if p.is_file()]
 static += [R/'.faithfulness-audit/METHODOLOGY.md']
 pins=list({str(p.resolve()):ref(p) for p in static}.values())
 destination=destination.resolve();assert destination.parent==D.resolve()
 destination.mkdir()
 create(destination/'input.txt',small);write(destination/'mapping.json',mapping)
 create(destination/'manifest-before.json',(O/'manifest.json').read_bytes())
 create(destination/'agent-runs-before.json',(O/'agent_outputs/agent_runs.json').read_bytes())
 plan={'format':'dim-adjudicator-plaintext-recovery-plan-1','task_id':TID,'failed_stem':'a','new_stem':'a2',
  'prepared_at_utc':now(),'lineage':bound,'static_inputs':pins,'input':ref(destination/'input.txt'),
  'mapping':ref(destination/'mapping.json'),'original_input':ref(P/'a_input.txt'),
  'original_transport':ref(P/'a_transport.json'),'manifest_before':ref(destination/'manifest-before.json'),
  'agent_runs_before':ref(destination/'agent-runs-before.json'),'runner':ref(Path(__file__)),
  'collector':ref(P/'c.py'),'source_config':ref(CONFIG),'launcher':ref(WRAPPER),
  'stdin_characters':len(small.decode()),'stdin_bytes':len(small),'stdin_sha256':digest(small),
  'original_characters':len(raw.decode()),'original_bytes':len(raw),'original_sha256':digest(raw),
  'limit':LIMIT,'roles_invoked':False,'audit_completed':False,
  'mapping_reconstruction_exact':True,'independent_visible_grammar_reconstruction_exact':True}
 assert lineage()==bound
 for pin in pins:verify(pin)
 write(destination/'plan.json',plan)
 print(json.dumps({'plan':ref(destination/'plan.json'),'characters':len(small.decode()),
  'bytes':len(small),'sha256':digest(small),'headroom':LIMIT-len(small.decode()),'roles_invoked':False},indent=2))

def completed(events_,before,failed):
 assert [x.get('type') for x in events_].count('thread.started')==1
 uid=next(x['thread_id'] for x in events_ if x.get('type')=='thread.started')
 assert uid not in failed and uid not in {x['agent_id'] for x in before['runs']}
 assert sum(x.get('type')=='turn.started' for x in events_)==1
 assert sum(x.get('type')=='turn.completed' for x in events_)==1
 assert not any(x.get('type') in {'error','turn.failed'} for x in events_)
 for x in events_:
  if x.get('type') in {'item.started','item.completed','item.updated'}:
   assert x.get('item',{}).get('type') in {'agent_message','reasoning'}
 return uid

def execute(plan_path,expected):
 assert sha(plan_path)==expected;plan=read(plan_path)
 assert plan['format']=='dim-adjudicator-plaintext-recovery-plan-1' and plan['task_id']==TID
 assert plan['failed_stem']=='a' and plan['new_stem']=='a2'
 assert plan['runner']==ref(Path(__file__)) and lineage()==plan['lineage']
 E=plan_path.parent;assert E.parent==D.resolve() and not (E/'execution-receipt.json').exists()
 for pin in plan['static_inputs']:verify(pin)
 raw=verify(plan['original_input']).read_bytes();original=read(verify(plan['original_transport']))
 small=verify(plan['input']).read_bytes();mapping=read(verify(plan['mapping']))
 rebuilt,remapped=plaintext.encode(raw,original['inputs'])
 assert rebuilt==small and remapped==mapping
 assert plaintext.reconstruct(small,mapping)==visible.reconstruct(small,original['inputs'])==raw
 assert len(small.decode())==plan['stdin_characters']<=LIMIT
 assert len(small)==plan['stdin_bytes'] and digest(small)==plan['stdin_sha256']
 before_manifest=read(verify(plan['manifest_before']));before_runs=read(verify(plan['agent_runs_before']))
 assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
 assert (O/'agent_outputs/agent_runs.json').read_bytes()==verify(plan['agent_runs_before']).read_bytes()
 config=verify(plan['source_config']);assert config.drive.lower()=='c:'
 env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/'+config.as_posix()[3:])
 receipt={'format':'dim-adjudicator-plaintext-recovery-execution-1','task_id':TID,'plan':ref(plan_path),
  'started_at_utc':now(),'lineage':plan['lineage'],'original_statuses_preserved':True,
  'steps':[],'exit_code':2,'audit_completed':False,'guard_error':None,
  'stdin_characters':len(small.decode()),'stdin_bytes':len(small),'stdin_sha256':digest(small),
  'native_environment_before':{'executable':plan['lineage']['native_executable'],'config':ref(config),
   'collector':plan['collector'],'launcher':plan['launcher'],'source_images':plan['lineage']['images']}}
 def stable():
  for pin in plan['static_inputs']:verify(pin)
 def step(name,command):
  a=E/(name+'-output.txt');b=E/(name+'-stderr.txt');start=now();tick=time.monotonic()
  with a.open('xb') as out,b.open('xb') as err:
   result=subprocess.run(command,cwd=R,env=env,stdout=out,stderr=err)
  record={'name':name,'command':command,'started_at_utc':start,'completed_at_utc':now(),
   'elapsed_seconds':time.monotonic()-tick,'exit_code':result.returncode,'stdout':ref(a),'stderr':ref(b)}
  write(E/(name+'-exit.json'),record);receipt['steps'].append(record)
  if result.returncode:raise subprocess.CalledProcessError(result.returncode,command)
 try:
  step('prepared-validation',[sys.executable,'-X','utf8','-B',str(verify(plan['launcher'])),
   '.faithfulness-audit/scripts/validate_audit.py',TID,'--phase','prepared'])
  stable();assert lineage()==plan['lineage']
  create(P/'a2_input.txt',small)
  command=list(original['command']);command[12]=str(Path(command[12]).with_name('a2_final.json'))
  assert command[:12]==original['command'][:12] and command[13:]==original['command'][13:]
  meta={k:original[k] for k in ['transport','fork','cwd']}
  meta.update(command=command,stdin_sha256=digest(small),stdin_bytes=len(small),stdin_characters=len(small.decode()),
   inputs=original['inputs'],started_at=now(),lossless_recovery_plan=ref(plan_path),
   mapping=plan['mapping'],original_expanded_stdin_sha256=digest(raw),original_expanded_stdin_bytes=len(raw))
  write(P/'a2_transport-start.json',meta);start=now();tick=time.monotonic()
  with (P/'a2_events.jsonl').open('xb') as out,(P/'a2_stderr.txt').open('xb') as err:
   result=subprocess.run(command,input=small,stdout=out,stderr=err,cwd=R,env=env)
  meta.update(completed_at=now(),exit_code=result.returncode);write(P/'a2_transport.json',meta)
  receipt['steps'].append({'name':'native-adjudicator','command':command,'started_at_utc':start,
   'completed_at_utc':now(),'elapsed_seconds':time.monotonic()-tick,'exit_code':result.returncode,
   'events':ref(P/'a2_events.jsonl'),'stderr':ref(P/'a2_stderr.txt'),'transport':ref(P/'a2_transport.json')})
  if result.returncode:raise subprocess.CalledProcessError(result.returncode,command)
  uid=completed(events(P/'a2_events.jsonl'),before_runs,
   {plan['lineage']['failed_direct_thread_id'],plan['lineage']['failed_adjudicator_thread_id']})
  stable();assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
  assert (O/'agent_outputs/agent_runs.json').read_bytes()==verify(plan['agent_runs_before']).read_bytes()
  step('collect',[sys.executable,'-X','utf8','-B',native_path(verify(plan['collector'])),TID,'a2','adjudicator','adjudicator.json'])
  stable();old.run_append(before_runs,read(O/'agent_outputs/agent_runs.json'),uid,plan['lineage']['failed_adjudicator_thread_id'])
  after_runs=read(O/'agent_outputs/agent_runs.json')
  assert len({x['model'] for x in before_runs['runs']})==1
  assert after_runs['runs'][-1]['model']==before_runs['runs'][0]['model']
  assert (O/'manifest.json').read_bytes()==verify(plan['manifest_before']).read_bytes()
  after_roles={str(p):sha(p) for p in [O/'agent_outputs/adjudicator.json',O/'agent_outputs/agent_runs.json']}
  step('finalize',[sys.executable,'-X','utf8','-B',str(verify(plan['launcher'])),'.faithfulness-audit/scripts/finalize_audit.py',TID])
  stable();old.manifest_transition(before_manifest,read(O/'manifest.json'));final_manifest=sha(O/'manifest.json')
  step('complete-validation',[sys.executable,'-X','utf8','-B',str(verify(plan['launcher'])),
   '.faithfulness-audit/scripts/validate_audit.py',TID,'--phase','complete'])
  stable();assert sha(O/'manifest.json')==final_manifest
  assert all(sha(Path(p))==h for p,h in after_roles.items())
  decision=read(O/'decision.json')
  receipt.update(exit_code=0,audit_completed=True,new_agent_id=uid,decision=ref(O/'decision.json'),
   report=ref(O/'report.md'),completed_manifest=ref(O/'manifest.json'),runtime=ref(P/'a2_runtime.json'),
   classification=decision['classification'],accepted=decision['accepted'],released_complete_validation_exit_code=0,
   manifest_transition_verified=True)
 except Exception as error:
  receipt['guard_error']=repr(error)
  if isinstance(error,subprocess.CalledProcessError):receipt['exit_code']=error.returncode
 finally:
  receipt['completed_at_utc']=now();receipt['actual_steps_completed']=len(receipt['steps'])
  try:
   stable();receipt['native_environment_after']=receipt['native_environment_before']
   receipt['all_original_static_inputs_unchanged']=True
  except Exception as error:
   receipt['static_pin_error']=repr(error);receipt['exit_code']=2;receipt['audit_completed']=False
  write(E/'execution-receipt.json',receipt);print(json.dumps(receipt,indent=2),flush=True)
 return receipt['exit_code']

def main():
 parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='mode',required=True)
 p=sub.add_parser('prepare');p.add_argument('--destination',type=Path,required=True)
 p=sub.add_parser('execute');p.add_argument('plan',type=Path);p.add_argument('--plan-sha256',required=True)
 args=parser.parse_args()
 if args.mode=='prepare':prepare(args.destination);return 0
 return execute(args.plan.resolve(),args.plan_sha256)
if __name__=='__main__':raise SystemExit(main())
