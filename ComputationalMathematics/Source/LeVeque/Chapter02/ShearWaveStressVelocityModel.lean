/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneShearStressModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveKinematicsModel
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Shear stress-velocity state and coefficient matrix
-/

namespace NumStability.Leveque02Tracer

/-- The coefficient matrix in equation (2.100). -/
noncomputable def shearWaveStressVelocityMatrix
    (shearModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -shearModulus; -(1 / density), 0]

/-- The state order in equation (2.100): shear stress then vertical velocity. -/
noncomputable def shearWaveStressVelocityState
    (W : ℝ → ℝ → ℝ) (shearModulus x t : ℝ) : Fin 2 → ℝ :=
  ![planeShearStress shearModulus (shearWaveStrain W) x t,
    shearWaveVelocity W x t]

end NumStability.Leveque02Tracer
