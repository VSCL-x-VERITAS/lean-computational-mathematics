/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.1(a) and (b): opposite Riemann jumps

Printed page 62/raw PDF page 84. The two characteristic speeds are -2 and 2.
-/


open MeasureTheory

namespace NumStability

def leveque03_exercise31abA : Matrix (Fin 2) (Fin 2) ℝ := !![0, 4; 1, 0]
def leveque03_exercise31abSpeeds : Fin 2 → ℝ := ![-2, 2]
def leveque03_exercise31abVectors : Fin 2 → (Fin 2 → ℝ) := ![![-2, 1], ![2, 1]]

noncomputable def leveque03_exercise31abSolution
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ∑ p : Fin 2,
    eigenmodeTravelingWave
      (riemannData (leftCoeff p) (originCoeff p) (rightCoeff p))
      (leveque03_exercise31abSpeeds p) (leveque03_exercise31abVectors p) x t

def leveque03_exercise31abState (coeff : Fin 2 → ℝ) : Fin 2 → ℝ :=
  ∑ p : Fin 2, coeff p • leveque03_exercise31abVectors p

def leveque03_exercise31abMiddleState (leftCoeff rightCoeff : Fin 2 → ℝ) : Fin 2 → ℝ :=
  rightCoeff 0 • leveque03_exercise31abVectors 0 + leftCoeff 1 • leveque03_exercise31abVectors 1

theorem leveque03_exercise31abEigenpairs (p : Fin 2) :
    leveque03_exercise31abA.mulVec (leveque03_exercise31abVectors p) =
      leveque03_exercise31abSpeeds p • leveque03_exercise31abVectors p := by
  funext i
  fin_cases p <;> fin_cases i <;>
    simp [leveque03_exercise31abA, leveque03_exercise31abVectors, leveque03_exercise31abSpeeds,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> norm_num

theorem leveque03_exercise31abSolution_weak
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution
      (leveque03_exercise31abSolution leftCoeff originCoeff rightCoeff)
      leveque03_exercise31abA.mulVec := by
  exact finite_sum_isRectangleSolution leveque03_exercise31abA _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution leveque03_exercise31abA _
      (riemannData_intervalIntegrable _ _ _) _ _ (leveque03_exercise31abEigenpairs p))

theorem leveque03_exercise31abSolution_initial
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    IsRiemannData
      (fun x => leveque03_exercise31abSolution leftCoeff originCoeff rightCoeff x 0)
      (leveque03_exercise31abState leftCoeff) (leveque03_exercise31abState rightCoeff) := by
  constructor
  · intro x hx
    ext i
    fin_cases i <;>
      simp [leveque03_exercise31abSolution, leveque03_exercise31abState, leveque03_exercise31abVectors,
        leveque03_exercise31abSpeeds, eigenmodeTravelingWave, travelingWave,
        riemannData, Fin.sum_univ_succ, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt.mpr hx.le
    ext i
    fin_cases i <;>
      simp [leveque03_exercise31abSolution, leveque03_exercise31abState, leveque03_exercise31abVectors,
        leveque03_exercise31abSpeeds, eigenmodeTravelingWave, travelingWave,
        riemannData, Fin.sum_univ_succ, hnotLeft, hx]

theorem leveque03_exercise31abSolution_left
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : x < -2 * t) :
    leveque03_exercise31abSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31abState leftCoeff := by
  have h0 : x - (-2) * t < 0 := by linarith
  have h1 : x - 2 * t < 0 := by linarith
  have hleftRay : x < -(2 * t) := by linarith
  have hx1 : x < 2 * t := by linarith
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31abSolution, leveque03_exercise31abState, leveque03_exercise31abVectors,
      leveque03_exercise31abSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hleftRay, hx1]

theorem leveque03_exercise31abSolution_middle
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (hx0 : -2 * t < x) (hx1 : x < 2 * t) :
    leveque03_exercise31abSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31abMiddleState leftCoeff rightCoeff := by
  have hnotLeft : ¬ x < -2 * t := not_lt.mpr hx0.le
  have hleftRay : -(2 * t) < x := by linarith
  have hnotLeftRay : ¬ x < -(2 * t) := not_lt.mpr hleftRay.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31abSolution, leveque03_exercise31abMiddleState, leveque03_exercise31abVectors,
      leveque03_exercise31abSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hnotLeftRay, hleftRay, hx1]

theorem leveque03_exercise31abSolution_right
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : 2 * t < x) :
    leveque03_exercise31abSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31abState rightCoeff := by
  have hx0 : -2 * t < x := by linarith
  have hnotLeft : ¬ x < -2 * t := not_lt.mpr hx0.le
  have hleftRay : -(2 * t) < x := by linarith
  have hnotLeftRay : ¬ x < -(2 * t) := not_lt.mpr hleftRay.le
  have hnotRight : ¬ x < 2 * t := not_lt.mpr hx.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31abSolution, leveque03_exercise31abState, leveque03_exercise31abVectors,
      leveque03_exercise31abSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hnotLeftRay, hleftRay, hnotRight, hx]

noncomputable def leveque03_exercise31aLeftCoeffs : Fin 2 → ℝ := ![1 / 2, 1 / 2]
noncomputable def leveque03_exercise31aRightCoeffs : Fin 2 → ℝ := ![1 / 4, 3 / 4]
noncomputable def leveque03_exercise31aSolution (originCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  leveque03_exercise31abSolution leveque03_exercise31aLeftCoeffs originCoeff leveque03_exercise31aRightCoeffs

theorem leveque03_exercise31aStates :
    leveque03_exercise31abState leveque03_exercise31aLeftCoeffs = ![0, 1] ∧
      leveque03_exercise31abMiddleState leveque03_exercise31aLeftCoeffs leveque03_exercise31aRightCoeffs = ![1 / 2, 3 / 4] ∧
      leveque03_exercise31abState leveque03_exercise31aRightCoeffs = ![1, 1] := by
  constructor
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31abState, leveque03_exercise31aLeftCoeffs, leveque03_exercise31abVectors,
        Fin.sum_univ_succ, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  constructor
  · ext i
    fin_cases i <;>
      simp [leveque03_exercise31abMiddleState, leveque03_exercise31aLeftCoeffs,
        leveque03_exercise31aRightCoeffs, leveque03_exercise31abVectors, Pi.add_apply, smul_eq_mul] <;>
        norm_num
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31abState, leveque03_exercise31aRightCoeffs, leveque03_exercise31abVectors,
        Fin.sum_univ_succ, Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> rfl

theorem leveque03_exercise31aPhasePlane :
    ![(0 : ℝ), 1] + (-(1 / 4) : ℝ) • leveque03_exercise31abVectors 0 = ![1 / 2, 3 / 4] ∧
      ![(1 / 2 : ℝ), 3 / 4] + (1 / 4 : ℝ) • leveque03_exercise31abVectors 1 = ![1, 1] := by
  constructor <;> ext i <;> fin_cases i <;>
    norm_num [leveque03_exercise31abVectors, Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> rfl

theorem leveque03_exercise31aRiemannProfile (originCoeff : Fin 2 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise31aSolution originCoeff x 0) ![0, 1] ![1, 1] ∧
      (∀ x t, 0 < t → x < -2 * t →
        leveque03_exercise31aSolution originCoeff x t = ![0, 1]) ∧
      (∀ x t, 0 < t → -2 * t < x → x < 2 * t →
        leveque03_exercise31aSolution originCoeff x t = ![1 / 2, 3 / 4]) ∧
      (∀ x t, 0 < t → 2 * t < x →
        leveque03_exercise31aSolution originCoeff x t = ![1, 1]) := by
  rcases leveque03_exercise31aStates with ⟨hl, hm, hr⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa only [leveque03_exercise31aSolution, hl, hr] using
      (leveque03_exercise31abSolution_initial leveque03_exercise31aLeftCoeffs originCoeff leveque03_exercise31aRightCoeffs)
  · intro x t ht hx
    simpa only [leveque03_exercise31aSolution, hl] using
      (leveque03_exercise31abSolution_left leveque03_exercise31aLeftCoeffs originCoeff leveque03_exercise31aRightCoeffs x t ht hx)
  · intro x t _ hx0 hx1
    simpa only [leveque03_exercise31aSolution, hm] using
      (leveque03_exercise31abSolution_middle leveque03_exercise31aLeftCoeffs originCoeff leveque03_exercise31aRightCoeffs x t hx0 hx1)
  · intro x t ht hx
    simpa only [leveque03_exercise31aSolution, hr] using
      (leveque03_exercise31abSolution_right leveque03_exercise31aLeftCoeffs originCoeff leveque03_exercise31aRightCoeffs x t ht hx)

theorem leveque03_exercise31aSolution_weak (originCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise31aSolution originCoeff)
      leveque03_exercise31abA.mulVec :=
  leveque03_exercise31abSolution_weak leveque03_exercise31aLeftCoeffs originCoeff leveque03_exercise31aRightCoeffs

noncomputable def leveque03_exercise31bLeftCoeffs : Fin 2 → ℝ := ![1 / 4, 3 / 4]
noncomputable def leveque03_exercise31bRightCoeffs : Fin 2 → ℝ := ![1 / 2, 1 / 2]
noncomputable def leveque03_exercise31bSolution (originCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  leveque03_exercise31abSolution leveque03_exercise31bLeftCoeffs originCoeff leveque03_exercise31bRightCoeffs

theorem leveque03_exercise31bStates :
    leveque03_exercise31abState leveque03_exercise31bLeftCoeffs = ![1, 1] ∧
      leveque03_exercise31abMiddleState leveque03_exercise31bLeftCoeffs leveque03_exercise31bRightCoeffs = ![1 / 2, 5 / 4] ∧
      leveque03_exercise31abState leveque03_exercise31bRightCoeffs = ![0, 1] := by
  constructor
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31abState, leveque03_exercise31bLeftCoeffs, leveque03_exercise31abVectors,
        Fin.sum_univ_succ, Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> rfl
  constructor
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31abMiddleState, leveque03_exercise31bLeftCoeffs,
        leveque03_exercise31bRightCoeffs, leveque03_exercise31abVectors, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31abState, leveque03_exercise31bRightCoeffs, leveque03_exercise31abVectors,
        Fin.sum_univ_succ, Pi.add_apply, Pi.smul_apply, smul_eq_mul]

theorem leveque03_exercise31bPhasePlane :
    ![(1 : ℝ), 1] + (1 / 4 : ℝ) • leveque03_exercise31abVectors 0 = ![1 / 2, 5 / 4] ∧
      ![(1 / 2 : ℝ), 5 / 4] + (-(1 / 4) : ℝ) • leveque03_exercise31abVectors 1 = ![0, 1] := by
  constructor <;> ext i <;> fin_cases i <;>
    norm_num [leveque03_exercise31abVectors, Pi.add_apply, Pi.smul_apply, smul_eq_mul] <;> rfl

theorem leveque03_exercise31bRiemannProfile (originCoeff : Fin 2 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise31bSolution originCoeff x 0) ![1, 1] ![0, 1] ∧
      (∀ x t, 0 < t → x < -2 * t →
        leveque03_exercise31bSolution originCoeff x t = ![1, 1]) ∧
      (∀ x t, 0 < t → -2 * t < x → x < 2 * t →
        leveque03_exercise31bSolution originCoeff x t = ![1 / 2, 5 / 4]) ∧
      (∀ x t, 0 < t → 2 * t < x →
        leveque03_exercise31bSolution originCoeff x t = ![0, 1]) := by
  rcases leveque03_exercise31bStates with ⟨hl, hm, hr⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa only [leveque03_exercise31bSolution, hl, hr] using
      (leveque03_exercise31abSolution_initial leveque03_exercise31bLeftCoeffs originCoeff leveque03_exercise31bRightCoeffs)
  · intro x t ht hx
    simpa only [leveque03_exercise31bSolution, hl] using
      (leveque03_exercise31abSolution_left leveque03_exercise31bLeftCoeffs originCoeff leveque03_exercise31bRightCoeffs x t ht hx)
  · intro x t _ hx0 hx1
    simpa only [leveque03_exercise31bSolution, hm] using
      (leveque03_exercise31abSolution_middle leveque03_exercise31bLeftCoeffs originCoeff leveque03_exercise31bRightCoeffs x t hx0 hx1)
  · intro x t ht hx
    simpa only [leveque03_exercise31bSolution, hr] using
      (leveque03_exercise31abSolution_right leveque03_exercise31bLeftCoeffs originCoeff leveque03_exercise31bRightCoeffs x t ht hx)

theorem leveque03_exercise31bSolution_weak (originCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise31bSolution originCoeff)
      leveque03_exercise31abA.mulVec :=
  leveque03_exercise31abSolution_weak leveque03_exercise31bLeftCoeffs originCoeff leveque03_exercise31bRightCoeffs

end NumStability
