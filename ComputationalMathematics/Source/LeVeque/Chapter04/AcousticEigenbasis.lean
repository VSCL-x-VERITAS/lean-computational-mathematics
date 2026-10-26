/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticFluxMatrices
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42AcousticShifts
import Mathlib.LinearAlgebra.Matrix.ToLinearEquiv
import Mathlib.LinearAlgebra.Basis.Defs
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: the physical acoustic eigenbasis

The existing acoustic eigenvector matrix gives a basis when its impedance
is nonzero. Its coordinate map is the inverse eigenvector matrix action.
-/

namespace NumStability

/-- The acoustic eigenvector matrix has nonzero determinant at nonzero
impedance. -/
theorem leveque04_acousticEigenvectorMatrix_det_ne_zero
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    (linearAcousticsEigenvectorMatrix density soundSpeed).det ≠ 0 := by
  have hdet : (linearAcousticsEigenvectorMatrix density soundSpeed).det =
      -2 * acousticImpedance density soundSpeed := by
    simp [linearAcousticsEigenvectorMatrix, acousticImpedance,
      Matrix.det_fin_two_of]
    ring
  rw [hdet]
  exact mul_ne_zero (by norm_num) himpedance

/-- The two acoustic eigenvectors, as an actual basis of pressure and
particle-velocity states. -/
noncomputable def leveque04_acousticEigenbasis
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    Module.Basis (Fin 2) ℝ (Fin 2 → ℝ) := by
  letI : Invertible (linearAcousticsEigenvectorMatrix density soundSpeed).det :=
    invertibleOfNonzero
      (leveque04_acousticEigenvectorMatrix_det_ne_zero density soundSpeed himpedance)
  letI : Invertible (linearAcousticsEigenvectorMatrix density soundSpeed) :=
    Matrix.invertibleOfDetInvertible _
  exact Module.Basis.ofEquivFun
    ((linearAcousticsEigenvectorMatrix density soundSpeed).toLinearEquiv'
      inferInstance).symm

/-- Each basis vector is the corresponding column of the existing
acoustic eigenvector matrix. -/
theorem leveque04_acousticEigenbasis_apply
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (p : Fin 2) :
    leveque04_acousticEigenbasis density soundSpeed himpedance p =
      (linearAcousticsEigenvectorMatrix density soundSpeed).mulVec
        (Pi.single p 1) := by
  unfold leveque04_acousticEigenbasis
  simp only [Module.Basis.coe_ofEquivFun, LinearEquiv.symm_symm]
  change Matrix.toLin' (linearAcousticsEigenvectorMatrix density soundSpeed)
      (Pi.single p 1) =
    (linearAcousticsEigenvectorMatrix density soundSpeed).mulVec
      (Pi.single p 1)
  exact Matrix.toLin'_apply _ _

/-- The first basis vector is the existing left acoustic eigenvector. -/
theorem leveque04_acousticEigenbasis_zero
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    leveque04_acousticEigenbasis density soundSpeed himpedance 0 =
      linearAcousticsLeftEigenvector density soundSpeed := by
  rw [leveque04_acousticEigenbasis_apply]
  ext k
  fin_cases k <;>
    simp [linearAcousticsEigenvectorMatrix,
      linearAcousticsLeftEigenvector, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two]

/-- The second basis vector is the existing right acoustic eigenvector. -/
theorem leveque04_acousticEigenbasis_one
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    leveque04_acousticEigenbasis density soundSpeed himpedance 1 =
      linearAcousticsRightEigenvector density soundSpeed := by
  rw [leveque04_acousticEigenbasis_apply]
  ext k
  fin_cases k <;>
    simp [linearAcousticsEigenvectorMatrix,
      linearAcousticsRightEigenvector, Matrix.mulVec,
      dotProduct, Fin.sum_univ_two]

/-- The physical convected acoustics matrix is diagonal in this basis,
with speeds `u₀-c` and `u₀+c`. -/
theorem leveque04_acousticEigenbasis_eigen
    (density soundSpeed backgroundVelocity : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (p : Fin 2) :
    (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2)
        density backgroundVelocity).mulVec
        (leveque04_acousticEigenbasis density soundSpeed himpedance p) =
      leveque04_acousticSpeeds backgroundVelocity soundSpeed p •
        leveque04_acousticEigenbasis density soundSpeed himpedance p := by
  have hdensity : density ≠ 0 := by
    intro h
    exact himpedance (by simp [acousticImpedance, h])
  fin_cases p
  · simpa [leveque04_acousticSpeeds,
      leveque04_acousticEigenbasis_zero] using
      convectedLinearAcousticsMatrix_mulVec_leftEigenvector
        (density * soundSpeed ^ 2) density soundSpeed
        backgroundVelocity hdensity rfl
  · simpa [leveque04_acousticSpeeds,
      leveque04_acousticEigenbasis_one] using
      convectedLinearAcousticsMatrix_mulVec_rightEigenvector
        (density * soundSpeed ^ 2) density soundSpeed
        backgroundVelocity hdensity rfl

/-- The physical convected acoustics matrix is real hyperbolic at
nonzero impedance. -/
theorem leveque04_acoustic_hyperbolic
    (density soundSpeed backgroundVelocity : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0) :
    IsRealHyperbolicMatrix
      (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2)
        density backgroundVelocity) := by
  exact ⟨leveque04_acousticSpeeds backgroundVelocity soundSpeed,
    leveque04_acousticEigenbasis density soundSpeed himpedance,
    leveque04_acousticEigenbasis_eigen density soundSpeed
      backgroundVelocity himpedance⟩

/-- The basis coordinates are the previously defined acoustic wave
strengths, obtained from the inverse eigenvector matrix. -/
theorem leveque04_acousticEigenbasis_coordinates
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (state : Fin 2 → ℝ) :
    (leveque04_acousticEigenbasis density soundSpeed himpedance).equivFun state =
      acousticWaveStrengths density soundSpeed (state 0) (state 1) := by
  letI : Invertible (linearAcousticsEigenvectorMatrix density soundSpeed).det :=
    invertibleOfNonzero
      (leveque04_acousticEigenvectorMatrix_det_ne_zero density soundSpeed himpedance)
  letI : Invertible (linearAcousticsEigenvectorMatrix density soundSpeed) :=
    Matrix.invertibleOfDetInvertible _
  unfold leveque04_acousticEigenbasis acousticWaveStrengths
  simp only [Module.Basis.equivFun_ofEquivFun]
  rw [← leveque04_acousticEigenvectorMatrix_inverse density soundSpeed himpedance]
  change ((linearAcousticsEigenvectorMatrix density soundSpeed).toLinearEquiv'
      inferInstance).symm state =
    (linearAcousticsEigenvectorMatrix density soundSpeed)⁻¹.mulVec
      ![state 0, state 1]
  rw [show ![state 0, state 1] = state by ext k; fin_cases k <;> rfl]
  rw [← Matrix.invOf_eq_nonsing_inv]
  exact congrArg (fun f : Module.End ℝ (Fin 2 → ℝ) => f state)
    ((linearAcousticsEigenvectorMatrix density soundSpeed).toLinearEquiv'_symm_apply
      inferInstance)

/-- Explicit characteristic coordinates of a pressure--velocity state. -/
theorem leveque04_acousticEigenbasis_characteristics
    (density soundSpeed : ℝ)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (state : Fin 2 → ℝ) :
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let Z := acousticImpedance density soundSpeed
    basis.equivFun state 0 = (-state 0 + Z * state 1) / (2 * Z) ∧
      basis.equivFun state 1 = (state 0 + Z * state 1) / (2 * Z) := by
  dsimp only
  rw [leveque04_acousticEigenbasis_coordinates]
  have h := Leveque02Tracer.acousticWaveStrengthsFormula
    density soundSpeed (state 0) (state 1) himpedance
  rw [h]
  exact ⟨rfl, rfl⟩

/-- The basis coordinates are scaled versions of the two physical
pressure--velocity characteristic combinations. -/
theorem leveque04_acousticEigenbasis_characteristicForms
    (density soundSpeed : ℝ)
    (himpedance : 0 < acousticImpedance density soundSpeed)
    (state : Fin 2 → ℝ) :
    let basis := leveque04_acousticEigenbasis density soundSpeed
      (ne_of_gt himpedance)
    let Z := acousticImpedance density soundSpeed
    basis.equivFun state 0 =
        -leveque04_acousticLeftCharacteristic Z state / (2 * Z) ∧
      basis.equivFun state 1 =
        leveque04_acousticRightCharacteristic Z state / (2 * Z) := by
  obtain ⟨hleft, hright⟩ :=
    leveque04_acousticEigenbasis_characteristics density soundSpeed
      himpedance state
  dsimp only at hleft hright ⊢
  constructor
  · rw [hleft]
    simp [leveque04_acousticLeftCharacteristic]
    ring
  · rw [hright]
    rfl

end NumStability
