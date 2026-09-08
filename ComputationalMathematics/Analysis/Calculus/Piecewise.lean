/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Topology.Order.OrderClosed
import Mathlib.Tactic

/-!
# Calculus for real piecewise functions

One-sided derivatives at thresholds and matching derivative germs support
calculus for continuous piecewise formulas.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section

/-- Glue a right derivative at a threshold, choosing the upper branch at the threshold. -/
theorem hasDerivWithinAt_if_lt_right {f g : ℝ → ℝ} {c x df dg : ℝ}
    (hf : x < c → HasDerivWithinAt f df (Ioi x) x)
    (hg : c ≤ x → HasDerivWithinAt g dg (Ioi x) x) :
    HasDerivWithinAt (fun y => if y < c then f y else g y)
      (if x < c then df else dg) (Ioi x) x := by
  by_cases hx : x < c
  · simp only [if_pos hx]
    apply (hf hx).congr_of_eventuallyEq
    · filter_upwards [(eventually_lt_nhds hx).filter_mono inf_le_left] with y hy
      simp only [if_pos hy]
    · simp only [if_pos hx]
  · simp only [if_neg hx]
    apply (hg (le_of_not_gt hx)).congr
    · intro y hy
      have hh : ¬ y < c := by linarith [mem_Ioi.mp hy]
      simp only [if_neg hh]
    · simp only [if_neg hx]

/-- Two differentiable formulas with matching values and derivatives can be glued
over any predicate at the point. -/
theorem hasDerivAt_if_of_eq {f g : ℝ → ℝ} (p : ℝ → Prop) [DecidablePred p]
    {x d : ℝ} (hf : HasDerivAt f d x) (hg : HasDerivAt g d x) (heq : f x = g x) :
    HasDerivAt (fun y => if p y then f y else g y) d x := by
  have h₁ : HasDerivWithinAt (fun y => if p y then f y else g y) d {y | p y} x := by
    apply hf.hasDerivWithinAt.congr
    · intro y hy
      simp only [mem_setOf_eq] at hy
      simp only [if_pos hy]
    · split_ifs <;> simp [heq]
  have h₂ : HasDerivWithinAt (fun y => if p y then f y else g y) d {y | p y}ᶜ x := by
    apply hg.hasDerivWithinAt.congr
    · intro y hy
      simp only [mem_compl_iff, mem_setOf_eq] at hy
      simp only [if_neg hy]
    · split_ifs <;> simp [heq]
  exact hasDerivWithinAt_univ.mp (by simpa only [union_compl_self] using h₁.union h₂)

theorem continuous_if_lt_of_closed {f g : ℝ → ℝ} {c : ℝ}
    (hf : ContinuousOn f (Iic c)) (hg : ContinuousOn g (Ici c)) (heq : f c = g c) :
    Continuous (fun y => if y < c then f y else g y) := by
  have hh : Continuous (fun y => if c ≤ y then g y else f y) :=
    continuous_if_le continuous_const continuous_id hg hf (fun y hy => by simpa [← hy] using heq.symm)
  convert hh using 1
  funext y
  by_cases hy : y < c
  · simp only [if_pos hy, if_neg (not_le.mpr hy)]
  · simp only [if_neg hy, if_pos (le_of_not_gt hy)]


end

end NumStability
