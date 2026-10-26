/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerNonlinearSmoothResidual
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerMovingExactAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.RichtmyerExactAverageFaceDerivativeError

/-!
# Local residual for the scalar exact-average Richtmyer update

Exact moving cell averages supply the differentiable left and right
state profiles required by the generic smooth face-error residual
theorem. The remaining analytic input is a uniform quadratic bound on
the actual face-flux derivative defect.
-/

namespace NumStability

open MeasureTheory

/-- A uniform quadratic derivative error of the actual Richtmyer
face flux on exact neighboring cell averages yields a quadratic
normalized local residual for the scalar conservative update. -/
theorem leveque04_richtmyer_exactAverage_smoothResidual
    (profile flux flux' exactFlux exactFlux' : ℝ → ℝ)
    (old exactFace exactNext : ℤ → Fin 1 → ℝ)
    (timeStep width bound : ℝ)
    (htime : 0 < timeStep) (hwidth : 0 < width)
    (hprofile : Continuous profile)
    (hflux : ∀ z, HasDerivAt flux (flux' z) z)
    (hexactFlux : ∀ x, HasDerivAt exactFlux (exactFlux' x) x)
    (hleftSample : ∀ j : ℤ,
      old (j - 1) 0 = oneDimensionalCellAverage profile
        ((j : ℝ) * width - width) ((j : ℝ) * width))
    (hrightSample : ∀ j : ℤ,
      old j 0 = oneDimensionalCellAverage profile
        ((j : ℝ) * width) ((j : ℝ) * width + width))
    (hexactFace : ∀ j : ℤ,
      exactFace j 0 = exactFlux ((j : ℝ) * width))
    (hformulaBound : ∀ x,
      |flux' (leveque04_richtmyerPredictor timeStep width
          (fun state (_ : Fin 1) => flux (state 0))
          (fun _ => oneDimensionalCellAverage profile (x - width) x)
          (fun _ => oneDimensionalCellAverage profile x (x + width)) 0) *
        (((profile x - profile (x - width)) / width +
            (profile (x + width) - profile x) / width) / 2 -
          timeStep / (2 * width) *
            (flux' (oneDimensionalCellAverage profile x (x + width)) *
                ((profile (x + width) - profile x) / width) -
              flux' (oneDimensionalCellAverage profile (x - width) x) *
                ((profile x - profile (x - width)) / width))) -
        exactFlux' x| ≤ bound * width ^ 2)
    (hexact : ∀ i, exactNext i =
      leveque04_finiteVolumeUpdate timeStep width old exactFace i)
    (i : ℤ) :
    let physicalFlux : (Fin 1 → ℝ) → Fin 1 → ℝ :=
      fun state _ => flux (state 0)
    let numericalFace := leveque04_localInterfaceFlux
      (leveque04_richtmyerFlux timeStep width physicalFlux) old
    |(leveque04_finiteVolumeUpdate timeStep width old numericalFace i 0 -
        exactNext i 0) / timeStep| ≤ bound * width ^ 2 := by
  exact leveque04_richtmyerScalar_smoothFaceDerivative_residual
    flux flux'
    (fun x => oneDimensionalCellAverage profile (x - width) x)
    (fun x => oneDimensionalCellAverage profile x (x + width))
    (fun x => (profile x - profile (x - width)) / width)
    (fun x => (profile (x + width) - profile x) / width)
    exactFlux exactFlux' old exactFace exactNext
    timeStep width bound htime hwidth
    hleftSample hrightSample hexactFace
    (fun x => leveque04_richtmyer_leftExactAverage_hasDerivAt
      profile x width hprofile hwidth)
    (fun x => leveque04_richtmyer_rightExactAverage_hasDerivAt
      profile x width hprofile hwidth)
    hflux hexactFlux hformulaBound hexact i

/-- Exact scalar cell averages on the one-dimensional face-indexed
grid used by the actual Richtmyer update. -/
noncomputable def leveque04_richtmyer_exactOld
    (profile : ℝ → ℝ) (width : ℝ) (j : ℤ) : Fin 1 → ℝ :=
  fun _ => oneDimensionalCellAverage profile
    ((j : ℝ) * width) (((j + 1 : ℤ) : ℝ) * width)

/-- Exact physical time-averaged face flux on the same grid. -/
noncomputable def leveque04_richtmyer_exactFace
    (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (timeStep width : ℝ) (j : ℤ) : Fin 1 → ℝ :=
  fun _ => oneDimensionalCellAverage
    (fun τ => flux (q ((j : ℝ) * width) τ)) 0 timeStep

theorem leveque04_richtmyer_exactOld_leftSample
    (profile : ℝ → ℝ) (width : ℝ) (j : ℤ) :
    leveque04_richtmyer_exactOld profile width (j - 1) 0 =
      oneDimensionalCellAverage profile
        ((j : ℝ) * width - width) ((j : ℝ) * width) := by
  simp only [leveque04_richtmyer_exactOld, Int.cast_sub,
    Int.cast_add, Int.cast_one]
  congr 1 <;> ring

theorem leveque04_richtmyer_exactOld_rightSample
    (profile : ℝ → ℝ) (width : ℝ) (j : ℤ) :
    leveque04_richtmyer_exactOld profile width j 0 =
      oneDimensionalCellAverage profile
        ((j : ℝ) * width) ((j : ℝ) * width + width) := by
  simp only [leveque04_richtmyer_exactOld, Int.cast_add, Int.cast_one]
  congr 1
  ring

theorem leveque04_richtmyer_exactFace_sample
    (q : ℝ → ℝ → ℝ) (flux : ℝ → ℝ)
    (timeStep width : ℝ) (j : ℤ) :
    leveque04_richtmyer_exactFace q flux timeStep width j 0 =
      (fun x => oneDimensionalCellAverage
        (fun τ => flux (q x τ)) 0 timeStep) ((j : ℝ) * width) := rfl

end NumStability
