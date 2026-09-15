import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.Exercise06.Signature
import ComputationalMathematics.Source.Vershynin.Chapter02.Section08.Theorem04.Contract

/-! Effective-domain deduction requested by Exercise 2.8.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.Bernstein

theorem hdp_02_hex_h2_d8_d6_effectiveDomain :
    hdp_02_hex_h2_d8_d6_effectiveDomain__contract_type := by
  classical
  intro ι Ω _ _ μ _ X K hne hMeas hCenter hBound hIndep hEx
  dsimp only
  set σ2 : ℝ := ∑ i, ∫ ω, X i ω ^ 2 ∂μ with hσ2
  have hKnonneg : 0 ≤ K := by
    obtain ⟨i, _⟩ := hne
    obtain ⟨ω, hω⟩ := (hBound i).exists
    exact (abs_nonneg (X i ω)).trans hω
  intro t ht
  set D : ℝ := σ2 + K * t / 3 with hD
  refine ⟨?_, ?_⟩
  · intro hDpos
    by_cases hKzero : K = 0
    · have hEffective := hdp_02_hthm_h2_d8_d4_effectiveDomain
        hne hMeas hCenter hBound hIndep ht
      exact hEffective.1 hDpos
    · have hKpos : 0 < K := lt_of_le_of_ne hKnonneg (Ne.symm hKzero)
      have htail := bernsteinBoundedTailOfMGFBound
        hKpos hMeas hCenter hBound hIndep hEx ht
      simpa [σ2, D] using htail
  · intro hDzero
    have hEffective := hdp_02_hthm_h2_d8_d4_effectiveDomain
      hne hMeas hCenter hBound hIndep ht
    exact (by simpa [σ2, D] using hEffective.2 hDzero)

end NumStability.HDP.Contract
