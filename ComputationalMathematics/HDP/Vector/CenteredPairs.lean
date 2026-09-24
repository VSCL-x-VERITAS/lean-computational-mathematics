import ComputationalMathematics.HDP.Vector.IsotropyPairs

/-!
# Distances between independent centered isotropic vectors

This module proves the expected squared-distance identity for independent,
centered finite isotropic random vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Isotropy

/-- Two independent, centered isotropic random vectors in `ℝⁿ` have expected
squared distance `2n`. -/
theorem integral_vecNorm2Sq_sub_eq_two_mul_card
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Fin n → Ω → ℝ}
    (hXLp : ∀ i, MemLp (X i) 2 μ) (hYLp : ∀ i, MemLp (Y i) 2 μ)
    (hXmean : NumStability.HDP.Vector.Covariance.meanVector μ X = 0)
    (hYmean : NumStability.HDP.Vector.Covariance.meanVector μ Y = 0)
    (hXiso : IsIsotropic μ X) (hYiso : IsIsotropic μ Y)
    (hIndep : (fun ω i => X i ω) ⟂ᵢ[μ] (fun ω i => Y i ω)) :
    (∫ ω, NumStability.vecNorm2Sq (fun i => X i ω - Y i ω) ∂μ) = 2 * n := by
  have hXint : ∀ i, Integrable (X i) μ :=
    fun i => (hXLp i).integrable (by norm_num)
  have hYint : ∀ i, Integrable (Y i) μ :=
    fun i => (hYLp i).integrable (by norm_num)
  have hXsq : Integrable (fun ω => ∑ i, (X i ω) ^ 2) μ := by
    apply integrable_finset_sum
    intro i _
    simpa [pow_two] using (hXLp i).integrable_mul (hXLp i)
  have hYsq : Integrable (fun ω => ∑ i, (Y i ω) ^ 2) μ := by
    apply integrable_finset_sum
    intro i _
    simpa [pow_two] using (hYLp i).integrable_mul (hYLp i)
  have hXY : Integrable (fun ω => ∑ i, X i ω * Y i ω) μ := by
    apply integrable_finset_sum
    intro i _
    exact (hXLp i).integrable_mul (hYLp i)
  have hCross : (∫ ω, ∑ i, X i ω * Y i ω ∂μ) = 0 := by
    rw [integral_finset_sum]
    · apply Finset.sum_eq_zero
      intro i _
      have hi := hIndep.comp (measurable_pi_apply i) (measurable_pi_apply i)
      have hfactor := hi.integral_fun_mul_eq_mul_integral (hXint i).1 (hYint i).1
      have hx0 : ∫ ω, X i ω ∂μ = 0 := by
        simpa [NumStability.HDP.Vector.Covariance.meanVector] using congrFun hXmean i
      have hy0 : ∫ ω, Y i ω ∂μ = 0 := by
        simpa [NumStability.HDP.Vector.Covariance.meanVector] using congrFun hYmean i
      calc
        (∫ ω, X i ω * Y i ω ∂μ) =
            (∫ ω, X i ω ∂μ) * (∫ ω, Y i ω ∂μ) := by
              simpa [Function.comp_def] using hfactor
        _ = 0 := by rw [hx0, hy0, zero_mul]
    · intro i _
      exact (hXLp i).integrable_mul (hYLp i)
  have hXnorm := integral_vecNorm2Sq_eq_card hXLp hXiso
  have hYnorm := integral_vecNorm2Sq_eq_card hYLp hYiso
  rw [show (fun ω => NumStability.vecNorm2Sq (fun i => X i ω - Y i ω)) =
      (fun ω => (∑ i, (X i ω) ^ 2) + (∑ i, (Y i ω) ^ 2) -
        2 * (∑ i, X i ω * Y i ω)) by
    funext ω
    simp only [NumStability.vecNorm2Sq]
    calc
      (∑ i, (X i ω - Y i ω) ^ 2) =
          ∑ i, ((X i ω) ^ 2 + (Y i ω) ^ 2 - 2 * (X i ω * Y i ω)) := by
            apply Finset.sum_congr rfl
            intro i _
            ring
      _ = (∑ i, (X i ω) ^ 2) + (∑ i, (Y i ω) ^ 2) -
          2 * (∑ i, X i ω * Y i ω) := by
            rw [Finset.sum_sub_distrib, Finset.sum_add_distrib, Finset.mul_sum]]
  calc
    (∫ ω, (∑ i, (X i ω) ^ 2) + (∑ i, (Y i ω) ^ 2) -
        2 * (∑ i, X i ω * Y i ω) ∂μ) =
        (∫ ω, ∑ i, (X i ω) ^ 2 ∂μ) +
          (∫ ω, ∑ i, (Y i ω) ^ 2 ∂μ) -
            2 * (∫ ω, ∑ i, X i ω * Y i ω ∂μ) := by
              calc
                _ = (∫ ω, (∑ i, (X i ω) ^ 2) + (∑ i, (Y i ω) ^ 2) ∂μ) -
                    (∫ ω, 2 * (∑ i, X i ω * Y i ω) ∂μ) := by
                      convert integral_sub (hXsq.add hYsq) (hXY.const_mul 2) using 1
                _ = _ := by rw [integral_add hXsq hYsq, integral_const_mul]
    _ = 2 * n := by
      have hXnorm' : (∫ ω, ∑ i, (X i ω) ^ 2 ∂μ) = n := by
        simpa [NumStability.vecNorm2Sq] using hXnorm
      have hYnorm' : (∫ ω, ∑ i, (Y i ω) ^ 2 ∂μ) = n := by
        simpa [NumStability.vecNorm2Sq] using hYnorm
      rw [hXnorm', hYnorm', hCross]
      ring

end NumStability.HDP.Vector.Isotropy
