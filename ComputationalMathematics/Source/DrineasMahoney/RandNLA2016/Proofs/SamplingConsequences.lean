import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.SamplingConsequences

/-! # Column sampling and deterministic entry sparsity -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

open scoped BigOperators

theorem columnSamplingAlgorithm : Targets.columnSamplingAlgorithm := by
  intro m n s A P _
  refine ⟨fun _ => rfl, P.iid_eventProb_positive s, ?_⟩
  intro ω i t
  simp [rowSampleSketchWithProb, rowSampleIncrementWithProb,
    rowSampleScaleDenWithProb, div_eq_mul_inv, mul_comm]

theorem elementwiseSamplingSparsity : Targets.elementwiseSamplingSparsity := by
  classical
  intro m n s A P _ ω _
  let supp := Finset.univ.filter (fun ij : Fin m × Fin n =>
    elementwiseTraceSketchWithProb s A (fun _ _ => 0)
      (fun i j => P.prob (i,j)) ω ij.1 ij.2 ≠ 0)
  have hsub : supp ⊆ Finset.univ.image ω := by
    intro ij hij
    by_contra hn
    have hnot : ∀ t, ω t ≠ ij := by simpa using hn
    have hz : elementwiseTraceSketchWithProb s A (fun _ _ => 0)
        (fun i j => P.prob (i,j)) ω ij.1 ij.2 = 0 := by
      simp only [elementwiseTraceSketchWithProb, zero_add]
      apply Finset.sum_eq_zero
      intro t _
      have hdiff : ¬ ((ω t).1 = ij.1 ∧ (ω t).2 = ij.2) := by
        intro h
        exact hnot t (Prod.ext h.1 h.2)
      simp [elementwiseTraceContributionWithProb, sampleHits, hdiff]
    exact (Finset.mem_filter.mp hij).2 hz
  exact (Finset.card_le_card hsub).trans ((Finset.card_image_le).trans (by simp))

theorem gramErrorHighProbability : Targets.gramErrorHighProbability := by
  intro m n s A hA hs δ hδ _
  let P := rowSqNormTraceProbability (steps := s) A hA
  let X : RowTrace m s → ℝ := fun ω =>
    frobNorm (fun j k => rowSampleGram s A ω j k - rowGram A j k)
  let T := rowSqNormProbDen A / (δ * Real.sqrt (s : ℝ))
  have hsR : 0 < (s : ℝ) := by exact_mod_cast hs
  have hT : 0 < T := div_pos hA (mul_pos hδ (Real.sqrt_pos.mpr hsR))
  have hmarkov := FiniteProbability.eventProb_real_le_ge_one_sub_expectationReal_div
    P X T (fun _ => frobNorm_nonneg _) hT
  have hmean : P.expectationReal X ≤ rowSqNormProbDen A / Real.sqrt (s : ℝ) := by
    simpa [P, X, one_div, div_eq_mul_inv, mul_comm] using
      rowSqNormTraceProbability_expectationReal_rowSampleGram_frob_error_le A hA hsR
  have hratio : P.expectationReal X / T ≤ δ := by
    calc
      P.expectationReal X / T ≤ (rowSqNormProbDen A / Real.sqrt (s : ℝ)) / T :=
        div_le_div_of_nonneg_right hmean hT.le
      _ = δ := by
        dsimp [T]
        field_simp [hA.ne', hδ.ne', (Real.sqrt_pos.mpr hsR).ne']
  have hleft : 1 - δ ≤ 1 - P.expectationReal X / T := by linarith
  exact hleft.trans hmarkov

end NumStability.Source.DrineasMahoney.RandNLA2016
