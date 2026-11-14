/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Fin.Tuple.Sort
import Mathlib.Data.Sym.Card
import Mathlib.Data.Vector.Basic

/-!
# Monotone tuples and finite symmetric indices

A nondecreasing tuple is the unique sorted representative of its multiset.
The equivalence below identifies monotone tuples with fixed-cardinality
multisets, and transports the existing `Sym.card_sym_eq_choose` count.
No new stars-and-bars proof or tensor carrier is constructed.
-/

set_option autoImplicit false

noncomputable section

namespace Tuple

/-- Nondecreasing tuples are the unique sorted representatives of fixed-size
multisets. The forward map keeps every entry and its multiplicity. -/
noncomputable def monotoneEquivSym (α : Type*) [LinearOrder α] (k : ℕ) :
    {f : Fin k → α // Monotone f} ≃ Sym α k :=
  Equiv.ofBijective
    (fun f => Sym.ofVector (List.Vector.ofFn f.1)) (by
      constructor
      · intro f g h
        apply Subtype.ext
        apply List.ofFn_injective
        have hm : ((List.ofFn f.1 : List α) : Multiset α) =
            ((List.ofFn g.1 : List α) : Multiset α) := by
          have hm := congrArg Sym.toMultiset h
          change ((List.Vector.ofFn f.1).toList : Multiset α) =
            ((List.Vector.ofFn g.1).toList : Multiset α) at hm
          simpa only [List.Vector.toList_ofFn] using hm
        have hp : List.Perm (List.ofFn f.1) (List.ofFn g.1) := Quotient.exact hm
        exact hp.eq_of_pairwise' f.2.sortedLE_ofFn.pairwise g.2.sortedLE_ofFn.pairwise
      · rintro ⟨s, hs⟩
        revert hs
        refine Quotient.inductionOn s ?_
        intro l hl
        let v : List.Vector α k := ⟨l, by simpa using hl⟩
        let f : Fin k → α := v.get
        refine ⟨⟨f ∘ Tuple.sort f, Tuple.monotone_sort f⟩, ?_⟩
        change Sym.ofVector (List.Vector.ofFn (f ∘ Tuple.sort f)) = ⟨(l : Multiset α), hl⟩
        calc
          _ = Sym.ofVector (List.Vector.ofFn f) :=
            Sym.sound (by
              change (List.Vector.ofFn (f ∘ Tuple.sort f)).toList.Perm
                (List.Vector.ofFn f).toList
              simpa only [List.Vector.toList_ofFn] using
                (Tuple.sort f).ofFn_comp_perm f)
          _ = Sym.ofVector v := by
            change Sym.ofVector (List.Vector.ofFn v.get) = Sym.ofVector v
            rw [List.Vector.ofFn_get]
          _ = ⟨(l : Multiset α), hl⟩ := rfl)

/-- The equivalence sends a sorted tuple to its full multiset, without
removing repeated entries. -/
@[simp] theorem monotoneEquivSym_apply {α : Type*} [LinearOrder α] {k : ℕ}
    (f : {f : Fin k → α // Monotone f}) :
    monotoneEquivSym α k f = Sym.ofVector (List.Vector.ofFn f.1) := rfl

/-- Count nondecreasing tuples using the existing multiset cardinality
formula; this theorem does not assert any vector-space dimension. -/
theorem card_monotone_tuples (α : Type*) [Fintype α] [LinearOrder α] (k : ℕ) :
    Fintype.card {f : Fin k → α // Monotone f} =
      (Fintype.card α + k - 1).choose k := by
  classical
  rw [Fintype.card_congr (monotoneEquivSym α k)]
  exact Sym.card_sym_eq_choose k

end Tuple
