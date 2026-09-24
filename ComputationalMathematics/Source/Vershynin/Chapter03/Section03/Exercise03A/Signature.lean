import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen contract signature for Exercise 3.3.3(a). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_3a__contract_type : Prop :=
  ∀ {n : ℕ} {Omega : Type*} [MeasurableSpace Omega]
      (mu : Measure Omega) [IsProbabilityMeasure mu]
      (X : Fin n → Omega → ℝ) (u : EuclideanSpace ℝ (Fin n)),
    NumStability.HDP.Vector.Gaussian.IsStandardNormal mu X →
      HasLaw (fun omega => ∑ i, X i omega * u i)
        (gaussianReal 0
          (show NNReal from
            { val := ‖u‖ ^ 2
              property := sq_nonneg ‖u‖ })) mu

end NumStability.HDP.Contract
