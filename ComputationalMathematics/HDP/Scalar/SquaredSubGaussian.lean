import ComputationalMathematics.HDP.Scalar.SubExponentialCentering

/-!
# Centered squares of sub-Gaussian random variables
-/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Scalar

/-- A normalized sub-Gaussian variable has a mean-zero, sub-exponential
centered square.  The explicit coefficient is the universal centering
constant provided by `centeredSubExponentialPsiOneNorm`. -/
theorem centeredSquare_psiOneGauge_le
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ} (hX : Measurable X)
    (hXsq : Integrable (fun ω ↦ X ω ^ 2) μ)
    (hsecond : (∫ ω, X ω ^ 2 ∂μ) = 1)
    {K : ℝ} (hK0 : 0 ≤ K)
    (hK : SubGaussian.PsiTwoNorm μ X ≤ ENNReal.ofReal K) :
    (∫ ω, (X ω ^ 2 - 1) ∂μ) = 0 ∧
      SubExponential.PsiOneGauge μ (fun ω ↦ X ω ^ 2 - 1) ≤
        ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) *
          (ENNReal.ofReal K) ^ 2 := by
  have hmeanZero : (∫ ω, (X ω ^ 2 - 1) ∂μ) = 0 := by
    rw [integral_sub hXsq (integrable_const 1), hsecond]
    simp
  have hpsiFinite : SubGaussian.PsiTwoGauge μ X < ∞ :=
    lt_of_le_of_lt hK ENNReal.ofReal_lt_top
  have hsqFinite :
      SubExponential.PsiOneGauge μ (fun ω ↦ X ω ^ 2) < ∞ := by
    rw [SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq hX]
    exact ENNReal.pow_lt_top hpsiFinite
  have hcenter :=
    SubExponential.centeredSubExponentialPsiOneNorm (μ := μ)
      (X := fun ω ↦ X ω ^ 2) (hX.pow_const 2) hsqFinite
  have hKgauge : SubGaussian.PsiTwoGauge μ X ≤ ENNReal.ofReal K := by
    simpa [SubGaussian.PsiTwoNorm] using hK
  refine ⟨hmeanZero, ?_⟩
  calc
    SubExponential.PsiOneGauge μ (fun ω ↦ X ω ^ 2 - 1) =
        SubExponential.PsiOneGauge μ
          (fun ω ↦ X ω ^ 2 - ∫ z, X z ^ 2 ∂μ) := by rw [hsecond]
    _ ≤ ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) *
          SubExponential.PsiOneGauge μ (fun ω ↦ X ω ^ 2) := hcenter.2
    _ = ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) *
          SubGaussian.PsiTwoGauge μ X ^ 2 := by
        rw [SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq hX]
    _ ≤ ENNReal.ofReal (1 + 2048 * (Real.exp 1) ^ 3) *
          (ENNReal.ofReal K) ^ 2 := by gcongr

end NumStability.HDP.Scalar
