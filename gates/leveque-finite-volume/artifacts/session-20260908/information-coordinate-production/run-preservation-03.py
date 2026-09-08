from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re,subprocess,sys,time
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
label,filename=sys.argv[1:3]
assert re.fullmatch('[a-z0-9-]+',label) and Path(filename).name==filename
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
plan=json.loads((P/'placement-map.json').read_bytes())
output=P/(label+'-output.txt');receipt=P/(label+'-receipt.json');src=P/(label+'-input.lean')
assert not any(p.exists() for p in [output,receipt,src])
source=P/filename;src.write_bytes(source.read_bytes())
pins={}
def bind(p,h=None):
 p=p.resolve();actual=sha(p)
 if h is not None:assert actual==h,p
 pins[p.relative_to(R).as_posix()]=actual
for p in [P/'run-preservation-03.py',P/'placement-map.json',P/'comparison-plan-03.json',source,src,R/'lean-toolchain',R/'lake-manifest.json']:bind(p)
for receipt_path,keys in [(S/'information-coordinate-sweep-draft/full04-exit.json',['input_files','compiled_imports']),(S/'information-method-production/final-check-01.receipt.json',['inputs'])]:
 bind(receipt_path);v=json.loads(receipt_path.read_bytes());assert v['exit_code']==0 and v['inputs_unchanged']
 for key in keys:
  for name,h in v.get(key,{}).items():
   p=Path(name);bind(p if p.is_absolute() else R/p,h)
for b in plan['frozen_inputs']:bind(R/b['path'],b['sha256'])
visited={};boundaries={}
def imports(p):return re.findall(r'^import\s+([A-Za-z0-9_.]+)\s*$',p.read_text(encoding='utf-8'),re.M)
def visit(module):
 if module in visited or module in boundaries:return
 rel=Path(*module.split('.')).with_suffix('.lean')
 if module.startswith('ComputationalMathematics.'):
  p=R/rel;o=R/'.lake/build/lib/lean'/rel.with_suffix('.olean')
  bind(p);bind(o);visited[module]=dict(source=p.relative_to(R).as_posix(),olean=o.relative_to(R).as_posix())
  for dep in imports(p):visit(dep)
 elif module.startswith('Mathlib.'):
  p=R/'.lake/packages/mathlib'/rel;o=R/'.lake/packages/mathlib/.lake/build/lib/lean'/rel.with_suffix('.olean')
  bind(p);bind(o);boundaries[module]=dict(source=p.relative_to(R).as_posix(),olean=o.relative_to(R).as_posix())
 else:raise AssertionError('unhandled import boundary: '+module)
for f in plan['files']:visit(f['module'])
for module in imports(src):visit(module)
assert (R/'lean-toolchain').read_text().strip()=='leanprover/lean4:v4.29.0-rc3'
assert next(x for x in json.loads((R/'lake-manifest.json').read_bytes())['packages'] if x['name']=='mathlib')['rev']=='e8ea1afc32790ce1d4e1a4e45cc412ba9388716b'
dep=P/(label+'-dependencies.json');assert not dep.exists()
dep.write_bytes((json.dumps(dict(schema=1,project_closure=visited,mathlib_direct_boundaries=boundaries,scope='Recursive authored project imports and direct Mathlib source/compiled boundaries; pinned full Mathlib revision and prior frozen native receipts retained.',input_files=pins),indent=2)+'\n').encode());bind(dep)
cmd=['C:/Users/qed_s/.elan/bin/lake.exe','env','lean',src.relative_to(R).as_posix()]
start=datetime.now(timezone.utc).isoformat();tick=time.monotonic()
with output.open('xb') as out:r=subprocess.run(cmd,cwd=R,stdout=out,stderr=subprocess.STDOUT)
unchanged=all(sha(R/p)==h for p,h in pins.items())
v=dict(schema=1,command=cmd,cwd=str(R),started_at_utc=start,completed_at_utc=datetime.now(timezone.utc).isoformat(),elapsed_ms=int((time.monotonic()-tick)*1000),exit_code=r.returncode,input_files=pins,inputs_unchanged=unchanged,output_sha256=sha(output),project_modules=len(visited),mathlib_boundary_modules=len(boundaries))
receipt.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(json.dumps({k:v[k] for k in ['exit_code','elapsed_ms','output_sha256','inputs_unchanged','project_modules','mathlib_boundary_modules']}),flush=True)
if r.returncode:
 text=output.read_text(encoding='utf-8');print('\n'.join(x for x in text.splitlines() if re.search(r'error[:(]|warning:',x)))
assert unchanged
sys.exit(r.returncode)
