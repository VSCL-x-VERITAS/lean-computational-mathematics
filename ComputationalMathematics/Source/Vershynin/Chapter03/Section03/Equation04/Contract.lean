import ComputationalMathematics.Source.Higham.Chapter28.Section03.Theorem01.StewartHaar.GaussianQRHaar
import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation04.Signature

/-! Source-facing contract for Equation (3.4). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Equation (3.4), printed page 50: the product standard-normal law has the
product density, whose pointwise value is the radial exponential density. -/
theorem hdp_03_eq_3_4 : hdp_03_eq_3_4__contract_type := by
  intro n
  exact ⟨NumStability.standardGaussianVectorMeasure_eq_withDensity_volume n,
    NumStability.HDP.Vector.Gaussian.standardGaussianProductDensity_eq n⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_4__contract : hdp_03_eq_3_4__contract_type :=
  hdp_03_eq_3_4

end NumStability.HDP.Contract
