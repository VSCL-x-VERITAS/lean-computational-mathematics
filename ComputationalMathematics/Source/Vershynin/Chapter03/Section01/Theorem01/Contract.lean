import ComputationalMathematics.HDP.Vector.NormConcentration
import ComputationalMathematics.Source.Vershynin.Chapter03.Section01.Theorem01.Signature

/-! Source-facing contract for Vershynin, Theorem 3.1.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Theorem 3.1.1, printed page 42: the Euclidean norm of a random vector with
independent sub-Gaussian coordinates and unit second moments concentrates in
`ψ₂` around the square root of its dimension. -/
theorem hdp_03_hthm_h3_d1_d1 :
    hdp_03_hthm_h3_d1_d1__contract_type :=
  NumStability.HDP.Vector.NormConcentration.euclideanNormDeviation_psiTwoGauge

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Theorem 3.1.1 signature. -/
theorem hdp_03_hthm_h3_d1_d1__contract :
    hdp_03_hthm_h3_d1_d1__contract_type :=
  hdp_03_hthm_h3_d1_d1

end NumStability.HDP.Contract
