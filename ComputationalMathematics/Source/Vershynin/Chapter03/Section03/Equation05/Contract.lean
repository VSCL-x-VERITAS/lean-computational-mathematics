import ComputationalMathematics.Source.Higham.Chapter28.Section03.Theorem01.StewartHaar.GaussianQRHaar
import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.Equation05.Signature

/-! Source-facing contract for Equation (3.5). -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

/-- Equation (3.5), printed page 51: the affine Gaussian law with mean m and
invertible covariance S has the displayed covariance-matrix density. -/
theorem hdp_03_eq_3_5 : hdp_03_eq_3_5__contract_type := by
  intro n m S B _ hSunit hBpos hBB
  have hBBunit : IsUnit (B * B) := hBB.symm ▸ hSunit
  have hBunit : IsUnit B := isUnit_of_mul_isUnit_left hBBunit
  unfold NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure
  rw [NumStability.standardGaussianVectorMeasure_eq_withDensity_volume]
  have hmeas : Measurable
      (fun z : Fin n → ℝ =>
        ENNReal.ofReal
          (∏ i : Fin n, ProbabilityTheory.gaussianPDFReal 0 1 (z i))) := by
    fun_prop
  rw [NumStability.HDP.Vector.Gaussian.map_affineGaussianMap_withDensity
    m B hBunit _ hmeas]
  congr 1
  funext x
  rw [← ENNReal.ofReal_mul (by positivity :
    0 ≤ abs (Matrix.det B)⁻¹)]
  congr 1
  exact
    NumStability.HDP.Vector.Gaussian.affineStandardGaussianDensity_eq_covarianceGaussianDensity
      m x S B hSunit hBpos hBB

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_5__contract : hdp_03_eq_3_5__contract_type :=
  hdp_03_eq_3_5

end NumStability.HDP.Contract
