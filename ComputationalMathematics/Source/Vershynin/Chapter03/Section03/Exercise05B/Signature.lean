import ComputationalMathematics.HDP.Vector.LinearMarginals

/-! Frozen signature for Exercise 3.3.5(b). -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_3_5b__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ) (u v : Fin n → ℝ),
    NumStability.HDP.Vector.Gaussian.IsStandardNormal μ X →
      NumStability.HDP.Vector.scalarL2Distance μ
          (NumStability.HDP.Vector.linearMarginal X u)
          (NumStability.HDP.Vector.linearMarginal X v) =
        NumStability.vecNorm2 (u - v)

end NumStability.HDP.Contract
