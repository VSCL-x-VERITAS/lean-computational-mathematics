import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.ImportanceUnbiasedness
import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.SamplingAlgorithms

/-! # Literal sampling constructions and supported unbiasedness -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

open scoped BigOperators

theorem elementwiseSamplingAlgorithm : Targets.elementwiseSamplingAlgorithm := by
  intro m n s A P _
  refine ⟨fun _ => rfl, P.iid_eventProb_positive s, ?_⟩
  intro ω i j
  simp only [elementwiseTraceSketchWithProb, zero_add,
    elementwiseTraceContributionWithProb, sampleHits, elementwiseIncrementWithProb]
  apply Finset.sum_congr rfl
  intro t _
  split <;> simp_all [div_eq_mul_inv, mul_comm]

theorem rowSamplingAlgorithm : Targets.rowSamplingAlgorithm := by
  intro m n s A P _
  refine ⟨fun _ => rfl, P.iid_eventProb_positive s, ?_⟩
  intro ω t j
  simp [rowSampleSketchWithProb, rowSampleIncrementWithProb,
    rowSampleScaleDenWithProb, div_eq_mul_inv, mul_comm]

theorem randomProjectionPreconditioningAlgorithm :
    Targets.randomProjectionPreconditioningAlgorithm := by
  intro m n L A R
  refine ⟨fun _ _ => rfl, fun _ _ => rfl, ?_⟩
  intro i j
  simp only [preconditionElements, preconditionColumns, preconditionRows,
    Finset.sum_mul]
  rw [Finset.sum_comm]

theorem elementwiseSamplingUnbiased : Targets.elementwiseSamplingUnbiased := by
  intro m n s A P hs hcover i j
  exact iid_elementwiseTraceSketchWithProb_expectation_entry A P hs hcover i j

theorem rowSamplingGramUnbiased : Targets.rowSamplingGramUnbiased := by
  intro m n s A P hs hcover j k
  exact iid_rowSampleSketchWithProb_expectation_gram A P hs hcover j k

end NumStability.Source.DrineasMahoney.RandNLA2016
