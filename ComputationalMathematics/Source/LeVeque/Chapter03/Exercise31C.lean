/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.1(c): Riemann jumps for a second acoustic matrix

Printed page 62/raw PDF page 84. The two characteristic speeds are -3 and 3.
-/


open MeasureTheory

namespace NumStability

def leveque03_exercise31cA : Matrix (Fin 2) (Fin 2) ℝ := !![0, 9; 1, 0]
def leveque03_exercise31cSpeeds : Fin 2 → ℝ := ![-3, 3]
def leveque03_exercise31cVectors : Fin 2 → (Fin 2 → ℝ) := ![![-3, 1], ![3, 1]]

noncomputable def leveque03_exercise31cSolution
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ∑ p : Fin 2,
    eigenmodeTravelingWave
      (riemannData (leftCoeff p) (originCoeff p) (rightCoeff p))
      (leveque03_exercise31cSpeeds p) (leveque03_exercise31cVectors p) x t

def leveque03_exercise31cState (coeff : Fin 2 → ℝ) : Fin 2 → ℝ :=
  ∑ p : Fin 2, coeff p • leveque03_exercise31cVectors p

def leveque03_exercise31cMiddleState (leftCoeff rightCoeff : Fin 2 → ℝ) : Fin 2 → ℝ :=
  rightCoeff 0 • leveque03_exercise31cVectors 0 + leftCoeff 1 • leveque03_exercise31cVectors 1

theorem leveque03_exercise31cEigenpairs (p : Fin 2) :
    leveque03_exercise31cA.mulVec (leveque03_exercise31cVectors p) =
      leveque03_exercise31cSpeeds p • leveque03_exercise31cVectors p := by
  funext i
  fin_cases p <;> fin_cases i <;>
    simp [leveque03_exercise31cA, leveque03_exercise31cVectors, leveque03_exercise31cSpeeds,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> norm_num

theorem leveque03_exercise31cSolution_weak
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution
      (leveque03_exercise31cSolution leftCoeff originCoeff rightCoeff)
      leveque03_exercise31cA.mulVec := by
  exact finite_sum_isRectangleSolution leveque03_exercise31cA _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution leveque03_exercise31cA _
      (riemannData_intervalIntegrable _ _ _) _ _ (leveque03_exercise31cEigenpairs p))

theorem leveque03_exercise31cSolution_initial
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    IsRiemannData
      (fun x => leveque03_exercise31cSolution leftCoeff originCoeff rightCoeff x 0)
      (leveque03_exercise31cState leftCoeff) (leveque03_exercise31cState rightCoeff) := by
  constructor
  · intro x hx
    ext i
    fin_cases i <;>
      simp [leveque03_exercise31cSolution, leveque03_exercise31cState, leveque03_exercise31cVectors,
        leveque03_exercise31cSpeeds, eigenmodeTravelingWave, travelingWave,
        riemannData, Fin.sum_univ_succ, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt.mpr hx.le
    ext i
    fin_cases i <;>
      simp [leveque03_exercise31cSolution, leveque03_exercise31cState, leveque03_exercise31cVectors,
        leveque03_exercise31cSpeeds, eigenmodeTravelingWave, travelingWave,
        riemannData, Fin.sum_univ_succ, hnotLeft, hx]

theorem leveque03_exercise31cSolution_left
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : x < -3 * t) :
    leveque03_exercise31cSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31cState leftCoeff := by
  have h0 : x - (-3) * t < 0 := by linarith
  have h1 : x - 3 * t < 0 := by linarith
  have hleftRay : x < -(3 * t) := by linarith
  have hx1 : x < 3 * t := by linarith
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31cSolution, leveque03_exercise31cState, leveque03_exercise31cVectors,
      leveque03_exercise31cSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hleftRay, hx1]

theorem leveque03_exercise31cSolution_middle
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (hx0 : -3 * t < x) (hx1 : x < 3 * t) :
    leveque03_exercise31cSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31cMiddleState leftCoeff rightCoeff := by
  have hnotLeft : ¬ x < -3 * t := not_lt.mpr hx0.le
  have hleftRay : -(3 * t) < x := by linarith
  have hnotLeftRay : ¬ x < -(3 * t) := not_lt.mpr hleftRay.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31cSolution, leveque03_exercise31cMiddleState, leveque03_exercise31cVectors,
      leveque03_exercise31cSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hnotLeftRay, hleftRay, hx1]

theorem leveque03_exercise31cSolution_right
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : 3 * t < x) :
    leveque03_exercise31cSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31cState rightCoeff := by
  have hx0 : -3 * t < x := by linarith
  have hnotLeft : ¬ x < -3 * t := not_lt.mpr hx0.le
  have hleftRay : -(3 * t) < x := by linarith
  have hnotLeftRay : ¬ x < -(3 * t) := not_lt.mpr hleftRay.le
  have hnotRight : ¬ x < 3 * t := not_lt.mpr hx.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31cSolution, leveque03_exercise31cState, leveque03_exercise31cVectors,
      leveque03_exercise31cSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hnotLeftRay, hleftRay, hnotRight, hx]

noncomputable def leveque03_exercise31cLeftCoeffs : Fin 2 → ℝ := ![-1 / 6, 1 / 6]
noncomputable def leveque03_exercise31cRightCoeffs : Fin 2 → ℝ := ![-2 / 3, 2 / 3]
noncomputable def leveque03_exercise31cRiemann (originCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  leveque03_exercise31cSolution leveque03_exercise31cLeftCoeffs originCoeff
    leveque03_exercise31cRightCoeffs

theorem leveque03_exercise31cStates :
    leveque03_exercise31cState leveque03_exercise31cLeftCoeffs = ![1, 0] ∧
      leveque03_exercise31cMiddleState leveque03_exercise31cLeftCoeffs
        leveque03_exercise31cRightCoeffs = ![5 / 2, -(1 / 2)] ∧
      leveque03_exercise31cState leveque03_exercise31cRightCoeffs = ![4, 0] := by
  constructor
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31cState, leveque03_exercise31cLeftCoeffs,
        leveque03_exercise31cVectors, Fin.sum_univ_succ, Pi.add_apply,
        Pi.smul_apply, smul_eq_mul]
  constructor
  · ext i
    fin_cases i <;>
      simp [leveque03_exercise31cMiddleState, leveque03_exercise31cLeftCoeffs,
        leveque03_exercise31cRightCoeffs, leveque03_exercise31cVectors,
        Pi.add_apply, smul_eq_mul] <;> norm_num
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31cState, leveque03_exercise31cRightCoeffs,
        leveque03_exercise31cVectors, Fin.sum_univ_succ, Pi.add_apply,
        Pi.smul_apply, smul_eq_mul] <;>
        exact (show (2 : ℝ) + 2 = 4 by norm_num)

theorem leveque03_exercise31cPhasePlane :
    ![(1 : ℝ), 0] + (-(1 / 2) : ℝ) • leveque03_exercise31cVectors 0 =
      ![5 / 2, -(1 / 2)] ∧
    ![(5 / 2 : ℝ), -(1 / 2)] + (1 / 2 : ℝ) • leveque03_exercise31cVectors 1 =
      ![4, 0] := by
  constructor <;> ext i <;> fin_cases i <;>
    norm_num [leveque03_exercise31cVectors, Pi.add_apply, Pi.smul_apply,
      smul_eq_mul] <;> rfl

theorem leveque03_exercise31cRiemannProfile (originCoeff : Fin 2 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise31cRiemann originCoeff x 0)
      ![1, 0] ![4, 0] ∧
    (∀ x t, 0 < t → x < -3 * t →
      leveque03_exercise31cRiemann originCoeff x t = ![1, 0]) ∧
    (∀ x t, 0 < t → -3 * t < x → x < 3 * t →
      leveque03_exercise31cRiemann originCoeff x t = ![5 / 2, -(1 / 2)]) ∧
    (∀ x t, 0 < t → 3 * t < x →
      leveque03_exercise31cRiemann originCoeff x t = ![4, 0]) := by
  rcases leveque03_exercise31cStates with ⟨hl, hm, hr⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa only [leveque03_exercise31cRiemann, hl, hr] using
      (leveque03_exercise31cSolution_initial leveque03_exercise31cLeftCoeffs
        originCoeff leveque03_exercise31cRightCoeffs)
  · intro x t ht hx
    simpa only [leveque03_exercise31cRiemann, hl] using
      (leveque03_exercise31cSolution_left leveque03_exercise31cLeftCoeffs
        originCoeff leveque03_exercise31cRightCoeffs x t ht hx)
  · intro x t _ hx0 hx1
    simpa only [leveque03_exercise31cRiemann, hm] using
      (leveque03_exercise31cSolution_middle leveque03_exercise31cLeftCoeffs
        originCoeff leveque03_exercise31cRightCoeffs x t hx0 hx1)
  · intro x t ht hx
    simpa only [leveque03_exercise31cRiemann, hr] using
      (leveque03_exercise31cSolution_right leveque03_exercise31cLeftCoeffs
        originCoeff leveque03_exercise31cRightCoeffs x t ht hx)

theorem leveque03_exercise31cRiemann_weak (originCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise31cRiemann originCoeff)
      leveque03_exercise31cA.mulVec :=
  leveque03_exercise31cSolution_weak leveque03_exercise31cLeftCoeffs
    originCoeff leveque03_exercise31cRightCoeffs

end NumStability
