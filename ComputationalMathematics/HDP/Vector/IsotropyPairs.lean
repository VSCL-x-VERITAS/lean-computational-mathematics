import ComputationalMathematics.HDP.Vector.IsotropyMarginals
import Mathlib.Probability.Independence.Integration

/-!
# Independent pairs of isotropic random vectors

This module proves the squared-inner-product moment identity for two
independent finite isotropic random vectors.
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Vector.Isotropy

/-- Two independent isotropic random vectors in `ℝⁿ` have expected squared
inner product `n`. -/
theorem integral_inner_sq_eq_card
    {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X Y : Fin n → Ω → ℝ}
    (hXLp : ∀ i, MemLp (X i) 2 μ) (hYLp : ∀ i, MemLp (Y i) 2 μ)
    (hXiso : IsIsotropic μ X) (hYiso : IsIsotropic μ Y)
    (hIndep : (fun ω i => X i ω) ⟂ᵢ[μ] (fun ω i => Y i ω)) :
    (∫ ω, (∑ i, X i ω * Y i ω) ^ 2 ∂μ) = n := by
  have hXpair : ∀ i j, Integrable (fun ω => X i ω * X j ω) μ := by
    intro i j
    exact (hXLp i).integrable_mul (hXLp j)
  have hYpair : ∀ i j, Integrable (fun ω => Y i ω * Y j ω) μ := by
    intro i j
    exact (hYLp i).integrable_mul (hYLp j)
  have hPairIndep : ∀ i j,
      (fun ω => X i ω * X j ω) ⟂ᵢ[μ] (fun ω => Y i ω * Y j ω) := by
    intro i j
    have h := hIndep.comp
      ((measurable_pi_apply i).mul (measurable_pi_apply j))
      ((measurable_pi_apply i).mul (measurable_pi_apply j))
    simpa [Function.comp_def] using h
  have hTerm : ∀ i j,
      Integrable (fun ω => (X i ω * X j ω) * (Y i ω * Y j ω)) μ := by
    intro i j
    exact (hPairIndep i j).integrable_mul (hXpair i j) (hYpair i j)
  have hFactor : ∀ i j,
      (∫ ω, (X i ω * X j ω) * (Y i ω * Y j ω) ∂μ) =
        (∫ ω, X i ω * X j ω ∂μ) * (∫ ω, Y i ω * Y j ω ∂μ) := by
    intro i j
    exact (hPairIndep i j).integral_fun_mul_eq_mul_integral
      (hXpair i j).1 (hYpair i j).1
  calc
    (∫ ω, (∑ i, X i ω * Y i ω) ^ 2 ∂μ) =
        ∫ ω, ∑ i, ∑ j, (X i ω * X j ω) * (Y i ω * Y j ω) ∂μ := by
          congr 1
          funext ω
          simp only [pow_two, Finset.sum_mul, Finset.mul_sum]
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          ring
    _ = ∑ i, ∫ ω, ∑ j, (X i ω * X j ω) * (Y i ω * Y j ω) ∂μ := by
          rw [integral_finset_sum]
          intro i _
          exact integrable_finset_sum _ (fun j _ => hTerm i j)
    _ = ∑ i, ∑ j, ∫ ω, (X i ω * X j ω) * (Y i ω * Y j ω) ∂μ := by
          apply Finset.sum_congr rfl
          intro i _
          rw [integral_finset_sum]
          intro j _
          exact hTerm i j
    _ = ∑ i, ∑ j,
        (∫ ω, X i ω * X j ω ∂μ) * (∫ ω, Y i ω * Y j ω ∂μ) := by
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          exact hFactor i j
    _ = n := by
          have hXcoord := (isIsotropic_iff_integral_mul μ X).1 hXiso
          have hYcoord := (isIsotropic_iff_integral_mul μ Y).1 hYiso
          simp [hXcoord, hYcoord]

end NumStability.HDP.Vector.Isotropy
