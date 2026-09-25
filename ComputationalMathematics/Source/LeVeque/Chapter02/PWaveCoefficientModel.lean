/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalKinematicsModel
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# One-dimensional compressional-wave coefficient matrix

The state order is longitudinal strain followed by longitudinal velocity.
The Lamé parameters and density are constants of a homogeneous material.
-/

namespace NumStability.Leveque02Tracer

/-- The coefficient matrix in LeVeque equation (2.93). -/
noncomputable def pWaveCoefficientMatrix
    (lameLambda shearModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -1; -((lameLambda + 2 * shearModulus) / density), 0]

/-- The state order in (2.93): longitudinal strain, then material velocity. -/
noncomputable def pWaveStrainVelocityState
    (X : ℝ → ℝ → ℝ) (x t : ℝ) : Fin 2 → ℝ :=
  ![longitudinalStrain X x t, longitudinalMaterialVelocity X x t]

end NumStability.Leveque02Tracer
