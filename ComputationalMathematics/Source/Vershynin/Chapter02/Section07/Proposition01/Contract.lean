import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Proposition01.Signature

/-! Stable Chapter 2 source contract for Proposition 2.7.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.IndependentSums.Bernstein

/-- Proposition 2.7.1: the four absolute-value sub-exponential properties are
equivalent up to an absolute factor, and centering adds the local MGF property
for `X` itself. -/
theorem hdp_02_hprop_h2_d7_d1_exact :
    ∃ C : Real, 1 <= C ∧
      ∀ {Omega : Type*} [MeasurableSpace Omega]
        {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
        (∀ i j : SubExponentialPropertyKind, ∀ {Ki : Real},
          0 < Ki -> SubExponentialProperty mu X i Ki ->
            ∃ Kj : Real, 0 < Kj ∧ Kj <= C * Ki ∧
              SubExponentialProperty mu X j Kj) ∧
        ((Integrable X mu ∧ (∫ omega, X omega ∂mu) = 0) ->
          (∀ {K2 : Real}, 0 < K2 ->
            SubExponentialProperty mu X .moment K2 ->
              ∃ K5 : Real, 0 < K5 ∧ K5 <= C * K2 ∧
                SubExponentialLinearMGF mu X K5) ∧
          (∀ {K5 : Real}, 0 < K5 ->
            SubExponentialLinearMGF mu X K5 ->
              ∃ K2 : Real, 0 < K2 ∧ K2 <= C * K5 ∧
                SubExponentialProperty mu X .moment K2)) :=
  subExponentialCharacterization_uniform

theorem hdp_02_hprop_h2_d7_d1__contract :
    hdp_02_hprop_h2_d7_d1__contract_type :=
  hdp_02_hprop_h2_d7_d1_exact

end NumStability.HDP.Contract
