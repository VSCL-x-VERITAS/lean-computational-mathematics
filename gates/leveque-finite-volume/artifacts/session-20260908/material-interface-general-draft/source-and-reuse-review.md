# Material-interface data: bounded general draft

This is an implementation and contextual review, not a semantic audit or a replacement decision. The complete original rejected audit remains untouched. No production, gate, ledger, tracker, kit, or Git changes are made.

## Primary source and exact scope

Source: Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, first printed 2002 (selected PDF copyright 2004), SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. The actual full-page rendered images `page-029.png`, `page-030.png`, and contextual `page-027.png` were inspected. `input-provenance.json` binds their bytes and all frozen audit files; no extracted text supplied source facts.

- Printed page 7 / raw PDF page 29, Section 1.4, final paragraph: heterogeneous material parameters can vary smoothly; sharp material interfaces and jump discontinuities are also discussed. This provides context for a jump model, without a displayed globally constant material profile.
- Printed page 8 / raw PDF page 30, Section 1.4, first paragraph, third sentence: “The idea of a Riemann problem is easily extended to the case where there is a discontinuity in the medium at x = 0 as well as a discontinuity in the initial data.” The preceding sentence motivates different material properties assigned to grid cells through averaging. The following sentence starts the separately scoped claim about solving the problem and wave decomposition. The draft supplies no wave decomposition, reflection, transmission, or evolution equation.
- Printed page 5 / raw PDF page 27, Section 1.2.1 and Eq. (1.11): ordinary Riemann initial data are piecewise constant on the two open half-lines, with the point at zero unspecified. The text calls this a single jump; the displayed formula itself does not contain an inequality between the two states.

The selected frozen task is `LEV-CH01-MATERIAL-INTERFACE-RIEMANN-DATA-PRODUCTION-20260908`. Decision SHA-256 `d39e5f7d682275ebe7333695c0249c6e4ccffd7b81e0bc4bfa3c4930659e1216` records `not-faithful-weaker`, accepted false. Its full decision and report were read. The decisive issue is that paired half-line constancy does not require either component to jump. Its separate residual uncertainty concerns global versus local material scope. This review preserves both findings rather than treating successful compilation as source acceptance.

## Checked mathematical increment

The scratch namespace is `NumStability.MaterialInterfaceDraft`. There are 14 new declarations: 3 definitions and 11 theorems.

`HasJumpAt data a left right` is the conjunction of the left limit at `a`, the right limit at `a`, and `left ≠ right`. It imposes no point value or behavior away from the interface. It is defined for arbitrary topological codomains; its noncontinuity consequence correctly requires a Hausdorff codomain. The domain is the real line, ensuring that both one-sided neighborhood filters are nontrivial.

`HasMaterialStateInterfaceAt` requires this jump predicate independently for material and state, at the same arbitrary real interface. The product-trace equivalence retains **both** component inequalities. The generic theorem proves actual noncontinuity of both fields. A separate checked counterexample shows a pair with distinct traces while the material component is constant, so a single pair inequality would not repair the rejected target.

`HasJumpAt.congr` proves invariance under equality eventually on each punctured side. It does not require equality at the interface or elsewhere. `hasJumpAt_of_isRiemannData` and `riemann_pair_hasMaterialStateInterface` reuse the existing global Riemann producers, with independent side inequalities and independently arbitrary origin values.

`materialInterface_of_local_medium_and_riemann_state` is the thin conditional contract draft. It accepts arbitrary material one-sided limits with distinct traces, retains full `IsRiemannData` for the initial state with distinct side states, and returns the interface predicate, the unchanged Riemann-state predicate, and both actual discontinuities. Thus the draft does not weaken Eq. (1.11)'s initial-state representation while removing an unestablished global material restriction.

The explicit witness has material `x` for `x < 0`, `1 + x` for `x > 0`, and any selected value at zero. Its initial state is 2 on the left, 3 on the right, and independently arbitrary at zero. Lean proves both jumps, both discontinuities, the exact initial Riemann data, both free origin values, and that **no choice of material side constants** makes this medium globally `IsRiemannData`. This is a generic mathematical example of the representation, not a claim that those real values are admissible physical acoustic densities, moduli, or another specified constitutive law.

## Reuse search and decisions

Interactive project and pinned Mathlib searches preceded the definitions/proofs; exact scoped replays and real exits are recorded in `input-provenance.json`.

| Search/candidate | Disposition |
| --- | --- |
| Project `MaterialInterface`, `materialInterface`, `RiemannData`, `JumpAt`, `JumpDiscontinu` | Existing source target and `InitialValue.Riemann.isRiemannData_prod_iff` establish global componentwise constancy; they do not provide the required two distinct jumps or a local medium model. They remain unchanged. |
| `FiniteVolume.RiemannDataRegularity` | Reuse `IsRiemannData.tendsto_left` and `.tendsto_right` for the constant-side specialization. `.not_continuousAt_zero` already proves the global special case, but cannot establish the arbitrary local-trace theorem without adding global assumptions. |
| `FiniteVolume.RiemannData` | Reuse `riemannData`, `riemannData_isRiemannData`, and `riemannData_zero` for witnesses and free point values. |
| Existing `HuberShock.Jump` | Contains a specific solution's trace calculation and discontinuity, not a generic two-field interface predicate. No shock dynamics imported. |
| Mathlib Topology/Analysis `JumpAt`, `JumpDiscontinu`, `jump_discontinu`, `jump.*tendsto`, `tendsto.*jump` | Recorded scoped search returned no matching generic producer. This is not a claim of exhaustive semantic absence. |
| Mathlib `tendsto_nhds_unique` | Reused twice to show distinct one-sided limits preclude continuity; the explicit `T2Space` assumption is necessary for this reasoning. |
| Mathlib `Filter.Tendsto.prodMk_nhds`, `.fst_nhds`, `.snd_nhds` | Reused directly for the product-trace equivalence; no duplicate product-topology proof. |
| Mathlib `Filter.Tendsto.congr'` | Reused for invariance under one-sided eventual equality. |
| Mathlib `not_continuousAt_of_tendsto` | General incompatible-filter criterion exists, but the source-relevant distinct-trace formulation is directly obtained from limit uniqueness without constructing an auxiliary incompatible target filter. |

The exact imported producer declarations are checked and their axioms printed alongside all new declarations. Native Lean version, pinned Mathlib revision, source files, direct imported oleans, and Lake manifest are recorded. The final check file starts with the exact final candidate bytes.

## Remaining source interpretation for the coordinator

The smallest new general interface representation is the local two-jump predicate. A source contract that additionally retains the original Riemann initial states is provided. This fixes the specific omitted-discontinuities defect mathematically and distinguishes the local and global medium domains concretely. It does not establish that this is the exhaustive intended source model.

Two precise interpretation choices remain available for a future source contract and audit:

1. Treat the selected sentence as the interface jump configuration: arbitrary material profiles with distinct one-sided traces, together with distinct initial Riemann states. The generic local-medium draft supplies this representation. This does not solve the associated variable-coefficient PDE.
2. Treat the sentence as a cell-based idealized Riemann problem with material constants on both half-lines. The globally constant-side specialization supplies both actual jumps, but the current source pages do not explicitly state this material profile, so the scope restriction needs source interpretation or user adoption rather than silent insertion.

Equal-side degenerate Riemann data may remain meaningful for a broader algorithmic family, but they cannot themselves witness the selected sentence's two discontinuities. The draft separates the nondegenerate interface case; it does not decide whether a larger source definition convention includes degenerate cases. The source's physical choice of material variables and admissible constitutive states is also not formalized here.

No final source-faithfulness verdict is asserted. The parent coordinator owns any subsequent target choice, canonical extraction, semantic audit, and row closure.
