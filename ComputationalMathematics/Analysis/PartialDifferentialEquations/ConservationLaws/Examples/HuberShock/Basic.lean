/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.SpecialFunctions.Huber

/-!
# A scalar shock profile for the Huber flux

The central region contracts to the origin at time one. The initial field is
the smooth, unbounded function −x. The right trace is selected at the later shock.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

/-- The central primitive, with division interpreted in the ambient real field. -/
def centralPotential (x t : ℝ) : ℝ := (-x ^ 2 / 2) / (1 - t)

/-- The outer primitive, also used after the central interval collapses. -/
def outerPotential (x t : ℝ) : ℝ := -x ^ 2 / 2 - t * |x| + t / 2 - t ^ 2 / 2

/-- Right trace is selected at the stationary interface. -/
def outerState (x t : ℝ) : ℝ := if x < 0 then t - x else -t - x

/-- The potential of the shock profile: `centralPotential` on the contracting central region
`t < 1 - |x|` and `outerPotential` elsewhere. Its spatial derivative is `shockState` and its time
derivative is `-huberFlux (shockState x t)`; the two branches agree on the interface
(`potential_match`). -/
def shockPotential (x t : ℝ) : ℝ :=
  if t < 1 - |x| then centralPotential x t else outerPotential x t

/-- The scalar shock profile for the Huber flux: the compression wave `-x / (1 - t)` on the
central region `t < 1 - |x|`, whose characteristics focus at the origin at time one, and the
transported outer state `outerState` elsewhere. It starts from the smooth initial field `-x` and
develops a stationary jump at `x = 0` once `1 ≤ t`. -/
def shockState (x t : ℝ) : ℝ :=
  if t < 1 - |x| then -x / (1 - t) else outerState x t

theorem shockState_initial (x : ℝ) : shockState x 0 = -x := by
  simp only [shockState, outerState]
  split_ifs <;> simp

theorem shockState_initial_smooth : ContDiff ℝ ⊤ (fun x => shockState x 0) := by
  simp only [shockState_initial]
  exact contDiff_id.neg

theorem shockState_after {t : ℝ} (ht : 1 ≤ t) (x : ℝ) :
    shockState x t = outerState x t := by
  simp only [shockState, if_neg (show ¬ t < 1 - |x| by linarith [abs_nonneg x])]

theorem central_flux {x t : ℝ} (h : t < 1 - |x|) :
    huberFlux (-x / (1 - t)) = (-x / (1 - t)) ^ 2 / 2 := by
  apply huberFlux_of_abs_le
  have hr : 0 < 1 - t := by linarith [abs_nonneg x]
  rw [abs_div, abs_neg, abs_of_pos hr]
  exact (div_le_one hr).mpr (by linarith)

theorem outer_flux {x t : ℝ} (h : 1 - |x| ≤ t) :
    huberFlux (outerState x t) = t + |x| - 1 / 2 := by
  by_cases hx : x < 0
  · rw [outerState, if_pos hx, abs_of_neg hx] at *
    rw [huberFlux_of_ge (by linarith : 1 ≤ t - x)]
    ring
  · rw [outerState, if_neg hx, abs_of_nonneg (le_of_not_gt hx)] at *
    rw [huberFlux_of_le (by linarith : -t - x ≤ -1)]
    ring

/-- The primitive values match on the boundary of the central region. -/
theorem potential_match {x t : ℝ} (h : t = 1 - |x|) :
    centralPotential x t = outerPotential x t := by
  by_cases hx : x = 0
  · subst x
    simp only [abs_zero, sub_zero] at h
    subst t
    norm_num [centralPotential, outerPotential]
    rfl
  have ha : 0 < |x| := abs_pos.mpr hx
  have hr : 1 - t ≠ 0 := by linarith
  have hsq : |x| ^ 2 = x ^ 2 := sq_abs x
  dsimp [centralPotential, outerPotential]
  field_simp
  nlinarith [sq_nonneg (|x| - (1 - t))]

theorem central_outer_state_match {x t : ℝ} (ht : t < 1) (h : t = 1 - |x|) :
    -x / (1 - t) = outerState x t := by
  have hr : 1 - t ≠ 0 := by linarith
  by_cases hx : x < 0
  · have hrel : t = 1 + x := by simpa only [abs_of_neg hx, sub_neg_eq_add] using h
    have hc : -x / (1 - t) = 1 := (div_eq_one_iff_eq hr).mpr (by linarith)
    rw [hc, outerState, if_pos hx]
    linarith
  · have hrel : t = 1 - x := by simpa only [abs_of_nonneg (le_of_not_gt hx)] using h
    have hc : -x / (1 - t) = -1 := (div_eq_iff hr).mpr (by linarith)
    rw [hc, outerState, if_neg hx]
    linarith


end

end NumStability.HuberShock
