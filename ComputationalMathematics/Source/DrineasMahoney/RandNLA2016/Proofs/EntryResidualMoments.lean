import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.EntryResidualMoments

/-! Covered-support raw Algorithm1 residual moments for source row016. -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem entryResidualMeanVariance : Targets.entryResidualMeanVariance := by
  intro m n s A P _hm _hn hs hcover i j
  have hcover0 : ∀ r c, P.prob (r,c) = 0 → A r c = 0 := by
    intro r c hp
    by_contra hA
    have hpos := hcover r c hA
    rw [hp] at hpos
    exact (lt_irrefl 0 hpos)
  refine ⟨iid_entrySamplingResidual_expectation_eq_zero A P hs hcover0 i j, ?_, ?_⟩
  · intro hp
    have hv := iid_entrySamplingResidual_variance_eq A P hs hcover0 i j hp
    refine ⟨hv, ?_, ?_⟩
    · rw [← hv]
      exact FiniteProbability.varianceReal_nonneg _ _
    · intro ω _hω
      exact entrySamplingResidual_abs_le A P hs i j hp ω
  · intro hp
    exact ⟨hcover0 i j hp,
      iid_entrySamplingResidual_zero_prob_event_eq_one A P hcover0 i j hp,
      iid_entrySamplingResidual_variance_eq_zero_of_prob_zero A P hcover0 i j hp⟩

end NumStability.Source.DrineasMahoney.RandNLA2016
