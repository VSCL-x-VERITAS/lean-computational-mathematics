import ComputationalMathematics.Source.DrineasMahoney.RandNLA2016.Targets.BasisGeometry
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.BasisGeometry

/-! # Basis invariance of normalized leverage scores -/

namespace NumStability.Source.DrineasMahoney.RandNLA2016

theorem leverageBasisInvariance : Targets.leverageBasisInvariance := by
  intro m n p U V _hn _hp hU hV hspan
  exact ⟨orthonormal_projector_eq_of_range_eq U V hU hV hspan,
    leverageScore_and_probability_eq_of_range_eq U V hU hV hspan⟩

end NumStability.Source.DrineasMahoney.RandNLA2016
