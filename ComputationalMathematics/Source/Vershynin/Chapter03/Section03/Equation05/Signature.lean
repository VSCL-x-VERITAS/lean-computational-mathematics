import ComputationalMathematics.HDP.Vector.GaussianAffine

/-! Frozen signature for the general multivariate Gaussian density in Equation (3.5). -/

noncomputable section

open MeasureTheory
open scoped ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_5__contract_type : Prop :=
  ∀ (n : ℕ) (m : Fin n → ℝ)
    (S B : Matrix (Fin n) (Fin n) ℝ),
      S.PosSemidef → IsUnit S → B.PosSemidef → B * B = S →
      NumStability.HDP.Vector.Gaussian.affineGaussianVectorMeasure m B =
        (volume : Measure (Fin n → ℝ)).withDensity
          (fun x => ENNReal.ofReal
            (NumStability.HDP.Vector.Gaussian.covarianceGaussianDensity m S x))

end NumStability.HDP.Contract
