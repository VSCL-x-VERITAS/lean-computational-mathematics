import ComputationalMathematics.HDP.Scalar.SubGaussian

/-!
# Frozen contract signature for the constant `ψ₂` bound in Lemma 2.6.8

This proof-free proposition makes the source's implicit absolute constant
uniform over the probability space and the scalar constant random variable.
-/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

def hdp_02_hbody_h2_d6_hconstant_hpsi2__contract_type : Prop :=
  ∃ C : ℝ, 1 ≤ C ∧
    ∀ {Omega : Type*} [MeasurableSpace Omega]
      {mu : Measure Omega} [IsProbabilityMeasure mu]
      (a : ℝ),
      NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm mu
          (fun _ : Omega => a) ≤ ENNReal.ofReal (C * |a|)

end NumStability.HDP.Contract
