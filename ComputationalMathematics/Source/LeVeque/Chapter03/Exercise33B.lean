/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannThreeFamily
import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.3(b): a three-family Riemann fan

Printed page 62/raw PDF page 84. The first family has zero strength; the
nontrivial state changes cross the speed-two and speed-three rays.
-/

open MeasureTheory

namespace NumStability

def leveque03_exercise33bA : Matrix (Fin 3) (Fin 3) ℝ :=
  !![1, 0, 2; 0, 2, 0; 0, 0, 3]

def leveque03_exercise33bSpeeds : Fin 3 → ℝ := ![1, 2, 3]

def leveque03_exercise33bVectors : Fin 3 → (Fin 3 → ℝ) :=
  ![![1, 0, 0], ![0, 1, 0], ![1, 0, 1]]

def leveque03_exercise33bLeft : Fin 3 → ℝ := ![1, 1, 1]
def leveque03_exercise33bMiddle : Fin 3 → ℝ := ![1, 3, 1]
def leveque03_exercise33bRight : Fin 3 → ℝ := ![3, 3, 3]
def leveque03_exercise33bLeftCoeffs : Fin 3 → ℝ := ![0, 1, 1]
def leveque03_exercise33bRightCoeffs : Fin 3 → ℝ := ![0, 3, 3]

noncomputable def leveque03_exercise33bSolution (valueAtJump : Fin 3 → ℝ) :
    ℝ → ℝ → (Fin 3 → ℝ) :=
  fun x t => ∑ p : Fin 3,
    eigenmodeTravelingWave
      (riemannData (leveque03_exercise33bLeftCoeffs p)
        (if p = 0 then 0 else valueAtJump p)
        (leveque03_exercise33bRightCoeffs p))
      (leveque03_exercise33bSpeeds p) (leveque03_exercise33bVectors p) x t

theorem leveque03_exercise33bEigenpairs (p : Fin 3) :
    leveque03_exercise33bA.mulVec (leveque03_exercise33bVectors p) =
      leveque03_exercise33bSpeeds p • leveque03_exercise33bVectors p := by
  funext i
  fin_cases p <;> fin_cases i <;>
    norm_num [leveque03_exercise33bA, leveque03_exercise33bVectors,
      leveque03_exercise33bSpeeds, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ] <;> rfl

theorem leveque03_exercise33bPhasePlane :
    leveque03_exercise33bMiddle =
      leveque03_exercise33bLeft + (2 : ℝ) • leveque03_exercise33bVectors 1 ∧
    leveque03_exercise33bRight =
      leveque03_exercise33bMiddle + (2 : ℝ) • leveque03_exercise33bVectors 2 := by
  constructor <;> ext i <;> fin_cases i <;>
    dsimp [leveque03_exercise33bLeft, leveque03_exercise33bMiddle,
      leveque03_exercise33bRight, leveque03_exercise33bVectors,
      Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> norm_num

theorem leveque03_exercise33bSolution_weak (valueAtJump : Fin 3 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise33bSolution valueAtJump)
      leveque03_exercise33bA.mulVec := by
  exact finite_sum_isRectangleSolution leveque03_exercise33bA _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution leveque03_exercise33bA _
      (riemannData_intervalIntegrable _ _ _) _ _ (leveque03_exercise33bEigenpairs p))

theorem leveque03_exercise33bSolution_initial (valueAtJump : Fin 3 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise33bSolution valueAtJump x 0)
      leveque03_exercise33bLeft leveque03_exercise33bRight := by
  constructor
  · intro x hx
    ext i
    fin_cases i <;>
      norm_num [leveque03_exercise33bSolution, leveque03_exercise33bLeft,
        leveque03_exercise33bLeftCoeffs, leveque03_exercise33bRightCoeffs,
        leveque03_exercise33bVectors, leveque03_exercise33bSpeeds,
        eigenmodeTravelingWave, travelingWave, riemannData,
        Fin.sum_univ_succ, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt.mpr hx.le
    ext i
    fin_cases i <;>
      norm_num [leveque03_exercise33bSolution, leveque03_exercise33bRight,
        leveque03_exercise33bLeftCoeffs, leveque03_exercise33bRightCoeffs,
        leveque03_exercise33bVectors, leveque03_exercise33bSpeeds,
        eigenmodeTravelingWave, travelingWave, riemannData,
        Fin.sum_univ_succ, hnotLeft, hx]

theorem leveque03_exercise33bSolution_left (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : x < 2 * t) :
    leveque03_exercise33bSolution valueAtJump x t = leveque03_exercise33bLeft := by
  have hthree : x < 3 * t := by linarith
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33bSolution, leveque03_exercise33bLeft,
      leveque03_exercise33bLeftCoeffs, leveque03_exercise33bRightCoeffs,
      leveque03_exercise33bVectors, leveque03_exercise33bSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hx, hthree] <;> norm_num

theorem leveque03_exercise33bSolution_middle (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (hxlo : 2 * t < x) (hxhi : x < 3 * t) :
    leveque03_exercise33bSolution valueAtJump x t = leveque03_exercise33bMiddle := by
  have hone : 1 * t < x := by linarith
  have hnotTwo : ¬ x < 2 * t := not_lt.mpr hxlo.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33bSolution, leveque03_exercise33bMiddle,
      leveque03_exercise33bLeftCoeffs, leveque03_exercise33bRightCoeffs,
      leveque03_exercise33bVectors, leveque03_exercise33bSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hone, hnotTwo, hxlo, hxhi] <;> norm_num

theorem leveque03_exercise33bSolution_right (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : 3 * t < x) :
    leveque03_exercise33bSolution valueAtJump x t = leveque03_exercise33bRight := by
  have hone : t < x := by linarith
  have htwo : 2 * t < x := by linarith
  have hnotTwo : ¬ x < 2 * t := not_lt.mpr htwo.le
  have hnotThree : ¬ x < 3 * t := not_lt.mpr hx.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33bSolution, leveque03_exercise33bRight,
      leveque03_exercise33bLeftCoeffs, leveque03_exercise33bRightCoeffs,
      leveque03_exercise33bVectors, leveque03_exercise33bSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hone, htwo, hnotTwo, hnotThree, hx] <;> norm_num

end NumStability
