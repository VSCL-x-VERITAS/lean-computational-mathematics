import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Vershynin, Chapter 4, Equation (4.9)

Source-correspondence wrapper for the Euclidean metric formula on `ℝⁿ`.
The reusable mathematical producer is Mathlib's `dist_eq_norm`.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Equation (4.9): Euclidean
distance on `ℝⁿ` is the Euclidean norm of the difference. -/
theorem hdp_04_heq_h4_d9 {n : ℕ} (x y : EuclideanSpace ℝ (Fin n)) :
    dist x y = ‖x - y‖ := by
  exact dist_eq_norm x y

end NumStability.HDP.Contract
