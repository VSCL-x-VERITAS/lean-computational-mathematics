/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.PositiveFactorTarget
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveDefinite
import ComputationalMathematics.Analysis.InnerProductSpace.QR.GramUniqueness

/-!
# Uniqueness of Bhatia's normalized Cholesky factor

Bhatia, *Matrix Analysis*, Exercise I.2.2, printed page 5 (PDF page 17).

A positive definite operator has at most one upper triangular Gram factor
whose diagonal entries are nonnegative real numbers. The proof transports the
source's strict quadratic condition to the matrix in the supplied orthonormal
basis and applies uniqueness of normalized triangular Gram factors. The empty
matrix is included; existence is the separate equivalence statement.
-/

set_option autoImplicit false
open scoped ComplexOrder
universe u

namespace NumStability.Bhatia.Chapter01

/-- The normalized Cholesky factor of a positive definite operator is unique
in every supplied orthonormal coordinate system. -/
theorem positiveFactorUniqueness : Targets.positiveFactorUniqueness.{u} := by
  intro H _ _ _ n E A hA
  dsimp only
  intro T S hT hS
  have hAdj : A = LinearMap.adjoint A :=
    (LinearMap.eq_adjoint_iff A A).mpr hA.1
  have hPD : (LinearMap.toMatrix E.toBasis E.toBasis A).PosDef :=
    (NumStability.posDef_toMatrix_iff_re_inner_pos E A hAdj).mpr hA.2
  exact NumStability.upperTriangular_gram_unique_of_posDef T S
    hT.1 hS.1 hT.2.1 hS.2.1
    (hT.2.2.symm.trans hS.2.2) (hT.2.2 ▸ hPD)

end NumStability.Bhatia.Chapter01
