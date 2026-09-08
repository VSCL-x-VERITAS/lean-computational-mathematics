from pathlib import Path
import hashlib,json,subprocess
P=Path(__file__).resolve().parent;R=P.parents[4];S=P.parent
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def bind(p):return dict(path=p.relative_to(R).as_posix(),sha256=sha(p))
receipt=S/'information-method-production/final-receipt.json'
assert sha(receipt)=='5f602458855faa07f2b770cd42e832e72f704ace3862025b53b15e87810b3645'
r=json.loads(receipt.read_bytes());assert r['status']=='PASS' and r['final_actual_exit']==0
manifest=Path(r['manifest']['path']);assert sha(manifest)=='66035ac89cc9dd4f479dd969da0c00ab3a4c24e35559d97c2d3b7a45abc3972b'
frozen={receipt,manifest};occurrences=0
def visit(x):
 global occurrences
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and isinstance(x.get('sha256'),str):
   p=Path(x['path']);p=p if p.is_absolute() else R/p
   assert sha(p)==x['sha256'],p;frozen.add(p);occurrences+=1
  for v in x.values():visit(v)
 elif isinstance(x,list):
  for v in x:visit(v)
visit(r);visit(json.loads(manifest.read_bytes()))
native=Path(r['final_native_receipt']['path']);n=json.loads(native.read_bytes());assert n['exit_code']==0
cmd=['rg','-n','InformationCoordinateSweepDraft|RiemannInformation.*sweep|sweep.*RiemannInformation','ComputationalMathematics','.lake/packages/mathlib/Mathlib','-g','*.lean']
s=subprocess.run(cmd,cwd=R,stdout=subprocess.PIPE,stderr=subprocess.STDOUT);assert s.returncode==1
search=P/'search-after-native-ready.txt';assert not search.exists();search.write_bytes(s.stdout)
v=dict(schema=1,status='native_ready_verified',frozen_inputs=[bind(p) for p in sorted(frozen)],verified_binding_occurrences=occurrences,native_actual_exit=0,canonical_declarations=r['canonical_declarations'],final_axiom_reports=r['final_axiom_reports'],search=dict(command=cmd,exit_code=s.returncode,output=bind(search)),source_acceptance=False)
dest=P/'production-context.json';assert not dest.exists();dest.write_bytes((json.dumps(v,indent=2)+'\n').encode());print(json.dumps(dict(sha256=sha(dest),bindings=occurrences,files=len(frozen))))
