import Mathlib.Probability.Moments.Variance

/-!
# Scalar mean and variance standardization

This module packages the standard score of a square-integrable real random
variable and proves its zero-mean and unit-variance normalization laws.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Scalar.Standardization

/-- The standard score obtained by subtracting the mean and dividing by the
standard deviation. -/
def standardScore {Ω : Type*} [MeasurableSpace Ω]
    (μ : Measure Ω) (X : Ω → ℝ) : Ω → ℝ :=
  fun ω => (X ω - ∫ ω, X ω ∂μ) / Real.sqrt (variance X μ)

/-- A square-integrable random variable remains centered after division by its
standard deviation.  This identity is valid even when the variance vanishes. -/
theorem integral_standardScore
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : MemLp X 2 μ) :
    ∫ ω, standardScore μ X ω ∂μ = 0 := by
  rw [show (fun ω => standardScore μ X ω) =
      fun ω => (X ω - ∫ ω, X ω ∂μ) / Real.sqrt (variance X μ) by rfl]
  have hXint : Integrable X μ := hX.integrable one_le_two
  rw [integral_div, integral_sub hXint (integrable_const _)]
  simp

/-- A standard score formed from a positive-variance random variable has unit
variance. -/
theorem variance_standardScore
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] {X : Ω → ℝ}
    (hX : MemLp X 2 μ) (hVar : 0 < variance X μ) :
    variance (standardScore μ X) μ = 1 := by
  rw [show standardScore μ X = fun ω => (1 / Real.sqrt (variance X μ)) *
      (X ω - ∫ ω, X ω ∂μ) by
    funext ω
    simp [standardScore, div_eq_mul_inv, mul_comm]]
  rw [variance_const_mul]
  rw [variance_sub_const hX.aestronglyMeasurable]
  have hsqrt_sq : (Real.sqrt (variance X μ)) ^ 2 = variance X μ :=
    Real.sq_sqrt (le_of_lt hVar)
  have hsqrt_ne : Real.sqrt (variance X μ) ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 hVar)
  field_simp
  exact hsqrt_sq.symm

end NumStability.HDP.Scalar.Standardization
