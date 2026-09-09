"""Native proof-free probe capture; no released preparation or audit roles."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,shutil,subprocess,sys,time
P=Path(__file__).resolve().parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
assert os.name=='nt'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
source=P/sys.argv[1];label=sys.argv[2]
assert source.parent==P and source.suffix=='.lean' and re.fullmatch('[a-z]+-[0-9]+',label)
out=P/label;out.mkdir()
(out/source.name).write_bytes(source.read_bytes())
pins={str(p):ref(p) for p in [source,Path(__file__),R/'lean-toolchain',R/'lake-manifest.json']}
queue=re.findall(r'^import\s+(\S+)',source.read_text(),re.M);seen=set()
while queue:
 m=queue.pop()
 if m in seen:continue
 seen.add(m)
 if m.startswith('ComputationalMathematics.'):
  p=R/(m.replace('.','/')+'.lean');queue+=re.findall(r'^import\s+(\S+)',p.read_text(),re.M)
  bases=[p,R/'.lake/build/lib/lean'/(m.replace('.','/')+'.olean')]
 elif m.startswith('Mathlib.'):
  bases=[R/'.lake/packages/mathlib'/(m.replace('.','/')+'.lean'),R/'.lake/packages/mathlib/.lake/build/lib/lean'/(m.replace('.','/')+'.olean')]
 else:continue
 for p in bases:
  pins[str(p)]=ref(p)
  if p.suffix=='.olean':
   for suffix in ('.private','.server'):
    q=Path(str(p)+suffix)
    if q.exists():pins[str(q)]=ref(q)
lake=shutil.which('lake');assert lake and lake.lower().endswith('lake.exe')
argv=[lake,'env','lean',source.relative_to(R).as_posix()]
started=datetime.now(timezone.utc).isoformat();timer=time.monotonic()
with (out/'output.txt').open('xb') as o,(out/'stderr.txt').open('xb') as e:
 result=subprocess.run(argv,cwd=R,stdout=o,stderr=e)
unchanged=all(sha(Path(p))==v['sha256'] for p,v in pins.items())
receipt={'schema':1,'command':argv,'exit_code':result.returncode,'started_at_utc':started,
 'completed_at_utc':datetime.now(timezone.utc).isoformat(),'elapsed_ms':int((time.monotonic()-timer)*1000),
 'input':ref(source),'input_snapshot':ref(out/source.name),'output':ref(out/'output.txt'),
 'stderr':ref(out/'stderr.txt'),'input_pins':list(pins.values()),'inputs_unchanged':unchanged,
 'git_invocations':0,'model_role_invocations':0,'preparer_invoked':False}
with (out/'receipt.json').open('x',encoding='utf-8',newline='\n') as stream:
 stream.write(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'receipt':ref(out/'receipt.json'),'exit_code':result.returncode,'inputs_unchanged':unchanged},indent=2))
if result.returncode:print((out/'output.txt').read_text())
assert unchanged
raise SystemExit(result.returncode)
