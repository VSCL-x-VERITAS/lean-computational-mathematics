/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerVectorExactBalance
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerMovingExactAverages
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv

/-!
# Moving vector exact averages at a Richtmyer face

Each coordinate of a finite vector cell average is the scalar cell
average of that coordinate. The checked scalar moving-average derivative
therefore supplies the vector predictor's neighboring-state slopes.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_richtmyer_vectorLeftExactAverage_hasDerivAt
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (face width : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width) :
    HasDerivAt
      (fun x => oneDimensionalCellAverage profile (x - width) x)
      (width⁻¹ • (profile face - profile (face - width))) face := by
  apply hasDerivAt_pi.mpr
  intro p
  have heq :
      (fun x => oneDimensionalCellAverage profile (x - width) x p) =
      (fun x => oneDimensionalCellAverage (fun y => profile y p)
        (x - width) x) := by
    funext x
    exact oneDimensionalCellAverage_apply profile (x - width) x
      (hprofile.intervalIntegrable (μ := volume) _ _) p
  change HasDerivAt
    (fun x => oneDimensionalCellAverage profile (x - width) x p)
    ((width⁻¹ • (profile face - profile (face - width))) p) face
  rw [heq]
  simpa only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul,
    div_eq_mul_inv, mul_comm] using
    (leveque04_richtmyer_leftExactAverage_hasDerivAt
      (fun x => profile x p) face width
      ((continuous_apply p).comp hprofile) hwidth)

theorem leveque04_richtmyer_vectorRightExactAverage_hasDerivAt
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (face width : ℝ)
    (hprofile : Continuous profile) (hwidth : 0 < width) :
    HasDerivAt
      (fun x => oneDimensionalCellAverage profile x (x + width))
      (width⁻¹ • (profile (face + width) - profile face)) face := by
  apply hasDerivAt_pi.mpr
  intro p
  have heq :
      (fun x => oneDimensionalCellAverage profile x (x + width) p) =
      (fun x => oneDimensionalCellAverage (fun y => profile y p)
        x (x + width)) := by
    funext x
    exact oneDimensionalCellAverage_apply profile x (x + width)
      (hprofile.intervalIntegrable (μ := volume) _ _) p
  change HasDerivAt
    (fun x => oneDimensionalCellAverage profile x (x + width) p)
    ((width⁻¹ • (profile (face + width) - profile face)) p) face
  rw [heq]
  simpa only [Pi.smul_apply, Pi.sub_apply, smul_eq_mul,
    div_eq_mul_inv, mul_comm] using
    (leveque04_richtmyer_rightExactAverage_hasDerivAt
      (fun x => profile x p) face width
      ((continuous_apply p).comp hprofile) hwidth)

theorem leveque04_richtmyer_vectorExactOld_leftSample
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (width : ℝ) (j : ℤ) :
    leveque04_richtmyer_vectorExactOld profile width (j - 1) =
      oneDimensionalCellAverage profile
        ((j : ℝ) * width - width) ((j : ℝ) * width) := by
  simp only [leveque04_richtmyer_vectorExactOld, Int.cast_sub,
    Int.cast_add, Int.cast_one]
  congr 1 <;> ring

theorem leveque04_richtmyer_vectorExactOld_rightSample
    {m : ℕ} (profile : ℝ → Fin m → ℝ) (width : ℝ) (j : ℤ) :
    leveque04_richtmyer_vectorExactOld profile width j =
      oneDimensionalCellAverage profile
        ((j : ℝ) * width) ((j : ℝ) * width + width) := by
  simp only [leveque04_richtmyer_vectorExactOld, Int.cast_add, Int.cast_one]
  congr 1
  ring

theorem leveque04_richtmyer_vectorExactFace_sample
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (timeStep width : ℝ) (j : ℤ) :
    leveque04_richtmyer_vectorExactFace q flux timeStep width j =
      (fun x => oneDimensionalCellAverage
        (fun τ => flux (q x τ)) 0 timeStep) ((j : ℝ) * width) := rfl

end NumStability
