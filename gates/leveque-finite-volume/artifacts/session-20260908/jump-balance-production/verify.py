"""Read-only verification of the frozen placement manifest and actual native receipts."""
from pathlib import Path
import hashlib,json
P=Path(__file__).resolve().parent;R=P.parents[4]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=json.loads((P/'placement-manifest.json').read_bytes())
bindings=[]
def walk(v):
 if isinstance(v,dict):
  if isinstance(v.get('path'),str) and isinstance(v.get('sha256'),str):
   p=Path(v['path']);p=p if p.is_absolute() else R/p
   assert sha(p)==v['sha256'],str(p);bindings.append(v['path'])
  if isinstance(v.get('input_sha256'),dict):
   for p,h in v['input_sha256'].items():assert sha(R/p)==h,p
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
walk(manifest)
assert len(manifest['canonical_files'])==6
assert len(manifest['canonical_axiom_checks'])==24
assert len(manifest['comparison_axiom_checks'])==30
assert all(x['result']['exit_code']==0 for x in manifest['native_receipts'])
allowed={'propext','Classical.choice','Quot.sound'}
assert all(set(a)<=allowed for a in list(manifest['canonical_axiom_checks'].values())+list(manifest['comparison_axiom_checks'].values()))
print(json.dumps({'status':'PASS','kind':'read-only-frozen-placement-validation','binding_occurrences':len(bindings),
 'unique_paths':len(set(bindings)),'canonical_declarations':24,'comparison_checks':30,
 'manifest_sha256':sha(P/'placement-manifest.json'),'source_acceptance_claimed':False}))
