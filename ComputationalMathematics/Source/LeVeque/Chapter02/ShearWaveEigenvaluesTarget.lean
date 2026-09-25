/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticWaveSpeedsModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocityModel
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# Proof-free target for LeVeque equation (2.101)

The source explicitly says both displayed S-wave coefficient matrices have
the signed eigenvalues determined by the same positive shear-wave speed.
-/

namespace NumStability.Leveque02Tracer

/-- Both shear-wave matrices have eigenvalues `-c_s` and `+c_s`, where
`c_s=sqrt(mu/rho)` is positive. -/
def shearWaveEigenvaluesTarget : Prop :=
  ∀ (shearModulus density : ℝ),
    0 < shearModulus →
    0 < density →
    let speed := shearWaveSpeed shearModulus density
    0 < speed ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (shearWaveCoefficientMatrix shearModulus density))
        (-speed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (shearWaveCoefficientMatrix shearModulus density))
        speed ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (shearWaveStressVelocityMatrix shearModulus density))
        (-speed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (shearWaveStressVelocityMatrix shearModulus density))
        speed

end NumStability.Leveque02Tracer
