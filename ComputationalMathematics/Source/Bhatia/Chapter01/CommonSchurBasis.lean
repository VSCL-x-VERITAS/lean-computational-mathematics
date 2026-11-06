/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Triangularization
import ComputationalMathematics.Analysis.LinearOperators.CommutingFamily.Triangularization
import ComputationalMathematics.Source.Bhatia.Chapter01.CommutingFamilyTarget
import Mathlib.Analysis.Complex.Polynomial.Basic

/-!
# Bhatia's common Schur basis

Source correspondence for Bhatia, *Matrix Analysis* (1997), Exercise I.2.3(i),
printed page 5: a commuting family has one common orthonormal Schur basis.
The index type may be empty or infinite, and dimension zero is included.

The reusable common triangular basis and its Gram–Schmidt transfer supply
`commonSchurBasis`; this module adds only the source-facing specialization.
-/

set_option autoImplicit false
universe u v

namespace NumStability.Bhatia.Chapter01

/-- Every commuting family has a common Schur basis, as in Exercise I.2.3(i). -/
theorem commonSchurBasis : Targets.commonSchurBasis.{u, v} := by
  intro H _ _ _ I A hcomm
  exact (NumStability.exists_common_blockTriangular_toMatrix_of_finrank
    (K := ℂ) (I := I) (Module.finrank ℂ H) (V := H) rfl A hcomm).elim
    (fun b hb => NumStability.exists_common_upperTriangular_orthonormalBasis_of_basis b A hb)

end NumStability.Bhatia.Chapter01
