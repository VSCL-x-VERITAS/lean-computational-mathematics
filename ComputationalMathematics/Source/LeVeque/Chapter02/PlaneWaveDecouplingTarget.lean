/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticPlaneWaveDecouplingModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveEigenvaluesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveMatrixSystemTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveEigenvaluesTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveMatrixSystemTarget

/-!
# Proof-free target: decoupling of a one-dimensional elastic plane wave

The joint state has one longitudinal and one transverse polarization. Its
linear isotropic coefficient has zero cross blocks. The target states an iff
between the full four-component equation and its independent two-component
P/S equations; the eigenvalue clauses certify their real wave speeds.
-/

namespace NumStability.Leveque02Tracer

/-- The combined plane-wave system splits into its independent compressional
and shear systems, with each subsystem having its stated real wave speeds. -/
def planeWaveDecouplingTarget : Prop :=
  (∀ (lameLambda shearModulus extensionStrain shearStrain : ℝ),
    elasticPlaneWaveStress lameLambda shearModulus extensionStrain shearStrain 0 0 =
      (lameLambda + 2 * shearModulus) * extensionStrain ∧
    elasticPlaneWaveStress lameLambda shearModulus extensionStrain shearStrain 1 0 =
      2 * shearModulus * shearStrain) ∧
  pWaveMatrixSystemTarget ∧ shearWaveMatrixSystemTarget ∧
  (∀ (X W : ℝ → ℝ → ℝ) (lameLambda shearModulus density x t : ℝ),
    0 < density → 0 < shearModulus →
    0 < lameLambda + 2 * shearModulus →
    (NumStability.IsConstantCoefficientLinearSystemSolutionAt
      (elasticPlaneWaveState X W)
      (elasticPlaneWaveCoefficientMatrix lameLambda shearModulus density) x t ↔
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (pWaveStrainVelocityState X)
        (pWaveCoefficientMatrix lameLambda shearModulus density) x t ∧
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (shearWaveStrainVelocityState W)
        (shearWaveCoefficientMatrix shearModulus density) x t)) ∧
  pWaveEigenvaluesTarget ∧ shearWaveEigenvaluesTarget

end NumStability.Leveque02Tracer
