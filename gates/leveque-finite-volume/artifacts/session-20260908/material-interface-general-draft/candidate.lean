/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataRegularity
import Mathlib.Topology.Constructions.SumProd

/-!
# Draft: distinct material and state traces at an interface

Generic foundations only. The final specialization retains globally constant
initial Riemann states, but imposes only one-sided limits on the medium.
This file does not settle whether the selected source prescribes globally
constant material parameters, and does not assert wave dynamics.
-/

open Filter Set
open scoped Topology

namespace NumStability.MaterialInterfaceDraft

/-- A jump has existing, distinct left and right traces. The point value is free. -/
def HasJumpAt {E : Type*} [TopologicalSpace E]
    (data : ℝ → E) (a : ℝ) (left right : E) : Prop :=
  Tendsto data (𝓝[<] a) (𝓝 left) ∧
    Tendsto data (𝓝[>] a) (𝓝 right) ∧ left ≠ right

theorem HasJumpAt.not_continuousAt {E : Type*} [TopologicalSpace E] [T2Space E]
    {data : ℝ → E} {a : ℝ} {left right : E}
    (h : HasJumpAt data a left right) : ¬ ContinuousAt data a := by
  intro hc
  have hl := tendsto_nhds_unique h.1 hc.continuousWithinAt.tendsto
  have hr := tendsto_nhds_unique h.2.1 hc.continuousWithinAt.tendsto
  exact h.2.2 (hl.trans hr.symm)

/-- Only the two punctured one-sided germs matter. -/
theorem HasJumpAt.congr {E : Type*} [TopologicalSpace E]
    {data other : ℝ → E} {a : ℝ} {left right : E}
    (h : HasJumpAt data a left right)
    (hl : data =ᶠ[𝓝[<] a] other) (hr : data =ᶠ[𝓝[>] a] other) :
    HasJumpAt other a left right :=
  ⟨h.1.congr' hl, h.2.1.congr' hr, h.2.2⟩

theorem hasJumpAt_of_isRiemannData {E : Type*} [TopologicalSpace E]
    {data : ℝ → E} {left right : E}
    (h : IsRiemannData data left right) (hne : left ≠ right) :
    HasJumpAt data 0 left right :=
  ⟨h.tendsto_left, h.tendsto_right, hne⟩

/-- Both components jump at the same point; pair inequality alone would allow
one component to remain constant. -/
def HasMaterialStateInterfaceAt {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    (medium : ℝ → Material) (initialState : ℝ → State) (a : ℝ)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) : Prop :=
  HasJumpAt medium a leftMaterial rightMaterial ∧
    HasJumpAt initialState a leftState rightState

theorem materialStateInterface_iff_product_traces {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    (medium : ℝ → Material) (initialState : ℝ → State) (a : ℝ)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    HasMaterialStateInterfaceAt medium initialState a
        leftMaterial rightMaterial leftState rightState ↔
      Tendsto (fun x => (medium x, initialState x)) (𝓝[<] a)
        (𝓝 (leftMaterial, leftState)) ∧
      Tendsto (fun x => (medium x, initialState x)) (𝓝[>] a)
        (𝓝 (rightMaterial, rightState)) ∧
      leftMaterial ≠ rightMaterial ∧ leftState ≠ rightState := by
  constructor
  · rintro ⟨hm, hq⟩
    exact ⟨hm.1.prodMk_nhds hq.1, hm.2.1.prodMk_nhds hq.2.1, hm.2.2, hq.2.2⟩
  · rintro ⟨hl, hr, hm, hq⟩
    exact ⟨⟨hl.fst_nhds, hr.fst_nhds, hm⟩, ⟨hl.snd_nhds, hr.snd_nhds, hq⟩⟩

theorem HasMaterialStateInterfaceAt.discontinuous {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    [T2Space Material] [T2Space State]
    {medium : ℝ → Material} {initialState : ℝ → State} {a : ℝ}
    {leftMaterial rightMaterial : Material} {leftState rightState : State}
    (h : HasMaterialStateInterfaceAt medium initialState a
      leftMaterial rightMaterial leftState rightState) :
    ¬ ContinuousAt medium a ∧ ¬ ContinuousAt initialState a :=
  ⟨h.1.not_continuousAt, h.2.not_continuousAt⟩

/-- Conditional source-contract draft: initial states retain Eq. (1.11)'s
global half-line values; the material has distinct traces at zero.
No full source-faithfulness assertion is made by this draft. -/
theorem materialInterface_of_local_medium_and_riemann_state
    {Material State : Type*} [TopologicalSpace Material] [TopologicalSpace State]
    [T2Space Material] [T2Space State]
    {medium : ℝ → Material} {initialState : ℝ → State}
    {leftMaterial rightMaterial : Material} {leftState rightState : State}
    (hmLeft : Tendsto medium (𝓝[<] 0) (𝓝 leftMaterial))
    (hmRight : Tendsto medium (𝓝[>] 0) (𝓝 rightMaterial))
    (hmNe : leftMaterial ≠ rightMaterial)
    (hq : IsRiemannData initialState leftState rightState)
    (hqNe : leftState ≠ rightState) :
    HasMaterialStateInterfaceAt medium initialState 0
        leftMaterial rightMaterial leftState rightState ∧
      IsRiemannData initialState leftState rightState ∧
      ¬ ContinuousAt medium 0 ∧ ¬ ContinuousAt initialState 0 := by
  have h : HasMaterialStateInterfaceAt medium initialState 0
      leftMaterial rightMaterial leftState rightState :=
    ⟨⟨hmLeft, hmRight, hmNe⟩, hasJumpAt_of_isRiemannData hq hqNe⟩
  exact ⟨h, hq, h.discontinuous⟩

/-- A nontrivial globally constant-side specialization with free origin values. -/
theorem riemann_pair_hasMaterialStateInterface
    {Material State : Type*} [TopologicalSpace Material] [TopologicalSpace State]
    (leftMaterial originMaterial rightMaterial : Material)
    (leftState originState rightState : State)
    (hm : leftMaterial ≠ rightMaterial) (hq : leftState ≠ rightState) :
    HasMaterialStateInterfaceAt
      (riemannData leftMaterial originMaterial rightMaterial)
      (riemannData leftState originState rightState) 0
      leftMaterial rightMaterial leftState rightState :=
  ⟨hasJumpAt_of_isRiemannData (riemannData_isRiemannData _ _ _) hm,
    hasJumpAt_of_isRiemannData (riemannData_isRiemannData _ _ _) hq⟩

/-- A varying medium, not a source-imposed material law. -/
noncomputable def varyingMedium (origin : ℝ) (x : ℝ) : ℝ :=
  riemannData 0 origin 1 x + x

theorem varyingMedium_hasJumpAt (origin : ℝ) :
    HasJumpAt (varyingMedium origin) 0 0 1 := by
  have h := riemannData_isRiemannData (0 : ℝ) origin 1
  have hl : Tendsto (fun x : ℝ => x) (𝓝[<] 0) (𝓝 0) :=
    continuousAt_id.continuousWithinAt.tendsto
  have hr : Tendsto (fun x : ℝ => x) (𝓝[>] 0) (𝓝 0) :=
    continuousAt_id.continuousWithinAt.tendsto
  refine ⟨?_, ?_, zero_ne_one⟩
  · simpa only [varyingMedium, add_zero] using h.tendsto_left.add hl
  · simpa only [varyingMedium, add_zero] using h.tendsto_right.add hr

/-- The broader material model does not secretly impose constant half-lines. -/
theorem varyingMedium_not_isRiemannData (origin : ℝ) :
    ¬ ∃ left right : ℝ, IsRiemannData (varyingMedium origin) left right := by
  rintro ⟨left, right, hl, hr⟩
  have h1 := hl (-1) (by norm_num)
  have h2 := hl (-2) (by norm_num)
  norm_num [varyingMedium, riemannData] at h1 h2
  linarith

/-- Substantive instance with both jumps, a nonconstant medium, Riemann initial
states, and independently free values at the interface. -/
theorem varyingMedium_interface_witness (originMaterial originState : ℝ) :
    HasMaterialStateInterfaceAt (varyingMedium originMaterial)
        (riemannData (2 : ℝ) originState 3) 0 0 1 2 3 ∧
      IsRiemannData (riemannData (2 : ℝ) originState 3) 2 3 ∧
      ¬ ContinuousAt (varyingMedium originMaterial) 0 ∧
      ¬ ContinuousAt (riemannData (2 : ℝ) originState 3) 0 ∧
      (¬ ∃ left right, IsRiemannData (varyingMedium originMaterial) left right) ∧
      varyingMedium originMaterial 0 = originMaterial ∧
      riemannData (2 : ℝ) originState 3 0 = originState := by
  have hm := varyingMedium_hasJumpAt originMaterial
  have h := materialInterface_of_local_medium_and_riemann_state hm.1 hm.2.1 hm.2.2
    (riemannData_isRiemannData (2 : ℝ) originState 3) (by norm_num)
  exact ⟨h.1, h.2.1, h.2.2.1, h.2.2.2,
    varyingMedium_not_isRiemannData originMaterial,
    by simp [varyingMedium], by simp⟩

/-- A jump of the pair alone cannot certify that both components jump. -/
theorem product_jump_with_constant_medium (originState : ℝ) :
    HasJumpAt (fun x => ((0 : ℝ), riemannData (0 : ℝ) originState 1 x))
        0 (0, 0) (0, 1) ∧
      ¬ HasMaterialStateInterfaceAt (fun _ => (0 : ℝ))
        (riemannData (0 : ℝ) originState 1) 0 0 0 0 1 := by
  have h := riemannData_isRiemannData (0 : ℝ) originState 1
  refine ⟨⟨tendsto_const_nhds.prodMk_nhds h.tendsto_left,
    tendsto_const_nhds.prodMk_nhds h.tendsto_right, ?_⟩, ?_⟩
  · intro heq
    have := congrArg Prod.snd heq
    norm_num at this
  · intro hi
    exact hi.1.2.2 rfl

end NumStability.MaterialInterfaceDraft
