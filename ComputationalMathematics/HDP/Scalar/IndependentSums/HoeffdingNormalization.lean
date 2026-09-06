import ComputationalMathematics.HDP.Scalar.IndependentSums.Hoeffding

/-!
# Coefficient normalization for Hoeffding's inequality

This module isolates the coefficient-energy case split and positive-energy
rescaling used in the source proof of Vershynin's Theorem 2.2.2.  The
probability theorem itself remains in `Hoeffding`; these algebraic lemmas expose
the exact unit-energy reduction and its degenerate branch.
-/

namespace NumStability.HDP.Scalar.IndependentSums.HoeffdingNormalization

/-- Dividing a nonzero coefficient vector by the square root of its squared
energy produces unit squared energy. -/
theorem sum_sq_div_sqrt_sum_sq_eq_one
    {ι : Type*} [Fintype ι] (a : ι → ℝ)
    (ha : 0 < ∑ i, (a i) ^ 2) :
    ∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) ^ 2 = 1 := by
  have hsqrt_sq : (Real.sqrt (∑ i, (a i) ^ 2)) ^ 2 = ∑ i, (a i) ^ 2 := by
    exact Real.sq_sqrt (le_of_lt ha)
  calc
    ∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) ^ 2 =
        (∑ i, (a i) ^ 2) / (Real.sqrt (∑ j, (a j) ^ 2)) ^ 2 := by
          simp only [div_pow]
          rw [Finset.sum_div]
    _ = 1 := by rw [hsqrt_sq, div_self (ne_of_gt ha)]

/-- Exact event identity implementing the source proof's reduction to unit
coefficient energy. -/
theorem weightedSum_ge_rescale_sqrt_sum_sq
    {ι Ω : Type*} [Fintype ι]
    (X : ι → Ω → ℝ) (a : ι → ℝ) (t : ℝ)
    (ha : 0 < ∑ i, (a i) ^ 2) :
    {ω | ∑ i, a i * X i ω ≥ t} =
      {ω | ∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) * X i ω ≥
        t / Real.sqrt (∑ j, (a j) ^ 2)} := by
  have hsqrt : 0 < Real.sqrt (∑ i, (a i) ^ 2) := Real.sqrt_pos.2 ha
  ext ω
  simp only [Set.mem_setOf_eq]
  have hsum :
      ∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) * X i ω =
        (∑ i, a i * X i ω) / Real.sqrt (∑ j, (a j) ^ 2) := by
    rw [Finset.sum_div]
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [hsum]
  exact (div_le_div_iff_of_pos_right hsqrt).symm

/-- The complete algebraic normalization reduction: zero coefficient energy
gives the trivial zero weighted sum, while positive energy permits exact
rescaling to unit squared energy. -/
theorem weightedSum_ge_normalization_or_zero
    {ι Ω : Type*} [Fintype ι]
    (X : ι → Ω → ℝ) (a : ι → ℝ) (t : ℝ) :
    ((∑ i, (a i) ^ 2 = 0) ∧
        {ω | ∑ i, a i * X i ω ≥ t} = {ω | (0 : ℝ) ≥ t}) ∨
      ((0 < ∑ i, (a i) ^ 2) ∧
        (∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) ^ 2 = 1) ∧
        {ω | ∑ i, a i * X i ω ≥ t} =
          {ω | ∑ i, (a i / Real.sqrt (∑ j, (a j) ^ 2)) * X i ω ≥
            t / Real.sqrt (∑ j, (a j) ^ 2)}) := by
  have hnonneg : 0 ≤ ∑ i, (a i) ^ 2 :=
    Finset.sum_nonneg fun i _ => sq_nonneg (a i)
  rcases hnonneg.eq_or_lt with hzero | hpos
  · left
    have ha_zero : ∀ i, a i = 0 := by
      intro i
      have hsquare : (a i) ^ 2 = 0 :=
        (Finset.sum_eq_zero_iff_of_nonneg fun j _ => sq_nonneg (a j)).mp hzero.symm i
          (Finset.mem_univ i)
      nlinarith [sq_nonneg (a i)]
    refine ⟨hzero.symm, ?_⟩
    ext ω
    simp [ha_zero]
  · right
    exact ⟨hpos,
      sum_sq_div_sqrt_sum_sq_eq_one a hpos,
      weightedSum_ge_rescale_sqrt_sum_sq X a t hpos⟩

end NumStability.HDP.Scalar.IndependentSums.HoeffdingNormalization
