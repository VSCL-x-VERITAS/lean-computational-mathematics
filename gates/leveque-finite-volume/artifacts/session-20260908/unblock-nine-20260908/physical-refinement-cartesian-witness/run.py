from pathlib import Path
import datetime,hashlib,json,os,re,shutil,subprocess,sys
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
tag=sys.argv[-1]
assert re.fullmatch(r'[a-z0-9-]+',tag)
if '--child' not in sys.argv:
 raise SystemExit(subprocess.run(['C:/Users/qed_s/.elan/bin/lake.EXE','env',sys.executable,'-X','utf8','-B',str(h/'run.py'),'--child',tag],cwd=r).returncode)
folder=h/tag
assert not folder.exists(),'Refusing overwrite'
folder.mkdir()
source=h/'Candidate.lean'
(folder/'Candidate.lean.snapshot').write_bytes(read(source))
lean=shutil.which('lean');assert lean
env=os.environ.copy();assert env.get('LEAN_PATH')
pins={str(p):p for p in [source,h/'run.py',h/'copied-inputs.json',r/'lean-toolchain',r/'lake-manifest.json',Path(lean)]}
modules=set()
def collect_module(module):
 if module in modules:return
 modules.add(module)
 if module.startswith('ComputationalMathematics.'):
  base=r;lib=r/'.lake/build/lib/lean'
 elif module.startswith('Mathlib.') or module=='Mathlib':
  base=r/'.lake/packages/mathlib';lib=base/'.lake/build/lib/lean'
 else:return
 p=base/(module.replace('.','/')+'.lean')
 q=lib/(module.replace('.','/')+'.olean')
 assert disk(p).is_file(),str(p)
 assert disk(q).is_file(),str(q)
 pins[str(p)]=p;pins[str(q)]=q
 for line in read(p).decode('utf-8-sig').splitlines():
  m=re.fullmatch(r'\s*(?:(?:public|private)\s+)?import\s+([\w.]+)\s*',line)
  if m:collect_module(m.group(1))
for line in read(source).decode().splitlines():
 m=re.fullmatch(r'\s*import\s+([\w.]+)\s*',line)
 if m:collect_module(m.group(1))
before=[ref(p) for p in pins.values()]
(folder/'inputs-before.json').write_text(json.dumps(before,indent=2)+'\n',encoding='utf-8')
(folder/'environment.json').write_text(json.dumps({'LEAN_PATH':env['LEAN_PATH'],'lean':ref(Path(lean)),'module_count':len(modules)},indent=2)+'\n',encoding='utf-8')
def capture(name,args):
 began=now();proc=subprocess.run(args,cwd=r,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 (folder/(name+'-output.txt')).write_bytes(proc.stdout);(folder/(name+'-stderr.txt')).write_bytes(proc.stderr)
 rec={'command':args,'cwd':str(r),'started_at_utc':began,'finished_at_utc':now(),'actual_exit_code':proc.returncode,'output':ref(folder/(name+'-output.txt')),'stderr':ref(folder/(name+'-stderr.txt'))}
 (folder/(name+'-receipt.json')).write_text(json.dumps(rec,indent=2)+'\n',encoding='utf-8')
 return proc,rec
deps,dep_receipt=capture('dependencies',[lean,'--deps',str(disk(source))])
if deps.returncode:raise SystemExit(deps.returncode)
proc,native_receipt=capture('native',[lean,str(disk(source))])
after=[ref(p) for p in pins.values()]
(folder/'inputs-after.json').write_text(json.dumps(after,indent=2)+'\n',encoding='utf-8')
receipt={'actual_exit_code':proc.returncode,'inputs_before':ref(folder/'inputs-before.json'),'inputs_after':ref(folder/'inputs-after.json'),'inputs_unchanged':before==after,'dependency_receipt':ref(folder/'dependencies-receipt.json'),'native_receipt':ref(folder/'native-receipt.json'),'environment':ref(folder/'environment.json'),'scope':'Native canonical geometry; no evolving generic quality imported; no source acceptance.'}
(folder/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'exit':proc.returncode,'inputs_unchanged':before==after,'receipt':ref(folder/'receipt.json'),'output':native_receipt['output']},indent=2))
if proc.returncode:print(proc.stdout.decode(errors='replace'));print(proc.stderr.decode(errors='replace'))
raise SystemExit(proc.returncode)
