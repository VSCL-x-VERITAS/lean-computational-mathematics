/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates

/-!
# Noncharacteristic diagonalizable linear systems

A real eigenbasis with no zero characteristic speed makes the coefficient
matrix injective on states. This is the algebraic condition needed to recover
matching spatial derivatives from matching time derivatives at a periodic seam.
-/

namespace NumStability

theorem matrix_mulVec_injective_of_nonzero_eigenvalues
    {m : ℕ} (A : Matrix (Fin m) (Fin m) ℝ)
    (b : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ)
    (heigen : ∀ i, A.mulVec (b i) = speeds i • b i)
    (hnonzero : ∀ i, speeds i ≠ 0) :
    Function.Injective A.mulVec := by
  intro u v h
  apply b.equivFun.injective
  have hcoord := congrArg b.equivFun h
  rw [eigenbasis_coordinates_mulVec A b speeds heigen u,
    eigenbasis_coordinates_mulVec A b speeds heigen v] at hcoord
  funext i
  have hi := congrFun hcoord i
  exact (mul_left_cancel₀ (hnonzero i)) hi

end NumStability
