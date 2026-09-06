import ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization

/-! Frozen contract for Exercise 2.7.3. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_hex_h2_d7_d3__contract_type : Prop :=
  ∃ C : Real, 1 <= C ∧
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu]
      {X : Omega -> Real} {alpha : Real}, 0 < alpha ->
      ∀ i j : SubWeibullPropertyKind, ∀ {Ki : Real},
        0 < Ki -> SubWeibullProperty mu X alpha i Ki ->
          ∃ Kj : Real, 0 < Kj ∧ Kj <= C * Ki ∧
            SubWeibullProperty mu X alpha j Kj

end NumStability.HDP.Contract
