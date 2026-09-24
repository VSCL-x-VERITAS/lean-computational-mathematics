import ComputationalMathematics.Source.Vershynin.Chapter03.Equation22.Signature
import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Exercise05.Contract

/-! Display (3.22): the correlation-matrix semidefinite program. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_22 : hdp_03_eq_3_22__contract_type := by
  intro n _ A hA
  refine ⟨hdp_03_ex_3_5_5 A hA, ?_⟩
  obtain ⟨M, hM, hvalue⟩ :=
    NumStability.HDP.Optimization.exists_semidefiniteQuadraticValue_eq_maximum A
  exact ⟨M, hM, hvalue, fun N hN ↦
    NumStability.HDP.Optimization.semidefiniteQuadraticValue_le_vectorMaximum A N hN⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_22__contract : hdp_03_eq_3_22__contract_type :=
  hdp_03_eq_3_22

end NumStability.HDP.Contract
