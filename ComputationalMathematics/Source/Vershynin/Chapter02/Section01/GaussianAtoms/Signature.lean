import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Frozen contract signature for the Section 2.1 Gaussian-atom display

This proof-free signature records that a standard Gaussian assigns zero
probability to the singleton at zero.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_hbody_h2_d1_hgaussian_hatom__contract_type : Prop :=
  standardNormalLaw {0} = 0

end NumStability.HDP.Contract
