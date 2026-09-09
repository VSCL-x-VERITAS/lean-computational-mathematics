"""Read-only verification of the two frozen mathematical draft packets."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re
D=Path(__file__).resolve().parent;U=D.parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((U/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def load(p):return json.loads(p.read_bytes())
def ref(p):return {'path':str(p.resolve()),'sha256':sha(p),'bytes':p.stat().st_size}
def resolve(name):
 p=Path(name);return p if p.is_absolute() else R/p
def refs(x):
 if isinstance(x,dict):
  if isinstance(x.get('path'),str) and re.fullmatch('[0-9a-f]{64}',str(x.get('sha256',''))):yield x
  for v in x.values():yield from refs(v)
 elif isinstance(x,list):
  for v in x:yield from refs(v)
A=U/'dim-shared-accuracy-certificate';B=U/'capacity-net-reference-error-draft'
roots=[A/'final-receipt.json',A/'manifest.json',A/'verification.json',A/'native-01/receipt.json',
 A/'native-01/native-receipt.json',B/'receipt.json',B/'manifest.json',B/'verification.json',
 B/'native-03/input-pins.json',B/'native-03/lean-receipt.json']
# Historical attempts' mutable input references are not used as final binding claims.
items=[]
for p in roots:
 obj=load(p)
 if p==B/'verification.json':
  obj={k:v for k,v in obj.items() if k!='attempts'}
 items+=list(refs(obj))
checked={};errors=[]
for x in items:
 p=resolve(x['path']);key=(str(p.resolve()),x['sha256'])
 if key in checked:continue
 try:
  actual=ref(p)
  assert actual['sha256']==x['sha256']
  if 'bytes' in x:assert actual['bytes']==x['bytes']
  checked[key]=actual
 except Exception as e:errors.append({'expected':x,'error':repr(e)})
a=load(A/'native-01/native-receipt.json');b=load(B/'native-03/lean-receipt.json')
assert a['actual_exit_code']==0 and b['exit_code']==0
outa=(A/'native-01/native-output.txt').read_text(encoding='utf-8')
outb=(B/'native-03/lean-output.txt').read_text(encoding='utf-8')
reports=[]
for label,out,count in [('certificate',outa,7),('net-error-with-bridge',outb,12)]:
 found=re.findall(r"'([^']+)' depends on axioms: \[([^\]]*)\]",out,re.S)
 assert len(found)==count
 for name,body in found:
  axioms=[x.strip() for x in body.split(',') if x.strip()]
  assert set(axioms)<={'propext','Classical.choice','Quot.sound'}
  reports.append({'packet':label,'declaration':name,'axioms':axioms})
 assert 'sorryAx' not in out and 'warning:' not in out and 'error:' not in out
assert outa.count('NO_OLD_ACCURACY_DEPENDENCY ')==5
assert (A/'Candidate.lean').read_bytes()==(A/'native-01/Candidate.lean.snapshot').read_bytes()
net=(B/'NetError.lean.fragment').read_bytes();native=(B/'native-03/Candidate.lean').read_bytes()
bridge=resolve(load(B/'verification.json')['bridge']['path']).read_bytes()
assert native.count(net)==1 and native.count(bridge)==1
source=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
context=[source/'CoordinateLineMethod.lean',source/'CoordinateLineMethodEstimates.lean',
 source/'RefiningLineMethod.lean',source/'FinitePhysicalReferenceError.lean',source/'FinitePhysicalUpdate.lean',
 U/'dim-five-owner-overlay/overlay/ComputationalMathematics/Analysis/PartialDifferentialEquations/ConservationLaws/LocalRectangleReference.lean',
 U/'dim-five-owner-overlay/overlay/ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/Examples/HighResolutionAdvectionLine.lean']
line_index={}
for p in [A/'Candidate.lean',B/'NetError.lean.fragment',B/'native-03/Candidate.lean']+context:
 hits=[]
 for number,line in enumerate(p.read_text(encoding='utf-8').splitlines(),1):
  if re.match(r'(?:noncomputable )?(?:theorem|def|structure) ',line):hits.append({'line':number,'text':line})
 line_index[str(p.resolve())]=hits
result={'format':'bounded-independent-code-review-verification-1','verified_at_utc':datetime.now(timezone.utc).isoformat(),
 'reviewer':'/root/hyperbolicity_audit/eigen_direct','roots':[ref(p) for p in roots],
 'verified_unique_pins':len(checked),'verified_pins':list(checked.values()),'pin_errors':errors,
 'native_exits':{'certificate':a['actual_exit_code'],'net_error_final':b['exit_code']},
 'axiom_reports':reports,'final_warnings':0,'certificate_snapshot_exact':True,
 'net_fragment_and_root_bridge_embedded_exactly':True,'direct_old_accuracy_dependency_guards':5,
 'additional_read_context':[ref(p) for p in context],'declaration_lines':line_index,
 'new_native_execution':False,'adjudicator_access':False,'source_judgment':False}
with (D/'verification.json').open('xb') as f:f.write((json.dumps(result,indent=2,ensure_ascii=False)+'\n').encode())
print(json.dumps({'verification':ref(D/'verification.json'),'verified_unique_pins':len(checked),
 'pin_errors':errors,'native_exits':result['native_exits'],'axiom_reports':len(reports)},indent=2))
assert not errors
