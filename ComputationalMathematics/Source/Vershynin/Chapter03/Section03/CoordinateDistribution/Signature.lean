import ComputationalMathematics.HDP.Vector.CoordinateDistribution

/-! Frozen signature for the coordinate-distribution definition in Section 3.3.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_coordinate_distribution__contract_type : Prop :=
  ∀ (n : ℕ) [NeZero n],
    NumStability.HDP.Vector.CoordinateDistribution.HasCoordinateDistribution
      (ProbabilityTheory.uniformOn (Set.univ : Set (Fin n)))
      (fun i k =>
        NumStability.HDP.Vector.CoordinateDistribution.coordinateVector n k i)

end NumStability.HDP.Contract
