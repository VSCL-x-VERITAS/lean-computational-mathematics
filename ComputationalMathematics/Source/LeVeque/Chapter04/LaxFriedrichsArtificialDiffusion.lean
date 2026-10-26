/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsViscosity
import Mathlib.Topology.Algebra.Field
import Mathlib.Topology.Instances.Real.Lemmas

/-!
# Artificial diffusion scale of the Lax–Friedrichs flux

The coefficient of the diffusion interpretation following (4.21) is
`width² / (2 * timeStep)`. It vanishes when the positive time-to-width ratio
is fixed and the width tends to zero. At a parabolic time scale proportional
to width squared, the coefficient instead remains constant.
-/

namespace NumStability

/-- The artificial diffusion coefficient identified beside (4.21). -/
noncomputable def leveque04_laxFriedrichs_artificialDiffusivity
    (timeStep width : ℝ) : ℝ :=
  leveque04_laxFriedrichsViscosity timeStep width

/-- A fixed positive time-to-width ratio makes the coefficient linear in
the cell width. -/
theorem leveque04_laxFriedrichs_artificialDiffusivity_fixedRatio
    (ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width) :
    leveque04_laxFriedrichs_artificialDiffusivity
      (ratio * width) width = width / (2 * ratio) := by
  exact leveque04_laxFriedrichsViscosity_fixedRatio ratio width hratio hwidth

/-- The fixed-ratio artificial diffusion coefficient is positive on
every positive grid width. -/
theorem leveque04_laxFriedrichs_artificialDiffusivity_pos
    (ratio width : ℝ) (hratio : 0 < ratio) (hwidth : 0 < width) :
    0 < leveque04_laxFriedrichs_artificialDiffusivity
      (ratio * width) width := by
  rw [leveque04_laxFriedrichs_artificialDiffusivity_fixedRatio
    ratio width hratio hwidth]
  exact div_pos hwidth (mul_pos (by norm_num) hratio)

/-- At a fixed positive time-to-width ratio, the artificial diffusion
coefficient vanishes on a shrinking positive-width family. -/
theorem leveque04_laxFriedrichs_artificialDiffusivity_tendsto_zero
    (ratio : ℝ) (width : ℕ → ℝ)
    (hratio : 0 < ratio) (hwidth : ∀ n, 0 < width n)
    (hlimit : Filter.Tendsto width Filter.atTop (nhds 0)) :
    Filter.Tendsto
      (fun n => leveque04_laxFriedrichs_artificialDiffusivity
        (ratio * width n) (width n))
      Filter.atTop (nhds 0) := by
  simpa only [leveque04_laxFriedrichs_artificialDiffusivity] using
    leveque04_laxFriedrichsViscosity_tendsto_zero ratio hratio width hwidth hlimit

/-- On a time scale proportional to width squared, the artificial
diffusion coefficient stays constant for each nonzero width. -/
theorem leveque04_laxFriedrichs_artificialDiffusivity_parabolicRatio
    (ratio width : ℝ) (hratio : ratio ≠ 0) (hwidth : width ≠ 0) :
    leveque04_laxFriedrichs_artificialDiffusivity
      (ratio * width ^ 2) width = 1 / (2 * ratio) := by
  unfold leveque04_laxFriedrichs_artificialDiffusivity leveque04_laxFriedrichsViscosity
  field_simp

end NumStability
