/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveKinematicsModel
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# One-dimensional shear-wave coefficient matrix and state
-/

namespace NumStability.Leveque02Tracer

/-- The matrix in equation (2.99), for shear strain then transverse velocity. -/
noncomputable def shearWaveCoefficientMatrix
    (shearModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -(1 / 2 : ℝ); -(2 * shearModulus / density), 0]

/-- The state order in equation (2.99). -/
noncomputable def shearWaveStrainVelocityState
    (W : ℝ → ℝ → ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  ![shearWaveStrain W x t, shearWaveVelocity W x t]

end NumStability.Leveque02Tracer
