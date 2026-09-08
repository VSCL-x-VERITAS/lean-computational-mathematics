/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataJump
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Local interfaces without global material constancy

These examples distinguish two component jumps from a single product jump.
They impose no material law or wave dynamics.
-/

open Filter Set
open scoped Topology

namespace NumStability.LocalMaterialInterface

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
    (HasJumpAt (varyingMedium originMaterial) 0 0 1 ∧
      HasJumpAt (riemannData (2 : ℝ) originState 3) 0 2 3) ∧
      IsRiemannData (riemannData (2 : ℝ) originState 3) 2 3 ∧
      ¬ ContinuousAt (varyingMedium originMaterial) 0 ∧
      ¬ ContinuousAt (riemannData (2 : ℝ) originState 3) 0 ∧
      (¬ ∃ left right, IsRiemannData (varyingMedium originMaterial) left right) ∧
      varyingMedium originMaterial 0 = originMaterial ∧
      riemannData (2 : ℝ) originState 3 0 = originState := by
  have hm := varyingMedium_hasJumpAt originMaterial
  have hq := riemannData_isRiemannData (2 : ℝ) originState 3
  have hj := hq.hasJumpAt (by norm_num)
  exact ⟨⟨hm, hj⟩, hq, hm.not_continuousAt, hj.not_continuousAt,
    varyingMedium_not_isRiemannData originMaterial,
    by simp [varyingMedium], by simp⟩
/-- A jump of the pair alone cannot certify that both components jump. -/
theorem product_jump_with_constant_medium (originState : ℝ) :
    HasJumpAt (fun x => ((0 : ℝ), riemannData (0 : ℝ) originState 1 x))
        0 (0, 0) (0, 1) ∧
      ¬ (HasJumpAt (fun _ => (0 : ℝ)) 0 0 0 ∧
        HasJumpAt (riemannData (0 : ℝ) originState 1) 0 0 1) := by
  have h := riemannData_isRiemannData (0 : ℝ) originState 1
  refine ⟨⟨tendsto_const_nhds.prodMk_nhds h.tendsto_left,
    tendsto_const_nhds.prodMk_nhds h.tendsto_right, ?_⟩, ?_⟩
  · intro heq
    have := congrArg Prod.snd heq
    norm_num at this
  · intro hi
    exact hi.1.2.2 rfl

end NumStability.LocalMaterialInterface
