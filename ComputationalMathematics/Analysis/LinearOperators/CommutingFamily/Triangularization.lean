/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.LinearOperators.Triangularization
import ComputationalMathematics.Analysis.LinearOperators.CommutingFamily.Eigenvector

/-!
# A common triangular basis for a commuting family

An arbitrary commuting family of endomorphisms on a finite-dimensional vector
space over an algebraically closed field has one basis making every member
upper triangular. The index type may be empty or infinite.

Induction uses a common eigenline, a common triangular basis of the induced
quotient family, and the existing basis-gluing construction. Dimension zero
is included; no inner product or orthonormality is assumed.
-/

set_option autoImplicit false

namespace NumStability

/-- A commuting family has a single finite basis in which every coordinate
matrix is upper triangular, with no finiteness assumption on the family. -/
theorem exists_common_blockTriangular_toMatrix_of_finrank
    {K I : Type*} [Field K] [IsAlgClosed K] :
    ∀ n : ℕ, ∀ {V : Type*} [AddCommGroup V] [Module K V] [FiniteDimensional K V],
      Module.finrank K V = n →
      ∀ A : I → Module.End K V,
        (∀ a b, (A a).comp (A b) = (A b).comp (A a)) →
        ∃ b : Module.Basis (Fin n) K V,
          ∀ a, (LinearMap.toMatrix b b (A a)).BlockTriangular id := by
  intro n
  induction n with
  | zero =>
      intro V _ _ _ hfin A _hcomm
      let b : Module.Basis (Fin 0) K V :=
        basisOfFinrankZero (K := K) (V := V) (ι := Fin 0) hfin
      refine ⟨b, ?_⟩
      intro a i j hij
      exact Fin.elim0 i
  | succ n ih =>
      intro V _ _ _ hfin A hcomm
      have hpos : 0 < Module.finrank K V := by
        rw [hfin]
        exact Nat.succ_pos n
      haveI : Nontrivial V := Module.finrank_pos_iff.mp hpos
      obtain ⟨v, hvne, hAv⟩ := exists_common_eigenvector_of_commute A hcomm
      let W : Submodule K V := K ∙ v
      have hW (a : I) : W ≤ W.comap (A a) := by
        obtain ⟨μ, hμ⟩ := hAv a
        have hv : (A a).HasEigenvector μ v :=
          Module.End.hasEigenvector_iff.mpr
            ⟨Module.End.mem_eigenspace_iff.mpr hμ, hvne⟩
        exact eigenvector_span_le_comap hv
      have hfinW : Module.finrank K W = 1 := by
        simpa [W] using finrank_span_singleton (K := K) hvne
      have hquot : Module.finrank K (V ⧸ W) = n := by
        have hsum := Submodule.finrank_quotient_add_finrank (R := K) (M := V) W
        rw [hfinW, hfin] at hsum
        omega
      let AQ : I → Module.End K (V ⧸ W) := fun a => W.mapQ W (A a) (hW a)
      have hAQcomm (a b : I) : (AQ a).comp (AQ b) = (AQ b).comp (AQ a) := by
        apply LinearMap.ext
        intro x
        refine Submodule.Quotient.induction_on W x ?_
        intro y
        change W.mkQ ((A a) ((A b) y)) = W.mkQ ((A b) ((A a) y))
        exact congrArg W.mkQ (LinearMap.congr_fun (hcomm a b) y)
      obtain ⟨bQ, hTQ⟩ := ih (V := V ⧸ W) hquot AQ hAQcomm
      let vv : W := ⟨v, Submodule.mem_span_singleton_self v⟩
      have hvv_ne : vv ≠ 0 := by
        intro hzero
        exact hvne (congrArg Subtype.val hzero)
      let bW : Module.Basis (Fin 1) K W :=
        FiniteDimensional.basisSingleton (Fin 1) hfinW vv hvv_ne
      let b0 : Module.Basis (Fin (1 + n)) K V :=
        sumQuotFinBasis (K := K) (V := V) (m := 1) (n := n) (W := W) bW bQ
      have hb0 (a : I) : (LinearMap.toMatrix b0 b0 (A a)).BlockTriangular id := by
        apply sumQuotFinBasis_blockTriangular_toMatrix (hW a)
        · exact finOne_blockTriangular _
        · exact hTQ a
      have hdim : 1 + n = Nat.succ n := by omega
      refine ⟨b0.reindex (finCongr hdim), ?_⟩
      intro a
      exact blockTriangular_reindex_finCongr hdim (hb0 a)

end NumStability
