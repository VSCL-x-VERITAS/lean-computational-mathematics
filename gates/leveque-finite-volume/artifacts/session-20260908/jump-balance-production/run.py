"""Native build/check capture; immutable labels preserve every attempt."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re,subprocess,sys,time
assert os.name=='nt'
P=Path(__file__).resolve().parent;R=P.parents[4]
label,mode=sys.argv[1:3];assert re.fullmatch('[a-z0-9-]+',label)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((P/'initial-placement.json').read_bytes())
modules=[x['module'] for x in manifest['created']]
files=[R/x['path'] for x in manifest['created']]
if mode=='build':args=['-q','build',*modules]
elif mode=='lean':
 source=P/sys.argv[3];assert source.parent==P and source.is_file()
 args=['env','lean',str(source)];files.append(source)
else:raise ValueError(mode)
files+=[R/'lean-toolchain',R/'lake-manifest.json']
hashes={str(p.relative_to(R)).replace(chr(92),'/'):sha(p) for p in files}
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
out=P/(label+'-output.txt');receipt=P/(label+'-exit.json')
assert not out.exists() and not receipt.exists()
cmd=['C:/Users/qed_s/.elan/bin/lake.exe',*args]
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f:run=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
assert hashes=={str(p.relative_to(R)).replace(chr(92),'/'):sha(p) for p in files}
record={'command':cmd,'cwd':str(R),'started_at_utc':start,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'elapsed_ms':int(1000*(time.monotonic()-tick)),'exit_code':run.returncode,'input_sha256':hashes,'output_sha256':sha(out)}
receipt.write_bytes((json.dumps(record,indent=2)+'\n').encode())
print(json.dumps(record),flush=True)
if run.returncode:sys.stdout.buffer.write(out.read_bytes())
sys.exit(run.returncode)
