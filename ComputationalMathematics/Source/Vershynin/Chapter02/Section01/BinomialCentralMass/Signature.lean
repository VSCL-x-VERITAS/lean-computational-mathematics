import ComputationalMathematics.HDP.Scalar.IndependentSums.FairCoinCentralMass

/-!
# Frozen contract signature for the Section 2.1 central-binomial display

This proof-free signature records the exact fair-binomial central mass, its
identification with the atom at zero after standardization, and its
constant-factor `1 / sqrt N` scale at even indices `N = 2n`.
-/

noncomputable section

open ENNReal NNReal Filter
open scoped Asymptotics

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.IndependentSums.FairCoinCentralMass

def hdp_02_hbody_h2_d1_hbinom_hcentral__contract_type : Prop :=
  (∀ n : ℕ,
      PMF.binomial (1 / 2) (by norm_num) (2 * n) ⟨n, by omega⟩ =
        (2 : ℝ≥0∞)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ≥0∞)) ∧
    (∀ n : ℕ, 0 < n →
      standardizedFairBinomial n 0 =
        PMF.binomial (1 / 2) (by norm_num) (2 * n) ⟨n, by omega⟩) ∧
    (fun n : ℕ =>
        (2 : ℝ)⁻¹ ^ (2 * n) * (Nat.choose (2 * n) n : ℝ)) =Θ[Filter.atTop]
      (fun n : ℕ => 1 / Real.sqrt (2 * (n : ℝ)))

end NumStability.HDP.Contract
