import ComputationalMathematics.HDP.Graph.RandomizedRounding
import ComputationalMathematics.Analysis.TestMatrices.Gaussian.GaussianOrthogonal

/-! Frozen proof-free signature for the randomized hyperplane-rounding procedure. -/

namespace NumStability.HDP.Contract

open MeasureTheory
open scoped InnerProductSpace

set_option linter.style.nameCheck false in
def hdp_03_body_3_6_randomized_rounding__contract_type : Prop :=
  ∀ {n : ℕ} (X : NumStability.HDP.Optimization.UnitVectorFamily n),
    let μ := NumStability.standardGaussianEuclideanMeasure n
    let labels : EuclideanSpace ℝ (Fin n) → (Fin n → ℝ) :=
      fun g i ↦ (NumStability.HDP.Graph.hyperplaneRounding X g i).value
    μ Set.univ = 1 ∧
      Measurable labels ∧
      Measure.map labels μ =
        Measure.map
          (fun g i ↦ if ⟪(X i : EuclideanSpace ℝ (Fin n)), g⟫_ℝ < 0
            then (-1 : ℝ) else 1) μ

end NumStability.HDP.Contract
