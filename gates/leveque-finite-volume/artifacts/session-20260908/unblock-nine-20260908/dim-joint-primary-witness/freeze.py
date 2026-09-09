"""Verify actual scratch receipts and freeze the joint witness; no audit or Git."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,re
P=Path(__file__).resolve().parent;D=P.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
ref=lambda p:{'path':p.relative_to(R).as_posix(),'sha256':sha(p)}
def write(name,data):
 with (P/name).open('x',encoding='utf-8',newline='\n') as f:f.write(json.dumps(data,indent=2)+'\n')
final=P/'native-03';receipt=json.loads((final/'receipt.json').read_bytes())
assert receipt['exit_code']==0 and receipt['inputs_unchanged'] and receipt['copied_quality_body_exact']
assert sha(R/receipt['output']['path'])==receipt['output']['sha256']
assert sha(R/receipt['input']['path'])==receipt['input']['sha256']
raw=(final/'output.txt').read_text(encoding='utf-8')
assert 'sorryAx' not in raw and ': error' not in raw
allowed={'propext','Classical.choice','Quot.sound'}
reports={}
for name,body in re.findall(r"'([^']+)' depends on axioms: \[([^]]*)\]",raw):
 assert name not in reports
 reports[name]={x.strip() for x in body.split(',') if x.strip()}
for name in re.findall(r"'([^']+)' does not depend on any axioms",raw):
 assert name not in reports
 reports[name]=set()
assert set(reports)==set(receipt['declarations']) and all(a<=allowed for a in reports.values())
types=[]
for name in receipt['declarations']:
 match=re.search(r'^'+re.escape(name)+r'(?=\s|\.|\().*?^\''+re.escape(name)+r"' (?:depends on axioms: \[[^]]*\]|does not depend on any axioms)",raw,re.M|re.S)
 assert match,name
 text=match.group(0).split("\n'"+name+"'")[0]
 types.append({'name':name,'native_type_text':text,'axioms':sorted(reports[name])})
resolutions=[];occurrences=0;attempts=[]
for folder in sorted(P.glob('native-*')):
 rr=json.loads((folder/'receipt.json').read_bytes())
 assert rr['inputs_unchanged']
 for item in rr['inputs']:
  p=R/item['path'];occurrences+=1
  if sha(p)==item['sha256']:continue
  assert p.parent==P and p.name in ('Fixture.lean.fragment','Application.lean.fragment','run.py'),item
  snapshot=folder/p.name
  assert snapshot.is_file() and sha(snapshot)==item['sha256'],item
  if p.suffix=='.fragment':
   assert snapshot.read_text(encoding='utf-8') in (folder/'Input.lean').read_text(encoding='utf-8')
  resolutions.append({'receipt':ref(folder/'receipt.json'),'original':item,'exact_historical_snapshot':ref(snapshot)})
 assert sha(R/rr['input']['path'])==rr['input']['sha256']
 assert sha(R/rr['output']['path'])==rr['output']['sha256']
 attempts.append({'receipt':ref(folder/'receipt.json'),'actual_exit':rr['exit_code']})
parents=[D/'directional-reference-repair/core-final02-receipt.json',
 D/'finite-cartesian-geometry-draft/final-receipt.json',D/'dim-quality-family-witness/receipt.json',
 D/'dim-local-characteristic-witness/receipt.json',D/'user-high-resolution-interpretation-20260908.json']
write('proof-free-native-types.json',{'schema':1,'native_output':receipt['output'],'declarations':types,
 'source_acceptance':False,'proofs_included':False})
write('verification.json',{'schema':1,'status':'PASS','attempts':attempts,
 'bound_input_occurrences':occurrences,'historical_mutable_input_resolutions':resolutions,
 'final_declaration_count':len(reports),'allowed_axioms':sorted(allowed),
 'inherited_warning':'One unused Fintype section variable in the copied cartesian_facePoint_measurable; no authored warnings.',
 'parent_evidence':[ref(p) for p in parents],'source_acceptance':False})
files=[ref(p) for p in sorted(P.rglob('*')) if p.is_file() and '__pycache__' not in p.parts and p.name not in ('manifest.json','final-receipt.json')]
write('manifest.json',{'schema':1,'status':'FROZEN-SCRATCH-NATIVE-PASS','files':files,'source_acceptance':False})
write('final-receipt.json',{'schema':1,'status':'PASS-JOINT-COMPLETE-PRIMARY-APPLICATION',
 'frozen_at_utc':datetime.now(timezone.utc).isoformat(),'manifest':ref(P/'manifest.json'),
 'native_receipt':ref(final/'receipt.json'),'native_input':receipt['input'],'native_output':receipt['output'],
 'actual_exit':0,'declaration_count':len(reports),'only_allowed_axioms':True,
 'proof_free_types':ref(P/'proof-free-native-types.json'),'verification':ref(P/'verification.json'),
 'fixture':ref(P/'Fixture.lean.fragment'),'application':ref(P/'Application.lean.fragment'),
 'primary_application':'DIMJointPrimaryWitness.full_application',
 'joint_applicability':'DIMJointPrimaryWitness.joint_applicability','source_acceptance':False})
print(json.dumps({'receipt':ref(P/'final-receipt.json'),'manifest':ref(P/'manifest.json'),
 'native_input':receipt['input'],'fixture':ref(P/'Fixture.lean.fragment'),
 'application':ref(P/'Application.lean.fragment'),'declarations':len(reports)},indent=2))
