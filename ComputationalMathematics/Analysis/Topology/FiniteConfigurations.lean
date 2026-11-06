/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Topology.Constructions
import Mathlib.Topology.Separation.Basic
import Mathlib.Topology.Perfect
import Mathlib.Data.Fin.Tuple.Basic
import Mathlib.Data.Set.Finite.Basic

/-!
# Distinct finite configurations

A finite family of infinite sets has a system of distinct representatives.
Consequently, injective finite tuples are dense in any T1 space without
isolated points, including the empty tuple. The topology is the actual finite
product topology, and no nonempty index or target type is assumed.
-/

set_option autoImplicit false

namespace NumStability

/-- Choose distinct representatives from a finite family of infinite sets. -/
theorem exists_injective_mem_infinite {X : Type*} :
    ∀ (n : ℕ) (s : Fin n → Set X), (∀ i, (s i).Infinite) →
      ∃ f : Fin n → X, Function.Injective f ∧ ∀ i, f i ∈ s i := by
  classical
  intro n
  induction n with
  | zero =>
    intro s hs
    refine ⟨Fin.elim0, ?_, ?_⟩
    · intro i
      exact Fin.elim0 i
    · intro i
      exact Fin.elim0 i
  | succ n ih =>
    intro s hs
    obtain ⟨f, hf, hmem⟩ := ih (fun i => s i.succ) (fun i => hs i.succ)
    obtain ⟨a, ha, havoid⟩ := (hs 0).exists_notMem_finset (Finset.univ.image f)
    have hnot : a ∉ Set.range f := by
      rintro ⟨i, rfl⟩
      exact havoid (Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩)
    refine ⟨Fin.cons a f, Fin.cons_injective_of_injective hnot hf, ?_⟩
    intro i
    refine Fin.cases ?_ (fun j => ?_) i
    · simpa only [Fin.cons_zero] using ha
    · simpa only [Fin.cons_succ] using hmem j

/-- Distinct finite tuples are dense in a T1 space with no isolated points. -/
theorem dense_injective_fin {X : Type*} [TopologicalSpace X] [T1Space X]
    [PerfectSpace X] (n : ℕ) :
    Dense {f : Fin n → X | Function.Injective f} := by
  classical
  refine dense_iff_inter_open.mpr ?_
  intro U hU hnonempty
  obtain ⟨a, ha⟩ := hnonempty
  obtain ⟨s, hs, hsub⟩ := isOpen_pi_iff'.mp hU a ha
  have hinf (i : Fin n) : (s i).Infinite :=
    infinite_of_mem_nhds (a i) ((hs i).1.mem_nhds (hs i).2)
  obtain ⟨f, hf, hmem⟩ := exists_injective_mem_infinite n s hinf
  exact ⟨f, hsub (fun i _ => hmem i), hf⟩

end NumStability
