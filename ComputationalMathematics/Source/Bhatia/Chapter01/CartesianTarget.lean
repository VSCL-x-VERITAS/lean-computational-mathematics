/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Adjoint

/-!
# Cartesian decomposition in Bhatia, Chapter I

The real and imaginary operator parts on page 6 are prescribed by their adjoint
formulas. The assertion includes their Hermitian character and reconstruction
of the original operator.
-/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed Cartesian parts and reconstruction in Bhatia, page 6. -/
def cartesianDecomposition : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let R : H →ₗ[ℂ] H := (2 : ℂ)⁻¹ • (A + LinearMap.adjoint A)
    let J : H →ₗ[ℂ] H := (2 * Complex.I)⁻¹ • (A - LinearMap.adjoint A)
    A = R + Complex.I • J ∧ LinearMap.adjoint R = R ∧ LinearMap.adjoint J = J

end NumStability.Bhatia.Chapter01.Targets
