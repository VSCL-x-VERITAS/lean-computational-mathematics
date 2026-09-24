import ComputationalMathematics.HDP.Vector.Gaussian

/-! Frozen signature for the standard multivariate Gaussian density in Equation (3.4). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_eq_3_4__contract_type : Prop :=
  ∀ (n : ℕ),
    NumStability.standardGaussianVectorMeasure n =
        (volume : Measure (Fin n → ℝ)).withDensity
          (fun x => ENNReal.ofReal
            (∏ i : Fin n, gaussianPDFReal 0 1 (x i))) ∧
      ∀ x : Fin n → ℝ,
        (∏ i : Fin n, gaussianPDFReal 0 1 (x i)) =
          (Real.sqrt (2 * Real.pi))⁻¹ ^ n *
            Real.exp (-(∑ i : Fin n, (x i) ^ 2) / 2)

end NumStability.HDP.Contract
