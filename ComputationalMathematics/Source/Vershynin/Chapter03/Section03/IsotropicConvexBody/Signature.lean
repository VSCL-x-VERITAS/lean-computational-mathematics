import ComputationalMathematics.HDP.Convex.IsotropicBody

/-! Frozen signature for the isotropic convex-body definition in Section 3.3.5. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_isotropic_body_def__contract_type : Prop :=
  ∀ (n : ℕ) (K : Set (Fin n → ℝ)),
    NumStability.HDP.Convex.IsIsotropicConvexBody K ↔
      NumStability.HDP.Convex.IsConvexBody K ∧
        NumStability.HDP.Vector.Covariance.meanVector
          (NumStability.HDP.Convex.uniformConvexBodyMeasure K)
          (fun i x => x i) = 0 ∧
        NumStability.HDP.Vector.Isotropy.IsIsotropic
          (NumStability.HDP.Convex.uniformConvexBodyMeasure K)
          (fun i x => x i)

end NumStability.HDP.Contract
