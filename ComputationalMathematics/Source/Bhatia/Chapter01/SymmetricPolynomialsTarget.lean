/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.NondecreasingIndicesTarget
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Fintype.Sets
import Mathlib.Data.List.FinRange
import Mathlib.Algebra.BigOperators.Group.Finset.Defs
import Mathlib.Algebra.Group.Commute.Defs
import Mathlib.Logic.Pairwise

set_option autoImplicit false
universe u
open scoped BigOperators
noncomputable section
attribute [local instance] Classical.propDecidable

namespace NumStability.Bhatia.Chapter01.Targets

/-- Positive ordered product. No multiplicative identity or distributivity
is used. Fin slot j corresponds to source slot j+1. -/
def positiveTupleMonomial {R : Type u} [Semigroup R] {n k : ℕ}
    (hk : 0 < k) (α : Fin n → R) (I : Fin k → Fin n) : R :=
  ((List.finRange k).drop 1).foldl
    (fun acc j => acc * α (I j)) (α (I ⟨0, hk⟩))

/-- Source e_k: each Q tuple contributes once. Pairwise commutation is an
input-domain condition, not an arbitrary desired-law callback. -/
def elementarySymmetricValue {R : Type u} [AddCommMonoid R] [Semigroup R]
    {n : ℕ} (α : Fin n → R)
    (_hcomm : Pairwise (fun i j : Fin n => Commute (α i) (α j)))
    (k : ℕ) (hk : 0 < k) : R :=
  ∑ I : {I : Fin k → Fin n // I ∈ increasingIndexSet n k},
    positiveTupleMonomial hk α I.val

/-- Source h_k: each G tuple contributes once, including repeated indices. -/
def completeSymmetricValue {R : Type u} [AddCommMonoid R] [Semigroup R]
    {n : ℕ} (α : Fin n → R)
    (_hcomm : Pairwise (fun i j : Fin n => Commute (α i) (α j)))
    (k : ℕ) (hk : 0 < k) : R :=
  ∑ I : {I : Fin k → Fin n // I ∈ nondecreasingIndexSet n k},
    positiveTupleMonomial hk α I.val

/-- Definition row only. No recurrence, homogeneity, invariance or trace theorem.
The expanded positive fold exposes the exact source products; no target-valued
input appears. These are definitions of values, not formal-polynomial equality. -/
def symmetricPolynomialsDefinitionTarget : Prop :=
  ∀ (R : Type u) [AddCommMonoid R] [Semigroup R] (n : ℕ)
    (α : Fin n → R)
    (hcomm : Pairwise (fun i j : Fin n => Commute (α i) (α j)))
    (k : ℕ) (hk : 0 < k),
    elementarySymmetricValue α hcomm k hk =
      ∑ I : {I : Fin k → Fin n // I ∈ increasingIndexSet n k},
        ((List.finRange k).drop 1).foldl
          (fun acc j => acc * α (I.val j)) (α (I.val ⟨0, hk⟩)) ∧
    completeSymmetricValue α hcomm k hk =
      ∑ I : {I : Fin k → Fin n // I ∈ nondecreasingIndexSet n k},
        ((List.finRange k).drop 1).foldl
          (fun acc j => acc * α (I.val j)) (α (I.val ⟨0, hk⟩))

end NumStability.Bhatia.Chapter01.Targets
