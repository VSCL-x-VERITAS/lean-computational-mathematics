import ComputationalMathematics.Source.Vershynin.Chapter03.Equation21.Signature

/-! Display (3.21): quadratic optimization over Euclidean unit vectors. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_21 : hdp_03_eq_3_21__contract_type := by
  intro n _ A _
  obtain ⟨X, hX⟩ :=
    NumStability.HDP.Optimization.exists_vectorQuadraticValue_eq_maximum A
  exact ⟨X, hX, NumStability.HDP.Optimization.vectorQuadraticValue_le_maximum A⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_21__contract : hdp_03_eq_3_21__contract_type :=
  hdp_03_eq_3_21

end NumStability.HDP.Contract
