import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-!
# Normalizing a fair-coin count

The elementary event identity used when the centered fair-coin count is scaled
by its standard deviation.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Scalar.IndependentSums.FairCoinNormalization

open NumStability.HDP.Scalar.IndependentSums.Hoeffding

/-- For a positive scale parameter `n`, crossing `3n/4` is equivalent to the
standardized centered value crossing `sqrt (n/4)`. -/
theorem standardizedThreeQuartersEvent
    {Ω : Type*} (S : Ω → ℝ) {n : ℝ} (hn : 0 < n) :
    {ω | S ω ≥ (3 / 4 : ℝ) * n} =
      {ω | (S ω - n / 2) / Real.sqrt (n / 4) ≥ Real.sqrt (n / 4)} := by
  have hn4 : 0 ≤ n / 4 := by positivity
  have hsqrt_pos : 0 < Real.sqrt (n / 4) := Real.sqrt_pos.2 (by positivity)
  have hsqrt_sq : (Real.sqrt (n / 4)) ^ 2 = n / 4 := Real.sq_sqrt hn4
  ext ω
  simp only [Set.mem_setOf_eq]
  constructor
  · intro hω
    apply (le_div_iff₀ hsqrt_pos).2
    nlinarith
  · intro hω
    have hmul := (le_div_iff₀ hsqrt_pos).1 hω
    nlinarith

/-- The preceding algebraic identity specialized to the number of heads in a
nonempty finite family of Boolean observations. -/
theorem fairBernoulliSum_standardizedThreeQuartersEvent
    {ι Ω : Type*} [Fintype ι]
    {B : ι → Ω → Bool}
    (hN : 0 < Fintype.card ι) :
    {ω | ∑ i, bernoulliIndicator (B i ω) ≥
        (3 / 4 : ℝ) * (Fintype.card ι : ℝ)} =
      {ω | (∑ i, bernoulliIndicator (B i ω) -
          (Fintype.card ι : ℝ) / 2) /
            Real.sqrt ((Fintype.card ι : ℝ) / 4) ≥
          Real.sqrt ((Fintype.card ι : ℝ) / 4)} := by
  apply standardizedThreeQuartersEvent
  exact_mod_cast hN

end NumStability.HDP.Scalar.IndependentSums.FairCoinNormalization
