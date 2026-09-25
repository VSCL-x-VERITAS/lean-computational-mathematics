/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneNormalStressModel

/-!
# Constant P-wave stress-velocity state and coefficient matrix

The state order and signs follow equation (2.95). The Lamé parameters and
density are constants of a homogeneous material.
-/

namespace NumStability.Leveque02Tracer

/-- The coefficient matrix for normal stress and material velocity. -/
noncomputable def pWaveStressVelocityMatrix
    (lameLambda shearModulus density : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -(lameLambda + 2 * shearModulus); -(1 / density), 0]

/-- Equation (2.95) uses normal stress before material velocity. -/
noncomputable def pWaveStressVelocityState
    (X : ℝ → ℝ → ℝ) (lameLambda shearModulus x t : ℝ) : Fin 2 → ℝ :=
  ![planeNormalStress lameLambda shearModulus (longitudinalStrain X) x t,
    longitudinalMaterialVelocity X x t]

end NumStability.Leveque02Tracer
