/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation04
import ComputationalMathematics.Source.LeVeque.Chapter01.ScalarHyperbolicity

/-!
# LeVeque Chapter 1, Equation (1.4): equation-level model

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equation (1.4) and its one-way-wave
interpretation.
-/

namespace NumStability

/-- Equation (1.4) at the source's equation-level scope. For every positive
speed, its scalar coefficient matrix is hyperbolic; increasing time moves the
characteristic coordinate strictly to the right; and every differentiable
translated profile solves the equation at every time while preserving its
shape. The later acoustics-mode theorem instantiates the abstract scalar
variable with the pressure/velocity combination supplied by the source. -/
theorem leveque01_equation04_scalarHyperbolicOneWayModel
    (c : ℝ) (hc : 0 < c) :
    leveque01IsHyperbolicMatrix (constantCoefficientScalarMatrix c) ∧
      (∀ x t₁ t₂ : ℝ, t₁ < t₂ → x + c * t₁ < x + c * t₂) ∧
      ∀ {profile : ℝ → ℝ} {profile' : ℝ} (x t : ℝ),
        HasDerivAt profile profile' (x - c * t) →
          leveque01_equation04_oneWayWaveAt
              (travelingWave profile c) c x t ∧
            travelingWave profile c (x + c * t) t = profile x := by
  refine ⟨leveque01_scalarEquation_isHyperbolic c, ?_, ?_⟩
  · intro x t₁ t₂ ht
    simpa [add_comm] using add_lt_add_left (mul_lt_mul_of_pos_left ht hc) x
  · intro profile profile' x t hprofile
    exact ⟨travelingWave_isLinearAdvectionSolutionAt c x t hprofile,
      travelingWave_at_translated_point profile c x t⟩

end NumStability
