/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticAdvection
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics

/-!
# Acoustic characteristic strengths from arbitrary initial data

Equation (3.12), printed page 50/raw PDF page 72. The two initial acoustic
strengths travel in opposite directions. The construction and its initial
state are defined for arbitrary profiles; classical PDE assertions require
additional regularity.
-/

namespace NumStability

/-- Assemble the acoustic state from the two translated initial strengths. -/
noncomputable def leveque03_acousticInitialDataSolution
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (x t : ℝ) : Fin 2 → ℝ :=
  (linearAcousticsEigenvectorMatrix density soundSpeed).mulVec
    ![acousticWaveStrengths density soundSpeed
        (initialPressure (x + soundSpeed * t))
        (initialVelocity (x + soundSpeed * t)) 0,
      acousticWaveStrengths density soundSpeed
        (initialPressure (x - soundSpeed * t))
        (initialVelocity (x - soundSpeed * t)) 1]

/-- The fixed inverse eigenvector matrix recovers precisely the two translated
initial strengths from the assembled state. -/
theorem leveque03_acousticInitialDataSolution_strengths
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) (x t : ℝ) :
    acousticWaveStrengths density soundSpeed
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity x t 0)
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity x t 1) =
    ![acousticWaveStrengths density soundSpeed
        (initialPressure (x + soundSpeed * t))
        (initialVelocity (x + soundSpeed * t)) 0,
      acousticWaveStrengths density soundSpeed
        (initialPressure (x - soundSpeed * t))
        (initialVelocity (x - soundSpeed * t)) 1] := by
  let R := linearAcousticsEigenvectorMatrix density soundSpeed
  let w : Fin 2 → ℝ :=
    ![acousticWaveStrengths density soundSpeed
        (initialPressure (x + soundSpeed * t))
        (initialVelocity (x + soundSpeed * t)) 0,
      acousticWaveStrengths density soundSpeed
        (initialPressure (x - soundSpeed * t))
        (initialVelocity (x - soundSpeed * t)) 1]
  have hfull := Leveque02Tracer.acousticEigenvectorMatrixNonsingular
    density soundSpeed hZ
  have hunit : IsUnit R.det := isUnit_iff_ne_zero.mpr hfull.1
  change (linearAcousticsEigenvectorMatrixInverse density soundSpeed).mulVec
    (R.mulVec w) = w
  rw [← hfull.2, Matrix.mulVec_mulVec, Matrix.nonsing_inv_mul R hunit,
    Matrix.one_mulVec]

/-- Equation (3.12) for both ordered acoustic wave strengths. -/
theorem leveque03_acousticInitialDataSolution_characteristicFormula
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) (x t : ℝ) :
    acousticWaveStrengths density soundSpeed
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity x t 0)
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity x t 1) 0 =
      acousticWaveStrengths density soundSpeed
        (initialPressure (x + soundSpeed * t))
        (initialVelocity (x + soundSpeed * t)) 0 ∧
    acousticWaveStrengths density soundSpeed
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity x t 0)
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity x t 1) 1 =
      acousticWaveStrengths density soundSpeed
        (initialPressure (x - soundSpeed * t))
        (initialVelocity (x - soundSpeed * t)) 1 := by
  have h := leveque03_acousticInitialDataSolution_strengths
    density soundSpeed initialPressure initialVelocity hZ x t
  exact ⟨congrFun h 0, congrFun h 1⟩

/-- At time zero, the assembled state equals the prescribed pressure and
velocity for every initial profile. -/
theorem leveque03_acousticInitialDataSolution_initial
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) (x : ℝ) :
    leveque03_acousticInitialDataSolution density soundSpeed
      initialPressure initialVelocity x 0 =
    ![initialPressure x, initialVelocity x] := by
  let R := linearAcousticsEigenvectorMatrix density soundSpeed
  have hfull := Leveque02Tracer.acousticEigenvectorMatrixNonsingular
    density soundSpeed hZ
  have hunit : IsUnit R.det := isUnit_iff_ne_zero.mpr hfull.1
  have hrec : R.mulVec (acousticWaveStrengths density soundSpeed
      (initialPressure x) (initialVelocity x)) =
      ![initialPressure x, initialVelocity x] := by
    change R.mulVec ((linearAcousticsEigenvectorMatrixInverse density soundSpeed).mulVec
      ![initialPressure x, initialVelocity x]) = _
    rw [← hfull.2, Matrix.mulVec_mulVec, Matrix.mul_nonsing_inv R hunit,
      Matrix.one_mulVec]
  simpa [leveque03_acousticInitialDataSolution, R] using hrec

/-- Every jointly differentiable acoustic solution has the translated
strengths in (3.12). This characterization complements the arbitrary-data
construction above. -/
theorem leveque03_acousticCharacteristicProfiles
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density soundSpeed : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2)
    (hpde : ∀ x t, IsLinearAcousticsSolutionAt
      pressure velocity bulkModulus density x t)
    (hdiffp : Differentiable ℝ (Function.uncurry pressure))
    (hdiffu : Differentiable ℝ (Function.uncurry velocity)) :
    ∀ x t,
      (acousticWaveStrengths density soundSpeed
        (pressure x t) (velocity x t) 0 =
        acousticWaveStrengths density soundSpeed
          (pressure (x + soundSpeed * t) 0)
          (velocity (x + soundSpeed * t) 0) 0) ∧
      (acousticWaveStrengths density soundSpeed
        (pressure x t) (velocity x t) 1 =
        acousticWaveStrengths density soundSpeed
          (pressure (x - soundSpeed * t) 0)
          (velocity (x - soundSpeed * t) 0) 1) := by
  let wL : ℝ → ℝ → ℝ := fun x t =>
    acousticWaveStrengths density soundSpeed (pressure x t) (velocity x t) 0
  let wR : ℝ → ℝ → ℝ := fun x t =>
    acousticWaveStrengths density soundSpeed (pressure x t) (velocity x t) 1
  let Z := acousticImpedance density soundSpeed
  have hLformula : Function.uncurry wL =
      fun xt => (-pressure xt.1 xt.2 + Z * velocity xt.1 xt.2) / (2 * Z) := by
    funext ⟨x, t⟩
    simpa [wL, Z, Function.uncurry] using
      (congrFun (Leveque02Tracer.acousticWaveStrengthsFormula
        density soundSpeed (pressure x t) (velocity x t) hZ) 0)
  have hRformula : Function.uncurry wR =
      fun xt => (pressure xt.1 xt.2 + Z * velocity xt.1 xt.2) / (2 * Z) := by
    funext ⟨x, t⟩
    simpa [wR, Z, Function.uncurry] using
      (congrFun (Leveque02Tracer.acousticWaveStrengthsFormula
        density soundSpeed (pressure x t) (velocity x t) hZ) 1)
  have hLdiff : Differentiable ℝ (Function.uncurry wL) := by
    rw [hLformula]
    simpa only [div_eq_mul_inv, Function.uncurry_apply_pair,
      Pi.add_apply, Pi.neg_apply, Pi.mul_apply] using
      (hdiffp.neg.add (hdiffu.const_mul Z)).mul_const (2 * Z)⁻¹
  have hRdiff : Differentiable ℝ (Function.uncurry wR) := by
    rw [hRformula]
    simpa only [div_eq_mul_inv, Function.uncurry_apply_pair,
      Pi.add_apply, Pi.mul_apply] using
      (hdiffp.add (hdiffu.const_mul Z)).mul_const (2 * Z)⁻¹
  have hLadv : ∀ x t, IsLinearAdvectionSolutionAt wL (-soundSpeed) x t := by
    intro x t
    exact (leveque03_acousticCharacteristicAdvection pressure velocity
      bulkModulus density soundSpeed x t hZ hmaterial (hpde x t)).1
  have hRadv : ∀ x t, IsLinearAdvectionSolutionAt wR soundSpeed x t := by
    intro x t
    exact (leveque03_acousticCharacteristicAdvection pressure velocity
      bulkModulus density soundSpeed x t hZ hmaterial (hpde x t)).2
  have hLprop := linearAdvection_eq_travelingWave_of_differentiable
    hLdiff hLadv
  have hRprop := linearAdvection_eq_travelingWave_of_differentiable
    hRdiff hRadv
  intro x t
  constructor
  · have h := congrFun (congrFun hLprop x) t
    simpa [wL, travelingWave] using h
  · have h := congrFun (congrFun hRprop x) t
    simpa [wR, travelingWave] using h

end NumStability
