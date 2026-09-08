/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Topology.Constructions.SumProd
import Mathlib.Topology.Instances.Real.Lemmas

/-!
# Distinct one-sided traces on the real line

A jump records distinct left and right limits, independently of the value at the point.
Both component inequalities are retained when pairing two jumps.
-/

open Filter Set
open scoped Topology

namespace NumStability

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
/-- Pairing one-sided traces preserves both component jumps, not only pair inequality. -/
theorem hasJumpAt_and_iff_product_traces {Material State : Type*}
    [TopologicalSpace Material] [TopologicalSpace State]
    (medium : ℝ → Material) (initialState : ℝ → State) (a : ℝ)
    (leftMaterial rightMaterial : Material) (leftState rightState : State) :
    (HasJumpAt medium a leftMaterial rightMaterial ∧
      HasJumpAt initialState a leftState rightState) ↔
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

end NumStability
