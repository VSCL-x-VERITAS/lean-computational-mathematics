import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.GaussianAtoms.Signature
import ComputationalMathematics.HDP.Scalar.GaussianAtoms

/-! Source-facing contract for the Section 2.1 Gaussian-atom display. -/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

/-- Printed page 14: continuity of the standard normal law gives
`P {g = 0} = 0`. -/
theorem hdp_02_hbody_h2_d1_hgaussian_hatom :
    standardNormalLaw {0} = 0 :=
  NumStability.HDP.Scalar.GaussianAtoms.standardNormalLaw_singleton 0

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hbody_h2_d1_hgaussian_hatom__contract :
    hdp_02_hbody_h2_d1_hgaussian_hatom__contract_type :=
  hdp_02_hbody_h2_d1_hgaussian_hatom

end NumStability.HDP.Contract
