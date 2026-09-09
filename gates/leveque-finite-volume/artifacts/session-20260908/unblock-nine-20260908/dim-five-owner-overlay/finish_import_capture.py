"""Replay only the corrected diagnostic against the successful lib03 outputs."""
import hashlib,json,os,subprocess,sys,time
from pathlib import Path
R=Path(r'C:\Users\qed_s\OneDrive\Documents\ChatGPT\VSCL-x-VERITAS\lean-computational-mathematics')
P=R/'gates/leveque-finite-volume/artifacts/session-20260908/unblock-nine-20260908/dim-five-owner-overlay'
O=P/'overlay';LIB=O/'lib03'
native=lambda p:str(p) if str(p).startswith('\\\\?\\') else '\\\\?\\'+os.path.abspath(p)
def raw(p):
 with open(native(p),'rb') as stream:return stream.read()
def load(p):return json.loads(raw(p))
def ref(p):
 data=raw(p)
 try:name=Path(p).relative_to(R).as_posix()
 except ValueError:name=str(p)
 return {'path':name,'sha256':hashlib.sha256(data).hexdigest(),'bytes':len(data)}
def put(p,data):
 os.makedirs(native(p.parent),exist_ok=True)
 if not isinstance(data,bytes):data=(json.dumps(data,indent=2,ensure_ascii=False)+'\n').encode()
 with open(native(p),'xb') as stream:stream.write(data)
 return ref(p)
def capture(label,command,cwd,env=None):
 dest=P/'runs04'/label;os.makedirs(native(dest),exist_ok=False);start=time.monotonic()
 print(json.dumps({'start':label,'command':command}),flush=True)
 with open(native(dest/'output.txt'),'xb') as out,open(native(dest/'stderr.txt'),'xb') as err:
  result=subprocess.run(command,cwd=cwd,env=env,stdout=out,stderr=err)
 rec={'command':command,'cwd':str(cwd),'exit_code':result.returncode,'elapsed_seconds':time.monotonic()-start,
      'stdout':ref(dest/'output.txt'),'stderr':ref(dest/'stderr.txt')}
 put(dest/'receipt.json',rec)
 print(json.dumps({'completed':label,'exit_code':result.returncode,'elapsed_seconds':rec['elapsed_seconds']}),flush=True)
 if result.returncode:
  print(raw(dest/'output.txt').decode('utf-8')[-4000:]);print(raw(dest/'stderr.txt').decode('utf-8')[-4000:])
  raise SystemExit(result.returncode)
 return rec
if '--child' not in sys.argv:
 rec=capture('lake-launch04',[r'C:\Users\qed_s\.elan\bin\lake.exe','env',sys.executable,'-X','utf8','-B',str(P/'finish_import_capture.py'),'--child'],R)
 raise SystemExit(rec['exit_code'])
plan=load(P/'plan.json');environment=load(P/'environment-v3.json')
assert os.environ.get('LEAN_PATH')==environment['inherited_LEAN_PATH']
for item in plan['all_read_inputs']:assert ref(R/item['path'])['sha256']==item['sha256'],item['path']
old=raw(O/'ImportClosureProbe.lean');assert old.count(b'liftIO <|')==1
new=old.replace(b'liftIO <|',b'Lean.Elab.Command.liftIO <|')
put(O/'ImportClosureProbe02.lean',new)
put(P/'import-probe02-derivation.json',{'before':ref(O/'ImportClosureProbe.lean'),
 'after':ref(O/'ImportClosureProbe02.lean'),'change':'Qualify only the diagnostic IO lift; no production, proposal, or proof changes.'})
outputs=[]
for directory,dirs,names in os.walk(native(LIB)):
 for name in names:
  path=Path(str(Path(directory)/name).removeprefix('\\\\?\\'));outputs.append(ref(path))
put(P/'successful-overlay-before-probe04.json',{'files':outputs})
env=os.environ.copy();env['LEAN_PATH']=environment['effective_LEAN_PATH']
rec=capture('ImportClosureProbe02',[environment['lean_executable']['path'],'-R',native(O),native(O/'ImportClosureProbe02.lean')],O,env)
compiled=[]
affected=set(plan['affected_modules_topological'])
for line in raw(R/rec['stdout']['path']).decode('utf-8').splitlines():
 if not line.startswith('COMPILED_IMPORT '):continue
 _,module,location=line.split(' ',2)
 path=Path(location.removeprefix('\\\\?\\'))
 if not path.is_absolute():path=O/path
 if module in affected:assert path.resolve()==(LIB/(module.replace('.','/')+'.olean')).resolve(),module
 compiled.append({'module':module,'file':ref(path),'overlay':path.is_relative_to(LIB)})
assert affected<={item['module'] for item in compiled}
direct=[]
for entry in sorted((P/'runs03').iterdir()):
 if not entry.name.endswith('-deps'):continue
 previous=load(entry/'receipt.json');assert previous['exit_code']==0
 deps=[]
 for line in raw(R/previous['stdout']['path']).decode('utf-8').splitlines():
  if not line.strip():continue
  path=Path(line.strip().removeprefix('\\\\?\\'))
  if not path.is_absolute():path=O/path
  deps.append(ref(path))
 direct.append({'label':entry.name,'dependencies':deps,'receipt':previous})
for item in outputs+plan['all_read_inputs']:assert ref(R/item['path'])['sha256']==item['sha256'],item['path']
put(P/'dependency-resolutions-v4.json',{'schema':1,'direct':direct,'full_compiled_imports':compiled,
    'new_diagnostic_receipt':ref(P/'runs04/ImportClosureProbe02/receipt.json')})
put(P/'completion-v4.json',{'schema':1,'status':'OVERLAY_NATIVE_REPLAY_COMPLETE','source_acceptance':False,
    'affected_modules_built':sorted(affected),'full_compiled_imports':len(compiled),
    'production_sources_and_captured_compiled_outputs_unchanged':True,'overlay_only':True,
    'successful_module_and_proof_runs':'runs03','final_diagnostic':'runs04',
    'historical_final_diagnostic_failure_preserved':True})
print(json.dumps({'complete':True,'compiled_imports':len(compiled)}),flush=True)
