import ComputationalMathematics.HDP.Vector.IsotropyMarginals

/-!
# Marginal variances of centered isotropic vectors

This module connects the marginal second-moment characterization of isotropy
to Mathlib's scalar variance for centered finite random vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Isotropy

/-- A finite linear marginal of square-integrable coordinates is square-integrable. -/
theorem marginal_memLp
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} {X : Fin n → Ω → ℝ}
    (hLp : ∀ i, MemLp (X i) 2 μ) (x : Fin n → ℝ) :
    MemLp (fun ω => ∑ i, X i ω * x i) 2 μ := by
  exact memLp_finset_sum _ (fun i _ => (hLp i).mul_const (x i))

/-- Every finite linear marginal of a centered vector has mean zero. -/
theorem integral_marginal_eq_zero
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Fin n → Ω → ℝ}
    (hLp : ∀ i, MemLp (X i) 2 μ)
    (hMean : NumStability.HDP.Vector.Covariance.meanVector μ X = 0)
    (x : Fin n → ℝ) :
    ∫ ω, (∑ i, X i ω * x i) ∂μ = 0 := by
  rw [integral_finset_sum]
  · apply Finset.sum_eq_zero
    intro i _
    have hi : ∫ ω, X i ω ∂μ = 0 := by
      simpa [NumStability.HDP.Vector.Covariance.meanVector] using congrFun hMean i
    rw [integral_mul_const, hi, zero_mul]
  · intro i _
    exact ((hLp i).integrable (by norm_num)).mul_const (x i)

/-- For a centered vector, the variance of a marginal is its second moment. -/
theorem variance_marginal_eq_secondMoment
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Fin n → Ω → ℝ}
    (hLp : ∀ i, MemLp (X i) 2 μ)
    (hMean : NumStability.HDP.Vector.Covariance.meanVector μ X = 0)
    (x : Fin n → ℝ) :
    variance (fun ω => ∑ i, X i ω * x i) μ = marginalSecondMoment μ X x := by
  rw [variance_eq_sub (marginal_memLp hLp x)]
  rw [integral_marginal_eq_zero hLp hMean x]
  simp [marginalSecondMoment]

/-- A centered finite random vector is isotropic exactly when every linear
marginal has variance equal to the squared Euclidean norm of its direction. -/
theorem isIsotropic_iff_marginalVariance
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ)
    (hLp : ∀ i, MemLp (X i) 2 μ)
    (hMean : NumStability.HDP.Vector.Covariance.meanVector μ X = 0) :
    IsIsotropic μ X ↔
      ∀ x : Fin n → ℝ,
        variance (fun ω => ∑ i, X i ω * x i) μ = ∑ i, (x i) ^ 2 := by
  rw [isIsotropic_iff_marginalSecondMoment μ X]
  · constructor <;> intro h x
    · rw [variance_marginal_eq_secondMoment hLp hMean x]
      exact h x
    · rw [← variance_marginal_eq_secondMoment hLp hMean x]
      exact h x
  · intro i j
    exact (hLp i).integrable_mul (hLp j)

end NumStability.HDP.Vector.Isotropy
