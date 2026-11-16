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

end NumStability.Source.DrineasMahoney.RandNLA2016
