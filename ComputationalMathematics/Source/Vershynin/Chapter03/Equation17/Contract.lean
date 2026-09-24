import ComputationalMathematics.Source.Vershynin.Chapter03.Equation17.Signature

/-! Display (3.17): the symmetric quadratic version of Grothendieck's
inequality has absolute bound `2 * K`. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

theorem hdp_03_eq_3_17 : hdp_03_eq_3_17__contract_type.{u} := by
  intro K hGroth n A hA hcase hquad
  exact symmetricQuadratic_grothendieck_bound K hGroth A hA hcase hquad

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_17__contract : hdp_03_eq_3_17__contract_type.{u} :=
  hdp_03_eq_3_17

end NumStability.HDP.Contract
