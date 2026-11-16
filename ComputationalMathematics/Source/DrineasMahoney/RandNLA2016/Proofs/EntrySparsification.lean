import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.EntrySparsification
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Equation02.SpectralApproximation.OneSidedDilation

/-! # Thresholded importance-sampling concentration -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem correctedTruncatedEntryGuarantee : Targets.correctedTruncatedEntryGuarantee := by
  classical
  intro n s A eps δ hn hs heps hδ hδ1 hsample
  let tau : ℝ := eps / (2 * (n : ℝ))
  let E : Set (Option (ElementwiseTrace n n s)) :=
    {outcome |
      rectOpNorm2Le (fun i j => A i j - truncatedElementwiseSketch tau A outcome i j) eps ∧
      (Finset.univ.filter (fun ij : Fin n × Fin n =>
        truncatedElementwiseSketch tau A outcome ij.1 ij.2 ≠ 0)).card ≤ s}
  change 1 - δ ≤ (truncatedElementwiseProbability tau A).eventProb E
  by_cases hden : 0 < sqMagProbDen (elementwiseTruncate tau A)
  · rw [truncatedElementwiseProbability_eventProb_of_pos tau A hden E]
    have hbase :=
      sqMagTraceProbability_eventProb_algorithm1ExactTruncatedSpectralEvent_ge_one_sub_delta_source_sample_budget_one_tail
        (n := n) (s := s) (eps := eps) (δ := δ)
        (by exact_mod_cast hn) (by exact_mod_cast hs) A hden hδ (le_of_lt hδ1) heps hsample
    apply hbase.trans
    apply FiniteProbability.eventProb_mono
    intro samples hgood
    exact ⟨by simpa [E, tau, algorithm1ExactTruncatedSpectralEvent,
      elementwiseTruncatedTraceResidual, truncatedElementwiseSketch] using hgood,
      truncatedElementwiseSketch_nonzero_card_le tau A (some samples)⟩
  · rw [truncatedElementwiseProbability_eventProb_of_not_pos tau A hden E,
      FiniteProbability.eventProb_atNone]
    have hnone : none ∈ E := by
      refine ⟨?_, truncatedElementwiseSketch_nonzero_card_le tau A none⟩
      apply rectOpNorm2Le_mono (show eps / 2 ≤ eps by linarith)
      exact truncatedElementwiseSketch_none_error A (le_of_lt heps) hn hden
    simp only [if_pos hnone]
    linarith

end NumStability.Source.DrineasMahoney.RandNLA2016
