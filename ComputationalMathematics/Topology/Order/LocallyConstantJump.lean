/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Topology.Order.Jump
import Mathlib.Topology.Order.LeftRight

/-!
# One-sided traces from local constant values

Constant values on open intervals adjacent to a point determine its one-sided
traces. The value at the point is needed only for the continuity criterion.
-/

open Filter Set
open scoped Topology

namespace NumStability

/-- A constant value on an interval ending at a point is its left trace. -/
theorem tendsto_nhdsLT_of_eqOn_Ioo {E : Type*} [TopologicalSpace E]
    {data : ℝ → E} {a x : ℝ} {left : E}
    (ha : a < x) (hl : EqOn data (fun _ => left) (Ioo a x)) :
    Tendsto data (𝓝[<] x) (𝓝 left) := by
  apply tendsto_nhds_of_eventually_eq
  filter_upwards [Ioo_mem_nhdsLT ha] with y hy
  exact hl hy

/-- A constant value on an interval starting at a point is its right trace. -/
theorem tendsto_nhdsGT_of_eqOn_Ioo {E : Type*} [TopologicalSpace E]
    {data : ℝ → E} {x b : ℝ} {right : E}
    (hb : x < b) (hr : EqOn data (fun _ => right) (Ioo x b)) :
    Tendsto data (𝓝[>] x) (𝓝 right) := by
  apply tendsto_nhds_of_eventually_eq
  filter_upwards [Ioo_mem_nhdsGT hb] with y hy
  exact hr hy

/-- Distinct constant values on adjacent open intervals give a jump. -/
theorem hasJumpAt_of_eqOn_Ioo {E : Type*} [TopologicalSpace E]
    {data : ℝ → E} {a x b : ℝ} {left right : E}
    (ha : a < x) (hb : x < b)
    (hl : EqOn data (fun _ => left) (Ioo a x))
    (hr : EqOn data (fun _ => right) (Ioo x b)) (hne : left ≠ right) :
    HasJumpAt data x left right :=
  ⟨tendsto_nhdsLT_of_eqOn_Ioo ha hl, tendsto_nhdsGT_of_eqOn_Ioo hb hr, hne⟩

/-- For the left-value representative, continuity is equivalent to equal traces. -/
theorem continuousAt_iff_eq_of_eqOn_Ioo {E : Type*} [TopologicalSpace E] [T2Space E]
    {data : ℝ → E} {a x b : ℝ} {left right : E}
    (ha : a < x) (hb : x < b)
    (hl : EqOn data (fun _ => left) (Ioo a x))
    (hr : EqOn data (fun _ => right) (Ioo x b)) (hpoint : data x = left) :
    ContinuousAt data x ↔ left = right := by
  constructor
  · intro hc
    have hright := tendsto_nhds_unique (tendsto_nhdsGT_of_eqOn_Ioo hb hr)
      hc.continuousWithinAt.tendsto
    exact hpoint.symm.trans hright.symm
  · intro heq
    apply continuousAt_iff_continuous_left'_right'.2
    constructor
    · simpa only [ContinuousWithinAt, hpoint] using tendsto_nhdsLT_of_eqOn_Ioo ha hl
    · simpa only [ContinuousWithinAt, hpoint, heq] using tendsto_nhdsGT_of_eqOn_Ioo hb hr

end NumStability
