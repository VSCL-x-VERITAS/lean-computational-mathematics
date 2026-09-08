"""Verify real native exits, exact frozen inputs and axioms; no semantic verdict."""
from pathlib import Path
from hashlib import sha256
from collections import Counter
import datetime,json,re,sys
here=Path(__file__).resolve().parent;repo=here.parents[4];session=here.parent
final_label=sys.argv[1]
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
put('verification.json',dict(status='PASS',source_acceptance=False,actual_native_attempts=attempts,
 allowed_axioms=sorted(allowed),successful_reports=reports,historical_candidate_resolutions=resolution,
 canonical_dependency_modules=len(final['local_dependencies']),direct_mathlib_modules=len(final['direct_mathlib_imports']),
 successful_base=bind(base),successful_base_preserved_exactly=True,source_renderings_match_original_frozen_manifest=True))
artifact_files=[p for p in sorted(here.rglob('*')) if p.is_file() and '__pycache__' not in p.parts
                and p.name not in ['manifest.json','final-receipt.json']]
manifest=put('manifest.json',dict(schema=1,scope='Prospective information-only interface capstone, scratch only',
 frozen_utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),source_acceptance=False,selected=False,
 candidate=bind(candidate),contracts=bind(here/'contracts.proof-free.md'),review=bind(here/'REVIEW.md'),
 context=bind(here/'preparation.json'),verification=bind(here/'verification.json'),
 final_native_receipt=bind(here/(final_label+'.receipt.json')),final_actual_exit=0,
 declarations=final['declarations'],reused_declarations=final['reused_declarations'],
 historical_candidate_resolutions=resolution,artifacts=[bind(p) for p in artifact_files],
 pending_accuracy_question='call_1UY4fVuKrjpIIQfhLdeuFoRH',
 avoided_compulsory_full_field_question='call_gBZtG6Mn328LLCQ5DfzmFZtV',
 adopted_rectangle_ae_provenance='call_GV856xXH10OQXasWapraHP5y',
 remaining='Root source selection/independent audit; pending accuracy interpretation. No compulsory full-field foundation remains for this contract.'))
receipt=put('final-receipt.json',dict(schema=1,status='PASS',source_acceptance=False,selected=False,
 manifest=bind(manifest),candidate=bind(candidate),contracts=bind(here/'contracts.proof-free.md'),review=bind(here/'REVIEW.md'),
 native_receipt=bind(here/(final_label+'.receipt.json')),native_actual_exit=0,
 authored_declarations=14,reused_declarations=10,axiom_reports=24,
 preserved_base_declarations=13,full_two_face_capstone_instantiated=True,
 scope='Scratch only; no production, workflow/gate/audit/Git changes or adopted accuracy metric.'))
print(json.dumps(dict(receipt=bind(receipt),manifest=bind(manifest),candidate=bind(candidate),
 contracts=bind(here/'contracts.proof-free.md'),review=bind(here/'REVIEW.md'),actual_native_exit=0)))
