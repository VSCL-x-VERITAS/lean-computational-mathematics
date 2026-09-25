/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveCoefficientModel
import Mathlib.Data.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Joint plane-wave linear elasticity model

The index `Sum (Fin 2) (Fin 2)` keeps the longitudinal and transverse
strain-velocity pairs in one state. The off-diagonal blocks vanish under the
one-dimensional plane-wave and linear isotropic constitutive assumptions.
-/

namespace NumStability.Leveque02Tracer

/-- Symmetric infinitesimal plane strain under x-only displacement variation.
The entry `shearStrain` is half the transverse x derivative. -/
noncomputable def elasticPlaneWaveStrain
    (extensionStrain shearStrain : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![extensionStrain, shearStrain; shearStrain, 0]

/-- The two-dimensional isotropic Hooke stress of the plane strain. -/
noncomputable def elasticPlaneWaveStress
    (lameLambda shearModulus extensionStrain shearStrain : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  let strain := elasticPlaneWaveStrain extensionStrain shearStrain
  fun i j => lameLambda * (strain 0 0 + strain 1 1) * (1 : Matrix (Fin 2) (Fin 2) ℝ) i j +
    2 * shearModulus * strain i j

/-- The joint four-component plane-wave state for one transverse polarization. -/
noncomputable def elasticPlaneWaveState
    (X W : ℝ → ℝ → ℝ) (x t : ℝ) : Sum (Fin 2) (Fin 2) → ℝ :=
  Sum.elim (pWaveStrainVelocityState X x t)
    (shearWaveStrainVelocityState W x t)

/-- The constant-coefficient plane-wave elasticity matrix in P/S blocks. -/
noncomputable def elasticPlaneWaveCoefficientMatrix
    (lameLambda shearModulus density : ℝ) :
    Matrix (Sum (Fin 2) (Fin 2)) (Sum (Fin 2) (Fin 2)) ℝ :=
  Matrix.fromBlocks (pWaveCoefficientMatrix lameLambda shearModulus density)
    0 0 (shearWaveCoefficientMatrix shearModulus density)

end NumStability.Leveque02Tracer
