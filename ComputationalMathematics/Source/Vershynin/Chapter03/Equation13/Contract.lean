import ComputationalMathematics.Source.Vershynin.Chapter03.Equation13.Signature

/-! Display (3.13): under the inherited sign test, the same absolute
Grothendieck constant gives the homogeneous conclusion, which is equivalent
to the unit-vector conclusion. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

theorem hdp_03_eq_3_13 : hdp_03_eq_3_13__contract_type.{u} := by
  let K := NumStability.HDP.Tensor.krivineBeta⁻¹
  have hGroth : IsGrothendieckConstant.{u} K :=
    NumStability.HDP.Optimization.isGrothendieckConstant_inv_krivineBeta
  have hK : 0 ≤ K := hGroth.nonneg
  refine ⟨K, NumStability.HDP.Tensor.inv_krivineBeta_lt_1783_div_1000.le, ?_⟩
  intro m n A hsign
  have hunit : UniversalUnitBound.{u} A K := hGroth A hsign
  have hequiv := universalUnitBound_iff_universalPiNormBound A K hK
  exact ⟨hequiv.mp hunit, hequiv⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_13__contract : hdp_03_eq_3_13__contract_type.{u} :=
  hdp_03_eq_3_13

end NumStability.HDP.Contract
