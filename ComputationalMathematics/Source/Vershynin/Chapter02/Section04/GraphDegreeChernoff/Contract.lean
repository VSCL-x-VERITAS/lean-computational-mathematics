import ComputationalMathematics.HDP.Scalar.IndependentSums.Chernoff

/-! Source-facing Chapter 2 contract for the fixed-vertex step in Proposition 2.4.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Every fixed vertex has the stated binomial degree law and an absolute
Chernoff exponent for a ten-percent deviation.  The absolute constant remains
existentially quantified as in the source. -/
theorem hdp_02_hbody_h2_d4_hdegree_hchernoff :
    (∀ (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n),
      HasLaw
        ((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).degree v)
        (NumStability.HDP.Scalar.IndependentSums.Chernoff.graphBinomialLaw n p)
        (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).graphLaw) ∧
      ∃ c : ℝ, 0 < c ∧
        ∀ (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (v : Fin n),
          (NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).graphLaw.real
              {G | (1 / 10 : ℝ) * ((n - 1) * (p : ℝ)) ≤
                |((NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiModel n p).degree
                    v G : ℝ) - (n - 1) * (p : ℝ)|} ≤
            2 * Real.exp (-(c * ((n - 1) * (p : ℝ)))) := by
  constructor
  · exact fun n p v =>
      NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiDegreeLaw n p v
  · refine ⟨1 / 400, by norm_num, ?_⟩
    intro n p v
    have hcore :=
      NumStability.HDP.Scalar.IndependentSums.Chernoff.erdosRenyiDegreeDeviationBound
        n p v (δ := 1 / 10) (by norm_num) (by norm_num)
    convert hcore using 1 <;> ring

end NumStability.HDP.Contract
