import ComputationalMathematics.Source.Vershynin.Chapter03.Section05.Exercise02B.Signature

/-! Exercise 3.5.2(b): the unit-vector and homogeneous max-norm forms of the
Hilbert-space conclusion are equivalent. -/

namespace NumStability.HDP.Contract

open NumStability.HDP.Optimization

universe u

theorem hdp_03_hex_h3_d5_d2b :
    hdp_03_hex_h3_d5_d2b__contract_type.{u} := by
  intro m n A K
  exact universalUnitBound_iff_universalPiNormBound A K

set_option linter.style.nameCheck false in
theorem hdp_03_hex_h3_d5_d2b__contract :
    hdp_03_hex_h3_d5_d2b__contract_type.{u} :=
  hdp_03_hex_h3_d5_d2b

end NumStability.HDP.Contract
