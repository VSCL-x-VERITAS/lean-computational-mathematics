import ComputationalMathematics.Analysis.SingularValues.InverseSVD

/-!
# Vershynin, Chapter 4, Exercise 4.1.1

Source-correspondence contract for the inverse of an invertible square real
matrix given by its singular-value decomposition.
-/

namespace NumStability.HDP.Contract

/-- Printed page 76, Exercise 4.1.1: inverting a full square SVD reciprocates
the nonzero singular values and swaps its left and right singular bases. -/
theorem hdp_04_exercise_4_1_1 {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (s : Fin n → ℝ)
    (u v : OrthonormalBasis (Fin n) ℝ (EuclideanSpace ℝ (Fin n)))
    (hs : ∀ i, 0 < s i) (hsvd : NumStability.IsSquareRealSVD A s u v) :
    NumStability.nonsingInv n A =
      NumStability.inverseSVDFormula s u v := by
  exact NumStability.nonsingInv_eq_inverseSVDFormula A s u v
    (fun i => ne_of_gt (hs i)) hsvd

end NumStability.HDP.Contract
