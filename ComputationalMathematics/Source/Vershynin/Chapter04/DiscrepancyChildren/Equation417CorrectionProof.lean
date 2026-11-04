import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.Equation417Children
import ComputationalMathematics.Source.Vershynin.Chapter04.DiscrepancyChildren.BalancedMean
import ComputationalMathematics.HDP.Graph.CommunityZeroSumKernel
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.ActualSpectrum

/-!
# Complete corrected Equation (4.17)

These source-model results support the separately specified analyst-derived
children of the printed stochastic-block claims.
-/

noncomputable section

set_option maxHeartbeats 1000000
set_option backward.isDefEq.respectTransparency false

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren

private theorem reindex_action {α β : Type*} [Fintype α] [Fintype β]
    (e : α ≃ β) (A : Matrix α α ℝ) (x : α → ℝ) :
    (Matrix.reindex e e A).mulVec (x ∘ e.symm) = (A.mulVec x) ∘ e.symm := by
  rw [Matrix.reindex_apply, Matrix.submatrix_mulVec_equiv]
  simp [Function.comp_def]

private theorem reindex_hasEigenvalue_iff {α β : Type*} [Fintype α] [Fintype β]
    (e : α ≃ β) (A : Matrix α α ℝ) (r : ℝ) :
    Module.End.HasEigenvalue (Matrix.reindex e e A).mulVecLin r ↔
      Module.End.HasEigenvalue A.mulVecLin r := by
  simp only [Module.End.hasEigenvalue_iff]
  change (¬ _ = ⊥) ↔ (¬ _ = ⊥)
  rw [← Submodule.finrank_eq_zero, ← Submodule.finrank_eq_zero, NumStability.HDP.Matrix.finrank_eigenspace_reindex]

/-- All balanced labelings satisfy the corrected expectation, rank, complement and complete signed-spectrum statements. -/
theorem equation417_correction_child_proved : HDP04Equation417CorrectionChildTarget := by
  classical
  intro k hk θ c hc hpq
  dsimp only
  obtain ⟨e, he, hB, hM⟩ := BalancedMean.balanced_reindex c hc θ.p θ.q
  have hones : (fun _ : Fin (2*k) => (1 : ℝ)) = StochasticBlock.allOnes k ∘ e.symm := rfl
  have hsign : (fun i : Fin (2*k) => if c i = 0 then (1 : ℝ) else -1) =
      StochasticBlock.communitySign k ∘ e.symm := by
    ext i
    have hi := he (e.symm i)
    simp only [Equiv.apply_symm_apply] at hi
    simp [StochasticBlock.communitySign, hi]
  have hBp := StochasticBlock.expectedAdjacency_rank_eq_two hk θ.q.coe_nonneg hpq
  have hMrank : Module.finrank ℝ
      (Module.End.eigenspace (FinStochasticBlock.expectedAdjacency c θ.p θ.q).mulVecLin
        (-(θ.p : ℝ))) = 2*k-2 := by
    rw [hM, NumStability.HDP.Matrix.finrank_eigenspace_reindex, looplessExpectedAdjacency_eq_displayed_sub_diagonal]
    exact StochasticBlock.finrank_expectedAdjacency_sub_diagonal_eigenspace hk θ.q.coe_nonneg hpq
  have horder := BalancedMean.balanced_mean_ordered hk θ c hc hpq
  refine ⟨FinStochasticBlock.adjacency_expectation c θ, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, hMrank, ?_, ?_, ?_⟩
  · intro i j
    by_cases h : i = j <;> simp [FinStochasticBlock.expectedAdjacency, h]
  · intro h
    have hi := congrFun (congrFun h (⟨0, by omega⟩ : Fin (2*k))) ⟨0, by omega⟩
    simp [FinStochasticBlock.expectedAdjacency] at hi
    exact (ne_of_gt (show (0 : ℝ) < θ.p by exact lt_of_le_of_lt θ.q.coe_nonneg hpq)) hi.symm
  · change (BalancedMean.block c θ.p θ.q).rank = 2
    rw [hB, Matrix.rank_reindex]; exact hBp
  · change (BalancedMean.block c θ.p θ.q).mulVec _ = _
    rw [hones, hB, reindex_action, StochasticBlock.expectedAdjacency_mulVec_allOnes]; rfl
  · change (BalancedMean.block c θ.p θ.q).mulVec _ = _
    rw [hsign, hB, reindex_action, StochasticBlock.expectedAdjacency_mulVec_communitySign]; rfl
  · rw [hones, hM, reindex_action, (hdp_04_equation_4_17_corrected hk θ hpq).1]; rfl
  · rw [hsign, hM, reindex_action, (hdp_04_equation_4_17_corrected hk θ hpq).2]; rfl
  · intro x hx
    have hsum (b : Fin 2) : ∑ a : Fin k, (x ∘ e) (b,a) = 0 := by
      have hh := hx b
      rw [← e.sum_comp] at hh
      fin_cases b <;> simpa [Function.comp_def, he, Fintype.sum_prod_type] using hh
    have hzero := StochasticBlock.expectedAdjacency_mulVec_eq_zero_of_community_sums k
      (θ.p : ℝ) (θ.q : ℝ) (x ∘ e) hsum
    have hx' : x = (x ∘ e) ∘ e.symm := by ext i; simp [Function.comp_def]
    constructor
    · change (BalancedMean.block c θ.p θ.q).mulVec x = 0
      rw [hB, hx', reindex_action, hzero]; rfl
    · rw [hM, hx', reindex_action,
        (hdp_04_equation_4_17_loopless_full_corrected hk θ hpq).2.2.2 _ hsum]; rfl
  · have hdim := LinearMap.finrank_range_add_finrank_ker (BalancedMean.block c θ.p θ.q).mulVecLin
    have hr : Module.finrank ℝ (LinearMap.range (BalancedMean.block c θ.p θ.q).mulVecLin) = 2 := by
      change (BalancedMean.block c θ.p θ.q).rank = 2
      rw [hB, Matrix.rank_reindex]; exact hBp
    rw [hr] at hdim
    simp only [Module.finrank_fintype_fun_eq_card, Fintype.card_fin] at hdim
    exact Nat.eq_sub_of_add_eq' hdim
  · intro r
    rw [hM, reindex_hasEigenvalue_iff,
      ← stochasticBlock_mean_matrix_eq_loopless hk θ hpq]
    exact stochasticBlock_mean_hasEigenvalue_iff hk θ hpq r
  · refine ⟨BalancedMean.block_hermitian c θ.p θ.q, ?_, ?_, ?_⟩
    · have h := BalancedMean.block_mean_ordered_shift c (θ.p : ℝ) (θ.q : ℝ) ⟨0, by omega⟩
      rw [horder.1] at h; linarith
    · have h := BalancedMean.block_mean_ordered_shift c (θ.p : ℝ) (θ.q : ℝ) ⟨1, by omega⟩
      rw [horder.2.1] at h; linarith
    · intro j hj
      have h := BalancedMean.block_mean_ordered_shift c (θ.p : ℝ) (θ.q : ℝ) j
      rw [horder.2.2 j hj] at h; linarith
  · exact ⟨BalancedMean.mean_hermitian c θ.p θ.q, horder⟩

end NumStability.HDP.Contract.DiscrepancyChildren
