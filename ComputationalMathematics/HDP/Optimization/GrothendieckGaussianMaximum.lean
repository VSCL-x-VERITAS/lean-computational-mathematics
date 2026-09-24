import ComputationalMathematics.HDP.Optimization.GrothendieckConstant

/-!
# The attained Grothendieck optimum as a Gaussian expectation

This isolated bridge packages the complete three-term identity from display
(3.14) without changing the established elementary-constant producer.
-/

noncomputable section

open MeasureTheory
open scoped BigOperators

namespace NumStability.HDP.Optimization

/-- The complete Gaussian identity for the attained matrix-specific optimum:
the optimum is the coordinate bilinear sum at the canonical maximizer, and
that sum is the expectation of the corresponding Gaussian marginals. -/
theorem bipartiteUnitMaximum_gaussian_identity {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    bipartiteUnitMaximum A =
        ∑ i, ∑ j, A i j * ∑ k,
          (bipartiteMaximizerRowDirection A i).1 k *
            (bipartiteMaximizerColumnDirection A j).1 k ∧
      (∑ i, ∑ j, A i j * ∑ k,
          (bipartiteMaximizerRowDirection A i).1 k *
            (bipartiteMaximizerColumnDirection A j).1 k) =
        ∫ g : Fin (m + n) → ℝ,
          ∑ i, ∑ j, A i j *
            NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k)
                (bipartiteMaximizerRowDirection A i).1 g *
              NumStability.HDP.Vector.linearMarginal (fun k x ↦ x k)
                (bipartiteMaximizerColumnDirection A j).1 g
          ∂NumStability.standardGaussianVectorMeasure (m + n) := by
  constructor
  · exact bipartiteUnitMaximum_eq_coordinate_sum A
  · exact (integral_standardGaussian_bilinear_sum A
      (fun i ↦ (bipartiteMaximizerRowDirection A i).1)
      (fun j ↦ (bipartiteMaximizerColumnDirection A j).1)).symm

end NumStability.HDP.Optimization
