/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticWaveSpeedsModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveCoefficientModel
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# Proof-free target for LeVeque equation (2.94)

The constant P-wave coefficient matrix has positive speed
`sqrt ((lambda + 2 mu) / rho)` and real eigenvalues of both signs.
-/

namespace NumStability.Leveque02Tracer

/-- The two P-wave eigenvalues and the positive compressional speed. -/
def pWaveEigenvaluesTarget : Prop :=
  ∀ (lameLambda shearModulus density : ℝ),
    0 < density →
    0 < lameLambda + 2 * shearModulus →
    let speed := compressionalWaveSpeed lameLambda shearModulus density
    0 < speed ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (pWaveCoefficientMatrix lameLambda shearModulus density))
        (-speed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (pWaveCoefficientMatrix lameLambda shearModulus density))
        speed

end NumStability.Leveque02Tracer
