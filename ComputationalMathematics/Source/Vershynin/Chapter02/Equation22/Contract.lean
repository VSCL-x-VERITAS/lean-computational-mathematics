import ComputationalMathematics.Source.Vershynin.Chapter02.Equation22.Signature

/-! Stable Chapter 2 source contract for Equation (2.22). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

/-- Equation (2.22): after normalizing both `psi_2` scales to one, both
quadratic exponential moments are at most two. -/
theorem hdp_02_heq_h2_d22_exact :
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu] {X Y : Omega -> Real},
      SubGaussian.IsSubGaussian mu X ->
        SubGaussian.IsSubGaussian mu Y ->
          SubGaussian.PsiTwoNorm mu X = 1 ->
            SubGaussian.PsiTwoNorm mu Y = 1 ->
              (∫ omega, Real.exp (X omega ^ 2) ∂mu) ≤ 2 ∧
                (∫ omega, Real.exp (Y omega ^ 2) ∂mu) ≤ 2 := by
  intro Omega _ mu _ X Y hXSub hYSub hXNorm hYNorm
  have hXFinite : SubGaussian.PsiTwoGauge mu X < (⊤ : ENNReal) := by
    simpa [SubGaussian.PsiTwoNorm] using
      (SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
        (μ := mu) (X := X)).mp hXSub
  have hYFinite : SubGaussian.PsiTwoGauge mu Y < (⊤ : ENNReal) := by
    simpa [SubGaussian.PsiTwoNorm] using
      (SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
        (μ := mu) (X := Y)).mp hYSub
  have hXGauge : SubGaussian.PsiTwoGauge mu X = 1 := by
    simpa [SubGaussian.PsiTwoNorm] using hXNorm
  have hYGauge : SubGaussian.PsiTwoGauge mu Y = 1 := by
    simpa [SubGaussian.PsiTwoNorm] using hYNorm
  have hXMoment := SubGaussian.psiTwoGauge_squareMoment hXSub.1 hXFinite
  have hYMoment := SubGaussian.psiTwoGauge_squareMoment hYSub.1 hYFinite
  exact ⟨by simpa [hXGauge] using hXMoment.2,
    by simpa [hYGauge] using hYMoment.2⟩

theorem hdp_02_heq_h2_d22__contract :
    hdp_02_heq_h2_d22__contract_type :=
  hdp_02_heq_h2_d22_exact

end NumStability.HDP.Contract
