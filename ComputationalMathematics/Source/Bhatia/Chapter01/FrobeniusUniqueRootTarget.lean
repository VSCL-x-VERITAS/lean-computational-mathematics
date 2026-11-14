/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveSquareRoot

/-!
# Frobenius norm from the unique positive absolute value

Bhatia, Matrix Analysis, Section I.2, printed page 7 (PDF page 19), with the
finite complex Hilbert setting and unique positive square root from printed
pages 1–5 (PDF pages 13–17).

The book's absolute value is the unique positive square root of the Gram
operator. Its full real eigenvalue tuple defines the singular-square sum.
The source-local quantities below retain all norm laws and the actual complex
trace, including dimension zero. Root existence and positivity are proved
mathematics used to define these quantities, never hypotheses from a caller.
-/

set_option autoImplicit false
open scoped BigOperators
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The singular-square prescription is a norm and agrees with the real
square root of the nonnegative complex Gram trace. All dimension slots,
zeros and multiplicities are retained. -/
def frobeniusNormAndTraceUniqueRoot : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n : ℕ := Module.finrank ℂ H
    let absOp : (H →ₗ[ℂ] H) → (H →ₗ[ℂ] H) := fun A =>
      NumStability.positiveSquareRoot ((LinearMap.adjoint A).comp A)
        (LinearMap.isPositive_adjoint_comp_self A)
    let absPos : ∀ A : H →ₗ[ℂ] H, (absOp A).IsPositive := fun A =>
      NumStability.positiveSquareRoot_isPositive ((LinearMap.adjoint A).comp A)
        (LinearMap.isPositive_adjoint_comp_self A)
    let singular : (H →ₗ[ℂ] H) → Fin n → ℝ := fun A =>
      (absPos A).isSymmetric.eigenvalues rfl
    let N : (H →ₗ[ℂ] H) → ℝ := fun A =>
      Real.sqrt (∑ j : Fin n, singular A j ^ 2)
    (∀ A : H →ₗ[ℂ] H, 0 ≤ N A ∧ (N A = 0 ↔ A = 0)) ∧
    (∀ (c : ℂ) (A : H →ₗ[ℂ] H), N (c • A) = ‖c‖ * N A) ∧
    (∀ A B : H →ₗ[ℂ] H, N (A + B) ≤ N A + N B) ∧
    (∀ A : H →ₗ[ℂ] H,
      let t : ℂ := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
      t.im = 0 ∧ 0 ≤ t.re ∧
        (((∑ j : Fin n, singular A j ^ 2) : ℝ) : ℂ) = t ∧
        N A = Real.sqrt t.re)

end NumStability.Bhatia.Chapter01.Targets
