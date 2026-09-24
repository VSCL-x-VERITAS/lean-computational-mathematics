import ComputationalMathematics.HDP.Vector.CoordinateDistribution

/-! Frozen signature for isotropy of the coordinate distribution in Section 3.3.4. -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_coordinate_isotropic__contract_type : Prop :=
  ∀ (n : ℕ) [NeZero n],
    NumStability.HDP.Vector.Isotropy.IsIsotropic
      (NumStability.HDP.Vector.CoordinateDistribution.coordinateDistributionMeasure n)
      (fun i : Fin n => fun x : Fin n → ℝ => x i)

end NumStability.HDP.Contract
