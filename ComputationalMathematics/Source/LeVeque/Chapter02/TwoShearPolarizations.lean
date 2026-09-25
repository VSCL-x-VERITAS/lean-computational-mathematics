/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TwoShearPolarizationsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveMatrixSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocitySystem
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveEigenvalues
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveEigenvalues
import ComputationalMathematics.Analysis.PartialDifferentialEquations.BlockDiagonalLinearSystem
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: two independent shear polarizations
-/

namespace NumStability.Leveque02Tracer

/-- Three-dimensional x-directed plane waves split into one longitudinal
and two transverse constant-coefficient systems. -/
theorem twoShearPolarizations : twoShearPolarizationsTarget := by
  refine ⟨?_, pWaveMatrixSystem, shearWaveStressVelocitySystem,
    ?_, ?_, ?_, pWaveEigenvalues, shearWaveEigenvalues⟩
  · intro lameLambda shearModulus extensionStrain shearY shearZ
    simp [elasticPlaneWave3DStress, elasticPlaneWave3DStrain,
      Matrix.one_apply]
    ring
  · intro X Wy Wz lameLambda shearModulus density x t _ _ _
    let A := pWaveCoefficientMatrix lameLambda shearModulus density
    let B := shearWaveStressVelocityMatrix shearModulus density
    let p := pWaveStrainVelocityState X
    let sy := shearWaveStressVelocityState Wy shearModulus
    let sz := shearWaveStressVelocityState Wz shearModulus
    have hinner :=
      NumStability.isConstantCoefficientLinearSystemSolutionAt_fromBlocks_iff
        sy sz B B x t
    have houter :=
      NumStability.isConstantCoefficientLinearSystemSolutionAt_fromBlocks_iff
        p (fun ξ τ => Sum.elim (sy ξ τ) (sz ξ τ))
        A (Matrix.fromBlocks B 0 0 B) x t
    simpa [elasticPlaneWave3DState, elasticPlaneWave3DCoefficientMatrix,
      p, sy, sz, A, B, hinner] using houter
  · intro transverse
    funext i
    fin_cases i <;> simp [Pi.add_apply]
  · intro a b h
    have h0 := congrFun h 0
    have h1 := congrFun h 1
    constructor
    · simpa [Pi.smul_apply, Pi.add_apply] using h0
    · simpa [Pi.smul_apply, Pi.add_apply] using h1

end NumStability.Leveque02Tracer
