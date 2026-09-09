"""Explicit staged collection/adjudication check/finalization. No role launcher.

Review-only until root invokes a mode. Failed attempts remain in this folder;
the canonical role-run receipt is created only after genuine complete validation.
"""
from pathlib import Path
from datetime import datetime,timezone
import argparse,hashlib,importlib.util,json,os,re,subprocess,sys

H=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('exact_role_guard',H/'guard.py')
g=importlib.util.module_from_spec(spec);spec.loader.exec_module(g)
R,S,T,O,P,TID=g.R,g.S,g.T,g.O,g.P,g.TID
raw,read,ref,write,create,disk,verify=g.raw,g.read,g.ref,g.write,g.create,g.disk,g.verify
WRAPPER=R.parent/'workflow-v5.0.1-local/run_workflow_posix.py'
CONFIG=S/'unblock-nine-20260908'/(TID+'.config.json')
def now():return datetime.now(timezone.utc).isoformat()
def exists(p):return os.path.exists(disk(p))
def pinned(pair):
 p=Path(pair[0]).resolve();assert hashlib.sha256(raw(p)).hexdigest()==pair[1];return p
def new_attempt(name):
 assert re.fullmatch(r'[a-z][a-z0-9-]*',name)
 p=H/name;assert not exists(p);os.mkdir(disk(p));return p
def env():
 path=CONFIG.as_posix();assert path.startswith('C:/')
 return dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/'+path[3:])
def step(destination,label,command,allowed=(0,)):
 out=destination/(label+'-output.txt');err=destination/(label+'-stderr.txt')
 assert not exists(out) and not exists(err)
 start=now()
 result=subprocess.run(command,cwd=R,env=env(),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 create(out,result.stdout);create(err,result.stderr)
 record={'command':command,'cwd':str(R),'config':ref(CONFIG),'started_at_utc':start,
  'completed_at_utc':now(),'exit_code':result.returncode,'stdout':ref(out),'stderr':ref(err)}
 write(destination/(label+'-receipt.json'),record)
 assert result.returncode in allowed,(label,result.returncode)
 return record
def released(destination,label,script,*args,allowed=(0,)):
 return step(destination,label,[sys.executable,'-X','utf8','-B',str(WRAPPER),
  '.faithfulness-audit/scripts/'+script,TID,*args],allowed)
def collect(args):
 plan_path=pinned(args.plan);plan=read(plan_path)
 assert plan_path.parent.parent==H and plan['task_id']==TID
 assert plan['runner']==ref(H/'guard.py') and plan['within_limit']
 execution_path=plan_path.parent/'execution-receipt.json';execution=read(execution_path)
 assert execution['plan']==ref(plan_path) and execution['actual_exit_code']==0
 assert execution['guard_error'] is None and execution['existing_r_unchanged']
 assert len(execution['actual_cli_calls'])==1
 assert execution['actual_cli_calls'][0]['stdin_sha256']==plan['stdin_sha256']
 collector=verify(plan['collector']);assert collector.resolve()==(P/'c.py').resolve()
 role=plan['role'];stem=plan['stem'];name=g.ROLES[role]
 assert not exists(O/'decision.json') and not exists(O/'agent_outputs'/name)
 destination=new_attempt(args.name)
 before_exists=exists(O/'agent_outputs/agent_runs.json')
 before=read(O/'agent_outputs/agent_runs.json') if before_exists else None
 if before_exists:create(destination/'agent-runs-before.json',raw(O/'agent_outputs/agent_runs.json'))
 else:write(destination/'agent-runs-before.json',None)
 status=2;failure=None;record=None
 try:
  record=step(destination,'collect',[sys.executable,'-X','utf8','-B',disk(collector),TID,stem,role,name])
  after=read(O/'agent_outputs/agent_runs.json')
  prior=[] if before is None else before['runs']
  assert after['task_id']==TID and after['runs'][:-1]==prior
  assert after['runs'][-1]['role']==role and len(after['runs'])==len(prior)+1
  runtime=read(P/(stem+'_runtime.json'))
  assert runtime['tool_calls']==0 and runtime['agent_id']==after['runs'][-1]['agent_id']
  assert runtime['stdin_sha256']==plan['stdin_sha256']
  create(destination/'agent-runs-after.json',raw(O/'agent_outputs/agent_runs.json'))
  status=0
 except Exception as error:failure=repr(error)
 result={'format':'staged-role-collection-1','task_id':TID,'role':role,'stem':stem,
  'plan':ref(plan_path),'execution':ref(execution_path),'collector':ref(collector),
  'exit_code':status,'guard_error':failure,'actual_collector_step':record,
  'agent_runs_before':ref(destination/'agent-runs-before.json'),
  'canonical_agent_runs_existed_before':before_exists,
  'q_py_invoked':False,'semantic_role_invoked':False}
 if status==0:
  result.update(output=ref(O/'agent_outputs'/name),runtime=ref(P/(stem+'_runtime.json')),
   agent_run=after['runs'][-1],agent_runs_after=ref(destination/'agent-runs-after.json'))
 write(destination/'receipt.json',result)
 print(json.dumps({'receipt':ref(destination/'receipt.json'),'exit_code':status},indent=2))
 return status
def collections(pairs,expected):
 found={};pins=[]
 for pair in pairs:
  p=pinned(pair);data=read(p)
  assert data['format']=='staged-role-collection-1' and data['task_id']==TID
  assert data['exit_code']==0 and data['guard_error'] is None and not data['q_py_invoked']
  role=data['role'];assert role in expected and role not in found
  for field in ('plan','execution','collector','output','runtime','agent_runs_before','agent_runs_after'):verify(data[field])
  step_=data['actual_collector_step'];assert step_['exit_code']==0
  verify(step_['stdout']);verify(step_['stderr'])
  output=read(verify(data['output']));assert output['role']==role
  if role!='blind-translation':assert output['task_id']==TID
  found[role]=data;pins.append(ref(p))
 assert set(found)==set(expected)
 runs=read(O/'agent_outputs/agent_runs.json')
 assert runs['task_id']==TID and len(runs['runs'])==len(found)
 assert {x['role'] for x in runs['runs']}==set(found)
 assert len({x['agent_id'] for x in runs['runs']})==len(found)
 for role,data in found.items():
  assert next(x for x in runs['runs'] if x['role']==role)==data['agent_run']
 return found,pins
BASE_ROLES={'source-contract','blind-translation','direct-judge','roundtrip-judge'}
def adjudication_contract(code,triggers):
 assert type(code) is int and code in (0,3) and type(triggers.get('required')) is bool
 assert triggers['required']==(code==3)
def check(args):
 assert not exists(O/'decision.json') and not exists(P/'adjudication_triggers.json')
 found,pins=collections(args.collection,BASE_ROLES)
 destination=new_attempt(args.name);status=2;failure=None;record=None
 try:
  record=released(destination,'check-adjudication','finalize_audit.py','--check-adjudication',allowed=(0,3))
  triggers=read(verify(record['stdout']));adjudication_contract(record['exit_code'],triggers)
  if triggers['required']:create(P/'adjudication_triggers.json',raw(verify(record['stdout'])))
  status=0
 except Exception as error:failure=repr(error)
 result={'format':'staged-adjudication-check-1','task_id':TID,'exit_code':status,
  'guard_error':failure,'collections':pins,'actual_check':record,'q_py_invoked':False}
 if status==0:result.update(required=triggers['required'],triggers=triggers,
  trigger_file=ref(P/'adjudication_triggers.json') if triggers['required'] else None)
 write(destination/'receipt.json',result)
 print(json.dumps({'receipt':ref(destination/'receipt.json'),'exit_code':status},indent=2))
 return status
def finish_core(args,destination):
 check_path=pinned(args.check);check_=read(check_path)
 assert check_['format']=='staged-adjudication-check-1' and check_['task_id']==TID
 assert check_['exit_code']==0 and check_['guard_error'] is None
 actual=check_['actual_check'];verify(actual['stdout']);verify(actual['stderr'])
 adjudication_contract(actual['exit_code'],read(verify(actual['stdout'])))
 assert read(verify(actual['stdout']))==check_['triggers']
 expected=BASE_ROLES|({'adjudicator'} if check_['required'] else set())
 found,pins=collections(args.collection,expected)
 base_pins=[item for item in pins if read(Path(item['path']))['role'] in BASE_ROLES]
 assert sorted(base_pins,key=lambda item:item['path'])==sorted(check_['collections'],key=lambda item:item['path'])
 if check_['required']:assert raw(verify(check_['trigger_file']))==raw(verify(actual['stdout']))
 else:assert not exists(O/'agent_outputs/adjudicator.json')
 assert not exists(O/'decision.json')
 output_pins=[data['output'] for data in found.values()]
 steps=[]
 steps.append(released(destination,'prepared-validation','validate_audit.py','--phase','prepared'))
 for role in sorted(expected):
  steps.append(released(destination,'validate-'+role,'validate_agent_output.py',role))
 steps.append(released(destination,'finalize','finalize_audit.py'))
 steps.append(released(destination,'complete-validation','validate_audit.py','--phase','complete'))
 for item in output_pins:verify(item)
 result={'format':'staged-audit-completion-1','task_id':TID,'exit_code':0,
  'collections':pins,'adjudication_check':ref(check_path),'steps':steps,
  'decision':ref(O/'decision.json'),'manifest':ref(O/'manifest.json'),'report':ref(O/'report.md'),
  'q_py_invoked':False,'source_acceptance_inferred':False}
 write(destination/'completion.json',result)
 print(json.dumps(result,indent=2));return 0
def finish(args):
 for name in ('role-run-receipt.json','role-run-output.txt','role-run-stderr.txt'):
  assert not exists(T/name),'Existing aggregate must remain immutable'
 destination=new_attempt(args.name)
 command=[sys.executable,'-X','utf8','-B',disk(Path(__file__)),'_finish',str(destination),
  '--check',*args.check]
 for pair in args.collection:command+=['--collection',*pair]
 start=now();result=subprocess.run(command,cwd=R,env=env(),stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 create(destination/'output.txt',result.stdout);create(destination/'stderr.txt',result.stderr)
 attempt={'format':'staged-finalizer-attempt-1','command':command,'started_at_utc':start,
  'completed_at_utc':now(),'exit_code':result.returncode,'stdout':ref(destination/'output.txt'),
  'stderr':ref(destination/'stderr.txt'),'q_py_invoked':False,'runner':ref(Path(__file__))}
 write(destination/'attempt-receipt.json',attempt)
 if result.returncode==0:
  complete=read(destination/'completion.json');assert complete['exit_code']==0
  assert complete['task_id']==TID and not complete['q_py_invoked']
  for name in ('decision','manifest','report'):verify(complete[name])
  create(T/'role-run-output.txt',result.stdout);create(T/'role-run-stderr.txt',result.stderr)
  aggregate={'format':'staged-existing-r-c-audit-run-1','task_id':TID,'command':command,
   'started_at_utc':start,'completed_at_utc':attempt['completed_at_utc'],'exit_code':0,
   'stdout_sha256':hashlib.sha256(result.stdout).hexdigest(),'stderr_sha256':hashlib.sha256(result.stderr).hexdigest(),
   'prepared_transport_sha256':hashlib.sha256(raw(T/'role-transport-preflight.json')).hexdigest(),
   'decision_sha256':complete['decision']['sha256'],'manifest_sha256':complete['manifest']['sha256'],
   'report_sha256':complete['report']['sha256'],'completion':ref(destination/'completion.json'),
   'attempt':ref(destination/'attempt-receipt.json'),'q_py_invoked':False,
   'audit_completed':True,'source_acceptance_inferred':False}
  write(T/'role-run-receipt.json',aggregate)
  print(json.dumps({'aggregate':ref(T/'role-run-receipt.json'),'exit_code':0},indent=2))
 return result.returncode
def main():
 parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='mode',required=True)
 p=sub.add_parser('collect');p.add_argument('--plan',nargs=2,required=True);p.add_argument('--name',required=True)
 p=sub.add_parser('check-adjudication');p.add_argument('--collection',nargs=2,action='append',required=True);p.add_argument('--name',required=True)
 p=sub.add_parser('finish');p.add_argument('--collection',nargs=2,action='append',required=True);p.add_argument('--check',nargs=2,required=True);p.add_argument('--name',required=True)
 p=sub.add_parser('_finish');p.add_argument('destination',type=Path);p.add_argument('--collection',nargs=2,action='append',required=True);p.add_argument('--check',nargs=2,required=True)
 args=parser.parse_args()
 if args.mode=='collect':return collect(args)
 if args.mode=='check-adjudication':return check(args)
 if args.mode=='finish':return finish(args)
 assert args.destination.resolve().parent==H and os.path.isdir(disk(args.destination))
 return finish_core(args,args.destination)
if __name__=='__main__':raise SystemExit(main())
