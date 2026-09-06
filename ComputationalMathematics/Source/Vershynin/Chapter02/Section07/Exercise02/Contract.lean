import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Exercise02.Signature

/-! Stable Chapter 2 source contract for Exercise 2.7.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Exercise 2.7.2: the tail, moment, local absolute-MGF, and one-point
absolute-MGF conditions are quantitatively equivalent with an absolute factor. -/
theorem hdp_02_hex_h2_d7_d2_exact :
    ∃ C : Real, 1 <= C ∧
      ∀ {Omega : Type*} [MeasurableSpace Omega]
        {mu : Measure Omega} [IsProbabilityMeasure mu] {X : Omega -> Real},
        ∀ i j : SubExponentialPropertyKind, ∀ {Ki : Real},
          0 < Ki -> SubExponentialProperty mu X i Ki ->
            ∃ Kj : Real, 0 < Kj ∧ Kj <= C * Ki ∧
              SubExponentialProperty mu X j Kj := by
  obtain ⟨C, hC, hAll⟩ := subExponentialCharacterization_uniform
  refine ⟨C, hC, ?_⟩
  intro Omega _ mu _ X i j Ki hKi hProp
  exact (hAll (mu := mu) (X := X)).1 i j hKi hProp

theorem hdp_02_hex_h2_d7_d2__contract :
    hdp_02_hex_h2_d7_d2__contract_type :=
  hdp_02_hex_h2_d7_d2_exact

end NumStability.HDP.Contract
