/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticSimpleWave
import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves

/-!
# The page 50 acoustic initial-data example

Equation (3.13) and the accompanying material and pure-wave relations,
printed page 50/raw PDF page 72.
-/

namespace NumStability

/-- The open-interval unit step `S` in (3.13). -/
noncomputable def leveque03_acousticExampleStep (x : ℝ) : ℝ :=
  if (-3 / 10 : ℝ) < x ∧ x < (-1 / 10 : ℝ) then 1 else 0

/-- The initial pressure in (3.13). -/
noncomputable def leveque03_acousticExamplePressure (x : ℝ) : ℝ :=
  Real.exp (-80 * x ^ 2) / 2 + leveque03_acousticExampleStep x

/-- The initially zero velocity in (3.13). -/
def leveque03_acousticExampleVelocity (_x : ℝ) : ℝ := 0

/-- The step has the exact open support specified in the source. -/
theorem leveque03_acousticExampleStep_formula (x : ℝ) :
    leveque03_acousticExampleStep x =
      if (-3 / 10 : ℝ) < x ∧ x < (-1 / 10 : ℝ) then 1 else 0 := rfl

/-- The arbitrary-profile construction recovers both parts of (3.13) at
time zero. -/
theorem leveque03_acousticExampleInitialState (x : ℝ) :
    leveque03_acousticInitialDataSolution 1 (1 / 2)
      leveque03_acousticExamplePressure leveque03_acousticExampleVelocity x 0 =
    ![Real.exp (-80 * x ^ 2) / 2 + leveque03_acousticExampleStep x, 0] := by
  have hZ : 0 < acousticImpedance 1 (1 / 2) := by
    norm_num [acousticImpedance]
  rw [leveque03_acousticInitialDataSolution_initial 1 (1 / 2)
    leveque03_acousticExamplePressure leveque03_acousticExampleVelocity hZ x]
  rfl

/-- The example's density `1` and bulk modulus `1/4` give sound speed and
impedance `1/2`. -/
theorem leveque03_acousticExampleParameters :
    (1 / 4 : ℝ) = 1 * (1 / 2 : ℝ) ^ 2 ∧
    Real.sqrt ((1 / 4 : ℝ) / 1) = 1 / 2 ∧
    acousticImpedance 1 (1 / 2) = 1 / 2 := by
  constructor
  · norm_num
  constructor
  · have hsqrt : Real.sqrt (4 : ℝ) = 2 := by
      rw [show (4 : ℝ) = 2 ^ 2 by norm_num, Real.sqrt_sq_eq_abs]
      norm_num
    norm_num [hsqrt]
  · norm_num [acousticImpedance]

/-- Each isolated acoustic eigenmode keeps its profile while traveling, and
its pressure and velocity obey the indicated left/right relation. -/
theorem leveque03_acousticPureWaveRelations (profile : ℝ → ℝ) :
    (IsPureEigenmodeWave
      (eigenmodeTravelingWave profile (-(1 / 2 : ℝ))
        (linearAcousticsLeftEigenvector 1 (1 / 2)))
      (-(1 / 2 : ℝ)) (linearAcousticsLeftEigenvector 1 (1 / 2))) ∧
    (IsPureEigenmodeWave
      (eigenmodeTravelingWave profile (1 / 2 : ℝ)
        (linearAcousticsRightEigenvector 1 (1 / 2)))
      (1 / 2 : ℝ) (linearAcousticsRightEigenvector 1 (1 / 2))) ∧
    (∀ x t,
      (eigenmodeTravelingWave profile (-(1 / 2 : ℝ))
        (linearAcousticsLeftEigenvector 1 (1 / 2)) x t) 0 =
      -(eigenmodeTravelingWave profile (-(1 / 2 : ℝ))
        (linearAcousticsLeftEigenvector 1 (1 / 2)) x t) 1 / 2) ∧
    (∀ x t,
      (eigenmodeTravelingWave profile (1 / 2 : ℝ)
        (linearAcousticsRightEigenvector 1 (1 / 2)) x t) 0 =
      (eigenmodeTravelingWave profile (1 / 2 : ℝ)
        (linearAcousticsRightEigenvector 1 (1 / 2)) x t) 1 / 2) := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact (isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
      _ _ _).2 ⟨profile, rfl⟩
  · exact (isPureEigenmodeWave_iff_exists_eq_eigenmodeTravelingWave
      _ _ _).2 ⟨profile, rfl⟩
  · intro x t
    simp [eigenmodeTravelingWave, linearAcousticsLeftEigenvector]
    ring
  · intro x t
    simp [eigenmodeTravelingWave, linearAcousticsRightEigenvector]
    ring

end NumStability
