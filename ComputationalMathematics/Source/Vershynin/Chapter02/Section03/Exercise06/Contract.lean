import ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff

/-! Source-facing Chapter 2 contract for Exercise 2.3.6. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- A practical near-mean two-sided Poisson bound with the explicit uniform
constant `c = 1 / 4`. -/
theorem hdp_02_hex_h2_d3_d6_quarter
    (rate : ℝ≥0) (hrate : 0 < rate) {t : ℝ}
    (ht0 : 0 < t) (ht : t ≤ (rate : ℝ)) :
    (poissonMeasure rate).real
        {n : ℕ | t ≤ |(n : ℝ) - (rate : ℝ)|} ≤
      2 * Real.exp (-(t ^ 2 / (4 * (rate : ℝ)))) := by
  let δ : ℝ := t / (rate : ℝ)
  have hr : 0 < (rate : ℝ) := by exact_mod_cast hrate
  have hδ0 : 0 < δ := div_pos ht0 hr
  have hδ1 : δ ≤ 1 := by
    dsimp [δ]
    exact (div_le_one hr).2 ht
  have hbound :=
    NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.poissonTwoSidedQuadraticBound
      rate hδ0 hδ1
  have hscale : δ * (rate : ℝ) = t := by
    dsimp [δ]
    field_simp
  have hexponent : (rate : ℝ) * δ ^ 2 / 4 =
      t ^ 2 / (4 * (rate : ℝ)) := by
    dsimp [δ]
    field_simp
  have hneg : -(rate : ℝ) * δ ^ 2 / 4 =
      -(t ^ 2 / (4 * (rate : ℝ))) := by
    rw [show -(rate : ℝ) * δ ^ 2 / 4 =
      -((rate : ℝ) * δ ^ 2 / 4) by ring, hexponent]
  simpa only [hscale, hneg] using hbound

/-- Exercise 2.3.6, preserving the book's deliberately unnamed absolute
constant as one existential witness that is uniform in the Poisson rate and
deviation threshold. -/
theorem hdp_02_hex_h2_d3_d6 :
    ∃ c : ℝ, 0 < c ∧
      ∀ (rate : ℝ≥0), 0 < rate → ∀ {t : ℝ}, 0 < t → t ≤ (rate : ℝ) →
        (poissonMeasure rate).real
            {n : ℕ | t ≤ |(n : ℝ) - (rate : ℝ)|} ≤
          2 * Real.exp (-(c * t ^ 2 / (rate : ℝ))) := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro rate hrate t ht0 ht
  have h := hdp_02_hex_h2_d3_d6_quarter rate hrate ht0 ht
  convert h using 1
  ring

end NumStability.HDP.Contract
