import ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff

/-! Source-facing Chapter 2 contract for Remark 2.3.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The sharpness content of Remark 2.3.4: the Poisson point mass has the
Stirling profile for every nonnegative rate, while the upper tail lies between
its first point mass and the matching Chernoff profile. -/
theorem hdp_02_hrem_h2_d3_d4_sharp (rate : ℝ≥0) :
    Asymptotics.IsEquivalent Filter.atTop
        (fun k : ℕ => poissonPMFReal rate k)
        (fun k : ℕ =>
          Real.exp (-(rate : ℝ)) *
            (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k /
              Real.sqrt (2 * (k : ℝ) * Real.pi)) ∧
      ∀ {k : ℕ}, (rate : ℝ) < (k : ℝ) →
        poissonPMFReal rate k ≤
            (poissonMeasure rate).real {n : ℕ | (k : ℝ) ≤ (n : ℝ)} ∧
          (poissonMeasure rate).real {n : ℕ | (k : ℝ) ≤ (n : ℝ)} ≤
            Real.exp (-(rate : ℝ)) *
              (Real.exp 1 * (rate : ℝ) / (k : ℝ)) ^ k := by
  refine ⟨NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.poissonPointMass_isEquivalent_stirling_all
    rate, ?_⟩
  intro k hk
  exact NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.poissonPointMass_le_upperTail_le_chernoffProfile
    rate hk

end NumStability.HDP.Contract
