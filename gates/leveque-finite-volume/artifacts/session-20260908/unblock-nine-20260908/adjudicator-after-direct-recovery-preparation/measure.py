"""Read-only prospective input construction from the exact existing r.py prefix.

No role launch. All writes through Path are forbidden during prefix evaluation.
Until q supplies canonical triggers, the prior actual released check's exact stdout
is supplied virtually at that one read path, explicitly recorded as prospective.
"""
from pathlib import Path
import ast,hashlib,importlib.util,io,json,os,sys,time
D=Path(__file__).resolve().parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file());S=R/'gates/leveque-finite-volume/artifacts/session-20260908'
exec(compile((D.parent/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'shim','exec'),globals())
TID='LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908';T=S/'audits'/TID;O=T/'faithfulness';P=O/'orchestration'
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':str(p),'sha256':sha(p),'bytes':p.stat().st_size}
def create(p,b):
 with p.open('xb') as f:f.write(b)
def write(p,x):create(p,(json.dumps(x,indent=2)+'\n').encode())
triggers=P/'adjudication_triggers.json'
prior=D.parent/'direct-transport-recovery-v1/dim-d2-01/check-adjudication-output.txt'
receipt=D.parent/'direct-transport-recovery-v1/dim-d2-01/execution-receipt.json'
execution=json.loads(receipt.read_bytes());assert execution['exit_code']==0 and not execution['audit_completed']
check=next(x for x in execution['steps'] if x['name']=='check-adjudication');assert check['exit_code']==3 and check['stdout']['sha256']==sha(prior)
assert json.loads(prior.read_bytes())['required'] is True
virtual=not triggers.is_file();trigger_bytes=prior.read_bytes() if virtual else triggers.read_bytes()
source=(P/'r.py').read_bytes();tree=ast.parse(source)
end=next(i for i,node in enumerate(tree.body) if isinstance(node,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='message' for t in node.targets))
prefix=ast.Module(body=tree.body[:end+1],type_ignores=[])
assert isinstance(prefix.body[-1].value,ast.Call)
old_open=Path.open;old_mkdir=Path.mkdir;old_argv=sys.argv
reads=[]
def read_only_open(self,mode='r',*args,**kwargs):
 assert not any(x in mode for x in ('w','a','x','+')),'Attempted mutation in prefix'
 if self.resolve()==triggers.resolve() and virtual:
  reads.append({'virtual':str(self),'actual_input':ref(prior)})
  return io.BytesIO(trigger_bytes) if 'b' in mode else io.StringIO(trigger_bytes.decode())
 return old_open(self,mode,*args,**kwargs)
def read_only_mkdir(self,*args,**kwargs):assert self.is_dir(),'Attempted directory creation'
namespace={'__name__':'read_only_prompt_prefix','__file__':str(P/'r.py')}
try:
 Path.open=read_only_open;Path.mkdir=read_only_mkdir
 sys.argv=[str(P/'r.py'),TID,'adjudicator','a','26,27,28,125,126']
 exec(compile(prefix,str(P/'r.py')+' [read-only prefix]','exec'),namespace)
finally:Path.open=old_open;Path.mkdir=old_mkdir;sys.argv=old_argv
raw=namespace['message'];inputs=namespace['records']
create(D/'prospective-input.txt',raw)
for item in inputs:
 p=Path(item['path']);body=trigger_bytes if p.resolve()==triggers.resolve() and virtual else p.read_bytes()
 assert hashlib.sha256(body).hexdigest()==item['sha256'] and len(body)==item['bytes']
 # Only the capacity experiment redirects the virtual canonical path to an exact-byte local snapshot.
 if p.resolve()==triggers.resolve() and virtual:
  create(D/'prospective-triggers.json',body);item['path']=str(D/'prospective-triggers.json')
path=D.parent/'adjudicator-transport-recovery-v3/recovery-v3.py'
assert sha(path)=='a2dddf4c3d7ca324f44fe9034b76964514d4c1e4eee96ea72bb5e48f90ff9887'
spec=importlib.util.spec_from_file_location('v3',path);v3=importlib.util.module_from_spec(spec);spec.loader.exec_module(v3)
clock=time.monotonic();compact,mapping=v3.deduplicate(raw,inputs)
create(D/'prospective-v3-input.txt',compact);write(D/'prospective-v3-mapping.json',mapping)
write(D/'prospective-input-records.json',inputs)
result={'format':'prospective-adjudicator-capacity-measurement-1','r_py':ref(P/'r.py'),
 'evaluated_prefix_last_ast_node':end,'all_prefix_writes_blocked':True,'source_of_trigger_bytes':ref(prior) if virtual else ref(triggers),
 'canonical_trigger_read_virtual':virtual,'actual_role_invocation':False,'actual_a_failure_claimed':False,
 'input':ref(D/'prospective-input.txt'),'original_characters':len(raw.decode()),
 'v3_input':ref(D/'prospective-v3-input.txt'),'v3_characters':len(compact.decode()),
 'v3_fits_native_limit':len(compact.decode())<=1048576,'v3_exact_reconstruction_verified':True,
 'v3_elapsed_seconds':time.monotonic()-clock,'actual_completed_direct_recovery':ref(receipt),
 'inputs':inputs}
write(D/'capacity.json',result)
print(json.dumps({k:v for k,v in result.items() if k!='inputs'},indent=2))
