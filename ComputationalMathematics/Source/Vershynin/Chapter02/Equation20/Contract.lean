import ComputationalMathematics.Source.Vershynin.Chapter02.Equation20.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Stable Chapter 2 source contract for Equation (2.20). -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-! Equation (2.20): the `ψ₂` triangle inequality applied to centering. -/
theorem hdp_02_heq_h2_d20
    {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : Ω → ℝ}
    (_hSub : NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ X) :
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (fun ω => X ω - ∫ x, X x ∂μ) ≤
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X +
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (fun _ : Ω => ∫ x, X x ∂μ) := by
  let m : ℝ := ∫ x, X x ∂μ
  calc
    NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
        (fun ω => X ω - ∫ x, X x ∂μ) =
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun ω => X ω + -m) := by simp [m,
            NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm, sub_eq_add_neg]
    _ ≤ NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ X +
        NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge μ
          (fun _ : Ω => -m) :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_add_le
    _ = NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ X +
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
          (fun _ : Ω => ∫ x, X x ∂μ) := by
      rw [NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_neg
        (μ := μ) (X := fun _ : Ω => m)]
      rfl

theorem hdp_02_heq_h2_d20__contract : hdp_02_heq_h2_d20__contract_type := by
  exact fun _hSub => hdp_02_heq_h2_d20 _hSub

end NumStability.HDP.Contract
