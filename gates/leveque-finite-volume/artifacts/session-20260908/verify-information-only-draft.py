"""Root verification of the broader, unselected information-only routine contract."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'riemann-information-only-method-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
def resolve(s):
 s=re.sub(r'/+','/',s.replace('\\','/'))
 if s.startswith('/c/'):s='C:/'+s[3:]
 p=Path(s);return p if p.is_absolute() else R/p
pins={'final-receipt.json':'9fb9b60408c939a0ab22af27d01710c022f1a3a0665e0966732a8860f6f292a2',
 'manifest.json':'d4791c79f3bf2bcb9a8949118629a0892f99af3a01604bfff42ae02ea379f05a',
 'Candidate.lean':'3d090a899d6a93ac19783ee2533f763084e9cac459e5e0e14f2b0058ffcfc466'}
for p,h in pins.items():assert sha(P/p)==h,p
bindings=[]
def walk(x):
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and isinstance(x.get('sha256'),str):
   p=resolve(x['path']);assert sha(p)==x['sha256'],x;bindings.append((str(p),x['sha256']))
  for y in x.values():walk(y)
 elif isinstance(x,list):
  for y in x:walk(y)
m=read(P/'manifest.json');walk(m);walk(read(P/'final-receipt.json'))
outcomes=[]
for field,expected in [('native_failed',1),('native_final',0)]:
 n=read(resolve(m[field]['path']));walk(n)
 assert type(n['exit_code']) is int and n['exit_code']==expected
 assert n['source_unchanged'] and n['dependencies_unchanged']
 assert sha(resolve(n['source']))==n['source_sha256_before']==n['source_sha256_after']
 assert sha(resolve(n['output']))==n['output_sha256']
 assert n['command'][:3]==['C:/Users/qed_s/.elan/bin/lake.exe','env','lean']
 assert resolve(n['command'][3])==resolve(n['source'])
 outcomes.append({'actual_exit':expected,'source_sha256':n['source_sha256_after'],'output_sha256':n['output_sha256']})
assert (P/'Candidate.lean').read_bytes()==resolve(n['source']).read_bytes()
raw=resolve(n['output']).read_text(encoding='utf-8')
assert not re.search(r'\b(?:warning|error):|sorryAx',raw)
names=m['new_declarations']+m['reused_checks'];assert len(set(names))==len(names)==29 and len(m['new_declarations'])==24
reports={}
for name in names:
 assert re.search(r'^'+re.escape(name)+r'(?:\.|\s|:)',raw,re.M),name
 match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
 if match:ax=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in match[1].split(',') if x.strip()]
 else:
  assert "'"+name+"' does not depend on any axioms" in raw,name
  ax=[]
 assert set(ax)<={'propext','Classical.choice','Quot.sound'},(name,ax)
 reports[name]=ax
assert raw in resolve(m['proof_free_contracts']['path']).read_text(encoding='utf-8')
data={'schema':1,'status':'PASS','source_acceptance':False,'pins':pins,'bindings_verified':len(bindings),
 'unique_paths':len({p for p,h in bindings}),'native_attempts':outcomes,'authored_declarations':24,
 'axiom_reports':reports,'canonical_import_closure_count':len(m['canonical_import_closure']),
 'root_review':'Read complete Candidate and scope review. Pure routine has six fields and no field, initial, conservation or trace premise. Optional trace is applied to the exact selected result; only actual finite-step integrability and the two used faces are required for update accuracy. Field embedding preserves original result/solve/extraction/flux. The concrete ordered-pair routine has separate unit-speed reference-average evidence, not a hidden returned field.',
 'next':'Place separate reusable core, field adapter, error estimates and examples. Broader representation removes the necessity of adopting the full-field/all-real restriction for this alternative; qualitative accuracy and source-specific selection remain pending.'}
dest=S/'root-information-only-draft-verification.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(data,indent=2)+'\n')
print(json.dumps({'status':'PASS','sha256':sha(dest),'bindings':len(bindings),'declarations':24,'checked_axioms':29}))
