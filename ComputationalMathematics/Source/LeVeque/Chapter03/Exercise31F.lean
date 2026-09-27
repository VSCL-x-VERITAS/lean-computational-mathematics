/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.ScalarRiemann

/-!
# Exercise 3.1(f): nearly parallel Riemann eigenvectors

Printed page 62/raw PDF page 84. The speeds are 199/100 and 201/100; the eigenvectors are nearly parallel.
-/


open MeasureTheory

namespace NumStability

/-- The coefficient matrix for Exercise 3.1(f). -/
noncomputable def leveque03_exercise31fA : Matrix (Fin 2) (Fin 2) ℝ := !![2, 1; 1 / 10000, 2]
/-- The characteristic speeds for Exercise 3.1(f). -/
noncomputable def leveque03_exercise31fSpeeds : Fin 2 → ℝ := ![199 / 100, 201 / 100]
/-- The right eigenvectors for Exercise 3.1(f). -/
def leveque03_exercise31fVectors : Fin 2 → (Fin 2 → ℝ) := ![![-100, 1], ![100, 1]]

/-- The solution field for Exercise 3.1(f). -/
noncomputable def leveque03_exercise31fSolution
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  fun x t => ∑ p : Fin 2,
    eigenmodeTravelingWave
      (riemannData (leftCoeff p) (originCoeff p) (rightCoeff p))
      (leveque03_exercise31fSpeeds p) (leveque03_exercise31fVectors p) x t

/-- The state reconstructed from characteristic coefficients for Exercise 3.1(f). -/
def leveque03_exercise31fState (coeff : Fin 2 → ℝ) : Fin 2 → ℝ :=
  ∑ p : Fin 2, coeff p • leveque03_exercise31fVectors p

/-- The intermediate state for Exercise 3.1(f). -/
def leveque03_exercise31fMiddleState (leftCoeff rightCoeff : Fin 2 → ℝ) : Fin 2 → ℝ :=
  rightCoeff 0 • leveque03_exercise31fVectors 0 + leftCoeff 1 • leveque03_exercise31fVectors 1

theorem leveque03_exercise31fEigenpairs (p : Fin 2) :
    leveque03_exercise31fA.mulVec (leveque03_exercise31fVectors p) =
      leveque03_exercise31fSpeeds p • leveque03_exercise31fVectors p := by
  funext i
  fin_cases p <;> fin_cases i <;>
    simp [leveque03_exercise31fA, leveque03_exercise31fVectors, leveque03_exercise31fSpeeds,
      Matrix.mulVec, dotProduct, Fin.sum_univ_succ] <;> norm_num

theorem leveque03_exercise31fSolution_weak
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution
      (leveque03_exercise31fSolution leftCoeff originCoeff rightCoeff)
      leveque03_exercise31fA.mulVec := by
  exact finite_sum_isRectangleSolution leveque03_exercise31fA _ (fun p =>
    eigenmodeTravelingWave_isRectangleSolution leveque03_exercise31fA _
      (riemannData_intervalIntegrable _ _ _) _ _ (leveque03_exercise31fEigenpairs p))

theorem leveque03_exercise31fSolution_initial
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ) :
    IsRiemannData
      (fun x => leveque03_exercise31fSolution leftCoeff originCoeff rightCoeff x 0)
      (leveque03_exercise31fState leftCoeff) (leveque03_exercise31fState rightCoeff) := by
  constructor
  · intro x hx
    ext i
    fin_cases i <;>
      simp [leveque03_exercise31fSolution, leveque03_exercise31fState, leveque03_exercise31fVectors,
        leveque03_exercise31fSpeeds, eigenmodeTravelingWave, travelingWave,
        riemannData, Fin.sum_univ_succ, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt.mpr hx.le
    ext i
    fin_cases i <;>
      simp [leveque03_exercise31fSolution, leveque03_exercise31fState, leveque03_exercise31fVectors,
        leveque03_exercise31fSpeeds, eigenmodeTravelingWave, travelingWave,
        riemannData, Fin.sum_univ_succ, hnotLeft, hx]

theorem leveque03_exercise31fSolution_left
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : x < (199 / 100) * t) :
    leveque03_exercise31fSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31fState leftCoeff := by
  have h0 : x - (199 / 100) * t < 0 := by linarith
  have h1 : x - (201 / 100) * t < 0 := by linarith
  have hleftRay : x < (199 / 100) * t := by linarith
  have hx1 : x < (201 / 100) * t := by linarith
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31fSolution, leveque03_exercise31fState, leveque03_exercise31fVectors,
      leveque03_exercise31fSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hleftRay, hx1]

theorem leveque03_exercise31fSolution_middle
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (hx0 : (199 / 100) * t < x) (hx1 : x < (201 / 100) * t) :
    leveque03_exercise31fSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31fMiddleState leftCoeff rightCoeff := by
  have hnotLeft : ¬ x < (199 / 100) * t := not_lt.mpr hx0.le
  have hleftRay : (199 / 100) * t < x := by linarith
  have hnotLeftRay : ¬ x < (199 / 100) * t := not_lt.mpr hleftRay.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31fSolution, leveque03_exercise31fMiddleState, leveque03_exercise31fVectors,
      leveque03_exercise31fSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hnotLeftRay, hleftRay, hx1]

theorem leveque03_exercise31fSolution_right
    (leftCoeff originCoeff rightCoeff : Fin 2 → ℝ)
    (x t : ℝ) (ht : 0 < t) (hx : (201 / 100) * t < x) :
    leveque03_exercise31fSolution leftCoeff originCoeff rightCoeff x t =
      leveque03_exercise31fState rightCoeff := by
  have hx0 : (199 / 100) * t < x := by linarith
  have hnotLeft : ¬ x < (199 / 100) * t := not_lt.mpr hx0.le
  have hleftRay : (199 / 100) * t < x := by linarith
  have hnotLeftRay : ¬ x < (199 / 100) * t := not_lt.mpr hleftRay.le
  have hnotRight : ¬ x < (201 / 100) * t := not_lt.mpr hx.le
  ext i
  fin_cases i <;>
    simp [leveque03_exercise31fSolution, leveque03_exercise31fState, leveque03_exercise31fVectors,
      leveque03_exercise31fSpeeds, eigenmodeTravelingWave, travelingWave,
      riemannData, Fin.sum_univ_succ, hnotLeftRay, hleftRay, hnotRight, hx]


/-- The left characteristic coefficients for Exercise 3.1(f). -/
noncomputable def leveque03_exercise31fLeftCoeffs : Fin 2 → ℝ := ![1 / 2, 1 / 2]
/-- The right characteristic coefficients for Exercise 3.1(f). -/
noncomputable def leveque03_exercise31fRightCoeffs : Fin 2 → ℝ := ![-1 / 200, 1 / 200]
/-- The Riemann solution field for Exercise 3.1(f). -/
noncomputable def leveque03_exercise31fRiemann (originCoeff : Fin 2 → ℝ) :
    ℝ → ℝ → (Fin 2 → ℝ) :=
  leveque03_exercise31fSolution leveque03_exercise31fLeftCoeffs originCoeff
    leveque03_exercise31fRightCoeffs

theorem leveque03_exercise31fStates :
    leveque03_exercise31fState leveque03_exercise31fLeftCoeffs = ![0, 1] ∧
      leveque03_exercise31fMiddleState leveque03_exercise31fLeftCoeffs
        leveque03_exercise31fRightCoeffs = ![101 / 2, 99 / 200] ∧
      leveque03_exercise31fState leveque03_exercise31fRightCoeffs = ![1, 0] := by
  constructor
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31fState, leveque03_exercise31fLeftCoeffs,
        leveque03_exercise31fVectors, Fin.sum_univ_succ, Pi.add_apply,
        Pi.smul_apply, smul_eq_mul] ;
        exact (show (-50 : ℝ) + 50 = 0 by norm_num)
  constructor
  · ext i
    fin_cases i <;>
      simp [leveque03_exercise31fMiddleState, leveque03_exercise31fLeftCoeffs,
        leveque03_exercise31fRightCoeffs, leveque03_exercise31fVectors,
        Pi.add_apply, smul_eq_mul] <;> norm_num
  · ext i
    fin_cases i <;>
      norm_num [leveque03_exercise31fState, leveque03_exercise31fRightCoeffs,
        leveque03_exercise31fVectors, Fin.sum_univ_succ, Pi.add_apply,
        Pi.smul_apply, smul_eq_mul]

theorem leveque03_exercise31fPhasePlane :
    ![(0 : ℝ), 1] + (-(101 / 200) : ℝ) • leveque03_exercise31fVectors 0 =
      ![101 / 2, 99 / 200] ∧
    ![(101 / 2 : ℝ), 99 / 200] + (-(99 / 200) : ℝ) •
      leveque03_exercise31fVectors 1 = ![1, 0] := by
  constructor <;> ext i <;> fin_cases i <;>
    norm_num [leveque03_exercise31fVectors, Pi.add_apply, Pi.smul_apply,
      smul_eq_mul] ; rfl

theorem leveque03_exercise31fRiemannProfile (originCoeff : Fin 2 → ℝ) :
    IsRiemannData (fun x => leveque03_exercise31fRiemann originCoeff x 0)
      ![0, 1] ![1, 0] ∧
    (∀ x t, 0 < t → x < (199 / 100) * t →
      leveque03_exercise31fRiemann originCoeff x t = ![0, 1]) ∧
    (∀ x t, 0 < t → (199 / 100) * t < x → x < (201 / 100) * t →
      leveque03_exercise31fRiemann originCoeff x t = ![101 / 2, 99 / 200]) ∧
    (∀ x t, 0 < t → (201 / 100) * t < x →
      leveque03_exercise31fRiemann originCoeff x t = ![1, 0]) := by
  rcases leveque03_exercise31fStates with ⟨hl, hm, hr⟩
  refine ⟨?_, ?_, ?_, ?_⟩
  · simpa only [leveque03_exercise31fRiemann, hl, hr] using
      (leveque03_exercise31fSolution_initial leveque03_exercise31fLeftCoeffs
        originCoeff leveque03_exercise31fRightCoeffs)
  · intro x t ht hx
    simpa only [leveque03_exercise31fRiemann, hl] using
      (leveque03_exercise31fSolution_left leveque03_exercise31fLeftCoeffs
        originCoeff leveque03_exercise31fRightCoeffs x t ht hx)
  · intro x t _ hx0 hx1
    simpa only [leveque03_exercise31fRiemann, hm] using
      (leveque03_exercise31fSolution_middle leveque03_exercise31fLeftCoeffs
        originCoeff leveque03_exercise31fRightCoeffs x t hx0 hx1)
  · intro x t ht hx
    simpa only [leveque03_exercise31fRiemann, hr] using
      (leveque03_exercise31fSolution_right leveque03_exercise31fLeftCoeffs
        originCoeff leveque03_exercise31fRightCoeffs x t ht hx)

theorem leveque03_exercise31fRiemann_weak (originCoeff : Fin 2 → ℝ) :
    IsRectangleConservationLawSolution (leveque03_exercise31fRiemann originCoeff)
      leveque03_exercise31fA.mulVec :=
  leveque03_exercise31fSolution_weak leveque03_exercise31fLeftCoeffs
    originCoeff leveque03_exercise31fRightCoeffs

end NumStability
