/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity

/-!
# Linear production with discontinuous spatial profiles

Arbitrary locally integrable profiles admit linear growth or depletion with zero
flux. A stationary spatial step supplies nonzero integrated production without
requiring spatial state differentiability.
-/

open MeasureTheory

namespace NumStability

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

section Examples

variable [CompleteSpace E]

/-- Arbitrary locally integrable profiles can grow or deplete at any real rate
with zero transport. The construction does not require spatial smoothness. -/
theorem linearAmplitude_isRectangleBalanceLawSolution (profile : ℝ → E)
    (hprofile : ∀ a b, IntervalIntegrable profile volume a b) (rate : ℝ) :
    IsRectangleBalanceLawSolution
      (fun x t => (rate * t) • profile x) (fun _ => 0)
      (fun x _ => rate • profile x) := by
  refine ⟨fun a b t => (hprofile a b).smul (rate * t),
    fun _ _ _ => intervalIntegrable_const,
    fun a b _ => (hprofile a b).smul rate,
    fun _ _ _ _ => intervalIntegrable_const, ?_⟩
  intro a b s t
  simp only [intervalIntegral.integral_smul, sub_self, intervalIntegral.integral_zero,
    zero_add, intervalIntegral.integral_const, ← sub_smul, smul_smul]
  congr 1
  ring

omit [CompleteSpace E] in
theorem linearAmplitude_hasDerivAt_mass (profile : ℝ → E) (rate a b t : ℝ) :
    HasDerivAt (fun τ => ∫ x in a..b, (rate * τ) • profile x)
      (rate • ∫ x in a..b, profile x) t := by
  simpa only [intervalIntegral.integral_smul, mul_one] using
    ((hasDerivAt_id t).const_mul rate).smul_const (∫ x in a..b, profile x)

end Examples

/-- The same constructed source has the existing conservative differential
meaning wherever that relation is used. A spatial state derivative is not
needed here, since the flux is the actual constant zero function. -/
theorem linearAmplitude_isBalanceLawSolutionAt {m : ℕ}
    (profile : ℝ → Fin m → ℝ) (rate x t : ℝ) :
    IsBalanceLawSolutionAt (fun ξ τ => (rate * τ) • profile ξ)
      (fun _ => 0) (rate • profile x) x t := by
  refine ⟨rate • profile x, 0, ?_, hasDerivAt_const x 0, by simp⟩
  simpa only [mul_one] using ((hasDerivAt_id t).const_mul rate).smul_const (profile x)
theorem riemannStep_unitCell : (∫ x in (1 : ℝ)..2, (riemannData (0 : ℝ) 0 1) x) = 1 := by
  have heq : (∫ x in (1 : ℝ)..2, (riemannData (0 : ℝ) 0 1) x) = ∫ _x in (1 : ℝ)..2, (1 : ℝ) := by
    apply intervalIntegral.integral_congr
    intro x hx
    have hx' : 1 ≤ x := by
      rcases Set.mem_uIcc.mp hx with h | h
      · exact h.1
      · linarith [h.1, h.2]
    exact (riemannData_isRiemannData 0 0 1).2 x (by linarith)
  rw [heq]
  norm_num
  rfl

/-- Signed production is retained: the unit rectangle contribution is exactly
the supplied real rate, so a negative rate models depletion equally well. -/
theorem riemannStep_signed_source_integral (rate : ℝ) :
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, rate * (riemannData (0 : ℝ) 0 1) x) = rate := by
  simp only [intervalIntegral.integral_const_mul, riemannStep_unitCell, mul_one,
    intervalIntegral.integral_const, smul_eq_mul]
  ring

/-- A real, spatially discontinuous source-bearing solution with nonzero net
production in a genuine rectangle and ordinary continuous-time mass rates. -/
theorem riemannStep_source_nonvacuity :
    IsRectangleBalanceLawSolution (fun x t => t * (riemannData (0 : ℝ) 0 1) x) (fun _ => 0)
      (fun x _ => (riemannData (0 : ℝ) 0 1) x) ∧
    ¬ ContinuousAt (fun x => (1 : ℝ) * (riemannData (0 : ℝ) 0 1) x) 0 ∧
    (∀ a b t, HasDerivAt (fun τ => ∫ x in a..b, τ * (riemannData (0 : ℝ) 0 1) x)
      (∫ x in a..b, (riemannData (0 : ℝ) 0 1) x) t) ∧
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, (riemannData (0 : ℝ) 0 1) x) = 1 ∧
    ¬ IsRectangleConservationLawSolution
      (fun x t => t * (riemannData (0 : ℝ) 0 1) x) (fun _ => 0) := by
  have hb : IsRectangleBalanceLawSolution (fun x t => t * (riemannData (0 : ℝ) 0 1) x)
      (fun _ => 0) (fun x _ => (riemannData (0 : ℝ) 0 1) x) := by
    simpa using linearAmplitude_isRectangleBalanceLawSolution (riemannData (0 : ℝ) 0 1)
      (riemannData_intervalIntegrable 0 0 1) 1
  have hnonzero : (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, (riemannData (0 : ℝ) 0 1) x) = 1 := by
    rw [riemannStep_unitCell]
    norm_num
    rfl
  refine ⟨hb, ?_, ?_, hnonzero, ?_⟩
  · simpa only [one_mul] using
      (riemannData_isRiemannData (0 : ℝ) 0 1).not_continuousAt_zero zero_ne_one
  · intro a b t
    simpa using linearAmplitude_hasDerivAt_mass (riemannData (0 : ℝ) 0 1) 1 a b t
  · exact hb.not_conservation_iff_exists_nonzero_source_integral.mpr
      ⟨1, 2, 1, 2, by rw [hnonzero]; exact one_ne_zero⟩

end NumStability
