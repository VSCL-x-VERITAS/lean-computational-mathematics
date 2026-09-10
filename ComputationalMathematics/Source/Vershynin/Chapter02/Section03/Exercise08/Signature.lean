import ComputationalMathematics.HDP.Scalar.PoissonNormal

/-!
# Frozen contract signature for Exercise 2.3.8

The source asks for the normal approximation to a Poisson variable as its
nonnegative real rate tends to infinity.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.PoissonNormal

def hdp_02_hex_h2_d3_d8__contract_type : Prop :=
  Tendsto standardizedPoissonLaw atTop
    (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ))

end NumStability.HDP.Contract
