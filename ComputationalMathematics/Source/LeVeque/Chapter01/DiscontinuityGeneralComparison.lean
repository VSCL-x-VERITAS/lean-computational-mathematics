/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Discontinuity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.MovingRiemannJump

/-!
# LeVeque Chapter 1, general discontinuity comparison

LeVeque, printed pages 4-5 (raw PDF pages 26-27), discusses integral balance
and classical failure at discontinuities around equation (1.10). This theorem
uses the interpretation adopted by the user on 2026-09-08: rectangle conservation,
the mass-rate identity almost everywhere for each fixed interval, and classical
solutionhood requiring spatial state differentiability. The exact instruction
is recorded in user-discontinuity-interpretation-20260908.json in the Chapter 1
session artifacts. A genuine finite-vector jump establishes nonvacuity.

This correspondence preserves the original printed ambiguity and is subject
to independent statement auditing; proof compilation alone is not acceptance.
-/

open MeasureTheory

namespace NumStability

theorem leveque01_discontinuity_generalIntegralComparison :
    (∀ (m : ℕ) (q : ℝ → ℝ → Fin m → ℝ)
      (flux : (Fin m → ℝ) → Fin m → ℝ) (x t : ℝ),
      IsRectangleConservationLawSolution q flux →
      ¬ ContinuousAt (fun ξ => q ξ t) x →
      (∀ a b, ∀ᵐ τ, HasDerivAt (fun s => ∫ ξ in a..b, q ξ s)
        (flux (q a τ) - flux (q b τ)) τ) ∧
      (∀ qx, ¬ HasDerivAt (fun ξ => q ξ t) qx x) ∧
      (¬ DifferentiableAt ℝ (fun ξ => q ξ t) x) ∧
      (∀ fluxDerivative : (Fin m → ℝ) → ((Fin m → ℝ) →L[ℝ] (Fin m → ℝ)),
        ¬ IsQuasilinearConservationLawSolutionAt q fluxDerivative x t)) ∧
    (∃ (q : ℝ → ℝ → Fin 1 → ℝ) (flux : (Fin 1 → ℝ) → Fin 1 → ℝ)
      (x t : ℝ), IsRectangleConservationLawSolution q flux ∧ 0 < t ∧
        ¬ ContinuousAt (fun ξ => q ξ t) x) := by
  exact ⟨fun _ _ _ _ _ hrectangle hjump =>
    hrectangle.discontinuity_comparison hjump, exists_discontinuous_rectangle_field⟩

end NumStability
