/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveStressVelocityModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocityModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-! The P- and S-wave stress systems have an acoustics form after negating stress. -/

namespace NumStability.Leveque02Tracer

/-- Sign conversion between stress and pressure variables. -/
noncomputable def stressToPressureSign : Matrix (Fin 2) (Fin 2) ℝ :=
  !![-1, 0; 0, 1]

/-- Pressure and shear wave structure of the stress formulation. -/
def pSWaveAcousticsStructureTarget : Prop :=
  ∀ (lameLambda shearModulus density : ℝ),
    0 < density → 0 < lameLambda + 2 * shearModulus → 0 < shearModulus →
    stressToPressureSign * stressToPressureSign = 1 ∧
    linearAcousticsMatrix (lameLambda + 2 * shearModulus) density =
      stressToPressureSign *
        pWaveStressVelocityMatrix lameLambda shearModulus density *
          stressToPressureSign ∧
    linearAcousticsMatrix shearModulus density =
      stressToPressureSign *
        shearWaveStressVelocityMatrix shearModulus density *
          stressToPressureSign ∧
    (∀ (X : ℝ → ℝ → ℝ) (x t : ℝ),
      let pressure := fun ξ τ =>
        -planeNormalStress lameLambda shearModulus (longitudinalStrain X) ξ τ
      let velocity := longitudinalMaterialVelocity X
      stressToPressureSign.mulVec
          (pWaveStressVelocityState X lameLambda shearModulus x t) =
        linearAcousticsState pressure velocity x t ∧
      (IsConstantCoefficientLinearSystemSolutionAt
          (pWaveStressVelocityState X lameLambda shearModulus)
          (pWaveStressVelocityMatrix lameLambda shearModulus density) x t ↔
        IsLinearAcousticsSolutionAt pressure velocity
          (lameLambda + 2 * shearModulus) density x t)) ∧
    (∀ (W : ℝ → ℝ → ℝ) (x t : ℝ),
      let pressureAnalogue := fun ξ τ =>
        -planeShearStress shearModulus (shearWaveStrain W) ξ τ
      let velocity := shearWaveVelocity W
      stressToPressureSign.mulVec
          (shearWaveStressVelocityState W shearModulus x t) =
        linearAcousticsState pressureAnalogue velocity x t ∧
      (IsConstantCoefficientLinearSystemSolutionAt
          (shearWaveStressVelocityState W shearModulus)
          (shearWaveStressVelocityMatrix shearModulus density) x t ↔
        IsLinearAcousticsSolutionAt pressureAnalogue velocity
          shearModulus density x t))

end NumStability.Leveque02Tracer
