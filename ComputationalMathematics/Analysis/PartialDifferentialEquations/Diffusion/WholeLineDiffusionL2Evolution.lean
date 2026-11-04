/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Diffusion.WholeLineDiffusionL2Existence
import Mathlib.Topology.MetricSpace.Lipschitz
import Mathlib.Data.Real.Sqrt

/-!
# Whole-line CN evolution without a coefficient bound

Every nonnegative face coefficient sequence gives an actual uniquely solved
CN update on real ℓ² of the integer line. Its iterates contract perturbations
with constant one, irrespective of coefficient growth and time-step size.
-/

namespace NumStability

/-- Physical whole-line grid parameters. The nonnegative conductivity may be
unbounded along the integer line; no common or per-grid bound is required. -/
structure WholeLineDiffusionL2Grid where
  /-- The nonnegative face conductivity on the integer grid. -/
  diffusivity : ℤ → ℝ
  diffusivity_nonneg : ∀ i, 0 ≤ diffusivity i
  /-- The positive physical grid spacing. -/
  width : ℝ
  width_pos : 0 < width
  /-- The nonnegative physical time step. -/
  timeStep : ℝ
  timeStep_nonneg : 0 ≤ timeStep

namespace WholeLineDiffusionL2Grid

variable (grid : WholeLineDiffusionL2Grid)

/-- The actual unique finite-energy CN solution for the supplied before-state. -/
noncomputable def update (before : lp (fun _ : ℤ => ℝ) 2) :
    lp (fun _ : ℤ => ℝ) 2 :=
  Classical.choose (wholeLineDiffusionL2_existsUnique grid.diffusivity
    grid.diffusivity_nonneg grid.width grid.timeStep grid.width_pos
    grid.timeStep_nonneg before)

/-- The chosen update obeys the literal conservative CN stencil at every cell. -/
theorem update_spec (before : lp (fun _ : ℤ => ℝ) 2) :
    IsWholeLineWeightedDiffusionCNStep grid.diffusivity grid.width grid.timeStep
      before (grid.update before) :=
  (Classical.choose_spec (wholeLineDiffusionL2_existsUnique grid.diffusivity
    grid.diffusivity_nonneg grid.width grid.timeStep grid.width_pos
    grid.timeStep_nonneg before)).1

/-- The literal finite-energy solution is exactly the chosen update. -/
theorem eq_update_iff (before after : lp (fun _ : ℤ => ℝ) 2) :
    after = grid.update before ↔
      IsWholeLineWeightedDiffusionCNStep grid.diffusivity grid.width grid.timeStep
        before after := by
  constructor
  · rintro rfl
    exact grid.update_spec before
  · intro h
    exact (Classical.choose_spec (wholeLineDiffusionL2_existsUnique grid.diffusivity
      grid.diffusivity_nonneg grid.width grid.timeStep grid.width_pos
      grid.timeStep_nonneg before)).2 after h

/-- All finite-energy perturbations contract at one actual step. -/
theorem update_norm_sub_le (before₁ before₂ : lp (fun _ : ℤ => ℝ) 2) :
    ‖grid.update before₁ - grid.update before₂‖ ≤ ‖before₁ - before₂‖ :=
  wholeLineDiffusionL2_norm_sub_le grid.diffusivity grid.diffusivity_nonneg
    grid.width grid.timeStep grid.width_pos grid.timeStep_nonneg
    before₁ (grid.update before₁) before₂ (grid.update before₂)
    (grid.update_spec before₁) (grid.update_spec before₂)

theorem update_lipschitz : LipschitzWith 1 grid.update := by
  apply LipschitzWith.of_dist_le_mul
  intro u v
  simpa only [dist_eq_norm, NNReal.coe_one, one_mul] using grid.update_norm_sub_le u v

/-- Ordinary function iteration of the actual unique whole-line update. -/
noncomputable def evolution (steps : ℕ) (before : lp (fun _ : ℤ => ℝ) 2) :
    lp (fun _ : ℤ => ℝ) 2 :=
  (grid.update)^[steps] before

@[simp] theorem evolution_zero (before : lp (fun _ : ℤ => ℝ) 2) :
    grid.evolution 0 before = before := rfl

theorem evolution_succ (steps : ℕ) (before : lp (fun _ : ℤ => ℝ) 2) :
    grid.evolution (steps + 1) before = grid.update (grid.evolution steps before) :=
  Function.iterate_succ_apply' _ _ _

/-- Every consecutive pair solves the actual whole-line CN stencil. -/
theorem evolution_step (steps : ℕ) (before : lp (fun _ : ℤ => ℝ) 2) :
    IsWholeLineWeightedDiffusionCNStep grid.diffusivity grid.width grid.timeStep
      (grid.evolution steps before) (grid.evolution (steps + 1) before) := by
  rw [grid.evolution_succ]
  exact grid.update_spec _

theorem evolution_lipschitz (steps : ℕ) : LipschitzWith 1 (grid.evolution steps) := by
  simpa only [one_pow] using grid.update_lipschitz.iterate steps

/-- The unit perturbation bound holds for every iteration count, with no
restriction linking the physical width, time step or coefficient values. -/
theorem evolution_norm_sub_le (steps : ℕ) (before₁ before₂ : lp (fun _ : ℤ => ℝ) 2) :
    ‖grid.evolution steps before₁ - grid.evolution steps before₂‖ ≤
      ‖before₁ - before₂‖ := by
  simpa only [dist_eq_norm, NNReal.coe_one, one_mul] using
    (grid.evolution_lipschitz steps).dist_le_mul before₁ before₂

/-- Physical mesh scaling of the actual finite-energy norm. -/
noncomputable def meshL2 (state : lp (fun _ : ℤ => ℝ) 2) : ℝ :=
  Real.sqrt grid.width * ‖state‖

/-- The physical discrete two-norm has the same uniform all-step bound. -/
theorem evolution_meshL2_sub_le (steps : ℕ) (before₁ before₂ : lp (fun _ : ℤ => ℝ) 2) :
    grid.meshL2 (grid.evolution steps before₁ - grid.evolution steps before₂) ≤
      grid.meshL2 (before₁ - before₂) :=
  mul_le_mul_of_nonneg_left (grid.evolution_norm_sub_le steps before₁ before₂)
    (Real.sqrt_nonneg grid.width)

end WholeLineDiffusionL2Grid

end NumStability
