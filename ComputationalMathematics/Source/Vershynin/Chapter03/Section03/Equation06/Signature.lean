import ComputationalMathematics.HDP.Vector.LinearMarginals

/-! Frozen signature for Equation (3.6). -/

noncomputable section

open MeasureTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_6__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ) (u v : Fin n → ℝ),
    NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X →
      (∫ ω,
        NumStability.HDP.Vector.linearMarginal X u ω *
          NumStability.HDP.Vector.linearMarginal X v ω ∂μ) =
        ∑ i, u i * v i

end NumStability.HDP.Contract
