import ComputationalMathematics.HDP.Vector.ProjectiveLimit

/-! Frozen proof-free signature for Remark 3.4.8. -/

noncomputable section

open Filter MeasureTheory ProbabilityTheory
open scoped Topology

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_rem_3_4_8__contract_type : Prop :=
  ∀ u : ∀ d,
      NumStability.HDP.Vector.SubGaussian.UnitDirection (d + 1),
    Tendsto
      (fun d =>
        NumStability.HDP.Vector.Spherical.ProjectiveLimit.sphericalMarginalProbabilityMeasure
          d (u d))
      atTop
      (𝓝 (⟨gaussianReal 0 1, inferInstance⟩ : ProbabilityMeasure ℝ))

end NumStability.HDP.Contract
