/-
SPDX-License-Identifier: MIT
-/
import Mathlib.LinearAlgebra.Matrix.Permanent
import Mathlib.Data.Fin.Tuple.Sort
import Mathlib.Algebra.BigOperators.GroupWithZero.Finset

/-!
# Equality-matrix permanents of sorted tuples

Distinct monotone tuples cannot be permutations of one another. Their cross
label-equality matrix therefore has permanent zero: every permutation term
contains a zero entry. The proof reuses `Tuple.unique_monotone` rather than
constructing a new permutation-matching or multiset equivalence.
-/

set_option autoImplicit false

open scoped BigOperators

namespace Matrix

/-- The equality cross-matrix of two distinct monotone tuples has permanent
zero, over any commutative semiring. Repeated labels are allowed. -/
theorem permanent_ite_eq_zero_of_monotone_ne
    {k : ℕ} {α R : Type*} [PartialOrder α] [DecidableEq α] [CommSemiring R]
    (f g : Fin k → α) (hf : Monotone f) (hg : Monotone g) (hfg : f ≠ g) :
    permanent (fun i j => if f i = g j then (1 : R) else 0) = 0 := by
  have hσ (σ : Equiv.Perm (Fin k)) : ¬ ∀ i, f (σ i) = g i := by
    intro h
    have he : f ∘ σ = g := funext h
    have hm : Monotone (f ∘ σ) := by rw [he]; exact hg
    have hs : f ∘ σ = f ∘ Equiv.refl _ :=
      Tuple.unique_monotone hm hf
    exact hfg (hs.symm.trans he)
  simp only [permanent, Fintype.prod_boole]
  apply Finset.sum_eq_zero
  intro σ _
  exact if_neg (hσ σ)

end Matrix
