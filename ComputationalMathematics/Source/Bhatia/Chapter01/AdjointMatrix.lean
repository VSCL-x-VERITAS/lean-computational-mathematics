/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.OperatorMatricesTarget

/-!
# Bhatia Chapter I: the matrix of an adjoint

Exercise I.2.1 uses the preceding orthonormal-basis convention. The matrix of
the adjoint reverses the bases and is the original matrix's conjugate transpose.
-/

set_option autoImplicit false
universe u v

namespace NumStability.Bhatia.Chapter01

/-- The adjoint-matrix identity in every supplied pair of orthonormal bases. -/
theorem adjointMatrix : Targets.adjointMatrix.{u, v} := by
  intro H K _ _ _ _ _ _ n m E F A
  exact LinearMap.toMatrix_adjoint E F A

end NumStability.Bhatia.Chapter01
