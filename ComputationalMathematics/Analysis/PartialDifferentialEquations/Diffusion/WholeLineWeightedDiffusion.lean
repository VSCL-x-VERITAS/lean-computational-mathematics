/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WeightedL2Diffusion
import ComputationalMathematics.Analysis.Normed.Lp.IntegerShift

/-!
# Actual variable-coefficient diffusion on the integer line

The square-summable operator has the conservative three-point stencil on every
integer cell. The coefficients are nonnegative and uniformly bounded; no finite
or periodic grid replaces the entire line.
-/

namespace NumStability
noncomputable section

/-- The conservative time-centered diffusion equation at every integer cell. -/
def IsWholeLineWeightedDiffusionCNStep (b : ℤ → ℝ) (width timeStep : ℝ)
    (before after : ℤ → ℝ) : Prop :=
  ∀ i : ℤ, after i - before i = timeStep / 2 *
    ((b (i + 1) * ((after (i + 1) + before (i + 1)) - (after i + before i)) -
      b i * ((after i + before i) - (after (i - 1) + before (i - 1)))) / width ^ 2)

/-- Conservative whole-line diffusion with the coefficient at each left face. -/
def wholeLineWeightedDiffusion (b : ℤ → ℝ) (C : ℝ)
    (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C) (width : ℝ) :
    lp (fun _ : ℤ => ℝ) 2 →L[ℝ] lp (fun _ : ℤ => ℝ) 2 :=
  weightedL2Diffusion l2IntForwardShift b C hC hb width

/-- The bundled bounded operator is the actual conservative integer stencil. -/
theorem wholeLineWeightedDiffusion_apply (b : ℤ → ℝ) (C : ℝ)
    (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C) (width : ℝ)
    (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    wholeLineWeightedDiffusion b C hC hb width u i =
      (b (i + 1) * (u (i + 1) - u i) - b i * (u i - u (i - 1))) / width ^ 2 := by
  change (width ^ 2)⁻¹ *
      ((l2BoundedRealMultiplier b C hC hb (u - l2IntBackwardShift u)) (i + 1) -
        (l2BoundedRealMultiplier b C hC hb (u - l2IntBackwardShift u)) i) = _
  simp only [l2BoundedRealMultiplier_apply, lp.coeFn_sub, Pi.sub_apply,
    l2IntBackwardShift_apply, add_sub_cancel_right]
  ring

/-- The actual pointwise equation is equivalent to the bounded operator equation. -/
theorem wholeLineWeightedDiffusion_crankNicolson_iff
    (b : ℤ → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C)
    (width timeStep : ℝ) (before after : lp (fun _ : ℤ => ℝ) 2) :
    after - before = (timeStep / 2) •
      wholeLineWeightedDiffusion b C hC hb width (after + before) ↔
    IsWholeLineWeightedDiffusionCNStep b width timeStep before after := by
  constructor
  · intro h i
    have hi := congrArg (fun u : lp (fun _ : ℤ => ℝ) 2 => u i) h
    simpa only [lp.coeFn_sub, lp.coeFn_smul, lp.coeFn_add, Pi.sub_apply, Pi.smul_apply,
      Pi.add_apply, smul_eq_mul, wholeLineWeightedDiffusion_apply] using hi
  · intro h
    ext i
    simpa only [lp.coeFn_sub, lp.coeFn_smul, lp.coeFn_add, Pi.sub_apply, Pi.smul_apply,
      Pi.add_apply, smul_eq_mul, wholeLineWeightedDiffusion_apply] using h i

/-- A whole-line variable-coefficient CN equation has a unique finite-energy
solution for every nonnegative duration, without a mesh CFL restriction. -/
theorem wholeLineWeightedDiffusion_crankNicolson_existsUnique
    (b : ℤ → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C)
    (hpos : ∀ i, 0 ≤ b i) (width : ℝ)
    (before : lp (fun _ : ℤ => ℝ) 2) (timeStep : ℝ) (htime : 0 ≤ timeStep) :
    ∃! after : lp (fun _ : ℤ => ℝ) 2,
      IsWholeLineWeightedDiffusionCNStep b width timeStep before after := by
  obtain ⟨after, hafter, hunique⟩ := weightedL2Diffusion_crankNicolson_existsUnique
    l2IntForwardShift b C hC hb hpos width before timeStep htime
  have heq := wholeLineWeightedDiffusion_crankNicolson_iff b C hC hb width timeStep before
  exact ⟨after, (heq after).mp hafter, fun other hother => hunique other ((heq other).mpr hother)⟩

/-- Two solutions of the literal whole-line stencil contract square-summable
perturbations for every nonnegative time step. -/
theorem wholeLineWeightedDiffusion_crankNicolson_norm_sub_le
    (b : ℤ → ℝ) (C : ℝ) (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C)
    (hpos : ∀ i, 0 ≤ b i) (width timeStep : ℝ) (htime : 0 ≤ timeStep)
    (before₁ after₁ before₂ after₂ : lp (fun _ : ℤ => ℝ) 2)
    (hstep₁ : IsWholeLineWeightedDiffusionCNStep b width timeStep before₁ after₁)
    (hstep₂ : IsWholeLineWeightedDiffusionCNStep b width timeStep before₂ after₂) :
    ‖after₁ - after₂‖ ≤ ‖before₁ - before₂‖ :=
  weightedL2Diffusion_crankNicolson_norm_sub_le l2IntForwardShift b C hC hb hpos width
    before₁ after₁ before₂ after₂ timeStep htime
    ((wholeLineWeightedDiffusion_crankNicolson_iff b C hC hb width timeStep before₁ after₁).mpr hstep₁)
    ((wholeLineWeightedDiffusion_crankNicolson_iff b C hC hb width timeStep before₂ after₂).mpr hstep₂)

end
end NumStability
