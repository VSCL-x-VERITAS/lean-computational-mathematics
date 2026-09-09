from pathlib import Path
import datetime,hashlib,json,os,re,shutil,subprocess,sys
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
o=h.parent/'dim-five-owner-overlay'
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def now():return datetime.datetime.now(datetime.timezone.utc).isoformat()
tag=sys.argv[-1]
assert re.fullmatch(r'[a-z0-9-]+',tag)
if '--child' not in sys.argv:
 cmd=['C:/Users/qed_s/.elan/bin/lake.EXE','env',sys.executable,'-X','utf8','-B',str(h/'run.py'),'--child',tag]
 proc=subprocess.run(cmd,cwd=r)
 raise SystemExit(proc.returncode)
folder=h/tag
if folder.exists():raise SystemExit('Refusing overwrite')
folder.mkdir()
assert ref(o/'receipt.json')['sha256']=='6d84c698bd2ddc3e203709f6686e85264b6da5f908fe5dc20d76b18348251e17'
assert ref(o/'compiled-module-map.json')['sha256']=='8a3964e7f6a9402aeb0a0ac7075f076e8044f0c9bcc90cb8fbd655dd9db3af01'
pins={}
def collect(obj):
 if isinstance(obj,dict):
  if 'path' in obj and 'sha256' in obj:
   p=Path(obj['path']);p=p if p.is_absolute() else r/p
   assert ref(p)['sha256']==obj['sha256'],str(p)
   pins[str(p)]=p
  for v in obj.values():collect(v)
 elif isinstance(obj,list):
  for v in obj:collect(v)
for name in ['compiled-module-map.json','unchanged-compiled-copies-v3.json']:
 collect(json.loads(read(o/name)));pins[str(o/name)]=o/name
for p in [h/'Candidate.lean',o/'receipt.json',o/'environment-v3.json',r/'lean-toolchain',r/'lake-manifest.json']:
 pins[str(p)]=p
source=h/'Candidate.lean'
(folder/'Candidate.lean.snapshot').write_bytes(read(source))
inherited=os.environ.get('LEAN_PATH','');assert inherited
lib=o/'overlay/lib03'
env=os.environ.copy();env['LEAN_PATH']=str(disk(lib))+os.pathsep+inherited
lean=shutil.which('lean');assert lean
pins[str(Path(lean))]=Path(lean)
before=[ref(p) for p in pins.values()]
(folder/'environment.json').write_text(json.dumps({'child_of':'native lake env Python','inherited_LEAN_PATH':inherited,
 'effective_LEAN_PATH':env['LEAN_PATH'],'lean':ref(Path(lean))},indent=2)+'\n',encoding='utf-8')
def capture(name,args):
 began=now();proc=subprocess.run(args,cwd=r,env=env,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
 (folder/(name+'-output.txt')).write_bytes(proc.stdout)
 (folder/(name+'-stderr.txt')).write_bytes(proc.stderr)
 rec={'command':args,'cwd':str(r),'started_at_utc':began,'finished_at_utc':now(),'actual_exit_code':proc.returncode,
  'output':ref(folder/(name+'-output.txt')),'stderr':ref(folder/(name+'-stderr.txt'))}
 (folder/(name+'-receipt.json')).write_text(json.dumps(rec,indent=2)+'\n',encoding='utf-8')
 return proc,rec
deps,dep_receipt=capture('dependencies',[lean,'--deps',str(disk(source))])
if deps.returncode:print(deps.stdout.decode(errors='replace'));raise SystemExit(deps.returncode)
project=[s.strip() for s in deps.stdout.decode().splitlines() if 'ComputationalMathematics' in s]
assert len(project)==2,project
assert all(str(disk(lib)).casefold() in s.casefold() for s in project),project
proc,native_receipt=capture('native',[lean,str(disk(source))])
after=[ref(p) for p in pins.values()]
receipt={'actual_exit_code':proc.returncode,'inputs_before':before,'inputs_after':after,'inputs_unchanged':before==after,
 'dependency_receipt':ref(folder/'dependencies-receipt.json'),'native_receipt':ref(folder/'native-receipt.json'),
 'environment':ref(folder/'environment.json'),'project_direct_imports':project,
 'scope':'Read-only frozen C-infinity lib03 overlay; only new scratch output; no old fixed-level lemma used.'}
(folder/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'exit':proc.returncode,'inputs_unchanged':before==after,'receipt':ref(folder/'receipt.json'),
 'output':native_receipt['output']},indent=2))
if proc.returncode:print(proc.stdout.decode(errors='replace'));print(proc.stderr.decode(errors='replace'))
raise SystemExit(proc.returncode)
