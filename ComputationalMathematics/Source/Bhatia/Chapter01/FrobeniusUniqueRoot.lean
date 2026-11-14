/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.FrobeniusUniqueRootTarget
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Frobenius

/-!
# Bhatia's singular-square norm and Gram trace

Bhatia, *Matrix Analysis*, Section I.2, printed page 7 (PDF page 19),
with the prescribed positive absolute value from printed page 5 (PDF page 17).

The full eigenvalue tuple of the unique positive square root of the Gram
operator defines a norm. Its square is the actual complex Gram trace, which
is real and nonnegative. The proof transports this prescribed root to the
intrinsic Frobenius API, including finite-dimensional spaces of dimension zero.
-/

set_option autoImplicit false
open scoped BigOperators
universe u

namespace NumStability.Bhatia.Chapter01

/-- The singular-square prescription satisfies the norm laws and the source's
Gram-trace formula on every finite-dimensional complex inner-product space. -/
theorem frobeniusNormAndTraceUniqueRoot : Targets.frobeniusNormAndTraceUniqueRoot.{u} := by
  intro H _ _ _
  let absOp : (H →ₗ[ℂ] H) → (H →ₗ[ℂ] H) := fun A =>
    NumStability.positiveSquareRoot ((LinearMap.adjoint A).comp A)
      (LinearMap.isPositive_adjoint_comp_self A)
  let absPos : ∀ A : H →ₗ[ℂ] H, (absOp A).IsPositive := fun A =>
    NumStability.positiveSquareRoot_isPositive ((LinearMap.adjoint A).comp A)
      (LinearMap.isPositive_adjoint_comp_self A)
  let singular : (H →ₗ[ℂ] H) → Fin (Module.finrank ℂ H) → ℝ := fun A =>
    (absPos A).isSymmetric.eigenvalues rfl
  let N : (H →ₗ[ℂ] H) → ℝ := fun A =>
    Real.sqrt (∑ j, singular A j ^ 2)
  have hs (A : H →ₗ[ℂ] H) : singular A = NumStability.linearMapSingularValue A := by
    let eig : { T : H →ₗ[ℂ] H // T.IsPositive } → Fin (Module.finrank ℂ H) → ℝ :=
      fun T => T.property.isSymmetric.eigenvalues rfl
    have hroot : (⟨absOp A, absPos A⟩ : { T : H →ₗ[ℂ] H // T.IsPositive }) =
        ⟨NumStability.linearMapAbs A, NumStability.linearMapAbs_isPositive A⟩ :=
      Subtype.ext (NumStability.positiveSquareRoot_adjoint_comp_self A)
    exact congrArg eig hroot
  have hN (A : H →ₗ[ℂ] H) : N A = NumStability.linearMapFrobenius A :=
    congrArg (fun s : Fin (Module.finrank ℂ H) → ℝ => Real.sqrt (∑ j, s j ^ 2)) (hs A)
  change (∀ A : H →ₗ[ℂ] H, 0 ≤ N A ∧ (N A = 0 ↔ A = 0)) ∧
    (∀ (c : ℂ) (A : H →ₗ[ℂ] H), N (c • A) = ‖c‖ * N A) ∧
    (∀ A B : H →ₗ[ℂ] H, N (A + B) ≤ N A + N B) ∧
    (∀ A : H →ₗ[ℂ] H,
      let t := LinearMap.trace ℂ H ((LinearMap.adjoint A).comp A)
      t.im = 0 ∧ 0 ≤ t.re ∧
        (((∑ j, singular A j ^ 2) : ℝ) : ℂ) = t ∧ N A = Real.sqrt t.re)
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro A
    rw [hN]
    exact ⟨NumStability.linearMapFrobenius_nonneg A,
      NumStability.linearMapFrobenius_eq_zero_iff A⟩
  · intro c A
    rw [hN, hN]
    exact NumStability.linearMapFrobenius_smul c A
  · intro A B
    rw [hN, hN, hN]
    exact NumStability.linearMapFrobenius_add_le A B
  · intro A
    dsimp only
    have ht := NumStability.trace_adjoint_comp_self_eq_frobenius_sq A
    refine ⟨?_, ?_, ?_, ?_⟩
    · rw [ht, Complex.ofReal_im]
    · rw [ht, Complex.ofReal_re]
      exact sq_nonneg _
    · rw [hs, ← NumStability.linearMapFrobenius_sq, ht]
    · rw [hN]
      exact NumStability.linearMapFrobenius_eq_sqrt_re_trace A

end NumStability.Bhatia.Chapter01
