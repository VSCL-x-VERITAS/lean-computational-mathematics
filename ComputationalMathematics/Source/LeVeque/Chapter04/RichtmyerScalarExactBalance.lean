/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactAverageResidual
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Exact scalar cell balance for Richtmyer reference states

Rectangle conservation identifies the change in an exact spatial cell
average with the difference of its physical time-averaged face fluxes.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_richtmyer_scalarExactCellBalance
    (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (hq : IsRectangleConservationLawSolution q flux)
    (left width timeStep : ℝ)
    (hwidth : 0 < width) (htime : 0 < timeStep) :
    oneDimensionalCellAverage (fun x => q x timeStep)
        left (left + width) =
      oneDimensionalCellAverage (fun x => q x 0)
        left (left + width) -
        timeStep / width *
          (oneDimensionalCellAverage
              (fun τ => flux (q (left + width) τ)) 0 timeStep -
            oneDimensionalCellAverage
              (fun τ => flux (q left τ)) 0 timeStep) := by
  have hw : (left + width) - left = width := by ring
  have hbalance := hq.2.2 left (left + width) 0 timeStep
  rw [intervalIntegral.integral_sub
    (hq.2.1 left 0 timeStep)
    (hq.2.1 (left + width) 0 timeStep)] at hbalance
  simp only [oneDimensionalCellAverage, hw, sub_zero, smul_eq_mul]
  have hwidth_ne : width ≠ 0 := ne_of_gt hwidth
  have htime_ne : timeStep ≠ 0 := ne_of_gt htime
  rw [show (∫ x in left..left + width, q x timeStep) =
      (∫ x in left..left + width, q x 0) +
        ((∫ τ in 0..timeStep, flux (q left τ)) -
          (∫ τ in 0..timeStep, flux (q (left + width) τ))) by
        linarith [hbalance]]
  field_simp
  ring

/-- Exact spatial cell averages after one time step on the same
face-indexed grid as the initial Richtmyer data. -/
noncomputable def leveque04_richtmyer_exactNext
    (q : ℝ → ℝ → ℝ) (timeStep width : ℝ)
    (j : ℤ) : Fin 1 → ℝ :=
  fun _ => oneDimensionalCellAverage (fun x => q x timeStep)
    ((j : ℝ) * width) (((j + 1 : ℤ) : ℝ) * width)

/-- The exact old, next, and physical face arrays obey the same
conservative cell balance used by the nonlinear Richtmyer residual. -/
theorem leveque04_richtmyer_exactAverages_update
    (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (hq : IsRectangleConservationLawSolution q flux)
    (timeStep width : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (i : ℤ) :
    leveque04_richtmyer_exactNext q timeStep width i =
      leveque04_finiteVolumeUpdate timeStep width
        (leveque04_richtmyer_exactOld (fun x => q x 0) width)
        (leveque04_richtmyer_exactFace q flux timeStep width) i := by
  funext p
  fin_cases p
  have hb := leveque04_richtmyer_scalarExactCellBalance
    q flux hq ((i : ℝ) * width) width timeStep hwidth htime
  simpa only [leveque04_richtmyer_exactNext,
    leveque04_richtmyer_exactOld, leveque04_richtmyer_exactFace,
    leveque04_finiteVolumeUpdate, conservativeFluxDifferenceUpdateInt,
    Pi.sub_apply, Pi.smul_apply, smul_eq_mul, Int.cast_add,
    Int.cast_one, add_mul, one_mul] using hb

/-- For exact old and next cell averages of a scalar rectangle
solution, the actual nonlinear Richtmyer residual is quadratic once
the numerical face-flux derivative has a uniform quadratic error. -/
theorem leveque04_richtmyer_exactSolution_smoothResidual
    (q : ℝ → ℝ → ℝ) (flux flux' : ℝ → ℝ)
    (physicalSlope : ℝ → ℝ → ℝ)
    (hq : IsRectangleConservationLawSolution q flux)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hprofile : Continuous (fun x => q x 0))
    (hflux : ∀ z, HasDerivAt flux (flux' z) z)
    (hphysicalDerivative : ∀ x,
      HasDerivAt
        (fun y => oneDimensionalCellAverage
          (fun τ => flux (q y τ)) 0 timeStep)
        (oneDimensionalCellAverage
          (fun τ => physicalSlope x τ) 0 timeStep) x)
    (hformulaBound : ∀ x,
      |flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage (fun y => q y 0)
            (x - width) x)
          (fun _ => oneDimensionalCellAverage (fun y => q y 0)
            x (x + width)) 0) *
        ((((q x 0 - q (x - width) 0) / width +
            (q (x + width) 0 - q x 0) / width) / 2) -
          timeStep / (2 * width) *
            (flux' (oneDimensionalCellAverage (fun y => q y 0)
                x (x + width)) *
                ((q (x + width) 0 - q x 0) / width) -
              flux' (oneDimensionalCellAverage (fun y => q y 0)
                (x - width) x) *
                ((q x 0 - q (x - width) 0) / width))) -
        oneDimensionalCellAverage
          (fun τ => physicalSlope x τ) 0 timeStep| ≤
        bound * width ^ 2)
    (i : ℤ) :
    let old := leveque04_richtmyer_exactOld (fun x => q x 0) width
    let exactNext := leveque04_richtmyer_exactNext q timeStep width
    let numericalFace := leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width
        (fun state (_ : Fin 1) => flux (state 0))) old
    |(leveque04_finiteVolumeUpdate timeStep width old numericalFace i 0 -
        exactNext i 0) / timeStep| ≤ bound * width ^ 2 := by
  exact leveque04_richtmyer_exactAverage_smoothResidual
    (fun x => q x 0) flux flux'
    (fun x => oneDimensionalCellAverage
      (fun τ => flux (q x τ)) 0 timeStep)
    (fun x => oneDimensionalCellAverage
      (fun τ => physicalSlope x τ) 0 timeStep)
    (leveque04_richtmyer_exactOld (fun x => q x 0) width)
    (leveque04_richtmyer_exactFace q flux timeStep width)
    (leveque04_richtmyer_exactNext q timeStep width)
    timeStep width bound htime hwidth hprofile hflux
    hphysicalDerivative
    (leveque04_richtmyer_exactOld_leftSample (fun x => q x 0) width)
    (leveque04_richtmyer_exactOld_rightSample (fun x => q x 0) width)
    (leveque04_richtmyer_exactFace_sample q flux timeStep width)
    hformulaBound
    (leveque04_richtmyer_exactAverages_update q flux hq timeStep width
      htime hwidth) i

end NumStability
