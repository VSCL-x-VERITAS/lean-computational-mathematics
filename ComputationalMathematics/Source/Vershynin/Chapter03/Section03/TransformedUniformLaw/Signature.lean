import ComputationalMathematics.HDP.Convex.LinearImage

/-! Frozen signature for linear transport of a uniform convex-body law in Section 3.3.5. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_transformed_uniform_law__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      (μ : Measure Ω) (X : Fin n → Ω → ℝ)
      (K : Set (Fin n → ℝ)) (A : Matrix (Fin n) (Fin n) ℝ),
    NumStability.HDP.Convex.HasUniformConvexBodyLaw μ X K →
      IsUnit A →
      HasLaw (fun ω => A.mulVec (fun i => X i ω))
        (NumStability.HDP.Convex.uniformConvexBodyMeasure
          (Matrix.toLin' A '' K)) μ

end NumStability.HDP.Contract
