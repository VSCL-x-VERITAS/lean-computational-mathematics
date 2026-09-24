import ComputationalMathematics.HDP.Vector.IsotropicSubGaussianNonConcentration

/-! Frozen proof-free signature for Exercise 3.4.10. -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_4_10__contract_type : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ n : ℕ, 0 < n →
    IsProbabilityMeasure
      (NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration.counterexampleMeasure n) ∧
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration.counterexampleMeasure n)
      (fun i x ↦ x i) ∧
    NumStability.HDP.Vector.SubGaussian.IsSubGaussian
      (NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration.counterexampleMeasure n)
      (fun i x ↦ x i) ∧
    NumStability.HDP.Vector.SubGaussian.PsiTwoNorm
        (NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration.counterexampleMeasure n)
        (fun i x ↦ x i) ≤ ENNReal.ofReal C ∧
    (NumStability.HDP.Vector.IsotropicSubGaussianNonConcentration.counterexampleMeasure n).real
      {x | |NumStability.vecNorm2 x - Real.sqrt n| ≥ Real.sqrt n} = 1

end NumStability.HDP.Contract
