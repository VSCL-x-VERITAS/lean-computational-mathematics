"""Native scratch check with immutable input/output/actual-exit receipts."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess,sys,time
assert os.name=='nt'
P=Path(__file__).resolve().parent;R=P.parents[4]
label=sys.argv[1];assert re.fullmatch(r'[a-z0-9-]+',label)
source=P/'GeneralFirstOrder.lean';snapshot=P/(label+'-input.lean')
out=P/(label+'-output.txt');receipt=P/(label+'-exit.json')
assert not any(p.exists() for p in [snapshot,out,receipt])
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
snapshot.write_bytes(source.read_bytes())
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
m=json.loads((R/'lake-manifest.json').read_bytes())
assert next(p for p in m['packages'] if p['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
lake=r'C:/Users/qed_s/.elan/bin/lake.exe'
command=[lake,'env','lean',source.relative_to(R).as_posix()]
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=R,text=True).strip()
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f:result=subprocess.run(command,cwd=R,stdout=f,stderr=subprocess.STDOUT)
assert sha(source)==sha(snapshot)
record={'command':command,'cwd':str(R),'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),'exit_code':result.returncode,'elapsed_ms':int((time.monotonic()-tick)*1000),'input_commit':head,'source_sha256':sha(snapshot),'raw_output_sha256':sha(out),'lean_toolchain_sha256':sha(R/'lean-toolchain'),'lake_manifest_sha256':sha(R/'lake-manifest.json')}
receipt.write_text(json.dumps(record,indent=2)+'\n',encoding='utf-8',newline='')
print(json.dumps(record),flush=True)
sys.stdout.buffer.write(out.read_bytes())
raise SystemExit(result.returncode)
