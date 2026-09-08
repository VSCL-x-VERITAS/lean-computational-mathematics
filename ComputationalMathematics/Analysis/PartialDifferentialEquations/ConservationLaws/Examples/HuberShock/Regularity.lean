/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Potential

/-!
# Spatial regularity of the Huber shock

The state is continuous before collapse. The continuous potential has the
state as its right spatial derivative at every point and time.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.HuberShock

noncomputable section

theorem shockPotential_space_continuous (t : ℝ) :
    Continuous (fun x => shockPotential x t) := by
  apply Continuous.if
  · intro x hx
    exact potential_match (frontier_lt_subset_eq continuous_const
      (continuous_const.sub continuous_abs) hx)
  · unfold centralPotential
    fun_prop
  · unfold outerPotential
    fun_prop

theorem outerState_space_continuousAt {x : ℝ} (hx : x ≠ 0) (t : ℝ) :
    ContinuousAt (fun y => outerState y t) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hh : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
    apply hh.continuousAt.congr_of_eventuallyEq
    filter_upwards [eventually_lt_nhds hneg] with y hy
    simp only [outerState, if_pos hy]
  · have hh : Continuous (fun y : ℝ => -t - y) := continuous_const.sub continuous_id
    apply hh.continuousAt.congr_of_eventuallyEq
    filter_upwards [eventually_gt_nhds hpos] with y hy
    simp only [outerState, if_neg (not_lt.mpr hy.le)]

theorem shockState_continuous_before {t : ℝ} (ht : t < 1) :
    Continuous (fun x => shockState x t) := by
  apply continuous_if
  · intro x hx
    exact central_outer_state_match ht (frontier_lt_subset_eq continuous_const
      (continuous_const.sub continuous_abs) hx)
  · exact (by fun_prop : Continuous (fun x : ℝ => -x / (1 - t))).continuousOn
  · intro x hx
    have hclosed : IsClosed {y : ℝ | ¬t < 1 - |y|} := by
      simp only [not_lt]
      exact isClosed_le (continuous_const.sub continuous_abs) continuous_const
    have hout : ¬t < 1 - |x| := by simpa only [hclosed.closure_eq] using hx
    have hxne : x ≠ 0 := by intro hz; simp only [hz, abs_zero, sub_zero] at hout; linarith
    exact (outerState_space_continuousAt hxne t).continuousWithinAt

theorem shockPotential_space_right_deriv (x t : ℝ) :
    HasDerivWithinAt (fun y => shockPotential y t) (shockState x t) (Ioi x) x := by
  by_cases ht : 1 ≤ t
  · have hpot : (fun y => shockPotential y t) = fun y => outerPotential y t := by
      funext y
      simp only [shockPotential, if_neg (show ¬t < 1 - |y| by linarith [abs_nonneg y])]
    rw [hpot, shockState_after ht]
    exact outerPotential_space_right_deriv x t
  have ht' : t < 1 := lt_of_not_ge ht
  by_cases hc : t < 1 - |x|
  · simp only [shockState, if_pos hc]
    apply (centralPotential_space_deriv x t).hasDerivWithinAt.congr_of_eventuallyEq
    · have hopen : IsOpen {y : ℝ | t < 1 - |y|} :=
        isOpen_lt continuous_const (continuous_const.sub continuous_abs)
      have hev : ∀ᶠ y in 𝓝 x, t < 1 - |y| := hopen.mem_nhds hc
      filter_upwards [hev.filter_mono inf_le_left] with y hy
      simp only [shockPotential, if_pos hy]
    · simp only [shockPotential, if_pos hc]
  by_cases heq : t = 1 - |x|
  · have hx : x ≠ 0 := by intro hz; simp only [hz, abs_zero, sub_zero] at heq; linarith
    have hmatch := central_outer_state_match ht' heq
    have hg : HasDerivAt (fun y => outerPotential y t) (-x / (1 - t)) x :=
      (outerPotential_space_deriv hx t).congr_deriv hmatch.symm
    have hh := hasDerivAt_if_of_eq (fun y => t < 1 - |y|)
      (centralPotential_space_deriv x t) hg (potential_match heq)
    simp only [shockState, if_neg hc]
    exact hh.hasDerivWithinAt.congr_deriv hmatch
  · have hstrict : 1 - |x| < t := lt_of_le_of_ne (le_of_not_gt hc) (Ne.symm heq)
    simp only [shockState, if_neg hc]
    apply (outerPotential_space_right_deriv x t).congr_of_eventuallyEq
    · have hopen : IsOpen {y : ℝ | 1 - |y| < t} :=
        isOpen_lt (continuous_const.sub continuous_abs) continuous_const
      have hev : ∀ᶠ y in 𝓝 x, 1 - |y| < t := hopen.mem_nhds hstrict
      filter_upwards [hev.filter_mono inf_le_left] with y hy
      simp only [shockPotential, if_neg (not_lt.mpr (le_of_lt hy))]
    · simp only [shockPotential, if_neg hc]


end

end NumStability.HuberShock
