/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.LinearOperators.Schur.Complex.NormalTriangular.Diagonal
import ComputationalMathematics.Source.Bhatia.Chapter01.CommonSchurBasis
import ComputationalMathematics.Source.Bhatia.Chapter01.CommutingFamilyTarget

/-!
# Bhatia's common eigenbasis

Source correspondence for Bhatia, *Matrix Analysis* (1997), Exercise I.2.3(ii),
printed page 5: a commuting family of normal operators has one common
orthonormal eigenbasis. Empty and infinite index types and dimension zero
remain included.

The common Schur basis is chosen once for the family. Its matrices remain
normal under the orthonormal coordinate star-algebra equivalence, so the
existing normal triangular matrix theorem makes them diagonal.
-/

set_option autoImplicit false
open scoped Matrix
universe u v

namespace NumStability.Bhatia.Chapter01

/-- A commuting family of normal operators has a common orthonormal eigenbasis. -/
theorem commonDiagonalBasis : Targets.commonDiagonalBasis.{u, v} := by
  intro H _ _ _ I A hcomm hnormal
  obtain ⟨E, hE⟩ := commonSchurBasis H I A hcomm
  refine ⟨E, ?_⟩
  intro a
  let T := LinearMap.toMatrix E.toBasis E.toBasis (A a)
  have hn : Tᴴ * T = T * Tᴴ := by
    simpa only [map_mul, map_star, Matrix.star_eq_conjTranspose] using
      congrArg (LinearMap.toMatrixOrthonormal E) (hnormal a).star_comm_self.eq
  exact NumStability.normal_upperTriangular_isDiag (T := T)
    (fun i j hji => hE a hji) hn

end NumStability.Bhatia.Chapter01
