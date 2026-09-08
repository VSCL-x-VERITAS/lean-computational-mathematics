/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# One-sided limits and discontinuity of Riemann data

The left and right traces are independent of the selected value at the origin.
Distinct states preclude continuity there.
-/

open Filter Set
open scoped Topology

namespace NumStability

theorem IsRiemannData.tendsto_left {State : Type*} [TopologicalSpace State]
    {data : ℝ → State} {leftState rightState : State}
    (hdata : IsRiemannData data leftState rightState) :
    Tendsto data (𝓝[<] (0 : ℝ)) (𝓝 leftState) := by
  apply (tendsto_const_nhds :
    Tendsto (fun _ : ℝ => leftState) (𝓝[<] (0 : ℝ)) (𝓝 leftState)).congr'
  filter_upwards [self_mem_nhdsWithin] with x hx
  exact (hdata.1 x hx).symm

theorem IsRiemannData.tendsto_right {State : Type*} [TopologicalSpace State]
    {data : ℝ → State} {leftState rightState : State}
    (hdata : IsRiemannData data leftState rightState) :
    Tendsto data (𝓝[>] (0 : ℝ)) (𝓝 rightState) := by
  apply (tendsto_const_nhds :
    Tendsto (fun _ : ℝ => rightState) (𝓝[>] (0 : ℝ)) (𝓝 rightState)).congr'
  filter_upwards [self_mem_nhdsWithin] with x hx
  exact (hdata.2 x hx).symm

theorem IsRiemannData.not_continuousAt_zero {State : Type*}
    [TopologicalSpace State] [T2Space State]
    {data : ℝ → State} {leftState rightState : State}
    (hdata : IsRiemannData data leftState rightState) (hne : leftState ≠ rightState) :
    ¬ ContinuousAt data 0 := by
  intro hc
  have hl := tendsto_nhds_unique hdata.tendsto_left hc.continuousWithinAt.tendsto
  have hr := tendsto_nhds_unique hdata.tendsto_right hc.continuousWithinAt.tendsto
  exact hne (hl.trans hr.symm)

end NumStability
