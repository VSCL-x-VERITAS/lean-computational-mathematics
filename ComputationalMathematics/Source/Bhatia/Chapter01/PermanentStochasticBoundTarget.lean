/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Complex.Order
import Mathlib.Data.Fintype.Perm
import Mathlib.LinearAlgebra.Matrix.PosDef

/-!
# Bhatia Chapter I: the permanent bound for positive stochastic matrices

Proof-free target for Problem I.6.14(iii), printed page 23 (PDF page 35).
The permanent is written as the source's unsigned column-permutation sum.
All finite sizes are included, with the standard empty-product, factorial,
and exponent-zero conventions at size zero. The following equality
characterization is a separate statement.
-/

set_option autoImplicit false

open scoped BigOperators ComplexOrder

namespace NumStability.Bhatia.Chapter01.Targets

/-- The source permanent lower bound for a complex positive semidefinite matrix
with nonnegative entries and every row sum equal to one. -/
def permanentStochasticBound : Prop :=
  ∀ n : ℕ, ∀ A : Matrix (Fin n) (Fin n) ℂ,
    Matrix.PosSemidef A →
      (∀ i j : Fin n, 0 ≤ A i j) →
        (∀ i : Fin n, ∑ j : Fin n, A i j = 1) →
          (((Nat.factorial n : ℝ) / (n : ℝ) ^ n) : ℂ) ≤
            ∑ σ : Equiv.Perm (Fin n), ∏ i : Fin n, A i (σ i)

end NumStability.Bhatia.Chapter01.Targets
