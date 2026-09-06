import ComputationalMathematics.HDP.Scalar.SubExponential

/-! Frozen contract for Equation (2.22). -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar

def hdp_02_heq_h2_d22__contract_type : Prop :=
  ∀ {Omega : Type*} [MeasurableSpace Omega]
    {mu : Measure Omega} [IsProbabilityMeasure mu] {X Y : Omega -> Real},
    SubGaussian.IsSubGaussian mu X ->
      SubGaussian.IsSubGaussian mu Y ->
        SubGaussian.PsiTwoNorm mu X = 1 ->
          SubGaussian.PsiTwoNorm mu Y = 1 ->
            (∫ omega, Real.exp (X omega ^ 2) ∂mu) ≤ 2 ∧
              (∫ omega, Real.exp (Y omega ^ 2) ∂mu) ≤ 2

end NumStability.HDP.Contract
