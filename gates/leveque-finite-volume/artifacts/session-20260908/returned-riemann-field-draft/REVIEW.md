# Returned Riemann field foundation

Bounded scratch implementation requested by the root coordinator. No production,
source-wrapper, aggregate, tier, gate, ledger, audit, workflow or Git writes are
part of this work. `manifest.json` and `final-receipt.json`, generated only after
actual native verification, are the authoritative frozen bindings.

## Scope and source provenance

The sole mathematical source for source facts is the pinned LeVeque PDF,
SHA256 b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5.
The preceding read-only review inspected actual raw26-27/printed4-5 renderings
from frozen task LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908,
and its immediate continuation raw28/printed6 from the prepared source renders.
`inputs-before-final.json` binds the PDF, task, unchanged rejected decision/report,
and all three images. The old decision SHA is
44dfd5c682eb5fdcd9fabd7b747df0ccbabc280d31482e26861c714a7b56c1a4.

The old interface method mandates exact local rectangle solutions. New conditional
estimates already bound extraction and local/global trace errors for that class.
Printed p6 explicitly includes approximate Riemann solvers; unlike an inexact flux
extracted from an exact field, a nonexact returned field cannot inhabit the old
certificate. This is a representational observation and generic foundation,
not a source-faithfulness verdict. The source supplies no selected numerical error
tolerance/order, and this work makes no interpretation choice for that claim or
for Eq1.10. `API-REVIEW.md` gives the proof-free effective domain and statements.

## Scoped reuse searches and disposition

`reuse-method.{json,txt}` captures actual rg arguments/results over the current
ComputationalMathematics tree and pinned Mathlib: approximate-Riemann names,
CertifiedRectangleRiemannSolution, normalized-average estimates, and numerical
update error estimates. No matching approximate-returned-field API was found in
that scope. This is not a claim of exhaustive semantic absence.

Selected current-tree producers:

- RectangleRiemannInterface: ordered problems, explicit-domain exact solver and
  certificate. Reused unchanged by the exact adapter; its mandatory PDE certificate
  prevents directly using it for nonexact returned fields.
- CellAverageEstimates.norm_oneDimensionalCellAverage_sub_le: reused twice for
  the neutral trace-level bound; no new measure or integration proof.
- FluxUpdateErrorBounds.riemannFiniteVolumeUpdate_error_le: reused directly for
  the new method's conditional update estimate. Existing physical flux averages,
  cell widths and full left/right update interfaces are retained.
- RectangleRiemannFluxError: inspected and resolved as comparison API. Its method
  parameter remains exact, so the neutral trace generalization cannot directly
  instantiate it for an arbitrary nonexact returned field. Its field-bound proof
  uses the exact certificate only to supply local trace integrability.
- LinearRectangleRiemannInterface.linearHyperbolicConservationLaw: reused for
  the identity-matrix witness law. Existing eigenbasis and matrix-one API verify
  real hyperbolicity instead of adding a fresh hyperbolicity definition.
- RiemannData and LinearRiemannSolution: reused ordered initial-data specification
  and interval integrability. Rectangle.travelingWave_isRectangleConservationLawSolution
  supplies the independent exact translating reference.

`reuse-witness.{json,txt}` records searches for these initial-data/integrability,
traveling-wave, matrix-one and interval-constant producers. A preliminary guessed
ConservationLaws/TravelingWave leaf did not exist; inspection located the actual
owner ConservationLaws/Rectangle. Mathlib intervalIntegral.integral_const is reused
for the conservation contradiction, and the ordinary norm-subtraction identities
bound the difference of the two explicit two-state fields. The earlier optional
Lipschitz state-to-flux bridge is unnecessary for this minimal flux-level adapter;
no new Lipschitz abstraction was introduced.

## Successful content and preserved attempts

There are 24 authored declarations: one method structure, execution/adapter and
error API, and an explicit witness family. The result type is dependent on the
ordered problem, permitting the original exact certificate to be retained without
any reconstruction. Final witness results carry the actual field as subtype data.

- native01: generic core checked; witness identity-matrix simplification and a
  section-variable name collision failed. Lean's downstream sorryAx diagnostics
  belong to this failed run, not to accepted evidence.
- native02: repaired identity law and exact reference; remaining witness coercion
  and inference through the initially Unit-valued result failed.
- native03: explicit method/problem parameters repaired those inferences; one
  scalar-action simplification in the rectangle contradiction remained.
- native04: changed witness result to carry its actual field; the same scalar
  simplification remained after evaluating the vector equality componentwise.
- native05: explicit real scalar type resolved that definitional elaboration
  issue; the complete candidate exited zero, including the nonexact instance.
- native06-final: full structure/signature and axiom inspection for every authored
  declaration and nine selected existing producers; see actual receipt and manifest.

All snapshots, raw outputs and actual exit records are preserved separately.
No authored declaration uses a placeholder; failed diagnostic sorryAx occurrences
are retained only in historical failed outputs. The final verifier rejects any
unexpected axiom, native error or warning, mismatched snapshot/output hash, or
changed selected dependency/source binding. Native checks run in the named Windows
Lean worktree with pinned Lean/Mathlib; no released Python script is invoked.

## Reusable placement proposal and limits

Potential later placement, subject to root review: a small FiniteVolume returned-field
method/adapter leaf, a trace/error-estimate leaf (the trace lemma can serve other
methods), and an Examples witness leaf. No canonical path is introduced here.
The current scratch imports the two integrated comparison/linear method leaves;
lower direct imports could be selected during an independently verified extraction.

The exact API is preserved. The generic contract covers field returns and the
neutral trace theorem also covers trace-only returns. It imposes no conservation
of the returned field, whereas the independent physical q in update estimates
must satisfy rectangle conservation. Constant consistency alone proves no
unequal-state error bound. No nonlinear solvability, entropy, stability, CFL,
convergence, source accuracy criterion or source acceptance is asserted. A small
jump makes the witness bound small by changing the problem; it is not arbitrary
accuracy for one fixed Riemann problem.
