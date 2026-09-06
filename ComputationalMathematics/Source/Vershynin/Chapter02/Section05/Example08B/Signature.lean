import Mathlib.MeasureTheory.Measure.Typeclasses.Probability
import ComputationalMathematics.HDP.Scalar.SubGaussian

/-! Proof-free type signature for Example 2.5.8(b). -/

namespace NumStability.HDP.Contract

def hdp_02_hexample_h2_d5_d8b__contract_type : Prop :=
  NumStability.HDP.Scalar.SubGaussian.PsiTwoGauge
      NumStability.HDP.Scalar.SubGaussian.rademacherPsiTwoLaw id =
    ENNReal.ofReal (1 / Real.sqrt (Real.log 2))

end NumStability.HDP.Contract
