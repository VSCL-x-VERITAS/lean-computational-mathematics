/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonUnconditionalStabilityQualifiedTarget

/-!
# The qualified whole-line Crank–Nicolson stability statement

The existing solved update contracts every finite-energy perturbation, even
for unbounded nonnegative face coefficients. Its constant-one bound supplies
the frozen finite-horizon refinement assertion without restricting its paths.
-/

namespace NumStability

private theorem cnQualified_update_zero (grid : WholeLineDiffusionL2Grid) :
    grid.update 0 = 0 := by
  symm
  apply (grid.eq_update_iff 0 0).mpr
  intro i
  change (0 : ℝ) - 0 = grid.timeStep / 2 *
    ((grid.diffusivity (i + 1) * ((0 + 0) - (0 + 0)) -
      grid.diffusivity i * ((0 + 0) - (0 + 0))) / grid.width ^ 2)
  simp

private theorem cnQualified_evolution_zero (grid : WholeLineDiffusionL2Grid)
    (steps : ℕ) : grid.evolution steps 0 = 0 := by
  induction steps with
  | zero => rfl
  | succ steps ih => rw [grid.evolution_succ, ih, cnQualified_update_zero]

/-- The actual source equation (4.13), solved on the whole integer line, obeys
the owner-qualified finite-horizon power bound in the physical mesh two-norm. -/
theorem leveque04_crankNicolsonUnconditionalQualifiedStability :
    Leveque04CrankNicolsonUnconditionalQualifiedStabilityTarget := by
  intro β _hβ faces faces_nonneg _happrox T _hT width duration width_pos
    duration_pos _hwidth_limit _hduration_limit
  refine ⟨1, by norm_num, 0, ?_⟩
  intro m _hm
  dsimp only
  intro steps _horizon before
  let grid : WholeLineDiffusionL2Grid :=
    { diffusivity := faces (width m)
      diffusivity_nonneg := faces_nonneg (width m) (width_pos m)
      width := width m
      width_pos := width_pos m
      timeStep := duration m
      timeStep_nonneg := (duration_pos m).le }
  have h := grid.evolution_meshL2_sub_le steps before 0
  rw [cnQualified_evolution_zero grid steps, sub_zero, sub_zero] at h
  simpa only [one_mul,
    WholeLineDiffusionL2Grid.evolution, leveque04_crankNicolsonSourceUpdate]
    using h

end NumStability
