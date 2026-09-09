"""Pin the read-only reference proposal; does not execute Lean or touch the audit."""
from pathlib import Path
from datetime import datetime,timezone
import hashlib,json,os
D=Path(__file__).resolve().parent;U=D.parent.parent
R=next(p for p in D.parents if (p/'lean-toolchain').is_file())
exec(compile((U/'fv-local-domain-review/native-long-path-io.py').read_bytes(),'native-long-path-io.py','exec'),globals())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def ref(p):return {'path':str(p.resolve()),'sha256':sha(p),'bytes':p.stat().st_size}
def write(p,x):
 with p.open('xb') as f:f.write((json.dumps(x,indent=2,ensure_ascii=False)+'\n').encode())
draft=U/'physical-refinement-quality-draft/PhysicalRefinement.lean.fragment'
raw=draft.read_bytes()
assert (D/'PhysicalRefinement.reviewed.snapshot').read_bytes()==raw
old_variation=b'Internal differences are counted twice.' in raw
assert not old_variation and b'target_interior_nonempty' in raw and b'next physical lookup is absent' in raw
root=R/'ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume'
sources=[root/p for p in ['FiniteCartesianGeometry.lean','FiniteCartesianReference.lean',
 'CartesianCellProjection.lean','CartesianGridGeometry.lean','CartesianDirectionalReference.lean','FinitePhysicalReferenceError.lean']]
sources += [R/'.lake/packages/mathlib/Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean',
 U/'dim-two-direction-joint-witness/Candidate.lean',U/'dim-two-direction-cinfty-replay-02/Candidate.lean',
 U/'dim-two-direction-cinfty-replay-02/full-joint-exit.json',
 U/'user-high-resolution-interpretation-20260908.json',U/'selected-interpretations.json']
before=[ref(p) for p in sources]
assert (U/'dim-two-direction-joint-witness/Candidate.lean').read_bytes()==(U/'dim-two-direction-cinfty-replay-02/Candidate.lean').read_bytes()
native=json.loads((U/'dim-two-direction-cinfty-replay-02/full-joint-exit.json').read_bytes())
assert native['exit_code']==0
for key in ['stdout','stderr']:
 p=R/native[key]['path'];assert sha(p)==native[key]['sha256'];before.append(ref(p))
assert b'def reference : (Direction' in (U/'dim-two-direction-joint-witness/Candidate.lean').read_bytes()
manifest={'format':'affine-fin2-reference-design-review-1','created_at_utc':datetime.now(timezone.utc).isoformat(),
 'reviewer':'/root/hyperbolicity_audit/eigen_direct','original_review':ref(D/'REVIEW.md'),'review':ref(D/'UPDATE.md'),
 'reviewed_draft_origin':ref(draft),'reviewed_snapshot':ref(D/'PhysicalRefinement.reviewed.snapshot'),
 'input_pins':before,'existing_witness_native_exit':0,'existing_witness_reference':'zero, fixed level 0',
 'proposed_reference':'q x t := fun _ : Fin 1 => x 0 + x 1 - t',
 'proposed_reference_native_check':False,'full_quality_claim':False,'unsplit_PDE_claim':False,
 'draft_variation_boundary_counterexample':'resolved in newer snapshot; once-per-edge weighting; no full quality proof inferred',
 'production_or_operational_mutations':False,'source_judgment':False,'new_roles':False}
assert draft.read_bytes()==raw
write(D/'manifest.json',manifest)
write(D/'receipt.json',{'format':'bounded-reference-design-review-receipt-1',
 'manifest':ref(D/'manifest.json'),'original_review':ref(D/'REVIEW.md'),'review':ref(D/'UPDATE.md'),'runner':ref(Path(__file__)),
 'snapshot':ref(D/'PhysicalRefinement.reviewed.snapshot'),'selected_pins':len(before),'original_freeze_exit_code':1,'draft_changes_independently_reread':True,
 'read_only_review':True,'new_Lean_execution':False,'source_judgment':False})
print(json.dumps({'receipt':ref(D/'receipt.json'),'original_review':ref(D/'REVIEW.md'),'review':ref(D/'UPDATE.md'),'manifest':ref(D/'manifest.json')},indent=2))
