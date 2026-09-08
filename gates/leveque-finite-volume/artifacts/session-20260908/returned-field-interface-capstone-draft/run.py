"""Native scratch check with frozen imports, source context and retained attempts."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys,time
sys.stdout.reconfigure(encoding='utf-8')
P=Path(__file__).resolve().parent;R=P.parents[4];label=sys.argv[1]
assert re.fullmatch('[a-z0-9-]+',label)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
source=P/(label+'-input.lean');out=P/(label+'-output.txt');receipt=P/(label+'-exit.json')
assert not any(p.exists() for p in [source,out,receipt])
candidate=P/'Candidate.lean';t=candidate.read_text(encoding='utf-8')
names=['NumStability.ReturnedFieldInterfaceDraft.'+x for x in re.findall(r'^(?:def|theorem)\s+(\w+)',t,re.M)]
source.write_bytes(candidate.read_bytes()+b'\n'+('\n'.join(f'#check {x}\n#print axioms {x}' for x in names)+'\n').encode())
prep=json.loads((P/'preparation.json').read_bytes());inputs=[candidate,P/'run.py',P/'preparation.json',R/'lean-toolchain',R/'lake-manifest.json',source]
for b in prep['context']+prep['canonical_sources']:
 p=R/b['path'];assert sha(p)==b['sha256'],p
 inputs.append(p)
compiled={}
for module in re.findall(r'^import ([\w.]+)',t,re.M):
 p=R/'.lake/build/lib/lean'/Path(*module.split('.')).with_suffix('.olean')
 assert p.is_file(),p
 compiled[p.relative_to(R).as_posix()]=sha(p)
hashes={p.relative_to(R).as_posix():sha(p) for p in inputs}
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(p for p in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if p['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
cmd=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',source.relative_to(R).as_posix()]
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f:r=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
unchanged=all(sha(R/p)==h for p,h in (hashes|compiled).items())
rec=dict(schema=1,command=cmd,cwd=str(R),started_at_utc=start,completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=int(1000*(time.monotonic()-tick)),exit_code=r.returncode,input_files=hashes,compiled_imports=compiled,inputs_unchanged=unchanged,output_sha256=sha(out),checked_declarations=names)
receipt.write_bytes((json.dumps(rec,indent=2)+'\n').encode())
print(json.dumps(dict(exit_code=r.returncode,elapsed_ms=rec['elapsed_ms'],declarations=len(names),output_sha256=rec['output_sha256'])),flush=True)
if r.returncode:print(out.read_text(encoding='utf-8')[-20000:])
assert unchanged
sys.exit(r.returncode)
