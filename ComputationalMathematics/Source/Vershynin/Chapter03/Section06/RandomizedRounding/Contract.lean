import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.RandomizedRounding.Signature

/-! Section 3.6.3: sample a standard Gaussian normal and round by its hyperplane. -/

namespace NumStability.HDP.Contract

open MeasureTheory

theorem hdp_03_body_3_6_randomized_rounding :
    hdp_03_body_3_6_randomized_rounding__contract_type := by
  intro n X
  dsimp only
  haveI : IsProbabilityMeasure (NumStability.standardGaussianEuclideanMeasure n) := by
    unfold NumStability.standardGaussianEuclideanMeasure
    exact Measure.isProbabilityMeasure_map (by fun_prop)
  refine ⟨IsProbabilityMeasure.measure_univ, ?_, ?_⟩
  · apply measurable_pi_iff.mpr
    intro i
    simp only [NumStability.HDP.Graph.hyperplaneRounding_apply,
      NumStability.HDP.Graph.hyperplaneSign_value]
    apply Measurable.ite
    · exact measurableSet_lt (by fun_prop) measurable_const
    · exact measurable_const
    · exact measurable_const
  · congr 1
    funext g i
    exact NumStability.HDP.Graph.hyperplaneSign_value (X i) g

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_6_randomized_rounding__contract :
    hdp_03_body_3_6_randomized_rounding__contract_type :=
  hdp_03_body_3_6_randomized_rounding

end NumStability.HDP.Contract
