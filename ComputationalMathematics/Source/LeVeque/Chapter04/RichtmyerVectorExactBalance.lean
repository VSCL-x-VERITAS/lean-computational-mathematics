/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerScalarExactBalance

/-!
# Exact vector cell balance for Richtmyer reference states

The rectangle conservation law supplies the exact update for the
vector-valued cell averages used by the general Richtmyer stencil.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_richtmyer_vectorExactCellBalance
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (hq : IsRectangleConservationLawSolution q flux)
    (left width timeStep : ℝ)
    (htime : 0 < timeStep) :
    oneDimensionalCellAverage (fun x => q x timeStep)
        left (left + width) =
      oneDimensionalCellAverage (fun x => q x 0)
        left (left + width) -
        (timeStep / width) •
          (oneDimensionalCellAverage
              (fun τ => flux (q (left + width) τ)) 0 timeStep -
            oneDimensionalCellAverage
              (fun τ => flux (q left τ)) 0 timeStep) := by
  have hw : (left + width) - left = width := by ring
  have hbalance := hq.2.2 left (left + width) 0 timeStep
  rw [intervalIntegral.integral_sub
    (hq.2.1 left 0 timeStep)
    (hq.2.1 (left + width) 0 timeStep)] at hbalance
  have hrewrite :
      (∫ x in left..left + width, q x timeStep) =
        (∫ x in left..left + width, q x 0) -
          ((∫ τ in 0..timeStep, flux (q (left + width) τ)) -
            (∫ τ in 0..timeStep, flux (q left τ))) := by
    linear_combination hbalance
  simp only [oneDimensionalCellAverage, hw, sub_zero]
  rw [hrewrite]
  simp only [smul_sub, smul_smul]
  congr 1
  field_simp

/-- Exact vector spatial averages at the old time level. -/
noncomputable def leveque04_richtmyer_vectorExactOld
    {m : ℕ} (q : ℝ → Fin m → ℝ) (width : ℝ)
    (j : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage q
    ((j : ℝ) * width) (((j + 1 : ℤ) : ℝ) * width)

/-- Exact vector spatial averages after one time step. -/
noncomputable def leveque04_richtmyer_vectorExactNext
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (timeStep width : ℝ) (j : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage (fun x => q x timeStep)
    ((j : ℝ) * width) (((j + 1 : ℤ) : ℝ) * width)

/-- Exact physical time-averaged vector flux at every face. -/
noncomputable def leveque04_richtmyer_vectorExactFace
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (timeStep width : ℝ) (j : ℤ) : Fin m → ℝ :=
  oneDimensionalCellAverage
    (fun τ => flux (q ((j : ℝ) * width) τ)) 0 timeStep

theorem leveque04_richtmyer_vectorExactAverages_update
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (hq : IsRectangleConservationLawSolution q flux)
    (timeStep width : ℝ)
    (htime : 0 < timeStep)
    (i : ℤ) :
    leveque04_richtmyer_vectorExactNext q timeStep width i =
      leveque04_finiteVolumeUpdate timeStep width
        (leveque04_richtmyer_vectorExactOld (fun x => q x 0) width)
        (leveque04_richtmyer_vectorExactFace q flux timeStep width) i := by
  have hb := leveque04_richtmyer_vectorExactCellBalance
    q flux hq ((i : ℝ) * width) width timeStep htime
  simpa only [leveque04_richtmyer_vectorExactNext,
    leveque04_richtmyer_vectorExactOld, leveque04_richtmyer_vectorExactFace,
    leveque04_finiteVolumeUpdate, conservativeFluxDifferenceUpdateInt,
    Int.cast_add, Int.cast_one, add_mul, one_mul] using hb

end NumStability
