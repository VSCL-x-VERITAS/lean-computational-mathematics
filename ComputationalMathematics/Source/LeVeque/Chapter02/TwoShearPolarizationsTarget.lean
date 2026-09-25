/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticPlaneWave3DModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveEigenvaluesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveMatrixSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveEigenvaluesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocitySystemTarget

/-!
# Proof-free target: two independent transverse S polarizations

The model is restricted to x-directed small-amplitude plane waves in a
homogeneous isotropic linear elastic solid. General multidimensional motion
is outside this target.
-/

namespace NumStability.Leveque02Tracer

/-- The y and z shear directions span the transverse plane and their two
identical systems decouple from each other and from the longitudinal system. -/
def twoShearPolarizationsTarget : Prop :=
  (∀ (lameLambda shearModulus extensionStrain shearY shearZ : ℝ),
    elasticPlaneWave3DStress lameLambda shearModulus
        extensionStrain shearY shearZ 0 0 =
      (lameLambda + 2 * shearModulus) * extensionStrain ∧
    elasticPlaneWave3DStress lameLambda shearModulus
        extensionStrain shearY shearZ 1 0 = 2 * shearModulus * shearY ∧
    elasticPlaneWave3DStress lameLambda shearModulus
        extensionStrain shearY shearZ 2 0 = 2 * shearModulus * shearZ) ∧
  pWaveMatrixSystemTarget ∧ shearWaveStressVelocitySystemTarget ∧
  (∀ (X Wy Wz : ℝ → ℝ → ℝ)
      (lameLambda shearModulus density x t : ℝ),
    0 < density → 0 < shearModulus →
    0 < lameLambda + 2 * shearModulus →
    (NumStability.IsConstantCoefficientLinearSystemSolutionAt
      (elasticPlaneWave3DState X Wy Wz shearModulus)
      (elasticPlaneWave3DCoefficientMatrix lameLambda shearModulus density) x t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (pWaveStrainVelocityState X)
        (pWaveCoefficientMatrix lameLambda shearModulus density) x t ∧
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (shearWaveStressVelocityState Wy shearModulus)
        (shearWaveStressVelocityMatrix shearModulus density) x t ∧
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (shearWaveStressVelocityState Wz shearModulus)
        (shearWaveStressVelocityMatrix shearModulus density) x t)) ∧
  (∀ transverse : Fin 2 → ℝ,
    transverse = transverse 0 • ![1, 0] + transverse 1 • ![0, 1]) ∧
  (∀ a b : ℝ,
    a • (![1, 0] : Fin 2 → ℝ) + b • (![0, 1] : Fin 2 → ℝ) = 0 →
      a = 0 ∧ b = 0) ∧
  pWaveEigenvaluesTarget ∧ shearWaveEigenvaluesTarget

end NumStability.Leveque02Tracer
