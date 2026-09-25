/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneWaveDecouplingTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveMatrixSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveMatrixSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveEigenvalues
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveEigenvalues
import ComputationalMathematics.Analysis.PartialDifferentialEquations.BlockDiagonalLinearSystem
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: P/S decoupling for a plane elastic wave
-/

namespace NumStability.Leveque02Tracer

/-- Isotropic Hooke stress has separate normal and shear columns under the
one-dimensional plane-wave strain, and the resulting joint system splits. -/
theorem planeWaveDecoupling : planeWaveDecouplingTarget := by
  refine ⟨?_, pWaveMatrixSystem, shearWaveMatrixSystem, ?_,
    pWaveEigenvalues, shearWaveEigenvalues⟩
  · intro lameLambda shearModulus extensionStrain shearStrain
    constructor
    · simp [elasticPlaneWaveStress, elasticPlaneWaveStrain,
        Matrix.one_apply]
      ring
    · simp [elasticPlaneWaveStress, elasticPlaneWaveStrain,
        Matrix.one_apply]
  · intro X W lameLambda shearModulus density x t _ _ _
    simpa [elasticPlaneWaveState, elasticPlaneWaveCoefficientMatrix] using
      (NumStability.isConstantCoefficientLinearSystemSolutionAt_fromBlocks_iff
        (pWaveStrainVelocityState X) (shearWaveStrainVelocityState W)
        (pWaveCoefficientMatrix lameLambda shearModulus density)
        (shearWaveCoefficientMatrix shearModulus density) x t)

end NumStability.Leveque02Tracer
