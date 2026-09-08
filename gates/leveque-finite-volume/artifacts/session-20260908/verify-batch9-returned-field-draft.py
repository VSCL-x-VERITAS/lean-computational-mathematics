"""Root read-only evidence verification for the returned-field extension."""
from pathlib import Path
import hashlib,json,re
S=Path(__file__).resolve().parent;R=S.parents[3];P=S/'returned-riemann-field-draft'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
pins={'final-receipt.json':'2e5de596e33a4d6bff277f8fd6fd77c79bf5b377fb6f7d4f95a0aa766dd5fc20',
 'manifest.json':'c5cc01da8b2ce8013816e02b9972fb84c4aa4af0a04463a4b2948418faf347a3',
 'Candidate.lean':'0e0376759b0021cb5d1756147baf778d6145807dc7d395ecd66e3ea7a00c6b99',
 'API-REVIEW.md':'4df5c55c0534586d0c06941c48b66035a403e78b11e2209cd9afcb88da519183'}
for p,h in pins.items():assert sha(P/p)==h,p
manifest=read(P/'manifest.json');verification=read(P/'verification.json');receipt=read(P/'final-receipt.json')
bindings=[]
def walk(v):
 if isinstance(v,dict):
  if isinstance(v.get('path'),str) and isinstance(v.get('sha256'),str):
   p=(R/v['path']).resolve()
   assert p.is_file() and sha(p)==v['sha256'],v
   bindings.append((str(p),v['sha256']))
  for x in v.values():walk(x)
 elif isinstance(v,list):
  for x in v:walk(x)
for doc in [manifest,verification,receipt]:walk(doc)
native=read(P/'native06-final.json');walk(native)
assert type(native['exit_code']) is int and native['exit_code']==0
assert native['input_commit']=='6f3a06c80e2b53c947a30aad9d954ba7dbf8e959'
assert [x.replace('\\','/').lower() for x in native['argv']]==[
 'c:/users/qed_s/.elan/bin/lake.exe','env','lean',
 (P/'Candidate.lean').relative_to(R).as_posix().lower()]
assert (P/'Candidate.lean').read_bytes()==(R/native['input']['path']).read_bytes()
names=manifest['declaration_list']['authored']+manifest['declaration_list']['reused_checks']
assert len(set(names))==len(names)==33
assert len(manifest['declaration_list']['authored'])==24
raw=(R/native['output']['path']).read_text(encoding='utf-8')
assert not re.search(r'\b(?:warning|error):|sorryAx',raw)
actual={}
for name in names:
 assert re.search(r'^'+re.escape(name)+r'(?:\.|\s|:)',raw,re.M),name
 match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
 if match:
  ax=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in match[1].split(',') if x.strip()]
 else:
  assert "'"+name+"' does not depend on any axioms" in raw,name;ax=[]
 assert set(ax)<={'propext','Classical.choice','Quot.sound'},(name,ax)
 assert ax==verification['all_axiom_results'][name],name
 actual[name]=ax
for attempt in verification['native_attempts']:
 n=read(R/attempt['receipt']['path']);walk(n)
 assert type(n['exit_code']) is int and n['exit_code']==attempt['actual_exit']
 assert n['input']==attempt['input'] and n['output']==attempt['output']
record={'schema':1,'status':'PASS','candidate_sha256':sha(P/'Candidate.lean'),
 'manifest_sha256':sha(P/'manifest.json'),'native_exit':0,'native_elapsed_ms':native['elapsed_ms'],
 'native_output_sha256':native['output']['sha256'],'bindings_verified':len(bindings),
 'unique_paths':len({p for p,h in bindings}),'authored_declarations':24,'existing_producer_checks':9,
 'root_review':'Read full mathematical candidate and proof-free API review. Actual solver/extractor coupling, ordered initial data, separate returned/reference error premises, exact embedding, and nonconserved stationary witness are present. The method demands temporal integrability of its physical interface trace on all finite real intervals; it makes no later spatial regularity or exact-conservation claim.',
 'source_acceptance':False,'next':'Separate reusable method, generic trace estimate, update estimates and examples in canonical placement; retain all-time trace convention and qualitative-accuracy source ambiguity.'}
p=S/'root-batch9-returned-field-verification.json'
with p.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'path':p.relative_to(R).as_posix(),'sha256':sha(p),'bindings':len(bindings),'axiom_checks':len(actual)}))

