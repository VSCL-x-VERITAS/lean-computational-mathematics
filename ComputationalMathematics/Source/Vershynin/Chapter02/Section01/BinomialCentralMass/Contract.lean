import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.BinomialCentralMass.Signature

/-! Source-facing contract for the Section 2.1 central-binomial display. -/

noncomputable section

open ENNReal NNReal Filter
open scoped Asymptotics

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.FairCoinCentralMass

/-- Printed page 14: in `N = 2n` fair tosses the central count has probability
`2⁻ᴺ * binom(N,N/2)`, the standardized count has the same mass at zero, and
that mass is comparable to `1 / sqrt N`. -/
theorem hdp_02_hbody_h2_d1_hbinom_hcentral :
    (∀ n : ℕ,
        PMF.binomial (1 / 2) (by norm_num) (2 * n) ⟨n, by omega⟩ =
          (2 : ℝ≥0∞)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ≥0∞)) ∧
      (∀ n : ℕ, 0 < n →
        standardizedFairBinomial n 0 =
          PMF.binomial (1 / 2) (by norm_num) (2 * n) ⟨n, by omega⟩) ∧
      (fun n : ℕ =>
          (2 : ℝ)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ)) =Θ[Filter.atTop]
        (fun n : ℕ => 1 / Real.sqrt (2 * (n : ℝ))) := by
  exact ⟨fairBinomial_centralMass, standardizedFairBinomial_zero,
    fairCentralMassReal_isTheta_inv_sqrt_double⟩

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hbody_h2_d1_hbinom_hcentral__contract :
    hdp_02_hbody_h2_d1_hbinom_hcentral__contract_type :=
  hdp_02_hbody_h2_d1_hbinom_hcentral

end NumStability.HDP.Contract
