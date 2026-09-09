from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys,time
P=Path(__file__).resolve().parent;S=P.parents[1];R=S.parents[3]
label,mode=sys.argv[1:3];assert re.fullmatch('[a-z0-9-]+',label) and mode in ['build','check']
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
plan=json.loads((P/'native-plan.json').read_bytes());review=json.loads((P/'review-before-implementation.json').read_bytes())
pins=dict(review['input_files'])
for name,h in pins.items():assert sha(R/name)==h,name
for p in [P/'run-native.py',P/'native-plan.json',P/'review-before-implementation.json',P/'Checks.lean',P/'FrozenRiemannSpan.lean.fragment']+[R/f['path'] for f in plan['files']]:pins[p.relative_to(R).as_posix()]=sha(p)
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
out=P/(label+'-output.txt');receipt=P/(label+'-receipt.json');snap=P/(label+'-sources');assert not out.exists() and not receipt.exists() and not snap.exists();snap.mkdir()
for f in plan['files']:
 p=R/f['path'];q=snap/p.name;q.write_bytes(p.read_bytes());pins[q.relative_to(R).as_posix()]=sha(q)
closure={}
def visit(module):
 if module in closure:return
 rel=Path(*module.split('.')).with_suffix('.lean')
 if module.startswith('ComputationalMathematics.'):
  source=R/rel;olean=R/'.lake/build/lib/lean'/rel.with_suffix('.olean');recurse=True
 elif module.startswith('Mathlib.'):
  source=R/'.lake/packages/mathlib'/rel;olean=R/'.lake/packages/mathlib/.lake/build/lib/lean'/rel.with_suffix('.olean');recurse=False
 else:raise AssertionError(module)
 pins[source.relative_to(R).as_posix()]=sha(source)
 if mode=='check':pins[olean.relative_to(R).as_posix()]=sha(olean)
 closure[module]=dict(source=source.relative_to(R).as_posix(),olean=olean.relative_to(R).as_posix())
 if recurse:
  for dep in re.findall(r'^import (\S+)\s*$',source.read_text(encoding='utf-8'),re.M):visit(dep)
if mode=='build':cmd=['C:/Users/qed_s/.elan/bin/lake.exe','build']+[f['module'] for f in plan['files'] if f['new_source']]
else:
 q=P/(label+'-input.lean');assert not q.exists();q.write_bytes((P/'Checks.lean').read_bytes());pins[q.relative_to(R).as_posix()]=sha(q)
 cmd=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',q.relative_to(R).as_posix()]
 for module in re.findall(r'^import (\S+)\s*$',q.read_text(encoding='utf-8'),re.M):visit(module)
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with out.open('xb') as f:result=subprocess.run(cmd,cwd=R,stdout=f,stderr=subprocess.STDOUT)
unchanged=all(sha(R/name)==h for name,h in pins.items())
v=dict(schema=1,mode=mode,command=cmd,cwd=str(R),started_utc=start,completed_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=int((time.monotonic()-tick)*1000),exit_code=result.returncode,input_files=pins,inputs_unchanged=unchanged,dependency_closure=closure,output=bind(out),source_snapshots=[bind(p) for p in sorted(snap.iterdir())])
receipt.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(json.dumps({k:v[k] for k in ['exit_code','elapsed_ms','inputs_unchanged','output']}),flush=True)
if result.returncode:print(out.read_text(encoding='utf-8'))
assert unchanged
sys.exit(result.returncode)
