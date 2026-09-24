import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.PlaneAngleMean.Signature

/-! Source-facing contract for the mean planar direction-angle claim. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2.3, printed page 49: the mean acute angle between two
independent uniformly distributed unoriented directions in the plane is
`Real.pi / 4`. -/
theorem hdp_03_body_3_2_plane_angle_mean :
    hdp_03_body_3_2_plane_angle_mean__contract_type := by
  simpa [NumStability.HDP.Vector.acuteAngle] using
    NumStability.HDP.Vector.integral_acuteAngle_planeDirectionMeasure_prod

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_2_plane_angle_mean__contract :
    hdp_03_body_3_2_plane_angle_mean__contract_type :=
  hdp_03_body_3_2_plane_angle_mean

end NumStability.HDP.Contract
