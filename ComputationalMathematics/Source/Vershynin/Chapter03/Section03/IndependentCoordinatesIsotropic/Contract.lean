import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.IndependentCoordinatesIsotropic.Signature

/-! Source-facing contract for the independent-coordinate isotropy claim in Section 3.3.1. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Section 3.3.1, printed page 49: independent zero-mean, unit-variance
coordinates form an isotropic random vector. -/
theorem hdp_03_body_3_3_independent_coordinates_isotropic :
    hdp_03_body_3_3_independent_coordinates_isotropic__contract_type := by
  intro n Ω _ μ _ X hLp hProductLaw hMean hBookVar
  exact NumStability.HDP.Vector.Isotropy.isIsotropic_of_iIndepFun_mean_zero_variance_one
    hLp ((iIndepFun_iff_map_fun_eq_pi_map fun i => (hLp i).aemeasurable).2 hProductLaw)
    hMean fun i => by
      rw [variance_eq_integral (hLp i).aemeasurable]
      simpa [NumStability.HDP.Scalar.Preliminaries.variance,
        NumStability.HDP.Scalar.Preliminaries.expectation] using hBookVar i

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.3.1 signature. -/
theorem hdp_03_body_3_3_independent_coordinates_isotropic__contract :
    hdp_03_body_3_3_independent_coordinates_isotropic__contract_type :=
  hdp_03_body_3_3_independent_coordinates_isotropic

end NumStability.HDP.Contract
