/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic
import Mathlib.Order.Interval.Set.Defs
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith

/-!
# Upwind Foot Geometry

The principal theorem `backtracked_foot_mem_adjacent_segment_iff` gives
the exact real-line interval equivalence. This module is reusable geometry.

Generic real-line geometry relating a backtracked foot to its normalized
weight. The equivalence assumes positive cell width and the stated equality
between weight and displacement; it makes no PDE or numerical-source claim.
-/

namespace NumStability
/-- The unit-CFL range places the backtracked foot in the closed segment from
the left grid point to the current grid point. -/
private theorem backtracked_foot_mem_adjacent_segment
    (x dx velocity dt weight : ℝ) (hdx : 0 < dx)
    (hweight : weight = velocity * dt / dx)
    (hunit : 0 ≤ weight ∧ weight ≤ 1) :
    x - velocity * dt ∈ Set.Icc (x - dx) x := by
  have hmul : weight * dx = velocity * dt := by
    rw [hweight]
    field_simp [ne_of_gt hdx]
  have hprod0 : 0 ≤ weight * dx := mul_nonneg hunit.1 hdx.le
  have hprod1 : weight * dx ≤ dx :=
    by simpa only [one_mul] using mul_le_mul_of_nonneg_right hunit.2 hdx.le
  rw [Set.mem_Icc]
  constructor
  · rw [← hmul]
    nlinarith
  · rw [← hmul]
    nlinarith

/-- Exact equivalence between geometric foot containment and unit interval
weight, for the weight tied to this exact time increment and positive width. -/
theorem backtracked_foot_mem_adjacent_segment_iff
    (x_i dx speed t_n t_next weight : ℝ) (hdx : 0 < dx)
    (hweight : weight = speed * (t_next - t_n) / dx) :
    x_i - speed * (t_next - t_n) ∈ Set.Icc (x_i - dx) x_i ↔
      0 ≤ weight ∧ weight ≤ 1 := by
  constructor
  · intro hmem
    rw [Set.mem_Icc] at hmem
    have hnum0 : 0 ≤ speed * (t_next - t_n) := by nlinarith [hmem.2]
    have hnumle : speed * (t_next - t_n) ≤ dx := by nlinarith [hmem.1]
    constructor
    · rw [hweight]
      exact div_nonneg hnum0 hdx.le
    · rw [hweight]
      exact (div_le_one hdx).2 hnumle
  · intro hunit
    exact backtracked_foot_mem_adjacent_segment x_i dx speed (t_next - t_n)
      weight hdx hweight hunit

end NumStability
