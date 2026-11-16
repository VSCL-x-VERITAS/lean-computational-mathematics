import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.UniformRows.TwoPointLaw
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Preconditioning.ExactTransforms.Core

/-!
# Exact pair collision probabilities for uniform signed-hash sampling

The hash coordinates are iid uniform. Distinct input rows collide with reciprocal
bucket probability, and their collision indicator has the same exact mean.
-/

namespace NumStability
open scoped BigOperators

/-- Under the exact iid uniform CountSketch hash law, two distinct input rows
collide with probability exactly `1 / r`. -/
theorem countSketchHashProbability_eventProb_pairCollision_eq_inv
    {r m : ℕ} (hr : 0 < r) (a b : Fin m) (hab : a ≠ b) :
    (countSketchHashProbability (r := r) (m := m) hr).eventProb
      (countSketchHashPairCollision (r := r) a b) = (r : ℝ)⁻¹ := by
  simpa [countSketchHashProbability, countSketchHashProbMass,
    countSketchHashPairCollision, CountSketchHash, RowTrace] using
    uniformRowTraceProbability_eventProb_pair_collision_eq_inv
      (m := r) (steps := m) hr a b hab

/-- Under the exact iid uniform CountSketch hash law, the real-valued
collision indicator for two distinct input rows has mean `1 / r`. -/
theorem countSketchHashProbability_expectationReal_pairCollisionIndicator_eq_inv
    {r m : ℕ} (hr : 0 < r) (a b : Fin m) (hab : a ≠ b) :
    (countSketchHashProbability (r := r) (m := m) hr).expectationReal
      (fun hash : CountSketchHash r m =>
        if hash a = hash b then (1 : ℝ) else 0) = (r : ℝ)⁻¹ := by
  classical
  let P := countSketchHashProbability (r := r) (m := m) hr
  let E := countSketchHashPairCollision (r := r) a b
  calc
    P.expectationReal
      (fun hash : CountSketchHash r m =>
        if hash a = hash b then (1 : ℝ) else 0)
        =
      P.expectationReal
        (fun hash : CountSketchHash r m =>
          if hash ∈ E then (1 : ℝ) else 0) := by
            apply congrArg P.expectationReal
            funext hash
            simp [E, countSketchHashPairCollision]
    _ = P.eventProb E := by
            exact FiniteProbability.expectationReal_indicator_eq_eventProb P E
    _ = (r : ℝ)⁻¹ := by
            simpa [P, E] using
              countSketchHashProbability_eventProb_pairCollision_eq_inv
                (r := r) (m := m) hr a b hab

end NumStability
