import ComputationalMathematics.HDP.Scalar.SubExponentialCharacterization

/-! Frozen contract for Exercise 2.7.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

def hdp_02_hex_h2_d7_d2__contract_type : Prop :=
  ∃ C : Real, 1 <= C ∧
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
      ∀ i j : SubExponentialPropertyKind, ∀ {Ki : Real},
        0 < Ki -> SubExponentialProperty mu X i Ki ->
          ∃ Kj : Real, 0 < Kj ∧ Kj <= C * Ki ∧
            SubExponentialProperty mu X j Kj

end NumStability.HDP.Contract
