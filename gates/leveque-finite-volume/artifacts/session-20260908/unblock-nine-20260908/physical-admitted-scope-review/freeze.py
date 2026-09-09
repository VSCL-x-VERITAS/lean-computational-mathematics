from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os,re
P=Path(__file__).resolve().parent;D=P.parent;S=D.parent
R=next(p for p in P.parents if (p/'lean-toolchain').is_file())
exec(compile((D/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
def ref(p):
 b=p.read_bytes();return {'path':p.relative_to(R).as_posix(),'sha256':hashlib.sha256(b).hexdigest(),'bytes':len(b)}
def put(p,x):
 b=x if isinstance(x,bytes) else (json.dumps(x,indent=2,ensure_ascii=False)+'\n').encode()
 with p.open('xb') as f:f.write(b)
 return ref(p)
A=D/'physical-admitted-high-resolution-sweep';old=D/'physical-high-resolution-sweep-draft'
assert ref(A/'receipt.json')['sha256']=='4a85f2ba726e00008c29783f55b3d87005754cf813b77f340948309d78caf153'
native=A/'native-01'
suffix=(old/'SourceTarget.lean.fragment').read_bytes()+b'\n'+(old/'Checks.lean.fragment').read_bytes()
before=(old/'native-03/Candidate.lean').read_bytes();assert before.endswith(suffix)
prefix=before[:-len(suffix)]
assert (native/'Candidate.lean').read_bytes()==prefix+b'\n'+(A/'Admitted.lean.fragment').read_bytes()+b'\n'+(A/'SourceTarget.lean.fragment').read_bytes()
for name in ('Admitted.lean.fragment','SourceTarget.lean.fragment'):
 assert (A/name).read_bytes()==(native/name).read_bytes()
 put(P/(name+'.snapshot'),(A/name).read_bytes())
for label in ('lake','lean'):
 r=json.loads((native/(label+'-receipt.json')).read_text());assert r['exit_code']==0
 for stream in ('stdout','stderr'):
  p=Path(r[stream]['path']);p=p if p.is_absolute() else R/p
  assert ref(p)['sha256']==r[stream]['sha256']
out=(native/'lean-output.txt').read_bytes()
reports=re.findall(rb"'([^']+)' depends on axioms: \[([^\]]*)\]",out)
assert len(reports)==61 and b'error:' not in out and b'warning:' not in out and b'sorryAx' not in out
for _,ax in reports:assert {v.strip().decode() for v in ax.split(b',')}<={'propext','Classical.choice','Quot.sound'}
source=S/'source/LeVeque_Finite_Volume_Methods_for_Hyperbolic_Problems_2002.pdf'
assert ref(source)['sha256']=='b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5'
paths=[source,S/'user-discontinuity-interpretation-20260908.json',D/'selected-interpretations.json',
 D/'user-high-resolution-interpretation-20260908.json',D/'dimensional-method-audit-preparation/source-context.json',
 S/'audits/LEV-CH01-COORDINATE-HIGH-RESOLUTION-METHODS-PRODUCTION-20260908/faithfulness/inputs/source_locator.json',
 D/'physical-refinement-quality-draft/native-02/Candidate.lean',D/'physical-refinement-quality-draft/native-02/PhysicalRefinement.lean.fragment',
 D/'capacity-boundary-sweep-draft/manifest.json',D/'capacity-boundary-sweep-draft/receipt.json',
 D/'physical-refinement-cartesian-witness/reference-native/manifest.json',D/'physical-refinement-cartesian-witness/reference-native/receipt.json',
 old/'native-03/Candidate.lean',old/'SourceTarget.lean.fragment',old/'Checks.lean.fragment',
 A/'Admitted.lean.fragment',A/'SourceTarget.lean.fragment',A/'REVIEW.md',A/'receipt.json',A/'manifest.json',A/'verification.json',
 native/'Candidate.lean',native/'lean-output.txt',native/'lean-receipt.json',native/'lake-receipt.json',native/'input-pins.json']
paths += [D/f'dimensional-method-audit-preparation/page-{n:03}.png' for n in (26,27,28)]
put(P/'findings.json',{'review_kind':'independent bounded design review, not sealed audit',
 'admission_gap':'addressed by exact ValidSubsteps on actual trajectory',
 'geometric_scope':'supplied measured directional balances; independent PDE equivalence is not claimed',
 'additional_necessary_changes':[], 'source_acceptance':False,'faithfulness_action':'new-audit-required',
 'unchanged_math_prefix':{'bytes':len(prefix),'sha256':hashlib.sha256(prefix).hexdigest()},
 'historical_native_exit_code':0,'historical_axiom_reports':61,'new_native_run':False,
 'historical_canonical_inputs_revalidated_as_current':False})
m=put(P/'manifest.json',{'schema':1,'source_pages':[26,27,28,125,126],'inputs':[ref(p) for p in paths],
 'outputs':[ref(p) for p in sorted(P.iterdir()) if p.is_file()],'source_acceptance':False})
r=put(P/'receipt.json',{'schema':1,'completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'manifest':m,'input_refs':len(paths),'scope_findings_addressed':True,
 'source_acceptance':False,'sealed_faithfulness_audit':False,'production_changes':False,'new_native_run':False})
print(json.dumps({'manifest':m,'receipt':r},indent=2))
