"""Freeze the scoped diagnosis and proposal; no production or workflow write."""
from pathlib import Path
import ast,datetime,hashlib,json,re
P=Path(__file__).resolve().parent;D=P.parent;R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
def sha(b):return hashlib.sha256(b).hexdigest()
def ref(p):return {'path':p.relative_to(R).as_posix(),'sha256':sha(p.read_bytes())}
def load(p):return json.loads(p.read_bytes())
def save(n,v):
 with (P/n).open('xb') as f:f.write((json.dumps(v,indent=2,ensure_ascii=True)+'\n').encode())
r=load(P/'native-01/receipt.json');raw=(P/'native-01/output.txt').read_bytes();assert r['exit_code']==0 and r['inputs_unchanged'] and sha(raw)==r['output_sha256']
t=raw.decode();assert 'error:' not in t and 'warning:' not in t
reports=re.findall(r"'([^']+)' (depends on axioms:\s*\[([^\]]*)\]|does not depend on any axioms)",t,re.S)
assert len(reports)==11 and len({x[0] for x in reports})==11
allowed={'propext','Classical.choice','Quot.sound'};axioms=[]
for name,kind,body in reports:
 names={v.strip() for v in body.split(',') if v.strip()};assert names<=allowed
 axioms.append({'declaration':name,'axioms':sorted(names)})
impact=load(P/'impact.json');assert len(impact['changes'])==4 and impact['regularity_edit']['all_direct_occurrences']==9
for v in impact['all_16_owners']:assert sha((R/v['owner']['path']).read_bytes())==v['owner']['sha256']
for v in impact['changes']:
 for k in ['before','proposed']:assert sha((R/v[k]['path']).read_bytes())==v[k]['sha256']
for p in P.glob('*.py'):ast.parse(p.read_bytes())
save('verification.json',{'status':'SCOPED_CHECKS_PASS','native_receipt':ref(P/'native-01/receipt.json'),'native_output':ref(P/'native-01/output.txt'),
 'actual_native_exit':0,'no_warnings_or_errors':True,'axiom_reports':axioms,'all_16_production_source_pins_unchanged':True,
 'direct_proposal_files':4,'annotation_substitutions':9,'expression_impact':ref(P/'expression-impact-v2.json'),
 'source_claim':'No source acceptance or full-family/source-joint replay asserted.'})
files=[ref(p)|{'bytes':p.stat().st_size} for p in sorted(P.rglob('*')) if p.is_file() and '__pycache__' not in p.parts and p.name not in ['manifest.json','receipt.json']]
save('manifest.json',{'schema':1,'source_acceptance':False,'files':files})
save('receipt.json',{'schema':1,'status':'DIAGNOSIS_AND_PROPOSAL_FROZEN','source_acceptance':False,'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
 'review':ref(P/'REVIEW.md'),'geometry_proposal':ref(P/'GEOMETRY-PROPOSAL.md'),'manifest':ref(P/'manifest.json'),'verification':ref(P/'verification.json'),
 'actual_native_exit':0,'native_output_sha256':r['output_sha256'],'production_changes':False,'full_build_run':False,'audit_or_gate_operations':False,
 'limits':['Only local C-infinity PDE/characteristic proof bodies replayed; full family/source joint replay remains necessary.',
 'C-infinity correction is separate from blind stability evidence and logical-geometry coverage.',
 'A fresh fingerprint/dependency/organization/audit successor is required after an adopted production repair.']})
print(json.dumps({'receipt':ref(P/'receipt.json'),'manifest':ref(P/'manifest.json'),'review':ref(P/'REVIEW.md'),'geometry':ref(P/'GEOMETRY-PROPOSAL.md'),'files':len(files)}))
