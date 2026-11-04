/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WholeLineWeightedDiffusion
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Data.Real.Sqrt

/-!
# Whole-line Crank–Nicolson evolution on finite-energy arrays

A bounded nonnegative interface conductivity and positive physical mesh width
give a uniquely solved CN update on real ℓ² of the entire integer line. Ordinary
function iteration preserves perturbation contraction for every step count,
without an upper time-step restriction. No periodic grid replaces the line.
-/

namespace NumStability

/-- Fixed whole-line diffusion parameters, including a genuine uniform bound
on the nonnegative interface coefficient. Zero time step is allowed. -/
structure WholeLineCrankNicolsonGrid where
  /-- The face conductivity on the integer grid. -/
  diffusivity : ℤ → ℝ
  /-- The nonnegative uniform bound on the face conductivity. -/
  bound : ℝ
  bound_nonneg : 0 ≤ bound
  diffusivity_le : ∀ i, |diffusivity i| ≤ bound
  diffusivity_nonneg : ∀ i, 0 ≤ diffusivity i
  /-- The positive physical grid spacing. -/
  width : ℝ
  width_pos : 0 < width
  /-- The nonnegative physical time step. -/
  timeStep : ℝ
  timeStep_nonneg : 0 ≤ timeStep

namespace WholeLineCrankNicolsonGrid

variable (grid : WholeLineCrankNicolsonGrid)

/-- The uniquely solved CN update on the full finite-energy sequence space. -/
noncomputable def update (before : lp (fun _ : ℤ => ℝ) 2) :
    lp (fun _ : ℤ => ℝ) 2 :=
  Classical.choose (wholeLineWeightedDiffusion_crankNicolson_existsUnique
    grid.diffusivity grid.bound grid.bound_nonneg grid.diffusivity_le
    grid.diffusivity_nonneg grid.width before grid.timeStep grid.timeStep_nonneg)

/-- Every coordinate of the chosen update obeys the actual conservative
three-point implicit equation. -/
theorem update_spec (before : lp (fun _ : ℤ => ℝ) 2) :
    IsWholeLineWeightedDiffusionCNStep grid.diffusivity grid.width grid.timeStep
      before (grid.update before) :=
  (Classical.choose_spec (wholeLineWeightedDiffusion_crankNicolson_existsUnique
    grid.diffusivity grid.bound grid.bound_nonneg grid.diffusivity_le
    grid.diffusivity_nonneg grid.width before grid.timeStep grid.timeStep_nonneg)).1

/-- The actual finite-energy solution of the stencil is exactly the update. -/
theorem eq_update_iff (before after : lp (fun _ : ℤ => ℝ) 2) :
    after = grid.update before ↔
      IsWholeLineWeightedDiffusionCNStep grid.diffusivity grid.width grid.timeStep
        before after := by
  constructor
  · rintro rfl
    exact grid.update_spec before
  · intro h
    exact (Classical.choose_spec (wholeLineWeightedDiffusion_crankNicolson_existsUnique
      grid.diffusivity grid.bound grid.bound_nonneg grid.diffusivity_le
      grid.diffusivity_nonneg grid.width before grid.timeStep grid.timeStep_nonneg)).2 after h

/-- The actual update contracts all square-summable perturbations. -/
theorem update_norm_sub_le (before₁ before₂ : lp (fun _ : ℤ => ℝ) 2) :
    ‖grid.update before₁ - grid.update before₂‖ ≤ ‖before₁ - before₂‖ :=
  wholeLineWeightedDiffusion_crankNicolson_norm_sub_le
    grid.diffusivity grid.bound grid.bound_nonneg grid.diffusivity_le
    grid.diffusivity_nonneg grid.width grid.timeStep grid.timeStep_nonneg
    before₁ (grid.update before₁) before₂ (grid.update before₂)
    (grid.update_spec before₁) (grid.update_spec before₂)

/-- Package the one-step contraction for the existing Lipschitz iteration API. -/
theorem update_lipschitz : LipschitzWith 1 grid.update := by
  apply LipschitzWith.of_dist_le_mul
  intro u v
  simpa only [dist_eq_norm, NNReal.coe_one, one_mul] using grid.update_norm_sub_le u v

/-- The whole-line evolution is the ordinary function iterate of the solved step. -/
noncomputable def evolution (steps : ℕ) (before : lp (fun _ : ℤ => ℝ) 2) :
    lp (fun _ : ℤ => ℝ) 2 :=
  (grid.update)^[steps] before

@[simp] theorem evolution_zero (before : lp (fun _ : ℤ => ℝ) 2) :
    grid.evolution 0 before = before := rfl

theorem evolution_succ (steps : ℕ) (before : lp (fun _ : ℤ => ℝ) 2) :
    grid.evolution (steps + 1) before = grid.update (grid.evolution steps before) :=
  Function.iterate_succ_apply' _ _ _

/-- Each successive pair obeys the actual whole-line CN stencil. -/
theorem evolution_step (steps : ℕ) (before : lp (fun _ : ℤ => ℝ) 2) :
    IsWholeLineWeightedDiffusionCNStep grid.diffusivity grid.width grid.timeStep
      (grid.evolution steps before) (grid.evolution (steps + 1) before) := by
  rw [grid.evolution_succ]
  exact grid.update_spec _

/-- Every iterate has the same unit Lipschitz bound. -/
theorem evolution_lipschitz (steps : ℕ) : LipschitzWith 1 (grid.evolution steps) := by
  simpa only [one_pow] using grid.update_lipschitz.iterate steps

/-- Perturbations remain bounded by their initial ℓ² norm at every step count. -/
theorem evolution_norm_sub_le (steps : ℕ) (before₁ before₂ : lp (fun _ : ℤ => ℝ) 2) :
    ‖grid.evolution steps before₁ - grid.evolution steps before₂‖ ≤
      ‖before₁ - before₂‖ := by
  simpa only [dist_eq_norm, NNReal.coe_one, one_mul] using
    (grid.evolution_lipschitz steps).dist_le_mul before₁ before₂

/-- Physical mesh scaling of the actual ℓ² norm. -/
noncomputable def meshL2 (state : lp (fun _ : ℤ => ℝ) 2) : ℝ :=
  Real.sqrt grid.width * ‖state‖

/-- The physical mesh-scaled norm has the same all-step perturbation bound. -/
theorem evolution_meshL2_sub_le (steps : ℕ) (before₁ before₂ : lp (fun _ : ℤ => ℝ) 2) :
    grid.meshL2 (grid.evolution steps before₁ - grid.evolution steps before₂) ≤
      grid.meshL2 (before₁ - before₂) :=
  mul_le_mul_of_nonneg_left (grid.evolution_norm_sub_le steps before₁ before₂)
    (Real.sqrt_nonneg grid.width)

end WholeLineCrankNicolsonGrid

end NumStability
