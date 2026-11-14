/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.2, printed page 4 (PDF page 16). Positivity is a supplied
hypothesis, and invertibility means a two-sided linear inverse. -/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- A positive operator is strictly positive exactly when it is invertible. -/
def positiveInvertible : Prop :=
  ∀ (H : Type u)
      [NormedAddCommGroup H] [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
      (A : H →ₗ[ℂ] H),
    A.IsPositive →
      ((∀ x : H, x ≠ 0 → 0 < (inner ℂ x (A x)).re) ↔
        ∃ B : H →ₗ[ℂ] H,
          A.comp B = LinearMap.id ∧ B.comp A = LinearMap.id)

end NumStability.Bhatia.Chapter01.Targets
