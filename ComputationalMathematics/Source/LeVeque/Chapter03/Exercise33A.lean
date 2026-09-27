/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.RiemannThreeFamily
import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.3(a): a three-family Riemann fan

Printed page 62/raw PDF page 84. All three families have nonzero strength; the
state changes cross the speed-minus-two, speed-one, and speed-two rays.
-/

open MeasureTheory

namespace NumStability

/-- The coefficient matrix for Exercise 3.3(a). -/
def leveque03_exercise33aA : Matrix (Fin 3) (Fin 3) ℝ :=
  !![0, 0, 4; 0, 1, 0; 1, 0, 0]

/-- The characteristic speeds for Exercise 3.3(a). -/
def leveque03_exercise33aSpeeds : Fin 3 → ℝ := ![-2, 1, 2]

/-- The right eigenvectors for Exercise 3.3(a). -/
def leveque03_exercise33aVectors : Fin 3 → (Fin 3 → ℝ) :=
  ![![-2, 0, 1], ![0, 1, 0], ![2, 0, 1]]

/-- The left state for Exercise 3.3(a). -/
def leveque03_exercise33aLeft : Fin 3 → ℝ := ![1, 2, 0]
/-- The first intermediate state for Exercise 3.3(a). -/
noncomputable def leveque03_exercise33aMiddle1 : Fin 3 → ℝ := ![0, 2, 1 / 2]
/-- The second intermediate state for Exercise 3.3(a). -/
noncomputable def leveque03_exercise33aMiddle2 : Fin 3 → ℝ := ![0, 5, 1 / 2]
/-- The right state for Exercise 3.3(a). -/
def leveque03_exercise33aRight : Fin 3 → ℝ := ![1, 5, 1]
/-- The left characteristic coefficients for Exercise 3.3(a). -/
noncomputable def leveque03_exercise33aLeftCoeffs : Fin 3 → ℝ := ![-1 / 4, 2, 1 / 4]
/-- The right characteristic coefficients for Exercise 3.3(a). -/
noncomputable def leveque03_exercise33aRightCoeffs : Fin 3 → ℝ := ![1 / 4, 5, 3 / 4]

/-- The solution field for Exercise 3.3(a). -/
noncomputable def leveque03_exercise33aSolution (valueAtJump : Fin 3 → ℝ) :
    ℝ → ℝ → (Fin 3 → ℝ) :=
  fun x t => ∑ p : Fin 3,
    eigenmodeTravelingWave
      (riemannData (leveque03_exercise33aLeftCoeffs p)
        (valueAtJump p)
        (leveque03_exercise33aRightCoeffs p))
      (leveque03_exercise33aSpeeds p) (leveque03_exercise33aVectors p) x t

theorem leveque03_exercise33aEigenpairs (p : Fin 3) :
    leveque03_exercise33aA.mulVec (leveque03_exercise33aVectors p) =
      leveque03_exercise33aSpeeds p • leveque03_exercise33aVectors p := by
  funext i
  fin_cases p <;> fin_cases i <;>
    norm_num [leveque03_exercise33aA, leveque03_exercise33aVectors,
      leveque03_exercise33aSpeeds, Matrix.mulVec, dotProduct,
      Fin.sum_univ_succ] ;
      exact (show (0 : ℝ) + 4 = 4 by norm_num)

theorem leveque03_exercise33aPhasePlane :
    leveque03_exercise33aMiddle1 =
      leveque03_exercise33aLeft + (1 / 2 : ℝ) • leveque03_exercise33aVectors 0 ∧
    leveque03_exercise33aMiddle2 =
      leveque03_exercise33aMiddle1 + (3 : ℝ) • leveque03_exercise33aVectors 1 ∧
    leveque03_exercise33aRight =
      leveque03_exercise33aMiddle2 + (1 / 2 : ℝ) • leveque03_exercise33aVectors 2 := by
  constructor
  · ext i
    fin_cases i <;>
      dsimp [leveque03_exercise33aLeft, leveque03_exercise33aMiddle1,
        leveque03_exercise33aVectors, Pi.add_apply, Pi.smul_apply]
        <;> norm_num ; rfl
  constructor
  · ext i
    fin_cases i <;>
      dsimp [leveque03_exercise33aMiddle1, leveque03_exercise33aMiddle2,
        leveque03_exercise33aVectors, Pi.add_apply, Pi.smul_apply]
        <;> norm_num
  · ext i
    fin_cases i <;>
      dsimp [leveque03_exercise33aMiddle2, leveque03_exercise33aRight,
        leveque03_exercise33aVectors, Pi.add_apply, Pi.smul_apply]
        <;> norm_num <;> rfl

theorem leveque03_exercise33aSolution_weak (valueAtJump : Fin 3 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise33aSolution valueAtJump)
      leveque03_exercise33aA.mulVec := by
  exact finite_sum_isRectangleSolution leveque03_exercise33aA _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution leveque03_exercise33aA _
      (riemannData_intervalIntegrable _ _ _) _ _ (leveque03_exercise33aEigenpairs p))

theorem leveque03_exercise33aSolution_initial (valueAtJump : Fin 3 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise33aSolution valueAtJump x 0)
      leveque03_exercise33aLeft leveque03_exercise33aRight := by
  constructor
  · intro x hx
    ext i
    fin_cases i <;>
      norm_num [leveque03_exercise33aSolution, leveque03_exercise33aLeft,
        leveque03_exercise33aLeftCoeffs, leveque03_exercise33aRightCoeffs,
        leveque03_exercise33aVectors, leveque03_exercise33aSpeeds,
        eigenmodeTravelingWave, travelingWave, riemannData,
        Fin.sum_univ_succ, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt.mpr hx.le
    ext i
    fin_cases i <;>
      norm_num [leveque03_exercise33aSolution, leveque03_exercise33aRight,
        leveque03_exercise33aLeftCoeffs, leveque03_exercise33aRightCoeffs,
        leveque03_exercise33aVectors, leveque03_exercise33aSpeeds,
        eigenmodeTravelingWave, travelingWave, riemannData,
        Fin.sum_univ_succ, hnotLeft, hx] <;> rfl

theorem leveque03_exercise33aSolution_left (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : x < -2 * t) :
    leveque03_exercise33aSolution valueAtJump x t = leveque03_exercise33aLeft := by
  have hone : x < t := by linarith
  have htwo : x < 2 * t := by linarith
  have hslowRay : x < -(2 * t) := by linarith
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33aSolution, leveque03_exercise33aLeft,
      leveque03_exercise33aLeftCoeffs, leveque03_exercise33aRightCoeffs,
      leveque03_exercise33aVectors, leveque03_exercise33aSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hslowRay, hone, htwo] <;> norm_num

theorem leveque03_exercise33aSolution_firstWedge (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hxlo : -2 * t < x) (hxhi : x < t) :
    leveque03_exercise33aSolution valueAtJump x t = leveque03_exercise33aMiddle1 := by
  have htwo : x < 2 * t := by linarith
  have hnotSlow : ¬ x < -2 * t := not_lt.mpr hxlo.le
  have hslowRay : -(2 * t) < x := by linarith
  have hnotSlowRay : ¬ x < -(2 * t) := not_lt.mpr hslowRay.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33aSolution, leveque03_exercise33aMiddle1,
      leveque03_exercise33aLeftCoeffs, leveque03_exercise33aRightCoeffs,
      leveque03_exercise33aVectors, leveque03_exercise33aSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hslowRay, hnotSlowRay, hxhi, htwo]
      ; norm_num

@[nolint unusedArguments]
theorem leveque03_exercise33aSolution_secondWedge (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (_ht : 0 < t) (hxlo : t < x) (hxhi : x < 2 * t) :
    leveque03_exercise33aSolution valueAtJump x t = leveque03_exercise33aMiddle2 := by
  have hslow : -2 * t < x := by linarith
  have hslowRay : -(2 * t) < x := by linarith
  have hnotSlow : ¬ x < -2 * t := not_lt.mpr hslow.le
  have hnotSlowRay : ¬ x < -(2 * t) := not_lt.mpr hslowRay.le
  have hnotOne : ¬ x < t := not_lt.mpr hxlo.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33aSolution, leveque03_exercise33aMiddle2,
      leveque03_exercise33aLeftCoeffs, leveque03_exercise33aRightCoeffs,
      leveque03_exercise33aVectors, leveque03_exercise33aSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hslowRay, hnotSlowRay,
      hxlo, hxhi, hnotOne]
      ; norm_num

theorem leveque03_exercise33aSolution_right (valueAtJump : Fin 3 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : 2 * t < x) :
    leveque03_exercise33aSolution valueAtJump x t = leveque03_exercise33aRight := by
  have hslow : -2 * t < x := by linarith
  have hslowRay : -(2 * t) < x := by linarith
  have hone : t < x := by linarith
  have hnotSlow : ¬ x < -2 * t := not_lt.mpr hslow.le
  have hnotSlowRay : ¬ x < -(2 * t) := not_lt.mpr hslowRay.le
  have hnotOne : ¬ x < t := not_lt.mpr hone.le
  have hnotTwo : ¬ x < 2 * t := not_lt.mpr hx.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise33aSolution, leveque03_exercise33aRight,
      leveque03_exercise33aLeftCoeffs, leveque03_exercise33aRightCoeffs,
      leveque03_exercise33aVectors, leveque03_exercise33aSpeeds,
      eigenmodeTravelingWave, travelingWave, riemannData,
      Fin.sum_univ_succ, hslowRay, hnotSlowRay,
      hone, hx, hnotOne, hnotTwo]
      <;> norm_num

end NumStability
