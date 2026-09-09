"""Seal only this new bounded read-only report; no reviewed input writes."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os
D=Path(__file__).resolve().parent;U=D.parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((U/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':str(p.resolve()),'sha256':sha(p),'bytes':p.stat().st_size}
def write(p,x):
 with p.open('xb') as f:f.write((json.dumps(x,indent=2,ensure_ascii=False)+'\n').encode())
x=json.loads((D/'verification.json').read_bytes());assert not x['pin_errors']
for pin in x['verified_pins']+x['roots']+x['additional_read_context']:
 p=Path(pin['path']);assert sha(p)==pin['sha256'] and p.stat().st_size==pin['bytes']
findings={'format':'bounded-independent-mathematical-review-1',
 'reviewer':'/root/hyperbolicity_audit/eigen_direct','reviewed_at_utc':datetime.now(timezone.utc).isoformat(),
 'scope':'Two frozen draft interfaces, proof bodies and final native bindings only',
 'source_judgment':False,'faithfulness_action':'none','production_edits':False,
 'necessary_corrections_to_stated_draft_theorems':[],
 'verified_conclusions':[
  {'id':'C1','category':'quantifier-order','claim':'For fixed family, p,L precede q; C,N belong to one all-level certificate before arbitrary compatible execution.',
   'evidence':{'path':str(U/'dim-shared-accuracy-certificate/Candidate.lean'),'lines':[15,33,67]}},
  {'id':'C2','category':'line-domain-nonvacuity','claim':'Exact projected integer-line inputs are admitted above the same threshold; scalar nonconstant physical reference is supplied.',
   'evidence':{'path':str(U/'dim-shared-accuracy-certificate/Candidate.lean'),'lines':[53,102,112]}},
  {'id':'C3','category':'physical-reference-and-sign','claim':'Net error uses the same actual q, physical face histories, cell/slab and numerical rule; sign and weighted norm propagation are correct.',
   'evidence':{'path':str(U/'capacity-net-reference-error-draft/NetError.lean.fragment'),'lines':[11,21,40]}},
  {'id':'C4','category':'same-operator-capacity-bridge','claim':'Actual-cell capacity and projection are identified by the exact embedded bridge without using dummy ghost capacity as geometry.',
   'evidence':{'path':str(U/'capacity-net-reference-error-draft/NetError.lean.fragment'),'lines':[57,78]}}],
 'retained_applicability_limits':[
  {'id':'L1','category':'finite-consumer-not-supplied','claim':'Full-line projected-input existence does not establish an extracted finite-array projection with fixed ghosts or a compatible later realization.'},
  {'id':'L2','category':'physical-projection-identification','claim':'Executed certificate target is a 1D reference average; no automatic identification with a measured multidimensional physical field is proved.'},
  {'id':'L3','category':'uniform-net-bound-pending','claim':'The physical net estimate assumes its net bound; a fixed-reference refinement-uniform net-defect estimate is still needed before claiming a combined physical high-order result.'},
  {'id':'L4','category':'witness-scope','claim':'Scalar net witness verifies arithmetic/integrals and nonzero error but does not apply the full PhysicalData/Incidence theorem.'},
  {'id':'L5','category':'environment-scope','claim':'The certificate native result uses the frozen C-infinity overlay; no production regularity change or uniform rate across distinct families is inferred.'}],
 'suggested_next_work_if_combined_claim_is_pursued':['Supply the same actual physical references, projections and admitted execution family.',
  'Prove the required 1D-to-measured projection identification or a uniform measured net-defect certificate.',
  'Instantiate a joint physical consumer of the resulting combined theorem.'],
 'not_reviewed':['source faithfulness','running adjudicator','global completion','production placement','performance'],
 'verification':ref(D/'verification.json'),'review':ref(D/'REVIEW.md')}
write(D/'findings.json',findings)
manifest={'format':'bounded-independent-review-manifest-1','files':[ref(D/p) for p in ['verify.py','freeze.py','verification.json','findings.json','REVIEW.md']],
 'input_roots':x['roots'],'input_pin_count':len(x['verified_pins']),'all_inputs_unchanged_at_freeze':True}
write(D/'manifest.json',manifest)
receipt={'format':'bounded-independent-review-receipt-1','completed_at_utc':datetime.now(timezone.utc).isoformat(),
 'manifest':ref(D/'manifest.json'),'review':ref(D/'REVIEW.md'),'findings':ref(D/'findings.json'),
 'verification':ref(D/'verification.json'),'verified_unique_pins':339,'native_receipt_exits':x['native_exits'],
 'permitted_axiom_reports':19,'necessary_draft_proof_corrections':0,
 'retained_limits':5,'source_judgment':False,'new_native_execution':False,'adjudicator_access':False,
 'production_or_operational_mutations':False,'full_skill_workflow_seal_claimed':False}
write(D/'receipt.json',receipt)
print(json.dumps({'receipt':ref(D/'receipt.json'),'review':ref(D/'REVIEW.md'),'findings':ref(D/'findings.json'),
 'manifest':ref(D/'manifest.json')},indent=2))
