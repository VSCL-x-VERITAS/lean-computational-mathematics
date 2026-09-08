"""Verify real native exits, exact frozen inputs and axioms; no semantic verdict."""
from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime,json,re,sys
here=Path(__file__).resolve().parent/'information-interface-capstone-draft';repo=here.parents[4];session=here.parent
final_label='native-05'
digest=lambda p:sha256(p.read_bytes()).hexdigest()
bind=lambda p:dict(path=str(p),sha256=digest(p))
def put(name,value):
 path=here/name;assert not path.exists(),path
 path.write_text(json.dumps(value,indent=2)+'\n',encoding='utf-8',newline='\n')
 return path
preparation=json.loads((here/'preparation.json').read_bytes())
def verify_pairs(value,base=repo):
 if isinstance(value,dict):
  if 'path' in value and 'sha256' in value:
   path=Path(value['path']);path=path if path.is_absolute() else base/path
   assert digest(path)==value['sha256'],path
  for x in value.values():verify_pairs(x,base)
 elif isinstance(value,list):
  for x in value:verify_pairs(x,base)
verify_pairs(preparation)
old=session/'returned-field-interface-capstone-draft'
old_receipt=json.loads((old/'final-receipt.json').read_bytes())
verify_pairs(old_receipt['manifest'])
old_manifest=json.loads((old/'manifest.json').read_bytes())
for item in old_manifest['artifacts']:
 if Path(item['path']).name in ['page-026.png','page-027.png','page-028.png','page-026.txt','page-027.txt','page-028.txt','preparation.json']:
  verify_pairs(item)
candidate=here/'Candidate.lean';raw=candidate.read_bytes()
assert b'\r' not in raw and not re.search(rb'\b(sorry|admit|axiom|unsafe)\b',raw)
base=here/'native-03-Candidate.lean';fragment=here/'ComparisonWitness.lean.fragment'
assert raw==base.read_bytes()+b'\n'+fragment.read_bytes()
assert (here/'native-03.lean').read_bytes().startswith(base.read_bytes()+b'\n')
resolution=[];attempts=[];reports={};allowed={'propext','Classical.choice','Quot.sound'}
receipts=sorted(here.glob('native-*.receipt.json'))
for rp in receipts:
 r=json.loads(rp.read_bytes());label=rp.name.removesuffix('.receipt.json')
 assert r['inputs_unchanged'],label
 assert digest(Path(r['source']))==r['source_sha256'] and digest(Path(r['output']))==r['output_sha256']
 for path,h in r['inputs'].items():
  actual=Path(path)
  if digest(actual)!=h:
   assert actual==candidate, (label,path)
   recovered=here/(label+'-Candidate.lean')
   assert digest(recovered)==h and Path(r['source']).read_bytes().startswith(recovered.read_bytes()+b'\n'),label
   resolution.append(dict(attempt=label,original_path=path,recovered=bind(recovered),contained_in=bind(Path(r['source']))))
  else:assert digest(actual)==h
 text=Path(r['output']).read_text(encoding='utf-8')
 if r['exit_code']==0:
  assert not re.search(r'error:|warning:|sorryAx',text),label
  parsed=[]
  for match in re.finditer(r"'([^']+)' (?:depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",text,re.S):
   name=re.sub(r'\.\{[^}]*\}$','',match.group(1))
   axioms=[] if match.group(2) is None else [x.strip() for x in match.group(2).split(',') if x.strip()]
   assert set(axioms)<=allowed,(label,name,axioms)
   parsed.append(dict(name=name,axioms=axioms))
  expected=r['declarations']+r['reused_declarations']
  assert Counter(x['name'] for x in parsed)==Counter(expected),(label,len(parsed),len(expected))
  reports[label]=dict(count=len(parsed),declarations=parsed)
 else:assert r['exit_code']==1 and 'error:' in text,label
 attempts.append(dict(label=label,exit_code=r['exit_code'],receipt=bind(rp),source=bind(Path(r['source'])),output=bind(Path(r['output']))))
final=json.loads((here/(final_label+'.receipt.json')).read_bytes())
assert final['exit_code']==0 and final['source_sha256']==digest(Path(final['source']))
assert Path(final['source']).read_bytes().startswith(raw+b'\n')
assert len(final['declarations'])==14 and len(final['reused_declarations'])==10 and reports[final_label]['count']==24
extraction=json.loads((here/'contract-extraction.json').read_bytes());verify_pairs(extraction)
assert extraction['theorem_headers']==11
for label,want in [('prepare-01',1),('prepare-02',0)]:
 record=json.loads((here/(label+'.receipt.json')).read_bytes());assert record['exit_code']==want;verify_pairs(record)

for name in ['manifest.json','final-receipt.json','verification.json']:
 verify_pairs(json.loads((here/name).read_bytes()))
assert digest(here/'manifest.json')=='ed0061a2dd7da789aa3185c343ad30666611f435b3e11350a2ce060912d3db8c'
assert digest(here/'final-receipt.json')=='9ccb09671a50823c688a436bfbd3da4903e8c634d40c82697d75037ef159e65a'
assert final['command'][:3]==['C:/Users/qed_s/.elan/bin/lake.exe','env','lean']
assert Path(final['command'][3])==here/'native-05.lean'
assert all(type(json.loads(Path(x['receipt']['path']).read_bytes())['exit_code']) is int for x in attempts)
target=session/'root-information-interface-capstone-verification.json'
record=dict(status='PASS',source_acceptance=False,manifest=bind(here/'manifest.json'),final_receipt=bind(here/'final-receipt.json'),actual_native_attempts=attempts,
 authored=14,reused=10,final_reports=24,preserved_successful_base=13,historical_candidate_resolutions=resolution,
 local_dependencies=len(final['local_dependencies']),direct_mathlib_imports=len(final['direct_mathlib_imports']),
 root_review='Read complete candidate including literal two-face positive-step comparison, proof-free headers, full scope review and native/freezer code. Normalized averages, independent rectangle reference and per-interval AE rate preserved; actual admitted result at each face. Quantitative source convention remains pending; no full-field requirement inferred.')
with target.open('x',encoding='utf-8',newline='') as f:f.write(json.dumps(record,indent=2)+'\n')
print(json.dumps(dict(status='PASS',verification_sha256=digest(target),actual_exits={x['label']:x['exit_code'] for x in attempts},final_reports=24)))
