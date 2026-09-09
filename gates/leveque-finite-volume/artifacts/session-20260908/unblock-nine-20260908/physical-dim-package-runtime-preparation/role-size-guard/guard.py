"""Prepare or explicitly execute one byte-identical existing audit role below a UTF-8 cap.

No semantic prompt builder is duplicated. Preparation evaluates the exact r.py AST
through its message assignment with writes/processes denied. Execution runs that
unchanged r.py and checks its actual subprocess stdin before delegating to the CLI.
"""
from pathlib import Path
from datetime import datetime, timezone
import argparse, ast, builtins, hashlib, io, json, os, re, runpy, subprocess, sys

HERE=Path(__file__).resolve().parent
R=next(p for p in HERE.parents if (p/'lean-toolchain').is_file())
S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
TID='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
T=S/'audits'/TID;O=T/'faithfulness';P=O/'orchestration'
LIMIT=1048576
ROLES={'source-contract':'source_contract.json','blind-translation':'blind_translation.json',
 'direct-judge':'direct_judge.json','roundtrip-judge':'roundtrip_judge.json','adjudicator':'adjudicator.json'}
PAGES='25,26,27,28,125,126'
def disk(p):
 value=os.path.abspath(p)
 if os.name=='nt' and not value.startswith('\\\\?\\'):
  value='\\\\?\\UNC\\'+value[2:] if value.startswith('\\\\') else '\\\\?\\'+value
 return value
def raw(p):
 with io.open(disk(p),'rb') as stream:return stream.read()
def digest(b):return hashlib.sha256(b).hexdigest()
def ref(p):return {'path':str(p),'sha256':digest(raw(p)),'bytes':len(raw(p))}
def read(p):return json.loads(raw(p))
def create(p,data):
 with io.open(disk(p),'xb') as stream:stream.write(data)
def write(p,value):create(p,(json.dumps(value,indent=2,ensure_ascii=False)+'\n').encode())
def now():return datetime.now(timezone.utc).isoformat()
def verify(item):
 p=Path(item['path']);assert ref(p)==item,('changed input',item['path']);return p
def size_guard(message):
 assert isinstance(message,bytes)
 message.decode('utf-8')
 assert len(message)<=LIMIT,('UTF-8 stdin exceeds reviewed byte cap',len(message),LIMIT)
 return digest(message)
def existing(task,role,stem,pages):
 assert task==TID and role in ROLES and re.fullmatch(r'[a-z][a-z0-9]*',stem)
 assert pages==('' if role=='blind-translation' else PAGES)
 assert os.path.isdir(disk(P)) and not os.path.exists(disk(O/'decision.json'))
 assert not os.path.exists(disk(O/'agent_outputs'/ROLES[role])), 'Completed role cannot be relaunched.'
 for suffix in ('input.txt','events.jsonl','stderr.txt','final.json','transport.json','runtime.json'):
  assert not os.path.exists(disk(P/(stem+'_'+suffix))),('Retained stem cannot be reused',stem,suffix)
 preflight=read(T/'role-transport-preflight.json')
 assert preflight['blind_isolation_verified'] is True
 for helper in preflight['helpers']:
  assert digest(raw(P/helper['file']))==helper['successor_sha256']
 validation=read(T/'prepared-validation-exit.json')
 assert validation['exit_code']==0 and read(O/'manifest.json')['status']=='prepared'
 for page in pages.split(','):
  if page:assert os.path.isfile(disk(P/('page-'+page.zfill(3)+'.png')))
 return preflight

def assemble(script,task,role,stem,pages):
 """Execute the exact constructor prefix; no substituted evidence or writes."""
 source=raw(script);tree=ast.parse(source)
 indices=[i for i,n in enumerate(tree.body) if isinstance(n,ast.Assign)
  and any(isinstance(t,ast.Name) and t.id=='message' for t in n.targets)]
 assert len(indices)==1
 stop=indices[0];last=tree.body[stop]
 assert ast.dump(last.value)==ast.dump(ast.parse("b''.join(parts)",mode='eval').body)
 prefix=ast.Module(body=tree.body[:stop+1],type_ignores=[])
 assert not any(isinstance(n,ast.Attribute) and isinstance(n.value,ast.Name)
  and n.value.id=='subprocess' for n in ast.walk(prefix))
 previous=(io.open,builtins.open,os.mkdir,subprocess.run,subprocess.Popen,sys.argv)
 path_methods={name:getattr(Path,name) for name in ('open','stat','mkdir','iterdir','resolve')}
 marker_exists=hasattr(Path,'_audit_extended_io_installed')
 marker=getattr(Path,'_audit_extended_io_installed',None)
 reads=set();denied=[]
 def readonly_open(file,mode='r',*args,**kwargs):
  assert isinstance(mode,str)
  if any(x in mode for x in 'wax+'):
   denied.append(('write',str(file)));raise AssertionError('Prompt-prefix write denied')
  if not isinstance(file,int):reads.add(os.path.abspath(file))
  return previous[0](file,mode,*args,**kwargs)
 def existing_directory(path,*args,**kwargs):
  assert os.path.isdir(path),'Prompt-prefix directory creation denied'
  raise FileExistsError(17,'Existing directory only',path)
 def no_process(*args,**kwargs):raise AssertionError('Prompt-prefix process denied')
 namespace={'__name__':'read_only_exact_role_prefix','__file__':str(script)}
 try:
  io.open=builtins.open=readonly_open;os.mkdir=existing_directory
  subprocess.run=subprocess.Popen=no_process
  sys.argv=[str(script),task,role,stem,pages]
  exec(compile(prefix,str(script)+' [exact read-only prefix]','exec'),namespace)
 finally:
  io.open,builtins.open,os.mkdir,subprocess.run,subprocess.Popen,sys.argv=previous
  for name,value in path_methods.items():setattr(Path,name,value)
  if marker_exists:Path._audit_extended_io_installed=marker
  elif hasattr(Path,'_audit_extended_io_installed'):delattr(Path,'_audit_extended_io_installed')
 assert not denied
 message=namespace['message'];assert isinstance(message,bytes)
 if role=='blind-translation':
  packet=raw(O/'inputs/blind_review_packet.md')
  assert message.endswith(packet) and message.count(packet)==1 and not namespace['images']
  assert TID.encode() not in message and b'LeVeque' not in message and b'user-interpretation' not in message
 return message,namespace['records'],[ref(Path(p)) for p in sorted(reads)]

def prepare(args):
 existing(TID,args.role,args.stem,args.pages)
 assert re.fullmatch(r'[a-z][a-z0-9-]*',args.name)
 dest=HERE/args.name;assert not os.path.exists(disk(dest))
 r=P/'r.py';message,records,pins=assemble(r,TID,args.role,args.stem,args.pages)
 # Repeated exact construction detects stateful construction before freezing.
 again,records2,pins2=assemble(r,TID,args.role,args.stem,args.pages)
 assert (message,records,pins)==(again,records2,pins2)
 launchable=len(message)<=LIMIT
 if launchable:size_guard(message)
 os.mkdir(disk(dest));create(dest/'input.txt',message)
 plan={'format':'exact-role-stdin-size-guard-1','task_id':TID,'role':args.role,'stem':args.stem,
  'pages':args.pages,'prepared_at_utc':now(),'runner':ref(Path(__file__)),'existing_r':ref(r),
  'collector':ref(P/'c.py'),'transport_preflight':ref(T/'role-transport-preflight.json'),
  'prepared_validation':ref(T/'prepared-validation-exit.json'),'input':ref(dest/'input.txt'),
  'input_records':records,'constructor_read_pins':pins,'stdin_bytes':len(message),
  'stdin_characters':len(message.decode()),'stdin_sha256':digest(message),'byte_limit':LIMIT,
  'within_limit':launchable,'repeated_construction_exact':True,
  'prefix_writes_denied':True,'prefix_processes_denied':True,'role_invoked':False}
 write(dest/'plan.json',plan)
 print(json.dumps({'plan':ref(dest/'plan.json'),'stdin_bytes':len(message),
  'stdin_characters':len(message.decode()),'within_limit':launchable,'role_invoked':False},indent=2))
 return 0 if launchable else 3

def execute(args):
 plan_path=args.plan.resolve();assert plan_path.parent.parent==HERE
 assert digest(raw(plan_path))==args.plan_sha256
 plan=read(plan_path);assert plan['format']=='exact-role-stdin-size-guard-1'
 assert plan['task_id']==TID and plan['runner']==ref(Path(__file__)) and plan['within_limit']
 assert plan['byte_limit']==LIMIT and not os.path.exists(disk(plan_path.parent/'execution-receipt.json'))
 existing(TID,plan['role'],plan['stem'],plan['pages'])
 for item in [plan['existing_r'],plan['collector'],plan['transport_preflight'],
              plan['prepared_validation'],*plan['constructor_read_pins']]:verify(item)
 frozen=raw(verify(plan['input']));assert size_guard(frozen)==plan['stdin_sha256']
 message,records,pins=assemble(verify(plan['existing_r']),TID,plan['role'],plan['stem'],plan['pages'])
 assert message==frozen and records==plan['input_records'] and pins==plan['constructor_read_pins']
 command_calls=[];original_run=subprocess.run;original_argv=sys.argv
 start=now();status=2;failure=None
 def guarded_cli(command,*args,**kwargs):
  assert not command_calls,'Exactly one CLI invocation is permitted'
  assert isinstance(command,list) and command[1:12]==['exec','--ignore-user-config',
   '--skip-git-repo-check','--json','--color','never','-C','C:/Windows/Temp','-s','read-only','-o']
  assert command[-1]=='-' and Path(command[12]).name==plan['stem']+'_final.json'
  actual=kwargs.get('input');assert actual==frozen and size_guard(actual)==plan['stdin_sha256']
  for item in plan['constructor_read_pins']:verify(item)
  command_calls.append({'command':command,'stdin_sha256':digest(actual),'stdin_bytes':len(actual)})
  return original_run(command,*args,**kwargs)
 try:
  subprocess.run=guarded_cli
  sys.argv=[str(P/'r.py'),TID,plan['role'],plan['stem'],plan['pages']]
  runpy.run_path(disk(P/'r.py'),run_name='__main__')
  assert len(command_calls)==1
  transport=read(P/(plan['stem']+'_transport.json'))
  assert transport['stdin_sha256']==plan['stdin_sha256'] and transport['stdin_bytes']==len(frozen)
  assert raw(P/(plan['stem']+'_input.txt'))==frozen
  status=transport['exit_code']
 except BaseException as error:
  failure=repr(error)
 finally:
  subprocess.run=original_run;sys.argv=original_argv
  write(plan_path.parent/'execution-receipt.json',{'plan':ref(plan_path),'started_at_utc':start,
   'completed_at_utc':now(),'actual_exit_code':status,'guard_error':failure,
   'actual_cli_calls':command_calls,'collector_invoked':False,
   'source_acceptance':False,'existing_r_unchanged':ref(P/'r.py')==plan['existing_r']})
 return status

def main():
 parser=argparse.ArgumentParser(description=__doc__);sub=parser.add_subparsers(dest='mode',required=True)
 p=sub.add_parser('prepare');p.add_argument('role',choices=ROLES);p.add_argument('stem');p.add_argument('pages');p.add_argument('--name',required=True)
 p=sub.add_parser('execute');p.add_argument('plan',type=Path);p.add_argument('--plan-sha256',required=True)
 args=parser.parse_args()
 return prepare(args) if args.mode=='prepare' else execute(args)
if __name__=='__main__':raise SystemExit(main())
