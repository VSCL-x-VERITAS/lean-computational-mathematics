/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ScalarLWViscosityCancellationTarget
import Mathlib.Tactic.Linarith

/-!
# Exact scalar viscosity cancellation and one-step preservation

The actual Richtmyer and Fick constructions cancel to the existing positive
upwind step. The closed Courant interval includes both zero and unit weight.
-/

namespace NumStability

/-- The specified scalar correction cancels exactly to upwind, including its
one-step interval and adjacent-monotonicity preservation properties. -/
theorem leveque04_scalarLWViscosityCancellation :
    Leveque04ScalarLWViscosityCancellationTarget := by
  intro speed timeStep cellWidth hspeed hwidth hcourant hcourant_le
  have hwidth_ne : cellWidth ≠ 0 := ne_of_gt hwidth
  have hweight : 0 ≤ 1 - speed * timeStep / cellWidth := sub_nonneg.mpr hcourant_le
  have hface (left right : ℝ) :
      leveque04_scalarLWFaceFlux speed timeStep cellWidth left right =
        speed * left + speed / 2 * (1 - speed * timeStep / cellWidth) *
          (right - left) := by
    unfold leveque04_scalarLWFaceFlux leveque04_richtmyerFlux
    dsimp only
    rw [leveque04_equation23]
    dsimp only
    field_simp [hwidth_ne]
    ring
  have hdiffusive (left right : ℝ) :
      leveque04_scalarLWAddedDiffusiveFlux speed timeStep cellWidth left right =
        -(speed / 2) * (1 - speed * timeStep / cellWidth) * (right - left) := by
    unfold leveque04_scalarLWAddedDiffusiveFlux leveque04_scalarLWAddedViscosity
      Leveque02Tracer.fickFlux
    field_simp [hwidth_ne]
  have hcorrected (left right : ℝ) :
      leveque04_scalarLWCorrectedFaceFlux speed timeStep cellWidth left right =
        speed * left := by
    rw [leveque04_scalarLWCorrectedFaceFlux, hface, hdiffusive]
    ring
  have hinterface (old : ℤ → ℝ) :
      leveque04_scalarLWCorrectedInterfaceFlux speed timeStep cellWidth old =
        leveque04_positiveUpwindInterfaceFlux speed old := by
    funext i
    exact hcorrected (old (i - 1)) (old i)
  have hstep (old : ℤ → ℝ) (i : ℤ) :
      leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i =
        leveque04_positiveUpwindStep timeStep cellWidth speed old i := by
    unfold leveque04_scalarLWCorrectedStep leveque04_positiveUpwindStep
    rw [hinterface]
  have hstencil (old : ℤ → ℝ) (i : ℤ) :
      leveque04_scalarLWCorrectedStep speed timeStep cellWidth old i =
        (speed * timeStep / cellWidth) * old (i - 1) +
          (1 - speed * timeStep / cellWidth) * old i := by
    rw [hstep, leveque04_equation26 timeStep cellWidth speed old i hspeed]
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact mul_nonneg (div_nonneg (mul_nonneg hspeed.le hwidth.le) (by norm_num)) hweight
  · intro left right
    exact ⟨hface left right, hdiffusive left right, hcorrected left right⟩
  · intro old i
    exact ⟨rfl, congrFun (hinterface old) i, hstep old i, hstencil old i⟩
  · intro old lower upper hbounds i
    rw [hstencil]
    constructor
    · have hleft := mul_le_mul_of_nonneg_left (hbounds (i - 1)).1 hcourant
      have hright := mul_le_mul_of_nonneg_left (hbounds i).1 hweight
      nlinarith
    · have hleft := mul_le_mul_of_nonneg_left (hbounds (i - 1)).2 hcourant
      have hright := mul_le_mul_of_nonneg_left (hbounds i).2 hweight
      nlinarith
  · intro old hincreasing i
    rw [hstencil, hstencil]
    have hleft := mul_le_mul_of_nonneg_left (hincreasing (i - 1)) hcourant
    have hright := mul_le_mul_of_nonneg_left (hincreasing i) hweight
    simp only [sub_add_cancel, add_sub_cancel_right] at hleft ⊢
    exact add_le_add hleft hright
  · intro old hdecreasing i
    rw [hstencil, hstencil]
    have hleft := mul_le_mul_of_nonneg_left (hdecreasing (i - 1)) hcourant
    have hright := mul_le_mul_of_nonneg_left (hdecreasing i) hweight
    simp only [sub_add_cancel, add_sub_cancel_right] at hleft ⊢
    exact add_le_add hleft hright

end NumStability
