import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.CoordinateIsotropic.Signature

/-! Source-facing contract for isotropy of the coordinate distribution in Section 3.3.4. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.4, printed page 52: the coordinate distribution is isotropic. -/
theorem hdp_03_body_3_3_coordinate_isotropic :
    hdp_03_body_3_3_coordinate_isotropic__contract_type :=
  NumStability.HDP.Vector.CoordinateDistribution.coordinateDistributionMeasure_isIsotropic

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_coordinate_isotropic__contract :
    hdp_03_body_3_3_coordinate_isotropic__contract_type :=
  hdp_03_body_3_3_coordinate_isotropic

end NumStability.HDP.Contract
