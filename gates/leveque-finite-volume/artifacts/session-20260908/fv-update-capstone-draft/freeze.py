"""Freeze actual native capstone assembly without source acceptance."""
from pathlib import Path
import hashlib,json,re
P=Path(__file__).resolve().parent;S=P.parent;R=S.parents[3]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest();read=lambda p:json.loads(p.read_bytes())
inputs=P/'inputs-v1.json';assert sha(inputs)=='3336d2c17e55f310f05d1253e66c2250cb74dc887298bb56b19c7540bf408049'
m=read(inputs)
for item in m['files']:assert sha(R/item['path'])==item['sha256'],item['path']
assert sha(R/m['old_witness'])==m['old_witness_sha256']
native=S/'fv-update-capstone-native01-exit.json';n=read(native)
assert type(n['exit_code']) is int and n['exit_code']==0
assert n['argv']==['lake','env','lean',(P/'Checks.lean').relative_to(R).as_posix()]
assert n['input_commit']=='6f3a06c80e2b53c947a30aad9d954ba7dbf8e959'
out=S/'fv-update-capstone-native01-output.txt';assert sha(out)==n['output_sha256']
candidate=P/'Candidate.lean';check=P/'Checks.lean'
assert check.read_bytes().startswith(candidate.read_bytes()+b'\n')
raw=out.read_text(encoding='utf-8')
assert not re.search(r'\b(?:warning|error):|sorryAx',raw)
axioms={}
for name in m['names']:
 assert re.search(r'^'+re.escape(name)+r'(?:\.|\s|:)',raw,re.M),name
 match=re.search(re.escape("'"+name+"' depends on axioms:")+r'\s*\[([^\]]*)\]',raw)
 if match:
  names=[re.sub(r'\.\{[^}]*\}$','',x.strip()) for x in match[1].split(',') if x.strip()]
 else:
  assert "'"+name+"' does not depend on any axioms" in raw,name;names=[]
 assert set(names)<={'propext','Classical.choice','Quot.sound'},(name,names)
 axioms[name]=names
def bind(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
artifact_paths=[p for p in sorted(P.iterdir()) if p.is_file()]+[native,out]
record={'schema':1,'scope':'Scratch assembly and nonvacuity only; pending source interpretation and independent audit.',
 'source_acceptance':False,'native_exit_code':0,'native_elapsed_ms':n['elapsed_ms'],
 'native_output_sha256':sha(out),'checked_declarations':len(axioms),'axioms':axioms,
 'artifacts':[bind(p) for p in artifact_paths],
 'canonical_inputs':m['files'],'preserved_witness':{'path':m['old_witness'],'sha256':m['old_witness_sha256']}}
dest=P/'final-receipt.json'
with dest.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps({'receipt_sha256':sha(dest),'candidate_sha256':sha(candidate),'axioms':len(axioms),'native_exit_code':0}))

