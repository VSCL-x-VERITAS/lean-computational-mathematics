"""Native single-file proof replay; no full build, Git, gate or audit."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,shutil,subprocess,sys,time
P=Path(__file__).resolve().parent;R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
assert os.name=='nt';label=sys.argv[1];assert label in ['native-01','native-02'];out=P/label;out.mkdir()
source=P/'LocalSmoothProbe.lean';(out/'LocalSmoothProbe.lean.snapshot').write_bytes(source.read_bytes())
paths=[source,R/'lean-toolchain',R/'lake-manifest.json']
for name in ['Defs','FTaylorSeries','Operations']:
 paths += [R/'.lake/packages/mathlib/Mathlib/Analysis/Calculus/ContDiff'/(name+'.lean'),R/'.lake/packages/mathlib/.lake/build/lib/lean/Mathlib/Analysis/Calculus/ContDiff'/(name+'.olean')]
records=[{'path':p.relative_to(R).as_posix(),'sha256_before':sha(p)} for p in paths]
lake=shutil.which('lake');assert lake and lake.lower().endswith('lake.exe')
command=[lake,'env','lean',source.relative_to(R).as_posix()];start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with (out/'output.txt').open('xb') as f:result=subprocess.run(command,cwd=R,stdout=f,stderr=subprocess.STDOUT)
for r in records:r['sha256_after']=sha(R/r['path'])
receipt={'command':command,'cwd':str(R),'exit_code':result.returncode,'elapsed_seconds':time.monotonic()-tick,'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'output_sha256':sha(out/'output.txt'),'snapshot_sha256':sha(out/'LocalSmoothProbe.lean.snapshot'),'runner_sha256':sha(Path(__file__)),
 'inputs':records,'inputs_unchanged':all(r['sha256_before']==r['sha256_after'] for r in records),
 'scope':'One scratch file replaying proposed C-infinity local PDE/characteristic proofs, not a production build, source audit or family/source joint replay.'}
(out/'receipt.json').write_bytes((json.dumps(receipt,indent=2)+'\n').encode());print(json.dumps({k:v for k,v in receipt.items() if k!='inputs'},indent=2))
if result.returncode:sys.stdout.buffer.write((out/'output.txt').read_bytes())
assert receipt['inputs_unchanged'];raise SystemExit(result.returncode)
