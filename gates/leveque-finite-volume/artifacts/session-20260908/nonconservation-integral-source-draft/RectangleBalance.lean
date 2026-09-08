/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation

/-!+# Scratch: rectangle balance with internal production

Only bounded-interval integrability is required. No spatial derivative, source
sign, constitutive rate law, or pointwise-in-time mass derivative is assumed.
-/

open MeasureTheory

namespace NumStability.IntegralSourceDraft

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-- Finite mass and boundary exchange, together with spatially integrated
production and its time integral, on all oriented bounded rectangles. -/
def IsRectangleBalanceLawSolution
    (q : ℝ → ℝ → E) (flux : E → E) (production : ℝ → ℝ → E) : Prop :=
  (∀ a b t, IntervalIntegrable (fun x => q x t) volume a b) ∧
  (∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) ∧
  (∀ a b t, IntervalIntegrable (fun x => production x t) volume a b) ∧
  (∀ a b s t, IntervalIntegrable (fun τ => ∫ x in a..b, production x τ) volume s t) ∧
  ∀ a b s t,
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      (∫ τ in s..t, flux (q a τ) - flux (q b τ)) +
        ∫ τ in s..t, ∫ x in a..b, production x τ

namespace IsRectangleBalanceLawSolution

variable {q : ℝ → ℝ → E} {flux : E → E} {production : ℝ → ℝ → E}

/-- The source contribution is the mass change after boundary inflow is removed. -/
theorem integrated_source_eq_mass_defect
    (h : IsRectangleBalanceLawSolution q flux production) (a b s t : ℝ) :
    (∫ τ in s..t, ∫ x in a..b, production x τ) =
      ((∫ x in a..b, q x t) - (∫ x in a..b, q x s)) -
        ∫ τ in s..t, flux (q a τ) - flux (q b τ) := by
  rw [h.2.2.2.2 a b s t]
  abel

theorem rectangle_conservation_iff_source_integral_zero
    (h : IsRectangleBalanceLawSolution q flux production) (a b s t : ℝ) :
    ((∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      ∫ τ in s..t, flux (q a τ) - flux (q b τ)) ↔
        (∫ τ in s..t, ∫ x in a..b, production x τ) = 0 := by
  rw [h.2.2.2.2 a b s t, add_eq_left]

/-- Homogeneous conservation is exactly zero net production on every rectangle,
provided the supplied fields satisfy the actual balance law. -/
theorem conservation_iff_source_integrals_zero
    (h : IsRectangleBalanceLawSolution q flux production) :
    IsRectangleConservationLawSolution q flux ↔
      ∀ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) = 0 := by
  constructor
  · intro hc a b s t
    exact (h.rectangle_conservation_iff_source_integral_zero a b s t).mp (hc.2.2 a b s t)
  · intro hz
    exact ⟨h.1, h.2.1, fun a b s t =>
      (h.rectangle_conservation_iff_source_integral_zero a b s t).mpr (hz a b s t)⟩

/-- Failure of homogeneous conservation forces an actual nonzero rectangle
source integral, rather than only a source value at an isolated point. -/
theorem not_conservation_iff_exists_nonzero_source_integral
    (h : IsRectangleBalanceLawSolution q flux production) :
    ¬ IsRectangleConservationLawSolution q flux ↔
      ∃ a b s t, (∫ τ in s..t, ∫ x in a..b, production x τ) ≠ 0 := by
  rw [h.conservation_iff_source_integrals_zero]
  push_neg
  rfl

/-- Every source field realizing these same mass and flux fields has the same
integrated contribution on each rectangle; no pointwise uniqueness is claimed. -/
theorem integrated_source_unique {other : ℝ → ℝ → E}
    (h : IsRectangleBalanceLawSolution q flux production)
    (hother : IsRectangleBalanceLawSolution q flux other) (a b s t : ℝ) :
    (∫ τ in s..t, ∫ x in a..b, production x τ) =
      ∫ τ in s..t, ∫ x in a..b, other x τ := by
  rw [h.integrated_source_eq_mass_defect, hother.integrated_source_eq_mass_defect]

end IsRectangleBalanceLawSolution

theorem zero_source_iff_conservation (q : ℝ → ℝ → E) (flux : E → E) :
    IsRectangleBalanceLawSolution q flux (fun _ _ => 0) ↔
      IsRectangleConservationLawSolution q flux := by
  constructor
  · intro h
    exact h.conservation_iff_source_integrals_zero.mpr (by simp)
  · rintro ⟨hq, hf, hb⟩
    refine ⟨hq, hf, ?_, ?_, ?_⟩
    · intros
      exact intervalIntegrable_const
    · intros
      simp only [intervalIntegral.integral_zero]
      exact intervalIntegrable_const
    · simpa using hb

/-- The a.e. mass-rate statement follows from the integral balance. Its null
exceptional set can depend on the fixed spatial interval. -/
theorem IsRectangleBalanceLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ} {production : ℝ → ℝ → ι → ℝ}
    (h : IsRectangleBalanceLawSolution q flux production) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t) + ∫ x in a..b, production x t) t := by
  have hint (s t : ℝ) : IntervalIntegrable
      (fun r => flux (q a r) - flux (q b r) + ∫ x in a..b, production x r)
      volume s t :=
    ((h.2.1 a s t).sub (h.2.1 b s t)).add (h.2.2.2.1 a b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hint] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s,
        flux (q a r) - flux (q b r) + ∫ x in a..b, production x r) +
          ∫ x in a..b, q x 0) := by
    funext s
    rw [intervalIntegral.integral_add
      ((h.2.1 a 0 s).sub (h.2.1 b 0 s)) (h.2.2.2.1 a b 0 s)]
    exact sub_eq_iff_eq_add.mp (h.2.2.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

section Examples

variable [CompleteSpace E]

/-- Arbitrary locally integrable profiles can grow or deplete at any real rate
with zero transport. The construction does not require spatial smoothness. -/
theorem linear_amplitude_balance (profile : ℝ → E)
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
theorem linear_amplitude_mass_derivative (profile : ℝ → E) (rate a b t : ℝ) :
    HasDerivAt (fun τ => ∫ x in a..b, (rate * τ) • profile x)
      (rate • ∫ x in a..b, profile x) t := by
  simpa only [intervalIntegral.integral_smul, mul_one] using
    ((hasDerivAt_id t).const_mul rate).smul_const (∫ x in a..b, profile x)

end Examples

/-- The same constructed source has the existing conservative differential
meaning wherever that relation is used. A spatial state derivative is not
needed here, since the flux is the actual constant zero function. -/
theorem linear_amplitude_classical_balance {m : ℕ}
    (profile : ℝ → Fin m → ℝ) (rate x t : ℝ) :
    IsBalanceLawSolutionAt (fun ξ τ => (rate * τ) • profile ξ)
      (fun _ => 0) (rate • profile x) x t := by
  refine ⟨rate • profile x, 0, ?_, hasDerivAt_const x 0, by simp⟩
  simpa only [mul_one] using ((hasDerivAt_id t).const_mul rate).smul_const (profile x)

noncomputable def stationaryStep : ℝ → ℝ := riemannData 0 0 1

theorem stationaryStep_integrable (a b : ℝ) :
    IntervalIntegrable stationaryStep volume a b :=
  riemannData_intervalIntegrable 0 0 1 a b

theorem stationaryStep_unitCell : (∫ x in (1 : ℝ)..2, stationaryStep x) = 1 := by
  have heq : (∫ x in (1 : ℝ)..2, stationaryStep x) = ∫ _x in (1 : ℝ)..2, (1 : ℝ) := by
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
theorem stationaryStep_signed_source_integral (rate : ℝ) :
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, rate * stationaryStep x) = rate := by
  simp only [intervalIntegral.integral_const_mul, stationaryStep_unitCell, mul_one,
    intervalIntegral.integral_const, smul_eq_mul]
  ring

/-- A real, spatially discontinuous source-bearing solution with nonzero net
production in a genuine rectangle and ordinary continuous-time mass rates. -/
theorem stationaryStep_source_nonvacuity :
    IsRectangleBalanceLawSolution (fun x t => t * stationaryStep x) (fun _ => 0)
      (fun x _ => stationaryStep x) ∧
    ¬ ContinuousAt (fun x => (1 : ℝ) * stationaryStep x) 0 ∧
    (∀ a b t, HasDerivAt (fun τ => ∫ x in a..b, τ * stationaryStep x)
      (∫ x in a..b, stationaryStep x) t) ∧
    (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, stationaryStep x) = 1 ∧
    ¬ IsRectangleConservationLawSolution
      (fun x t => t * stationaryStep x) (fun _ => 0) := by
  have hb : IsRectangleBalanceLawSolution (fun x t => t * stationaryStep x)
      (fun _ => 0) (fun x _ => stationaryStep x) := by
    simpa using linear_amplitude_balance stationaryStep stationaryStep_integrable 1
  have hnonzero : (∫ _τ in (1 : ℝ)..2, ∫ x in (1 : ℝ)..2, stationaryStep x) = 1 := by
    rw [stationaryStep_unitCell]
    norm_num
    rfl
  refine ⟨hb, ?_, ?_, hnonzero, ?_⟩
  · simpa only [one_mul, stationaryStep] using
      (riemannData_isRiemannData (0 : ℝ) 0 1).not_continuousAt_zero zero_ne_one
  · intro a b t
    simpa using linear_amplitude_mass_derivative stationaryStep 1 a b t
  · exact hb.not_conservation_iff_exists_nonzero_source_integral.mpr
      ⟨1, 2, 1, 2, by rw [hnonzero]; exact one_ne_zero⟩

end NumStability.IntegralSourceDraft
