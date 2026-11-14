/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot

/-!
# Frobenius trace and every orthonormal coordinate identity

Bhatia, Matrix Analysis, Section I.2, printed page 7 (PDF page 19), with the
finite complex Hilbert setting, adjoint and unique positive square root from
printed pages 1–5 (PDF pages 13–17).

The local absolute value is a proved positive square root of the Gram operator.
The full eigenvalue tuple includes every dimension slot and multiplicity. The
identities retain the actual complex trace and quantify over every orthonormal
basis of the same space, including the empty basis in dimension zero.
-/

set_option autoImplicit false
open scoped BigOperators
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The complete singular-square prescription agrees with the nonnegative
Gram trace and the full matrix-entry sum in every orthonormal basis. -/
def frobeniusTraceAndEveryBasisEntriesUniqueRoot : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    let n : ℕ := Module.finrank ℂ H
    let absOp : H →ₗ[ℂ] H :=
      NumStability.positiveSquareRoot ((LinearMap.adjoint A).comp A)
        (LinearMap.isPositive_adjoint_comp_self A)
    let absPos : absOp.IsPositive :=
      NumStability.positiveSquareRoot_isPositive ((LinearMap.adjoint A).comp A)
        (LinearMap.isPositive_adjoint_comp_self A)
    let singular : Fin n → ℝ := absPos.isSymmetric.eigenvalues rfl
    let N : ℝ := Real.sqrt (∑ j : Fin n, singular j ^ 2)
    let t : ℂ := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
    t.im = 0 ∧ 0 ≤ t.re ∧
      (((∑ j : Fin n, singular j ^ 2) : ℝ) : ℂ) = t ∧
      N = Real.sqrt t.re ∧
      (∀ E : OrthonormalBasis (Fin n) ℂ H,
        let M := LinearMap.toMatrix E.toBasis E.toBasis A
        (∀ i j, M i j = inner ℂ (E i) (A (E j))) ∧
          t = (((∑ i, ∑ j, ‖M i j‖ ^ 2) : ℝ) : ℂ) ∧
          N = Real.sqrt (∑ i, ∑ j, ‖M i j‖ ^ 2))

end NumStability.Bhatia.Chapter01.Targets
