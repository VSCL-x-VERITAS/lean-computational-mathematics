# Riemann foundation scratch investigation

The immutable selected source is LeVeque (2002), Chapter 1. Raw PDF pages 27 and 33 were read from the root coordinator's rendered source pages. Page 27 gives piecewise constant left/right initial data without a value at x = 0, describes typical similarity solutions, and states that the linear hyperbolic problem is solved in terms of eigendata. Page 33 defines the ray-zero value of a similarity solution. Source SHA-256: `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.

## Scope and reuse search

This directory is scratch evidence only. It introduces no production declaration, gate closure, audit decision, or source equivalence claim. The root's checked `transport-rectangle-candidate.lean` was copied without changing that root file. Its time-integrated rectangle balance is the starting foundation, not a claim that the printed differential-in-time formula holds classically at all shock crossings.

Current canonical PDE tree searches used `Riemann`, `riemann`, `stepFunction`, `Heaviside`, `eigenmode.*sum`, and `rectangle`. Selected existing producers:

- `ComputationalMathematics/Analysis/PartialDifferentialEquations/FiniteVolume/RiemannData.lean`: `riemannData`, `IsRiemannData`, and the free origin parameter. This is an exact fit; it avoids imposing a trace convention absent from (1.11).
- `ComputationalMathematics/Analysis/PartialDifferentialEquations/Hyperbolicity.lean`: `IsRealHyperbolicMatrix` and its real eigenbasis witness. No new matrix diagonalization or eigenbasis structure is needed.
- `ComputationalMathematics/Analysis/PartialDifferentialEquations/EigenmodeWaves.lean`: `eigenmodeTravelingWave`. The existing classical solution theorem has a differentiable-profile premise, so it cannot establish the proposed discontinuous Riemann construction.
- `RiemannInterface.lean`: its certified-solution structures consume a solution of the existing integral-law predicate. They do not produce an eigenbasis Riemann solution; using such a certificate as a premise would leave the requested construction unproved.

Pinned Mathlib searches used `intervalIntegrable.*piecewise`, `IntervalIntegrable.congr`, `integral_finset_sum`, `Integrable.piecewise`, `mulVec_sum`, and `mulVec_smul`. Selected producers include `MeasureTheory.Integrable.piecewise` in `MeasureTheory/Integral/IntegrableOn.lean`, interval-integrable constants, `IntervalIntegrable.smul_continuousOn`, `IntervalIntegrable.sum`, `intervalIntegral.integral_finset_sum`, `Finset.sum_sub_distrib`, and the matrix sum/scalar-action identities. Restricting volume to a bounded interval gives integrable constants, so two measurable half-line splits establish local integrability with an arbitrary origin value. No measure-zero origin rewrite is necessary.

Search results establish these concrete candidates and rejections, not global semantic absence. The root coordinator handles eventual reusable placement, source wrappers, independent audits, and current-lane reconciliation.

## Intended checked contract

The construction uses a real eigenbasis, eigenvalues, arbitrary left/origin/right states, translated scalar piecewise constant characteristic profiles, and their finite sum. The intended theorem proves rectangle balance, exact initial data, and positive-time self-similarity. Evaluating the selected profile at ray zero defines its ray-zero state; no uniqueness across different trace selections is asserted.

Errors from exploratory compilation are retained as `attempt-*.txt` and must not be treated as passed checks. Final results are reported separately once Lean succeeds.

## Successful result

Native `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/riemann-foundation/candidate.lean` exited 0 on the third attempt. Its exact complete stdout is preserved in `final-output.txt` (identical bytes to `attempt-03.txt`). The first two attempts contain elaboration errors and are historical failed checks only. The successful output contains no errors or warnings. All nine printed dependency closures use only `propext`, `Classical.choice`, and `Quot.sound`; the file contains no `sorry`, `admit`, `axiom`, or `unsafe` token.

The checked candidate now proves every intended contract above, including the full existential construction `NumStability.Chapter01Scratch.IsRealHyperbolicMatrix.exists_rectangle_riemann_solution`. The construction is an explicit finite sum of the existing `eigenmodeTravelingWave` producer, with characteristic coefficients obtained from the existing `Module.Basis.equivFun`. Exact initial reconstruction reuses `Module.Basis.equivFun_symm_apply` and the equivalence inverse law. Positive-time similarity follows from preservation of both half-line predicates under multiplication by a positive time. No coordinate-of-matrix-action identity or classical PDE decoupling theorem is introduced; the root coordinator is developing that distinct analytic result separately.

The free initial origin state is preserved exactly. In particular, the theorem imposes no left-continuous or right-continuous convention at a stationary characteristic. The selected ray-zero value may therefore depend on this chosen representative. The checked result proves constancy along the positive-time ray for that selected solution, not uniqueness across arbitrary solution representatives.

The conservation contract is the root's time-integrated rectangle law on all real space/time endpoints. This does not establish the existing classical `HasDerivAt` interval-mass predicate at every jump crossing. Reusable production placement, comparison of the rectangle contract with the source's intended weak law, source wrappers, and independent semantic audits remain the root coordinator's work. There are no unresolved Lean obligations in this scratch construction and no claimed hard blocker.

Candidate SHA-256: `3597bcb220f76e330d8c780f92fd68123ec0865e7bb1b5eae48a5a0f2bde0876`.
Final output SHA-256: `fda62c6b38132c56533382d3ff4cd9ec5f02872e110e2befc41eb73ca149e44a`.
Copied root base SHA-256: `a574b4546afa6ed7df9ff82cd14597cae2843a78078e57f9a4ef482e64a750bb`.
Observed repository HEAD after validation: `8f16ae5e2d64e2d71e3ad2cbe1fed3e7b4795b6b`.
Lean toolchain file SHA-256: `fdf7ccfe204caff50fab1913b9f13a763be5384e87d14555c9fdcb2be2b9f7f8`.
Lake manifest SHA-256: `ccfe8a72d6d227aebfe4e58575ddf2a2aef03b795052f97b770c36f684cc5774`.
