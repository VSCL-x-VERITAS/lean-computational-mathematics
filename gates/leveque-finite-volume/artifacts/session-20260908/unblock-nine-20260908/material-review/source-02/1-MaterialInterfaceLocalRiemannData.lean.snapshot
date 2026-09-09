/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataJump

/-!
# LeVeque Chapter 1, local material interfaces with Riemann initial data

The selected sentence on printed page 8 (raw PDF page 30) includes a material
discontinuity and an initial-state discontinuity at zero. The coordinator selects
local distinct material traces, retaining constant strict-half-line initial
states. The source does not explicitly decide whether the material must be
globally constant on each half-line. No wave dynamics are asserted here.
-/

open Filter Set
open scoped Topology

namespace NumStability

/-- The local-material interpretation gives both actual component jumps, with
separate side inequalities. Initial data retains its free origin value, while
the material need not be constant away from the interface. -/
theorem leveque01_materialInterfaceLocalRiemannData {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    [T2Space Material] [T2Space State]
    {medium : ℝ → Material} {initialState : ℝ → State}
    {leftMaterial rightMaterial : Material} {leftState rightState : State}
    (hmedium : HasJumpAt medium 0 leftMaterial rightMaterial)
    (hstate : IsRiemannData initialState leftState rightState)
    (hdistinct : leftState ≠ rightState) :
    (HasJumpAt medium 0 leftMaterial rightMaterial ∧
      HasJumpAt initialState 0 leftState rightState) ∧
    (Tendsto (fun x => (medium x, initialState x)) (𝓝[<] 0)
        (𝓝 (leftMaterial, leftState)) ∧
      Tendsto (fun x => (medium x, initialState x)) (𝓝[>] 0)
        (𝓝 (rightMaterial, rightState)) ∧
      leftMaterial ≠ rightMaterial ∧ leftState ≠ rightState) ∧
    IsRiemannData initialState leftState rightState ∧
    ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt initialState 0 ∧
    (∃ originState, initialState = riemannData leftState originState rightState) := by
  have hjump := hstate.hasJumpAt hdistinct
  exact ⟨⟨hmedium, hjump⟩,
    (hasJumpAt_and_iff_product_traces _ _ _ _ _ _ _).mp ⟨hmedium, hjump⟩,
    hstate, hmedium.not_continuousAt, hjump.not_continuousAt,
    (isRiemannData_iff_exists_valueAtOrigin _ _ _).mp hstate⟩

end NumStability
