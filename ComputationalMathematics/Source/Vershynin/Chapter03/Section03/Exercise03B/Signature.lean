import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Frozen contract signature for Exercise 3.3.3(b). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_3b__contract_type : Prop :=
  ∀ {n : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) [IsProbabilityMeasure mu]
      (X : Fin n → Omega → ℝ) (variance : Fin n → NNReal),
    (∀ i, HasLaw (X i) (gaussianReal 0 (variance i)) mu) →
      iIndepFun X mu →
        HasLaw (fun omega => ∑ i, X i omega)
          (gaussianReal 0 (∑ i, variance i)) mu

end NumStability.HDP.Contract
