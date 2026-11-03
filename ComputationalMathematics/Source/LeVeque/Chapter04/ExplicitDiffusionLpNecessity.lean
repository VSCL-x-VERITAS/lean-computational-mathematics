/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionFullStabilityTarget
import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionStabilityBounds

/-!
# Coefficient bounds from actual standard-norm diffusion stability

A unit input in the cell immediately to the left of a face isolates the
corresponding coefficient in one actual update. The whole-line input belongs
to every standard `lp` space. On a finite grid both neighboring cells must be
active; arbitrary nonlinear exterior ghost rules then disappear from the
selected output difference. No stability of those boundary rules is asserted.
-/

namespace NumStability

open WithLp

noncomputable section

/-- Standard-norm stability through one step bounds every whole-line face
coefficient. The positive physical weight cancels for every exponent,
including infinity. -/
theorem explicitDiffusionLp_face_bound
    (p : ENNReal) [Fact (1 ≤ p)]
    {horizon bound timeStep width : ℝ} {diffusivity : ℤ → ℝ}
    (hw : 0 < width) (ht : timeStep ≤ horizon)
    (hs : IsExplicitDiffusionLpStableThrough p horizon bound timeStep width diffusivity)
    (i : ℤ) : |timeStep / width ^ 2 * diffusivity i| ≤ bound := by
  have hp : 0 < p := lt_of_lt_of_le zero_lt_one Fact.out
  let u : lp (fun _ : ℤ => ℝ) p := lp.single p (i - 1) 1
  obtain ⟨hm, hnorm⟩ := hs u 0 1 (by simpa using ht)
  let difference : ℤ → ℝ := fun k =>
    ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[1] (u : ℤ → ℝ)) k -
      ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[1]
        ((0 : lp (fun _ : ℤ => ℝ) p) : ℤ → ℝ)) k
  let v : lp (fun _ : ℤ => ℝ) p := ⟨difference, hm⟩
  have hwgt : 0 < explicitDiffusionPhysicalWeight p width :=
    Real.rpow_pos_of_pos hw _
  have hv : ‖v‖ ≤ bound := by
    have hu : ‖u - 0‖ = 1 := by simp [u, lp.norm_single hp]
    change explicitDiffusionPhysicalWeight p width * ‖v‖ ≤
      bound * (explicitDiffusionPhysicalWeight p width * ‖u - 0‖) at hnorm
    rw [hu, mul_one, mul_comm bound] at hnorm
    exact (mul_le_mul_iff_right₀ hwgt).mp hnorm
  have hcoord := (lp.norm_apply_le_norm hp.ne' v i).trans hv
  have hright : i + 1 ≠ i - 1 := by omega
  have hprobe : difference i = timeStep / width ^ 2 * diffusivity i := by
    change leveque04_explicitDiffusionStep timeStep width diffusivity (u : ℤ → ℝ) i -
      leveque04_explicitDiffusionStep timeStep width diffusivity (fun _ => 0) i = _
    rw [leveque04_explicitDiffusionStep_sub_weights timeStep width diffusivity
        (u : ℤ → ℝ) (fun _ => 0) hw i]
    simp [u, Pi.single_eq_of_ne hright]
  change |difference i| ≤ bound at hcoord
  rwa [hprobe] at hcoord

/-- The literal shared-Fick-flux finite method has the centered stencil at
every genuine interior row, independently of its exterior ghost functions. -/
theorem explicitDiffusionFiniteStep_interior
    {cells : ℕ} (timeStep width : ℝ) (diffusivity : Fin (cells + 1) → ℝ)
    (leftGhost rightGhost : (Fin cells → ℝ) → ℝ) (before : Fin cells → ℝ)
    (i : Fin cells) (hi0 : 1 ≤ i.val) (hi1 : i.val + 1 < cells) (hw : 0 < width) :
    explicitDiffusionFiniteStep timeStep width diffusivity leftGhost rightGhost before i =
      before i + timeStep / width ^ 2 *
        (diffusivity ⟨i.val + 1, Nat.succ_lt_succ i.isLt⟩ *
          (before ⟨i.val + 1, hi1⟩ - before i) -
        diffusivity ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩ *
          (before i - before ⟨i.val - 1, by omega⟩)) := by
  have hi : i.val ≠ 0 := by omega
  simp [explicitDiffusionFiniteStep, conservativeFluxDifferenceUpdate,
    explicitDiffusionFiniteFaceFlux, i.isLt, hi, hi1,
    Nat.lt_succ_of_lt i.isLt, Nat.succ_lt_succ i.isLt,
    Leveque02Tracer.fickFlux, smul_eq_mul]
  field_simp
  ring

/-- Actual finite-vector pair stability bounds a left-face coefficient at an
interior output. No homogeneity assumption on the ghost functions is needed. -/
theorem explicitDiffusionFiniteLp_face_bound
    (p : ENNReal) [Fact (1 ≤ p)] {cells : ℕ}
    {horizon bound timeStep width : ℝ} {diffusivity : Fin (cells + 1) → ℝ}
    {leftGhost rightGhost : (Fin cells → ℝ) → ℝ}
    (hw : 0 < width) (ht : timeStep ≤ horizon)
    (hs : IsExplicitDiffusionFiniteLpStableThrough p horizon bound timeStep width
      diffusivity leftGhost rightGhost)
    (i : Fin cells) (hi0 : 1 ≤ i.val) (hi1 : i.val + 1 < cells) :
    |timeStep / width ^ 2 * diffusivity ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩| ≤ bound := by
  let left : Fin cells := ⟨i.val - 1, by omega⟩
  let u : Fin cells → ℝ := Pi.single left 1
  let difference : Fin cells → ℝ :=
    (explicitDiffusionFiniteStep timeStep width diffusivity leftGhost rightGhost)^[1] u -
      (explicitDiffusionFiniteStep timeStep width diffusivity leftGhost rightGhost)^[1] 0
  let v : PiLp p (fun _ : Fin cells => ℝ) := toLp p difference
  have hwgt : 0 < explicitDiffusionPhysicalWeight p width :=
    Real.rpow_pos_of_pos hw _
  have hnorm := hs u 0 1 (by simpa using ht)
  have hv : ‖v‖ ≤ bound := by
    have hu : ‖(toLp p (u - 0) : PiLp p (fun _ : Fin cells => ℝ))‖ = 1 := by
      simp [u, PiLp.norm_toLp_single]
    change explicitDiffusionPhysicalWeight p width * ‖v‖ ≤
      bound * (explicitDiffusionPhysicalWeight p width *
        ‖(toLp p (u - 0) : PiLp p (fun _ : Fin cells => ℝ))‖) at hnorm
    rw [hu, mul_one, mul_comm bound] at hnorm
    exact (mul_le_mul_iff_right₀ hwgt).mp hnorm
  have hcoord := (PiLp.norm_apply_le v i).trans hv
  have hcenter : i ≠ left := by
    intro h
    have hv := congrArg Fin.val h
    dsimp [left] at hv
    omega
  have hright : (⟨i.val + 1, hi1⟩ : Fin cells) ≠ left := by
    intro h
    have hv := congrArg Fin.val h
    dsimp [left] at hv
    omega
  have hu0 : u i = 0 := Pi.single_eq_of_ne hcenter 1
  have hur : u ⟨i.val + 1, hi1⟩ = 0 := Pi.single_eq_of_ne hright 1
  have hul : u ⟨i.val - 1, by omega⟩ = 1 := by simp [u, left]
  have hprobe : difference i =
      timeStep / width ^ 2 * diffusivity ⟨i.val, Nat.lt_succ_of_lt i.isLt⟩ := by
    dsimp only [difference]
    simp only [Function.iterate_one, Pi.sub_apply]
    rw [explicitDiffusionFiniteStep_interior timeStep width diffusivity
        leftGhost rightGhost u i hi0 hi1 hw,
      explicitDiffusionFiniteStep_interior timeStep width diffusivity
        leftGhost rightGhost 0 i hi0 hi1 hw]
    simp [hu0, hur, hul]
  change |difference i| ≤ bound at hcoord
  rwa [hprobe] at hcoord

/-- A positive sampled coefficient and its actual amplification bound give
the quadratic step restriction. The quantitative constant is proof support,
not an additional source-level conclusion. -/
theorem explicitDiffusion_quadratic_bound_of_face_bound
    {timeStep width bound lower coefficient : ℝ}
    (ht : 0 ≤ timeStep) (hw : 0 < width) (hl : 0 < lower)
    (hc : lower ≤ coefficient)
    (hb : |timeStep / width ^ 2 * coefficient| ≤ bound) :
    timeStep ≤ (bound / lower) * width ^ 2 := by
  have hμ : 0 ≤ timeStep / width ^ 2 := div_nonneg ht (sq_nonneg width)
  have hprod : timeStep / width ^ 2 * lower ≤ bound :=
    (mul_le_mul_of_nonneg_left hc hμ).trans ((le_abs_self _).trans hb)
  have hratio : timeStep / width ^ 2 ≤ bound / lower :=
    (le_div_iff₀ hl).mpr hprod
  calc
    timeStep = (timeStep / width ^ 2) * width ^ 2 :=
      (div_mul_cancel₀ _ (ne_of_gt (sq_pos_of_pos hw))).symm
    _ ≤ (bound / lower) * width ^ 2 :=
      mul_le_mul_of_nonneg_right hratio (sq_nonneg width)

end

end NumStability
