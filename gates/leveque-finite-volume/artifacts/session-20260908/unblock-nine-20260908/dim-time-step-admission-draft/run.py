from pathlib import Path
import datetime,hashlib,json,re,subprocess,sys
h=Path(__file__).resolve().parent
r=next(p for p in h.parents if (p/'lean-toolchain').is_file())
tag=sys.argv[1]
if not re.fullmatch(r'[a-z0-9-]+',tag):raise SystemExit('Invalid label')
folder=h/tag
if folder.exists():raise SystemExit('Refusing overwrite')
folder.mkdir()
def disk(p):return Path('\\\\?\\'+str(p.resolve()))
def read(p):return disk(p).read_bytes()
def ref(p):
 b=read(p);return {'path':str(p),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
source=h/'Candidate.lean';(folder/'Candidate.lean.snapshot').write_bytes(read(source))
modules=set()
def visit(raw):
 for module in re.findall(r'^import\s+(\S+)',raw.decode(),re.M):
  if module in modules:continue
  modules.add(module)
  if module.startswith('ComputationalMathematics.'):
   visit(read(r/(module.replace('.','/')+'.lean')))
visit(read(source))
inputs=[source,r/'lean-toolchain',r/'lake-manifest.json']
for m in sorted(modules):
 base=r if m.startswith('ComputationalMathematics.') else r/'.lake/packages/mathlib'
 for suffix in ['.lean','.olean']:
  p=base/(m.replace('.','/')+suffix) if suffix=='.lean' else base/'.lake/build/lib/lean'/(m.replace('.','/')+suffix)
  if disk(p).is_file():inputs.append(p)
before=[ref(p) for p in inputs]
cmd=['C:/Users/qed_s/.elan/bin/lake.EXE','env','lean',str(source)]
started=datetime.datetime.now(datetime.timezone.utc).isoformat()
result=subprocess.run(cmd,cwd=r,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
finished=datetime.datetime.now(datetime.timezone.utc).isoformat()
(folder/'output.txt').write_bytes(result.stdout)
after=[ref(p) for p in inputs]
receipt={'command':cmd,'cwd':str(r),'started_at_utc':started,'finished_at_utc':finished,'actual_exit_code':result.returncode,
 'inputs_before':before,'inputs_after':after,'inputs_unchanged':before==after,'output':ref(folder/'output.txt'),
 'scope':'Artifact-only inputwise time-step admission. No smooth-order or source-acceptance claim. Exact current canonical dependency pins retained.'}
(folder/'receipt.json').write_text(json.dumps(receipt,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'exit':result.returncode,'inputs_unchanged':before==after,'output':ref(folder/'output.txt'),'receipt':ref(folder/'receipt.json')},indent=2))
if result.returncode:print(result.stdout.decode('utf-8',errors='replace'))
raise SystemExit(result.returncode)
