import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise06.Signature
import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Exercise03C.Contract
import ComputationalMathematics.HDP.Vector.LinearMarginals

/-! Exercise 3.3.6: orthogonal images under a Gaussian matrix. -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

/-- A Gaussian matrix sends two fixed orthogonal unit directions to independent
standard-Gaussian output vectors. -/
theorem hdp_03_ex_3_3_6 : hdp_03_ex_3_3_6__contract_type := by
  intro m n Omega _ mu _ G u v hRows hRowLaw hu hv huv
  refine ⟨hdp_03_ex_3_3_3c mu G u hRows hRowLaw hu,
    hdp_03_ex_3_3_3c mu G v hRows hRowLaw hv, ?_⟩
  simpa [NumStability.HDP.Vector.linearMarginal] using
    NumStability.HDP.Vector.Gaussian.indepFun_rowwise_linearMarginals_of_isStandardNormal
      hRows hRowLaw u v huv

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_3_6__contract : hdp_03_ex_3_3_6__contract_type :=
  hdp_03_ex_3_3_6

end NumStability.HDP.Contract
