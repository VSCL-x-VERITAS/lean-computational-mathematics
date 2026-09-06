import ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization

/-!
# Frozen contract for Proposition 2.7.1

This proof-free signature records the uniform absolute-constant equivalence of
the four sub-exponential properties and, under centering, property (e).
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential
open NumStability.HDP.Scalar.IndependentSums.Bernstein

def hdp_02_hprop_h2_d7_d1__contract_type : Prop :=
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
              SubExponentialProperty mu X .moment K2))

end NumStability.HDP.Contract
