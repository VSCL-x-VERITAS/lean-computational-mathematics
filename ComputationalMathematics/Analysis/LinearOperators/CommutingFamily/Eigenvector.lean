/-
SPDX-License-Identifier: MIT
-/
import Mathlib.LinearAlgebra.Eigenspace.Triangularizable

/-!
# Common eigenvectors of commuting families

A pairwise commuting family on a nonzero finite-dimensional vector space over
an algebraically closed field has a common eigenvector. The indexing type is
arbitrary: no finiteness or nonemptiness condition is needed.

The proof inducts on the ambient dimension. If every member is scalar, any
nonzero vector works. Otherwise an eigenspace of a nonscalar member is a
nonzero proper subspace invariant under the entire family.
-/

set_option autoImplicit false

namespace NumStability

/-- A commuting family on a nonzero finite-dimensional space over an
algebraically closed field has a common nonzero eigenvector, including when
the family is empty or infinitely indexed. -/
theorem exists_common_eigenvector_of_commute
    {K V I : Type*} [Field K] [IsAlgClosed K] [AddCommGroup V] [Module K V]
    [FiniteDimensional K V] [Nontrivial V]
    (A : I → Module.End K V)
    (hcomm : ∀ a b, (A a).comp (A b) = (A b).comp (A a)) :
    ∃ v : V, v ≠ 0 ∧ ∀ a : I, ∃ μ : K, A a v = μ • v := by
  classical
  generalize hn : Module.finrank K V = n
  induction n using Nat.strong_induction_on generalizing V with
  | h n ih =>
    by_cases hscalar : ∀ a : I, ∃ μ : K, A a = μ • LinearMap.id
    · obtain ⟨v, hv⟩ := exists_ne (0 : V)
      refine ⟨v, hv, ?_⟩
      intro a
      obtain ⟨μ, hμ⟩ := hscalar a
      exact ⟨μ, by rw [hμ]; rfl⟩
    · obtain ⟨a, ha⟩ := not_forall.mp hscalar
      obtain ⟨μ, hμ⟩ := (A a).exists_eigenvalue
      let W : Submodule K V := (A a).eigenspace μ
      have hWbot : W ≠ ⊥ := hμ
      have hWtop : W ≠ ⊤ := by
        intro htop
        apply ha
        refine ⟨μ, ?_⟩
        ext x
        have hx : x ∈ W := by rw [htop]; exact Submodule.mem_top
        exact Module.End.mem_eigenspace_iff.mp hx
      have hWdim : Module.finrank K W < n := by
        rw [← hn]
        exact Submodule.finrank_lt hWtop
      have hW (b : I) : ∀ x ∈ W, A b x ∈ W := by
        intro x hx
        change A b x ∈ (A a).eigenspace μ
        rw [Module.End.mem_eigenspace_iff] at hx ⊢
        calc
          A a (A b x) = A b (A a x) := congrArg (fun T : Module.End K V => T x) (hcomm a b)
          _ = μ • A b x := by rw [hx, map_smul]
      let B : I → Module.End K W := fun b => (A b).restrict (hW b)
      have hB : ∀ b c, (B b).comp (B c) = (B c).comp (B b) := by
        intro b c
        ext x
        exact congrArg (fun T : Module.End K V => T (x : V)) (hcomm b c)
      haveI : Nontrivial W := Submodule.nontrivial_iff_ne_bot.mpr hWbot
      obtain ⟨v, hv, hAv⟩ := ih (Module.finrank K W) hWdim B hB rfl
      refine ⟨(v : V), ?_, ?_⟩
      · intro hz
        apply hv
        exact Subtype.ext hz
      · intro b
        obtain ⟨ν, hν⟩ := hAv b
        exact ⟨ν, congrArg Subtype.val hν⟩

end NumStability
