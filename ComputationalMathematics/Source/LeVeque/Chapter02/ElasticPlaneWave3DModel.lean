/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocityModel
import Mathlib.Data.Matrix.Block
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Three-component x-directed elastic plane-wave model

The two transverse stress-velocity pairs have identical coefficients. The
three-dimensional strain and isotropic stress show why their constitutive
components do not couple to the longitudinal strain or to each other.
-/

namespace NumStability.Leveque02Tracer

/-- Plane strain from one longitudinal and two transverse displacements. -/
noncomputable def elasticPlaneWave3DStrain
    (extensionStrain shearY shearZ : ℝ) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![extensionStrain, shearY, shearZ;
     shearY, 0, 0;
     shearZ, 0, 0]

/-- Isotropic linear stress of a three-dimensional x-directed plane strain. -/
noncomputable def elasticPlaneWave3DStress
    (lameLambda shearModulus extensionStrain shearY shearZ : ℝ) :
    Matrix (Fin 3) (Fin 3) ℝ :=
  let strain := elasticPlaneWave3DStrain extensionStrain shearY shearZ
  fun i j => lameLambda * (strain 0 0 + strain 1 1 + strain 2 2) *
      (1 : Matrix (Fin 3) (Fin 3) ℝ) i j +
    2 * shearModulus * strain i j

/-- One P pair and two independent copies of the S stress-velocity pair. -/
noncomputable def elasticPlaneWave3DState
    (X Wy Wz : ℝ → ℝ → ℝ) (shearModulus x t : ℝ) :
    Sum (Fin 2) (Sum (Fin 2) (Fin 2)) → ℝ :=
  Sum.elim (pWaveStrainVelocityState X x t)
    (Sum.elim (shearWaveStressVelocityState Wy shearModulus x t)
      (shearWaveStressVelocityState Wz shearModulus x t))

/-- The constant x-directed plane-wave matrix: one P and two S blocks. -/
noncomputable def elasticPlaneWave3DCoefficientMatrix
    (lameLambda shearModulus density : ℝ) :
    Matrix (Sum (Fin 2) (Sum (Fin 2) (Fin 2)))
      (Sum (Fin 2) (Sum (Fin 2) (Fin 2))) ℝ :=
  Matrix.fromBlocks (pWaveCoefficientMatrix lameLambda shearModulus density)
    0 0
    (Matrix.fromBlocks (shearWaveStressVelocityMatrix shearModulus density)
      0 0 (shearWaveStressVelocityMatrix shearModulus density))

end NumStability.Leveque02Tracer
