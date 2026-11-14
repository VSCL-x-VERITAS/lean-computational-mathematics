/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Algebra.Polynomial.Roots
import Mathlib.Data.Multiset.ZeroCons
import Mathlib.Analysis.Complex.Norm

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- Proposed precise reading of Bhatia I.3, printed page 11: polynomial roots
vary continuously with the coefficients. The statement uses complete
multiset matching, preserves all nonmonic polynomials of fixed exact degree,
and includes nonzero constants at degree zero. -/
noncomputable def rootsContinuousMatchingTarget : Prop :=
  ∀ (n : ℕ) (p : Polynomial ℂ),
    p ≠ 0 → p.natDegree = n →
    ∀ ε : ℝ, 0 < ε →
      ∃ δ : ℝ, 0 < δ ∧
        ∀ q : Polynomial ℂ,
          q ≠ 0 → q.natDegree = n →
          (∀ j : ℕ, j ≤ n → ‖q.coeff j - p.coeff j‖ < δ) →
          Multiset.Rel (fun z w : ℂ => ‖z - w‖ < ε) p.roots q.roots

end NumStability.Bhatia.Chapter01.Targets
