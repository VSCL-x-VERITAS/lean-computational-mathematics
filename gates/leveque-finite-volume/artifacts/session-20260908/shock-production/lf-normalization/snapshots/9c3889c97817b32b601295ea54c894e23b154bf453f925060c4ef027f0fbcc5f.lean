/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Basic
import ComputationalMathematics.Analysis.Calculus.Piecewise
import ComputationalMathematics.Analysis.Calculus.Deriv.Abs

/-!
# Temporal calculus for the Huber shock potential

The continuous potential has right time derivative equal to minus the actual
composed flux, including collapse and stationary-interface values.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem centralPotential_space_deriv (x t : ℝ) :
    HasDerivAt (fun y => centralPotential y t) (-x / (1 - t)) x := by
  convert (((hasDerivAt_id x).pow 2).neg.div_const 2).div_const (1 - t) using 1
  norm_num [id_eq]
  ring

theorem centralPotential_time_deriv {x t : ℝ} (ht : t < 1) :
    HasDerivAt (centralPotential x) (-((-x / (1 - t)) ^ 2 / 2)) t := by
  have hr : 1 - t ≠ 0 := by linarith
  convert (hasDerivAt_const t (-x ^ 2 / 2)).div
    ((hasDerivAt_const t (1 : ℝ)).sub (hasDerivAt_id t)) hr using 1
  dsimp
  field_simp
  ring

theorem outerPotential_time_deriv (x t : ℝ) :
    HasDerivAt (outerPotential x) (-|x| + 1 / 2 - t) t := by
  convert ((((hasDerivAt_const t (-x ^ 2 / 2)).sub ((hasDerivAt_id t).mul_const |x|)).add
    ((hasDerivAt_id t).div_const 2)).sub (((hasDerivAt_id t).pow 2).div_const 2)) using 1
  norm_num [id_eq]

theorem outerPotential_space_right_deriv (x t : ℝ) :
    HasDerivWithinAt (fun y => outerPotential y t) (outerState x t) (Ioi x) x := by
  have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).hasDerivWithinAt.sub
    ((hasDerivWithinAt_abs_right x).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
  convert hh using 1
  simp only [outerState]
  split_ifs <;> norm_num [id_eq] <;> ring

theorem outerPotential_space_deriv {x : ℝ} (hx : x ≠ 0) (t : ℝ) :
    HasDerivAt (fun y => outerPotential y t) (outerState x t) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).sub
      ((hasDerivAt_abs_neg hneg).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
    convert hh using 1
    norm_num [outerState, hneg, id_eq]
    ring
  · have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).sub
      ((hasDerivAt_abs_pos hpos).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
    convert hh using 1
    norm_num [outerState, not_lt.mpr hpos.le, id_eq]
    ring

theorem centralPotential_time_continuousOn (x : ℝ) :
    ContinuousOn (centralPotential x) (Iic (1 - |x|)) := by
  by_cases hx : x = 0
  · subst x
    unfold centralPotential
    simpa [centralPotential] using
      (continuousOn_const : ContinuousOn (fun _ : ℝ => (0 : ℝ)) (Iic (1 - |(0 : ℝ)|)))
  apply ContinuousOn.div continuousOn_const (continuous_const.sub continuous_id).continuousOn
  intro t ht
  have ha : 0 < |x| := abs_pos.mpr hx
  change t ≤ 1 - |x| at ht
  change 1 - t ≠ 0
  linarith

theorem shockPotential_time_continuous (x : ℝ) : Continuous (shockPotential x) := by
  apply continuous_if_lt_of_closed (centralPotential_time_continuousOn x)
  · exact (by unfold outerPotential; fun_prop : Continuous (outerPotential x)).continuousOn
  · exact potential_match rfl

theorem shockPotential_time_right_deriv (x t : ℝ) :
    HasDerivWithinAt (shockPotential x) (-huberFlux (shockState x t)) (Ioi t) t := by
  have hh : HasDerivWithinAt (shockPotential x)
      (if t < 1 - |x| then -((-x / (1 - t)) ^ 2 / 2) else -|x| + 1 / 2 - t) (Ioi t) t := by
    apply hasDerivWithinAt_if_lt_right
    · intro ht
      exact (centralPotential_time_deriv (by linarith [abs_nonneg x])).hasDerivWithinAt
    · intro _
      exact (outerPotential_time_deriv x t).hasDerivWithinAt
  apply hh.congr_deriv
  by_cases ht : t < 1 - |x|
  · simp only [if_pos ht, shockState, central_flux ht]
  · simp only [if_neg ht, shockState, outer_flux (le_of_not_gt ht)]
    ring


end

end NumStability.HuberShock
