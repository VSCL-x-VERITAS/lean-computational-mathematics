/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.1(d): stationary and moving Riemann jumps

Printed page 62/raw PDF page 84. The two characteristic speeds are 0 and 2.
-/


open MeasureTheory

namespace NumStability

def leveque03_exercise31dA : Matrix (Fin 2) (Fin 2) ℝ := !![1, 1; 1, 1]
def leveque03_exercise31dSpeeds : Fin 2 → ℝ := ![0, 2]
def leveque03_exercise31dVectors : Fin 2 → (Fin 2 → ℝ) := ![![1, -1], ![1, 1]]
noncomputable def leveque03_exercise31dLeftCoeffs : Fin 2 → ℝ := ![1 / 2, 1 / 2]
def leveque03_exercise31dRightCoeffs : Fin 2 → ℝ := ![1, 1]
def leveque03_exercise31dLeft : Fin 2 → ℝ := ![1, 0]
noncomputable def leveque03_exercise31dMiddle : Fin 2 → ℝ := ![3 / 2, -(1 / 2)]
def leveque03_exercise31dRight : Fin 2 → ℝ := ![2, 0]

noncomputable def leveque03_exercise31dSolution (valueAtJump : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ∑ p : Fin 2,
    eigenmodeTravelingWave
      (riemannData (leveque03_exercise31dLeftCoeffs p) (valueAtJump p)
        (leveque03_exercise31dRightCoeffs p))
      (leveque03_exercise31dSpeeds p) (leveque03_exercise31dVectors p) x t

theorem leveque03_exercise31dEigenpairs (p : Fin 2) :
    leveque03_exercise31dA.mulVec (leveque03_exercise31dVectors p) =
      leveque03_exercise31dSpeeds p • leveque03_exercise31dVectors p := by
  funext i
  fin_cases p <;> fin_cases i <;>
    norm_num [leveque03_exercise31dA, leveque03_exercise31dVectors, leveque03_exercise31dSpeeds,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> rfl

theorem leveque03_exercise31dPhasePlane :
    leveque03_exercise31dMiddle = leveque03_exercise31dLeft + (1 / 2 : ℝ) • leveque03_exercise31dVectors 0 ∧
    leveque03_exercise31dRight = leveque03_exercise31dMiddle + (1 / 2 : ℝ) • leveque03_exercise31dVectors 1 := by
  constructor <;> ext i <;> fin_cases i <;>
    norm_num [leveque03_exercise31dMiddle, leveque03_exercise31dLeft, leveque03_exercise31dRight,
      leveque03_exercise31dVectors, Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> rfl

theorem leveque03_exercise31dSolution_weak (valueAtJump : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise31dSolution valueAtJump)
      leveque03_exercise31dA.mulVec := by
  exact finite_sum_isRectangleSolution leveque03_exercise31dA _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution leveque03_exercise31dA _
      (riemannData_intervalIntegrable _ _ _) _ _ (leveque03_exercise31dEigenpairs p))

theorem leveque03_exercise31dSolution_initial (valueAtJump : Fin 2 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise31dSolution valueAtJump x 0)
      leveque03_exercise31dLeft leveque03_exercise31dRight := by
  constructor
  · intro x hx
    ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31dSolution, leveque03_exercise31dLeft, leveque03_exercise31dLeftCoeffs,
        leveque03_exercise31dRightCoeffs, leveque03_exercise31dVectors, leveque03_exercise31dSpeeds,
        eigenmodeTravelingWave, travelingWave, riemannData,
        Fin.sum_univ_succ, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt.mpr hx.le
    ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31dSolution, leveque03_exercise31dRight, leveque03_exercise31dLeftCoeffs,
        leveque03_exercise31dRightCoeffs, leveque03_exercise31dVectors, leveque03_exercise31dSpeeds,
        eigenmodeTravelingWave, travelingWave, riemannData,
        Fin.sum_univ_succ, hnotLeft, hx]

theorem leveque03_exercise31dSolution_left (valueAtJump : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : x < 0) :
    leveque03_exercise31dSolution valueAtJump x t = leveque03_exercise31dLeft := by
  have h0 : x - 0 * t < 0 := by simpa using hx
  have h2 : x - 2 * t < 0 := by linarith
  have hx2 : x < 2 * t := by linarith
  ext i
  fin_cases i <;>
    norm_num [leveque03_exercise31dSolution, leveque03_exercise31dLeft, leveque03_exercise31dLeftCoeffs,
      leveque03_exercise31dRightCoeffs, leveque03_exercise31dVectors, leveque03_exercise31dSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hx, hx2]

theorem leveque03_exercise31dSolution_middle (valueAtJump : Fin 2 → ℝ)
    (x t : ℝ) (hx0 : 0 < x) (hx2 : x < 2 * t) :
    leveque03_exercise31dSolution valueAtJump x t = leveque03_exercise31dMiddle := by
  have h0 : 0 < x - 0 * t := by simpa using hx0
  have h2 : x - 2 * t < 0 := by linarith
  have hnotLeft : ¬ x < 0 := not_lt.mpr hx0.le
  ext i
  fin_cases i <;>
    norm_num [leveque03_exercise31dSolution, leveque03_exercise31dMiddle, leveque03_exercise31dLeftCoeffs,
      leveque03_exercise31dRightCoeffs, leveque03_exercise31dVectors, leveque03_exercise31dSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hnotLeft, hx0, hx2]

theorem leveque03_exercise31dSolution_right (valueAtJump : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : 2 * t < x) :
    leveque03_exercise31dSolution valueAtJump x t = leveque03_exercise31dRight := by
  have h0 : 0 < x - 0 * t := by linarith
  have h2 : 0 < x - 2 * t := by linarith
  have hx0 : 0 < x := by linarith
  have hnotLeft : ¬ x < 0 := not_lt.mpr hx0.le
  have hnotMid : ¬ x < 2 * t := not_lt.mpr hx.le
  ext i
  fin_cases i <;>
    norm_num [leveque03_exercise31dSolution, leveque03_exercise31dRight, leveque03_exercise31dLeftCoeffs,
      leveque03_exercise31dRightCoeffs, leveque03_exercise31dVectors, leveque03_exercise31dSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hnotLeft, hx0, hnotMid, hx]

end NumStability
