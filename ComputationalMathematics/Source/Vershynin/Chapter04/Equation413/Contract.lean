import ComputationalMathematics.HDP.Metric.NetApproximation
import ComputationalMathematics.Analysis.OperatorNorms.RealMatrix

/-!
# Vershynin Chapter 4, Equation (4.13)
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.13): quarter-nets of the domain and codomain unit
spheres control the matrix operator norm by twice the largest sampled bilinear
form. -/
theorem hdp_04_equation_4_13 {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ)
    (N : Finset (EuclideanSpace ℝ (Fin n)))
    (M : Finset (EuclideanSpace ℝ (Fin m)))
    (hN : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) N)
    (hM : NumStability.HDP.Metric.IsFiniteUnitSphereNet (1 / 4 : ℝ) M)
    (hNnonempty : N.Nonempty) (hMnonempty : M.Nonempty) :
    ∃ x ∈ N, ∃ y ∈ M,
      (∀ u ∈ N, ∀ v ∈ M,
        inner ℝ (Matrix.toEuclideanLin A u) v ≤
          inner ℝ (Matrix.toEuclideanLin A x) y) ∧
      ‖NumStability.realMatrixContinuousLinearMap A‖ ≤
        2 * inner ℝ (Matrix.toEuclideanLin A x) y := by
  simpa [NumStability.realMatrixContinuousLinearMap] using
    NumStability.HDP.Metric.exists_quarter_net_bilinear_max_bound
      (NumStability.realMatrixContinuousLinearMap A) N M hN hM hNnonempty hMnonempty

end NumStability.HDP.Contract
