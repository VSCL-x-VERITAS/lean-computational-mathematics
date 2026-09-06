import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.ConstantPsiTwoNorm.Signature
import ComputationalMathematics.HDP.Scalar.SubGaussianCentering

/-! Stable Chapter 2 source contract for the constant `ψ₂` bound. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

/-! Lemma 2.6.8 proof body: a constant random variable has `ψ₂` norm
bounded by an absolute constant times its magnitude. -/
theorem hdp_02_hbody_h2_d6_hconstant_hpsi2 :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ {Omega : Type*} [MeasurableSpace Omega]
        {mu : Measure Omega} [IsProbabilityMeasure mu]
        (a : ℝ),
        NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm mu
            (fun _ : Omega => a) ≤ ENNReal.ofReal (C * |a|) := by
  refine ⟨2, by norm_num, ?_⟩
  intro Omega _ mu _ a
  simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm] using
    (NumStability.HDP.Scalar.SubGaussian.psiTwoGauge_const_le_two_mul_abs
      (Ω := Omega) (μ := mu) a)

theorem hdp_02_hbody_h2_d6_hconstant_hpsi2__contract :
    hdp_02_hbody_h2_d6_hconstant_hpsi2__contract_type := by
  exact hdp_02_hbody_h2_d6_hconstant_hpsi2

end NumStability.HDP.Contract
