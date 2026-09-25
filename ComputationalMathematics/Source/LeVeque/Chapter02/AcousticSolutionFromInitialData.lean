/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticSolutionFromInitialDataTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticInitialAmplitudes
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticInitialWaveStrengths

/-!
# Acoustic solution from initial pressure and velocity
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.68): substitute the initial wave strengths into the same
two-wave state to obtain both pressure and velocity solution formulas. -/
theorem acousticSolutionFromInitialData : acousticSolutionFromInitialDataTarget := by
  intro density soundSpeed pressure velocity leftProfile rightProfile
    hImpedance hform x t
  let Z := acousticImpedance density soundSpeed
  have hmatrix (ξ : ℝ) :
      (linearAcousticsEigenvectorMatrix density soundSpeed).mulVec
          ![leftProfile ξ, rightProfile ξ] =
        ![pressure ξ 0, velocity ξ 0] := by
    simpa [linearAcousticsState] using
      (acousticInitialAmplitudes density soundSpeed pressure velocity
        leftProfile rightProfile hform ξ)
  have hstrengths := acousticInitialWaveStrengths density soundSpeed
    (fun ξ => pressure ξ 0) (fun ξ => velocity ξ 0)
    leftProfile rightProfile hImpedance hmatrix
  have hleft := (hstrengths (x + soundSpeed * t)).1
  have hright := (hstrengths (x - soundSpeed * t)).2
  have hstate := hform x t
  have hp : pressure x t =
      -Z * leftProfile (x + soundSpeed * t) +
        Z * rightProfile (x - soundSpeed * t) := by
    have h := congrFun hstate 0
    simpa [linearAcousticsState, linearAcousticsLeftEigenvector,
      linearAcousticsRightEigenvector, Z, acousticImpedance,
      mul_comm, mul_left_comm] using h
  have hu : velocity x t =
      leftProfile (x + soundSpeed * t) +
        rightProfile (x - soundSpeed * t) := by
    have h := congrFun hstate 1
    simpa [linearAcousticsState, linearAcousticsLeftEigenvector,
      linearAcousticsRightEigenvector] using h
  rw [hleft, hright] at hp hu
  have hZne : Z ≠ 0 := ne_of_gt hImpedance
  constructor
  · calc
      pressure x t =
          -Z * ((-pressure (x + soundSpeed * t) 0 +
                Z * velocity (x + soundSpeed * t) 0) / (2 * Z)) +
            Z * ((pressure (x - soundSpeed * t) 0 +
                Z * velocity (x - soundSpeed * t) 0) / (2 * Z)) := hp
      _ = _ := by
        dsimp [Z]
        field_simp [hZne]
        ring
  · calc
      velocity x t =
          (-pressure (x + soundSpeed * t) 0 +
              Z * velocity (x + soundSpeed * t) 0) / (2 * Z) +
            (pressure (x - soundSpeed * t) 0 +
              Z * velocity (x - soundSpeed * t) 0) / (2 * Z) := hu
      _ = _ := by
        dsimp [Z]
        field_simp [hZne]
        ring

end NumStability.Leveque02Tracer
