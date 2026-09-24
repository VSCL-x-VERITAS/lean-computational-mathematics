import ComputationalMathematics.HDP.Convex.Uniform

/-! Frozen signature for the uniform convex-body law in Section 3.3.5. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_uniform_convex_law__contract_type : Prop :=
  ∀ (Ω : Type*) [MeasurableSpace Ω] (n : ℕ) (μ : Measure Ω)
      (X : Fin n → Ω → ℝ) (K : Set (Fin n → ℝ)),
    NumStability.HDP.Convex.HasUniformConvexBodyLaw μ X K ↔
      NumStability.HDP.Convex.IsConvexBody K ∧
        HasLaw (fun ω i => X i ω)
          (NumStability.HDP.Convex.uniformConvexBodyMeasure K) μ

end NumStability.HDP.Contract
