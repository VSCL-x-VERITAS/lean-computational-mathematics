/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter04.SignedSpectralMatrices
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, Exercise 4.1(a): acoustics split matrices

The convected acoustics matrix of (2.50) has eigenvalues `u₀-c` and
`u₀+c`, with the two acoustic eigenvectors already used in Chapter 2.
Applying (4.45) gives explicit positive and negative coefficient parts.
-/

namespace NumStability

/-- Acoustics characteristic speeds in left/right wave order. -/
def leveque04_acousticSpeeds (backgroundVelocity soundSpeed : ℝ) :
    Fin 2 → ℝ :=
  ![backgroundVelocity - soundSpeed,
    backgroundVelocity + soundSpeed]

/-- The positive spectral part of the convected acoustics matrix. -/
noncomputable def leveque04_acousticPositiveMatrix
    (density soundSpeed backgroundVelocity : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  linearAcousticsEigenvectorMatrix density soundSpeed *
    Matrix.diagonal (fun p =>
      leveque04_positiveVelocity
        (leveque04_acousticSpeeds backgroundVelocity soundSpeed p)) *
    (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹

/-- The negative spectral part of the convected acoustics matrix. -/
noncomputable def leveque04_acousticNegativeMatrix
    (density soundSpeed backgroundVelocity : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  linearAcousticsEigenvectorMatrix density soundSpeed *
    Matrix.diagonal (fun p =>
      leveque04_negativeVelocity
        (leveque04_acousticSpeeds backgroundVelocity soundSpeed p)) *
    (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹

/-- The displayed Chapter 2 acoustics inverse is the actual matrix
inverse when the acoustic impedance is nonzero. -/
theorem leveque04_acousticEigenvectorMatrix_inverse
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹ =
      linearAcousticsEigenvectorMatrixInverse density soundSpeed := by
  have hdensity : density ≠ 0 := by
    intro h
    exact himpedance (by simp [acousticImpedance, h])
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    exact himpedance (by simp [acousticImpedance, h])
  apply Matrix.inv_eq_right_inv
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [linearAcousticsEigenvectorMatrix,
      linearAcousticsEigenvectorMatrixInverse, acousticImpedance,
      Matrix.mul_apply, Fin.sum_univ_two] <;>
    field_simp [hdensity, hspeed] <;> ring

/-- Exercise 4.1(a): explicit entries of both signed acoustics matrices. -/
theorem leveque04_exercise41_acousticMatrices
    (density soundSpeed backgroundVelocity : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    let Z := acousticImpedance density soundSpeed
    let aPlus := max (backgroundVelocity - soundSpeed) 0
    let bPlus := max (backgroundVelocity + soundSpeed) 0
    let aMinus := min (backgroundVelocity - soundSpeed) 0
    let bMinus := min (backgroundVelocity + soundSpeed) 0
    leveque04_acousticPositiveMatrix density soundSpeed backgroundVelocity =
        !![(aPlus + bPlus) / 2, Z * (bPlus - aPlus) / 2;
           (bPlus - aPlus) / (2 * Z), (aPlus + bPlus) / 2] ∧
      leveque04_acousticNegativeMatrix density soundSpeed backgroundVelocity =
        !![(aMinus + bMinus) / 2, Z * (bMinus - aMinus) / 2;
           (bMinus - aMinus) / (2 * Z), (aMinus + bMinus) / 2] := by
  dsimp only
  have hdensity : density ≠ 0 := by
    intro h
    exact himpedance (by simp [acousticImpedance, h])
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    exact himpedance (by simp [acousticImpedance, h])
  rw [leveque04_acousticPositiveMatrix,
    leveque04_acousticNegativeMatrix,
    leveque04_acousticEigenvectorMatrix_inverse density soundSpeed himpedance]
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [linearAcousticsEigenvectorMatrix,
        linearAcousticsEigenvectorMatrixInverse,
        leveque04_acousticSpeeds,
        leveque04_positiveVelocity, acousticImpedance,
        Matrix.mul_apply, Matrix.vecMul, dotProduct,
        Fin.sum_univ_two] <;>
      field_simp [hdensity, hspeed] <;> ring
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [linearAcousticsEigenvectorMatrix,
        linearAcousticsEigenvectorMatrixInverse,
        leveque04_acousticSpeeds,
        leveque04_negativeVelocity, acousticImpedance,
        Matrix.mul_apply, Matrix.vecMul, dotProduct,
        Fin.sum_univ_two] <;>
      field_simp [hdensity, hspeed] <;> ring

end NumStability
