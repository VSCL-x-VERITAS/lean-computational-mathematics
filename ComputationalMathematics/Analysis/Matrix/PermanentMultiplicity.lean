/-
SPDX-License-Identifier: MIT
-/
import Mathlib.LinearAlgebra.Matrix.Permanent
import Mathlib.GroupTheory.Perm.DomMulAct
import Mathlib.Algebra.BigOperators.GroupWithZero.Finset
import Mathlib.Algebra.BigOperators.Ring.Finset

/-!
# Permanents and multiplicities of finite fibers

The permanent of the equality matrix of a finite map counts the permutations
preserving that map. The existing `DomMulAct.stabilizer_card` identifies this
count with the product of the factorials of the fiber cardinalities.

This reusable matrix leaf introduces no permanent or multiplicity definition
and does not reconstruct the permutation stabilizer equivalence.
-/

set_option autoImplicit false

open scoped BigOperators

namespace Matrix

/-- The permanent of the equality matrix of a finite map is the product of
its fiber-cardinality factorials, cast into the entry semiring. -/
theorem permanent_ite_eq_prod_factorial_card_fiber
    {ι α R : Type*} [Fintype ι] [DecidableEq ι] [Fintype α] [DecidableEq α]
    [CommSemiring R] (f : ι → α) :
    permanent (fun i j => if f i = f j then (1 : R) else 0) =
      (((∏ a : α, Nat.factorial (Fintype.card {i // f i = a})) : ℕ) : R) := by
  have hp (σ : Equiv.Perm ι) :
      (∀ i, f (σ i) = f i) ↔ f ∘ σ = f := funext_iff.symm
  simp only [permanent, Fintype.prod_boole]
  simp_rw [hp]
  rw [Finset.sum_boole, ← Fintype.card_subtype, DomMulAct.stabilizer_card]

end Matrix
