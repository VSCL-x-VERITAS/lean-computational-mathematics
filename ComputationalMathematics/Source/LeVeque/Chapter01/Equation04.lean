/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# LeVeque Chapter 1, Equation (1.4)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equation (1.4).
-/

namespace NumStability

/-- Equation (1.4): the one-way wave equation `w_t + c w_x = 0` at `(x, t)`.

The source's right-going interpretation assumes `0 < c`; that assumption is
made explicit by the theorem below rather than built into the residual.
-/
abbrev leveque01_equation04_oneWayWaveAt
    (w : ℝ → ℝ → ℝ) (c x t : ℝ) : Prop :=
  IsLinearAdvectionSolutionAt w c x t

/-- A positive-speed translated profile moves to larger spatial coordinates
at every positive time while retaining its value. -/
theorem leveque01_equation04_profileMovesRight
    (profile : ℝ → ℝ) (c x t : ℝ) (hc : 0 < c) (ht : 0 < t) :
    x < x + c * t ∧ travelingWave profile c (x + c * t) t = profile x := by
  constructor
  · exact lt_add_of_pos_right x (mul_pos hc ht)
  · exact travelingWave_at_translated_point profile c x t

/-- A differentiable translated profile solves equation (1.4). With the
source assumption `0 < c`, the profile value initially at `x` moves to the
strictly larger coordinate `x + c t` at every positive time. -/
theorem leveque01_equation04_positiveSpeedOneWayWave
    {profile : ℝ → ℝ} {profile' : ℝ} (c x t : ℝ)
    (hc : 0 < c) (ht : 0 < t)
    (hprofile : HasDerivAt profile profile' (x - c * t)) :
    leveque01_equation04_oneWayWaveAt
        (travelingWave profile c) c x t ∧
      x < x + c * t ∧
        travelingWave profile c (x + c * t) t = profile x := by
  constructor
  · exact travelingWave_isLinearAdvectionSolutionAt c x t hprofile
  · exact leveque01_equation04_profileMovesRight profile c x t hc ht

end NumStability
