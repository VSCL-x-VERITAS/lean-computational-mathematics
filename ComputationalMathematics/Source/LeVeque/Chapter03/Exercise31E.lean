/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.1(e): repeated-speed Riemann jump

Printed page 62/raw PDF page 84. Both characteristic speeds equal 2.
-/

open MeasureTheory

namespace NumStability

def leveque03_exercise31eA : Matrix (Fin 2) (Fin 2) ℝ := Matrix.diagonal (fun _ => 2)
def leveque03_exercise31eLeft : Fin 2 → ℝ := ![0, 1]
def leveque03_exercise31eRight : Fin 2 → ℝ := ![1, 0]

noncomputable def leveque03_exercise31eSolution (valueAtJump : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  travelingWave (riemannData leveque03_exercise31eLeft valueAtJump leveque03_exercise31eRight) 2

theorem leveque03_exercise31eA_eigen (v : Fin 2 → ℝ) :
    leveque03_exercise31eA.mulVec v = (2 : ℝ) • v := by
  ext i
  simp [leveque03_exercise31eA, Matrix.mulVec_diagonal, Pi.smul_apply, smul_eq_mul]

theorem leveque03_exercise31e_phasePlane :
    leveque03_exercise31eRight = leveque03_exercise31eLeft + ![(1 : ℝ), -1] ∧
      leveque03_exercise31eA.mulVec (leveque03_exercise31eRight - leveque03_exercise31eLeft) =
        (2 : ℝ) • (leveque03_exercise31eRight - leveque03_exercise31eLeft) := by
  constructor
  · ext i
    fin_cases i <;> norm_num [leveque03_exercise31eLeft, leveque03_exercise31eRight]
  · exact leveque03_exercise31eA_eigen _

theorem leveque03_exercise31eSolution_initial (valueAtJump : Fin 2 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise31eSolution valueAtJump x 0)
      leveque03_exercise31eLeft leveque03_exercise31eRight := by
  simpa [leveque03_exercise31eSolution] using
    (riemannData_isRiemannData leveque03_exercise31eLeft valueAtJump leveque03_exercise31eRight)

theorem leveque03_exercise31eSolution_left (valueAtJump : Fin 2 → ℝ) (x t : ℝ)
    (hx : x < 2 * t) : leveque03_exercise31eSolution valueAtJump x t = leveque03_exercise31eLeft := by
  have hneg : x - 2 * t < 0 := sub_neg.mpr hx
  simp [leveque03_exercise31eSolution, travelingWave, riemannData, hneg]

theorem leveque03_exercise31eSolution_right (valueAtJump : Fin 2 → ℝ) (x t : ℝ)
    (hx : 2 * t < x) : leveque03_exercise31eSolution valueAtJump x t = leveque03_exercise31eRight := by
  have hpos : 0 < x - 2 * t := sub_pos.mpr hx
  have hnotLeft : ¬ x - 2 * t < 0 := not_lt_of_ge hpos.le
  simp [leveque03_exercise31eSolution, travelingWave, riemannData, hpos, hnotLeft]

theorem leveque03_exercise31eSolution_profile (valueAtJump : Fin 2 → ℝ) (x t : ℝ) :
    (x < 2 * t → leveque03_exercise31eSolution valueAtJump x t = ![0, 1]) ∧
      (2 * t < x → leveque03_exercise31eSolution valueAtJump x t = ![1, 0]) := by
  exact ⟨leveque03_exercise31eSolution_left valueAtJump x t,
    leveque03_exercise31eSolution_right valueAtJump x t⟩

theorem leveque03_exercise31eSolution_weak (valueAtJump : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise31eSolution valueAtJump)
      (fun state => leveque03_exercise31eA.mulVec state) := by
  have hflux : (fun state : Fin 2 → ℝ => leveque03_exercise31eA.mulVec state) =
      (fun state => (2 : ℝ) • state) := by
    funext state
    exact leveque03_exercise31eA_eigen state
  rw [hflux]
  exact travelingWave_isRectangleConservationLawSolution
    (riemannData leveque03_exercise31eLeft valueAtJump leveque03_exercise31eRight)
    (riemannData_intervalIntegrable leveque03_exercise31eLeft valueAtJump leveque03_exercise31eRight) 2

end NumStability
