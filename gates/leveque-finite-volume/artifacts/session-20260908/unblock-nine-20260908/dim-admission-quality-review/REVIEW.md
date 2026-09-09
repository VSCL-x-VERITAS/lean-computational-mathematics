# Admission, fixed-level accuracy, and stability separation

This is an implementation proposal based on the actual completed direct judgment, current declarations, and the exact user receipt. The original audit's adjudication was not yet available when this review was prepared. It is not a new semantic judgment or acceptance, and no production change is authorized by this artifact itself.

## Smallest concrete changes

**Separate high-resolution quality from stability.** The literal receipt requires order greater than one on smooth solutions, quantitative oscillation control near discontinuities, and coordinate execution/error propagation. It does not equate these with uniform pairwise Lipschitz stability in the maximum norm. Define a core quality predicate with the existing uniform smooth-order and oscillation statements; keep the exact pairwise stability predicate and its witness as a distinct analysis assumption. The conservative execution, actual line linkage, locality, and geometry observations should not require that assumption. Perturbed-input accuracy and repeated error propagation can be explicit conditional conclusions under that separate assumption. Combining core quality with a supplied stability witness can recover the existing stronger quality structure internally, so the checked error producers can be reused rather than reproved. The primary must expose the separation; moving the same hidden requirement into a renamed structure is insufficient.

There is also a concrete source-wrapper documentation error. Its module prose currently says that the separately adopted convention requires “perturbation stability.” The exact receipt does not. The replacement prose in `SOURCE-DOC-PROPOSAL.md` attributes stability only to the additional conditional error analysis, with no invented user adoption. It must accompany the actual type-level separation.

**Make nonsmooth input coverage explicit without asserting a uniform CFL.** The old `admitted : ℕ → (ℤ → State) → Prop` is arbitrary. Oscillation control on that predicate does not alone establish control for physical discontinuity data. The following fixed-step sufficient condition is TOO STRONG as a generic repair and is retained only as a rejected alternative:

```lean
∀ n values,
  (∀ j ∈ inputWindow n, values j ∈ family.states) →
  family.admitted n values
```

It would admit every physical-state array at the same predetermined step. A nonlinear law on an unbounded state domain can require smaller steps for larger data. The selected minimal proposal instead makes the actual time step an argument of admission and of the numerical operator:

```lean
admitted : ℕ → ℝ → (ℤ → State) → Prop
∀ n values,
  (∀ j ∈ inputWindow n, values j ∈ states) →
  ∃ dt, 0 < dt ∧ dt ≤ actualMesh n ∧ admitted n dt values
```

Here `actualMesh` is bound to real supplied input-cell widths, not a free asymptotic parameter or the dummy capacity at a missing lookup. The condition gives every two-state jump array a positive available step when both states belong to the declared domain. It does not assert one step works for all arrays, any whole interval of permitted steps, a spectral CFL formula, or unconditional availability outside the declared state domain. A scalar CFL-one instance may prove the stronger data-independent choice `dt = h n`; that is a property of that instance.

Oscillation control is quantified over every admitted physical array at its actual supplied `dt`. Pairwise perturbation stability is a separate condition comparing both arrays at the SAME supplied `dt`; choosing a different time step for each side does not justify such a comparison. The actual execution must supply its admitted step, and availability alone does not prove stability, accuracy, conservation, or solvability.

If a proposed general method is only available under an actual data-dependent numerical CFL condition, retain that condition in `admitted` and prove the inputwise positive-step existence theorem. Merely replacing `admitted` with another arbitrary caller predicate would leave the same defect. Smooth-order constants in a later family must be independent of the refinement level and actual admitted time step, with an explicit allowed-step scope; a defect proportional to `dt * mesh ^ p` is a per-unit-time order statement, not a claim of convergence merely from small steps.

Do not require `admitted ↔ physical state membership` as a shortcut. The current smooth-order clause already admits exact projections of smooth physical references. An arbitrary admissible-state set need not be convex, so averages of admissible pointwise values need not lie in that set. A one-way physical-input coverage theorem preserves the separately established projection admission without adding an unproved convexity premise. If a successor instead requires projected means to remain in the state set, that condition must be explicit and justified for the actual law/domain.

**Share the uniform threshold with execution.** The existing family-wide statement `∃ p,L, ∀ q, ∃ C,N, ∀ level≥N, ...` is meaningful. The separate executed-cell clause chooses `N` after fixing the one actual level and can choose `N = level + 1`. It does not certify accuracy at that level.

Retain the family-wide certificate and either remove the redundant advertised executed-level existential or replace it by a corollary using the same certificate:

```text
for each family/reference, choose C,N once with the full all-level estimate;
for every compatible realization and cell at selected level k,
if N ≤ k and the actual projection/input hypotheses hold,
then the concrete executed update satisfies the corresponding estimate.
```

The certificate must contain the estimate for every sufficiently fine level; it cannot be defined by the one output error being bounded. `N` is selected before the later realization/level, or passed universally together with its all-level certificate. Do not require a rate bound at all coarse levels merely to remove the vacuity: an asymptotic order statement legitimately has a threshold. If the actual selected level is below it, the theorem should make no higher-order estimate there. Exact conservative execution still applies.

## Physical projection and refinement impact

The existing normalized cell-mean operation needs no replacement. The logical repair concerns which actual reference means enter `InitialProjection`, which domain admits them, and how one uniform refinement certificate is applied to actual execution.

For root's capacity/variable-face-area generalization, projection must remain the independent physical cell mass divided by that same positive capacity/volume, and the numerical update must use the same capacity and shared area-integrated flux. An algebraic capacity reparameterization is not by itself a proof that `finiteVolumeCellAverageOn` over an auxiliary interval equals a physical cell average. Reuse the current measured cell-average producer and prove that correspondence when the geometric realization supplies it. Keep independent all-subinterval physical references; do not redefine the reference by the numerical output.

The refinement rate must remain tied to actual executed geometry. The old uniform lower/upper comparability requirement excludes strongly graded meshes. A less restrictive concrete replacement is to define the declared mesh as the maximum width/diameter of the finite active/input cells used at that level, retain fixed-region coverage and convergence of that actual maximum to zero, and avoid any minimum-width ratio unless a particular conditional analysis requires it. Positive capacities alone have volume units and are not automatically a one-dimensional spatial mesh size. This is a proposed API direction, not a proved generic curvilinear convergence or chart theorem.

Fixed ghost values, synchronized duration, common-area representability and general logical-grid realization are distinct findings. Root is developing the capacity bridge; this review does not broaden geometry definitions before adjudication or claim that the new Fin2 example solves their universal scope.

## Reuse and next proof boundaries

- First artifact-only slice: a time-step-dependent domain on supplied finite input cells, actual-mesh binding, inputwise positive-step availability, and a theorem for every declared two-state jump. Instantiate availability with the existing scalar CFL-one operator and `dt = h n`; expose separate same-step oscillation/stability predicates. No higher-order quality construction is claimed in this slice.
- Subsequent `RefiningLineMethod` successor: split order/oscillation from stability, replace fixed-step admission by the explicit available-step API, and bind smooth physical projections and uniform refinement certificates before claiming a complete quality family.
- `CoordinateLineMethodEstimates.lean`: reuse `advance_eq`, `extract_error_le`, conservative execution, and the generic sequential error producer. Refactor `coordinate_stability` to accept the separate stability witness. Replace `smooth_accuracy`'s fixed-level existential by a shared all-level certificate corollary.
- `HighResolutionCoordinateSweep.lean` and the thin source wrapper: retain the unconditional process/geometry clauses under supplied compatible data; make quantitative perturbed/error estimates conditional on the separate stability/error assumptions.
- Root's broader capacity realization: establish exact physical projection and geometry linkage before using any auxiliary line-grid quality statement.

The frozen two-direction witness proves a compatible 16-cell instance and real two-stage movement with nonzero numerical flux. It cannot repair any universal admission, threshold, or method-domain gap by itself. The five-owner C-infinity/printer proposal remains a separate frozen packet; its semantics must not be relabeled as having repaired these additional findings.
