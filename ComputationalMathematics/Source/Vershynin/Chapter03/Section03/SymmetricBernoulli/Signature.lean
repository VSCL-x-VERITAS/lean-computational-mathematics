import ComputationalMathematics.HDP.Vector.Bernoulli

/-! Frozen contract signature for the symmetric Bernoulli vector definition in Section 3.3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_symmetric_bernoulli__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : Fin n → Ω → ℝ),
      (NumStability.HDP.Vector.Bernoulli.IsSymmetricBernoulli μ X ↔
          iIndepFun X μ ∧
            ∀ i, HasLaw (X i)
              NumStability.HDP.Scalar.IndependentSums.Hoeffding.rademacherPMF.toMeasure μ) ∧
        (NumStability.HDP.Vector.Bernoulli.IsSymmetricBernoulli μ X ↔
          NumStability.HDP.Vector.Bernoulli.HasUniformDiscreteCubeLaw μ X)

end NumStability.HDP.Contract
