from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys,time
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
label,mode=sys.argv[1:3];assert re.fullmatch('[a-z0-9-]+',label) and mode in ['build','declarations','comparisons']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((P/'placement-map.json').read_bytes()); files=plan['files']
output=P/(label+'-output.txt');receipt=P/(label+'-receipt.json');snap=P/(label+'-sources')
assert not output.exists() and not receipt.exists() and not snap.exists();snap.mkdir()
inputs=[P/'run.py',P/'placement-map.json',R/'lean-toolchain',R/'lake-manifest.json']
for b in plan['frozen_inputs']:
 p=R/b['path'];assert sha(p)==b['sha256'],p;inputs.append(p)
snapshots=[]
for f in files:
 src=R/f['path'];dest=snap/Path(f['path']).name;dest.write_bytes(src.read_bytes());inputs.extend([src,dest])
 snapshots.append(dict(owner=f['path'],path=dest.relative_to(R).as_posix(),sha256=sha(dest)))
if mode=='build':cmd=['C:/Users/qed_s/.elan/bin/lake.exe','build']+[f['module'] for f in files]
else:
 src=P/(label+'-input.lean');assert not src.exists()
 if mode=='declarations':
  data=''.join('import '+f['module']+'\n' for f in files)+'\n'
  data+='\n'.join('#check '+n+'\n#print axioms '+n for f in files for n in f['declarations'])+'\n'
  src.write_bytes(data.encode())
 else:
  body=P/'Comparisons.lean';inputs.append(body);src.write_bytes(body.read_bytes())
 inputs.append(src);cmd=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',src.relative_to(R).as_posix()]
native=json.loads((S/'information-method-production/final-check-01.receipt.json').read_bytes())
assert native['exit_code']==0 and native['inputs_unchanged']
for p,h in native['inputs'].items():
 p=Path(p);assert sha(p)==h,p;inputs.append(p)
hashes={p.relative_to(R).as_posix():sha(p) for p in inputs}
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
compiled={}
if mode!='build':
 for f in files:
  p=R/'.lake/build/lib/lean'/Path(f['path']).with_suffix('.olean');compiled[p.relative_to(R).as_posix()]=sha(p)
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with output.open('xb') as out:r=subprocess.run(cmd,cwd=R,stdout=out,stderr=subprocess.STDOUT)
unchanged=all(sha(R/p)==h for p,h in (hashes|compiled).items())
v=dict(schema=1,mode=mode,command=cmd,cwd=str(R),started_at_utc=start,completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=int((time.monotonic()-tick)*1000),exit_code=r.returncode,input_files=hashes,compiled_production=compiled,inputs_unchanged=unchanged,source_snapshots=snapshots,output_sha256=sha(output),authored_declarations=[n for f in files for n in f['declarations']])
receipt.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(json.dumps(dict(exit_code=r.returncode,elapsed_ms=v['elapsed_ms'],output_sha256=v['output_sha256'])),flush=True)
if r.returncode:
 text=output.read_text(encoding='utf-8');print('\n'.join(x for x in text.splitlines() if re.search(r'error[:(]|warning:',x)))
assert unchanged
sys.exit(r.returncode)
