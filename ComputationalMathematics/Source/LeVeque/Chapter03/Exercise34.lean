/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticInitialData
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution

/-!
# Exercise 3.4: a compact pressure pulse splits into two acoustic waves

Printed page 62/raw PDF page 84. The initial pressure is one on the closed
interval `[1,2]` and zero outside, while initial velocity vanishes.
-/

namespace NumStability

open MeasureTheory

noncomputable def leveque03_exercise34InitialPressure (x : ℝ) : ℝ :=
  if 1 ≤ x ∧ x ≤ 2 then 1 else 0

def leveque03_exercise34InitialVelocity (_x : ℝ) : ℝ := 0

noncomputable def leveque03_exercise34Solution
    (density soundSpeed : ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  leveque03_acousticInitialDataSolution density soundSpeed
    leveque03_exercise34InitialPressure leveque03_exercise34InitialVelocity x t

/-- Reusable two-wave formula for arbitrary zero-velocity acoustic initial
pressure. Discontinuous profiles are allowed. -/
theorem leveque03_acousticZeroVelocity_formula
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (initialPressure : ℝ → ℝ) (x t : ℝ) :
    leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure (fun _ => 0) x t =
      ![(initialPressure (x + soundSpeed * t) +
          initialPressure (x - soundSpeed * t)) / 2,
        (initialPressure (x - soundSpeed * t) -
          initialPressure (x + soundSpeed * t)) /
          (2 * acousticImpedance density soundSpeed)] := by
  have hdensity : density ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  ext i
  fin_cases i <;>
    simp [leveque03_acousticInitialDataSolution,
      acousticWaveStrengths, linearAcousticsEigenvectorMatrix,
      linearAcousticsEigenvectorMatrixInverse, Matrix.mulVec,
      dotProduct, Fin.sum_univ_succ, acousticImpedance,
      smul_eq_mul] <;>
    field_simp [hdensity, hspeed] <;> ring

/-- The two pulses translate in opposite directions. The formula is
pointwise, including the values inherited from the closed initial interval. -/
theorem leveque03_exercise34Solution_formula
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (x t : ℝ) :
    leveque03_exercise34Solution density soundSpeed x t =
      ![(leveque03_exercise34InitialPressure (x + soundSpeed * t) +
          leveque03_exercise34InitialPressure (x - soundSpeed * t)) / 2,
        (leveque03_exercise34InitialPressure (x - soundSpeed * t) -
          leveque03_exercise34InitialPressure (x + soundSpeed * t)) /
          (2 * acousticImpedance density soundSpeed)] := by
  simpa only [leveque03_exercise34Solution,
    leveque03_exercise34InitialVelocity] using
    leveque03_acousticZeroVelocity_formula density soundSpeed hZ
      leveque03_exercise34InitialPressure x t

/-- The constructed solution recovers the source's pulse and zero velocity
at initial time. -/
theorem leveque03_exercise34Solution_initial
    (density soundSpeed : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) (x : ℝ) :
    leveque03_exercise34Solution density soundSpeed x 0 =
      ![leveque03_exercise34InitialPressure x, 0] := by
  simpa [leveque03_exercise34Solution, leveque03_exercise34InitialVelocity] using
    (leveque03_acousticInitialDataSolution_initial density soundSpeed
      leveque03_exercise34InitialPressure leveque03_exercise34InitialVelocity hZ x)

theorem leveque03_exercise34InitialPressure_support (x : ℝ) :
    leveque03_exercise34InitialPressure x = 1 ↔ 1 ≤ x ∧ x ≤ 2 := by
  simp [leveque03_exercise34InitialPressure]

/-- The compact step profile is integrable on every finite interval. -/
theorem leveque03_exercise34InitialPressure_intervalIntegrable (a b : ℝ) :
    IntervalIntegrable leveque03_exercise34InitialPressure volume a b := by
  rw [intervalIntegrable_iff]
  have hc (v : ℝ) :
      Integrable (fun _ : ℝ => v) (volume.restrict (Set.uIoc a b)) :=
    (intervalIntegrable_const (a := a) (b := b) (c := v)).def'
  have hp := Integrable.piecewise (μ := volume.restrict (Set.uIoc a b))
    (s := Set.Icc (1 : ℝ) 2) measurableSet_Icc
    (hc 1).integrableOn (hc 0).integrableOn
  simpa only [Set.piecewise, Set.mem_Icc,
    leveque03_exercise34InitialPressure] using hp

noncomputable def leveque03_exercise34LeftStrength
    (density soundSpeed : ℝ) (x : ℝ) : ℝ :=
  (-(1 / (2 * acousticImpedance density soundSpeed))) *
    leveque03_exercise34InitialPressure x

noncomputable def leveque03_exercise34RightStrength
    (density soundSpeed : ℝ) (x : ℝ) : ℝ :=
  (1 / (2 * acousticImpedance density soundSpeed)) *
    leveque03_exercise34InitialPressure x

theorem leveque03_exercise34LeftStrength_intervalIntegrable
    (density soundSpeed a b : ℝ) :
    IntervalIntegrable
      (leveque03_exercise34LeftStrength density soundSpeed) volume a b := by
  exact (leveque03_exercise34InitialPressure_intervalIntegrable a b).const_mul _

theorem leveque03_exercise34RightStrength_intervalIntegrable
    (density soundSpeed a b : ℝ) :
    IntervalIntegrable
      (leveque03_exercise34RightStrength density soundSpeed) volume a b := by
  exact (leveque03_exercise34InitialPressure_intervalIntegrable a b).const_mul _

noncomputable def leveque03_exercise34WaveSolution
    (density soundSpeed : ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  eigenmodeTravelingWave (leveque03_exercise34LeftStrength density soundSpeed)
    (-soundSpeed) (linearAcousticsLeftEigenvector density soundSpeed) x t +
  eigenmodeTravelingWave (leveque03_exercise34RightStrength density soundSpeed)
    soundSpeed (linearAcousticsRightEigenvector density soundSpeed) x t

theorem leveque03_exercise34WaveSolution_weak
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
      (leveque03_exercise34WaveSolution density soundSpeed)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
  let q : Fin 2 → ℝ → ℝ → (Fin 2 → ℝ) :=
    ![eigenmodeTravelingWave (leveque03_exercise34LeftStrength density soundSpeed)
        (-soundSpeed) (linearAcousticsLeftEigenvector density soundSpeed),
      eigenmodeTravelingWave (leveque03_exercise34RightStrength density soundSpeed)
        soundSpeed (linearAcousticsRightEigenvector density soundSpeed)]
  have hq : ∀ p, IsRectangleConservationLawSolution (q p)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
    intro p
    fin_cases p
    · exact eigenmodeTravelingWave_isRectangleSolution _ _
        (leveque03_exercise34LeftStrength_intervalIntegrable density soundSpeed)
        _ _ (linearAcousticsMatrix_mulVec_leftEigenvector
          bulkModulus density soundSpeed hdensity hmaterial)
    · exact eigenmodeTravelingWave_isRectangleSolution _ _
        (leveque03_exercise34RightStrength_intervalIntegrable density soundSpeed)
        _ _ (linearAcousticsMatrix_mulVec_rightEigenvector
          bulkModulus density soundSpeed hdensity hmaterial)
  simpa [leveque03_exercise34WaveSolution, q, Fin.sum_univ_succ] using
    finite_sum_isRectangleSolution (linearAcousticsMatrix bulkModulus density) q hq

theorem leveque03_exercise34WaveSolution_eq
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (x t : ℝ) :
    leveque03_exercise34WaveSolution density soundSpeed x t =
      leveque03_exercise34Solution density soundSpeed x t := by
  have hdensity : density ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    apply hZ
    simp [acousticImpedance, h]
  rw [leveque03_exercise34Solution_formula density soundSpeed hZ x t]
  ext i
  fin_cases i <;>
    simp [leveque03_exercise34WaveSolution,
      leveque03_exercise34LeftStrength,
      leveque03_exercise34RightStrength,
      eigenmodeTravelingWave, travelingWave,
      linearAcousticsLeftEigenvector,
      linearAcousticsRightEigenvector, Pi.add_apply, Pi.smul_apply,
      smul_eq_mul, acousticImpedance] <;>
    field_simp [hdensity, hspeed] <;> ring

theorem leveque03_exercise34Solution_weak
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : density ≠ 0)
    (hspeed : soundSpeed ≠ 0)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
      (leveque03_exercise34Solution density soundSpeed)
      (linearAcousticsMatrix bulkModulus density).mulVec := by
  have hZ : acousticImpedance density soundSpeed ≠ 0 := by
    simp [acousticImpedance, hdensity, hspeed]
  have heq : leveque03_exercise34WaveSolution density soundSpeed =
      leveque03_exercise34Solution density soundSpeed := by
    funext x t
    exact leveque03_exercise34WaveSolution_eq density soundSpeed hZ x t
  rw [← heq]
  exact leveque03_exercise34WaveSolution_weak
    bulkModulus density soundSpeed hdensity hmaterial

/-- The source's acoustic initial-value problem, including the discontinuous
initial pulse, in the rectangle weak conservation-law sense. -/
theorem leveque03_exercise34FullSolution
    (bulkModulus density soundSpeed : ℝ)
    (hdensity : 0 < density) (hspeed : 0 < soundSpeed)
    (hmaterial : bulkModulus = density * soundSpeed ^ 2) :
    IsRectangleConservationLawSolution
        (leveque03_exercise34Solution density soundSpeed)
        (linearAcousticsMatrix bulkModulus density).mulVec ∧
      (∀ x, leveque03_exercise34Solution density soundSpeed x 0 =
        ![leveque03_exercise34InitialPressure x, 0]) ∧
      (∀ x t, 0 < t → leveque03_exercise34Solution density soundSpeed x t =
        ![(leveque03_exercise34InitialPressure (x + soundSpeed * t) +
            leveque03_exercise34InitialPressure (x - soundSpeed * t)) / 2,
          (leveque03_exercise34InitialPressure (x - soundSpeed * t) -
            leveque03_exercise34InitialPressure (x + soundSpeed * t)) /
            (2 * acousticImpedance density soundSpeed)]) := by
  have hZ : 0 < acousticImpedance density soundSpeed := by
    exact mul_pos hdensity hspeed
  refine ⟨leveque03_exercise34Solution_weak bulkModulus density soundSpeed
    hdensity.ne' hspeed.ne' hmaterial, ?_, ?_⟩
  · exact fun x => leveque03_exercise34Solution_initial density soundSpeed hZ x
  · exact fun x t _ => leveque03_exercise34Solution_formula
      density soundSpeed hZ.ne' x t

end NumStability
