import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Exercise03.Signature

/-! Stable Chapter 2 source contract for Exercise 2.7.3. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.SubExponential

/-- Exercise 2.7.3: for every positive power `alpha`, applying the four
sub-exponential characterizations to `|X|^alpha` gives a quantitative
characterization of tails on the scale `exp (-c t^alpha)`. -/
theorem hdp_02_hex_h2_d7_d3_exact :
    ∃ C : Real, 1 <= C ∧
      ∀ {Omega : Type*} [MeasurableSpace Omega]
        {mu : Measure Omega} [IsProbabilityMeasure mu]
        {X : Omega -> Real} {alpha : Real}, 0 < alpha ->
        ∀ i j : SubWeibullPropertyKind, ∀ {Ki : Real},
          0 < Ki -> SubWeibullProperty mu X alpha i Ki ->
            ∃ Kj : Real, 0 < Kj ∧ Kj <= C * Ki ∧
              SubWeibullProperty mu X alpha j Kj := by
  obtain ⟨C, hC, hAll⟩ := subExponentialCharacterization_uniform
  refine ⟨C, hC, ?_⟩
  intro Omega _ mu _ X alpha hAlpha i j Ki hKi hProp
  rcases hProp with ⟨hAlpha', hSub⟩
  obtain ⟨Kj, hKj, hKjBound, hResult⟩ :=
    (hAll (mu := mu) (X := fun omega => |X omega| ^ alpha)).1 i j hKi hSub
  exact ⟨Kj, hKj, hKjBound, ⟨hAlpha', hResult⟩⟩

theorem hdp_02_hex_h2_d7_d3__contract :
    hdp_02_hex_h2_d7_d3__contract_type :=
  hdp_02_hex_h2_d7_d3_exact

end NumStability.HDP.Contract
