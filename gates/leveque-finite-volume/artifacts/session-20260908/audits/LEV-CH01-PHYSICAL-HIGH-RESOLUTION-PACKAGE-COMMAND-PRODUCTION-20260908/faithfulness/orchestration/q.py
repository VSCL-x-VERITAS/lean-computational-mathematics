import os,sys,json,subprocess,hashlib
from pathlib import Path
import os
def install_native_long_path_io():
 """Use extended Windows paths only at I/O; preserve all logical Path strings."""
 import io
 if getattr(Path,'_audit_extended_io_installed',False):return
 assert os.name=='nt'
 def native_path(path):
  value=os.path.abspath(os.fspath(path))
  if value.startswith('\\\\?\\'):return value
  if value.startswith('\\\\'):return '\\\\?\\UNC\\'+value[2:]
  return '\\\\?\\'+value
 def normal_path(value):
  if value.startswith('\\\\?\\UNC\\'):return '\\\\'+value[8:]
  if value.startswith('\\\\?\\'):return value[4:]
  return value
 def path_open(self,mode='r',buffering=-1,encoding=None,errors=None,newline=None):
  return io.open(native_path(self),mode,buffering,encoding,errors,newline)
 def path_stat(self,*,follow_symlinks=True):return os.stat(native_path(self),follow_symlinks=follow_symlinks)
 def path_mkdir(self,mode=0o777,parents=False,exist_ok=False):
  try:os.mkdir(native_path(self),mode)
  except FileNotFoundError:
   if not parents or self.parent==self:raise
   self.parent.mkdir(parents=True,exist_ok=True)
   self.mkdir(mode,parents=False,exist_ok=exist_ok)
  except OSError:
   if not exist_ok or not self.is_dir():raise
 def path_iterdir(self):
  for name in os.listdir(native_path(self)):yield self/name
 def path_resolve(self,strict=False):return type(self)(normal_path(os.path.realpath(native_path(self),strict=strict)))
 Path.open=path_open;Path.stat=path_stat;Path.mkdir=path_mkdir;Path.iterdir=path_iterdir;Path.resolve=path_resolve
 Path._audit_extended_io_installed=True

install_native_long_path_io()

from concurrent.futures import ThreadPoolExecutor
root=Path(r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics')
task,pages=sys.argv[1:3]
assert task=='LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908'
workers=int(sys.argv[3]) if len(sys.argv)>3 else 1
assert workers in (1,2)
assert task.startswith('LEV-CH01-') and task.endswith(('-CANONICAL-20260908','-PRODUCTION-20260908'))
base=root/'gates/leveque-finite-volume/artifacts/session-20260908/audits'
out=Path(chr(92)*2+'?'+chr(92)+str(base/task/'faithfulness'))
helper=out/'orchestration'
assert not (out/'decision.json').exists(), 'Frozen/completed audit must not be changed'
env=dict(os.environ,FAITHFULNESS_AUDIT_CONFIG='/c/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/lean-computational-mathematics/gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/LEV-CH01-PHYSICAL-HIGH-RESOLUTION-PACKAGE-COMMAND-PRODUCTION-20260908.config.json')
wrapper=r'C:/Users/qed_s/OneDrive/Documents/ChatGPT/VSCL-x-VERITAS/workflow-v5.0.1-local/run_workflow_posix.py'
def released(script,*args,capture=False):
 cmd=[sys.executable,'-B',wrapper,'.faithfulness-audit/scripts/'+script,task,*args]
 if capture: return subprocess.run(cmd,cwd=root,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 subprocess.run(cmd,cwd=root,env=env,check=True)
def run_role(spec):
 role,stem,name,images=spec
 if not (out/'agent_outputs'/name).exists():
  subprocess.run([sys.executable,'-B',str(helper/'r.py'),task,role,stem,images],cwd=root,check=True)
def collect_role(spec):
 role,stem,name,images=spec
 dest=out/'agent_outputs'/name
 if not dest.exists():
  subprocess.run([sys.executable,'-B',str(helper/'c.py'),task,stem,role,name],cwd=root,check=True)
 else: released('validate_agent_output.py',role)
 data=json.loads(dest.read_bytes())
 print(json.dumps({'boundary':'role_validated','task':task,'role':role,'classification':data.get('classification'),'accepted':data.get('accepted'),'findings':data.get('findings'),'ambiguities':data.get('ambiguities'),'remaining_uncertainties':data.get('remaining_uncertainties')},ensure_ascii=True),flush=True)
def pair(specs):
 with ThreadPoolExecutor(max_workers=workers) as pool:
  futures=[pool.submit(run_role,spec) for spec in specs]
  for future in futures: future.result()
 for spec in specs: collect_role(spec)
def role(role,stem,name,images):
 spec=(role,stem,name,images)
 run_role(spec);collect_role(spec)
released('validate_audit.py','--phase','prepared')
assert not (out/'inputs/dependency_reuse_direct.json').exists(), 'Fresh supplementary setup must not reuse a conflicting setup'
assert not (out/'inputs/dependency_reuse_blind.json').exists()
pair([('source-contract','s','source_contract.json',pages),('blind-translation','b','blind_translation.json','')])
pair([('direct-judge','d','direct_judge.json',pages),('roundtrip-judge','r','roundtrip_judge.json',pages)])
p=released('finalize_audit.py','--check-adjudication',capture=True)
assert p.returncode in (0,3),(p.returncode,p.stdout,p.stderr)
triggers=json.loads(p.stdout)
print(json.dumps({'boundary':'adjudication_check','task':task,'triggers':triggers}),flush=True)
if triggers['required']:
 dest=out/'orchestration/adjudication_triggers.json'
 assert not dest.exists()
 dest.write_bytes(p.stdout)
 role('adjudicator','a','adjudicator.json',pages)
released('finalize_audit.py')
released('validate_audit.py','--phase','complete')
decision=json.loads((out/'decision.json').read_bytes())
hashes={name:hashlib.sha256((out/name).read_bytes()).hexdigest() for name in ('manifest.json','decision.json','report.md')}
print(json.dumps({'boundary':'audit_frozen','task':task,'decision':decision,'hashes':hashes},ensure_ascii=True),flush=True)
