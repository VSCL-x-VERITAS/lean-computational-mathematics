import ComputationalMathematics.HDP.Matrix.DavisKahan

/-!
# Vershynin Chapter 4, Theorem 4.5.5
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Theorem 4.5.5 (Davis--Kahan): if the `i`-th ordered
eigenvalue of a real symmetric matrix is separated from every other
eigenvalue by the positive gap `δ`, then the sine of the angle between the
corresponding ordered unit eigenvectors before and after perturbation is at
most `2 ‖S - T‖ / δ`.

The second conjunct in `hgap` records that `δ` is the attained minimum gap,
not merely a lower bound. -/
theorem hdp_04_theorem_4_5_5
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n)
    (δ : ℝ) (hδ : 0 < δ)
    (hgap :
      (∀ j : Fin n, j ≠ i →
        δ ≤ |NumStability.hermitianOrderedEigenvalue hS i -
          NumStability.hermitianOrderedEigenvalue hS j|) ∧
      ∃ j : Fin n, j ≠ i ∧
        |NumStability.hermitianOrderedEigenvalue hS i -
          NumStability.hermitianOrderedEigenvalue hS j| = δ) :
    (∀ j k : Fin n, j ≤ k →
      NumStability.hermitianOrderedEigenvalue hS k ≤
        NumStability.hermitianOrderedEigenvalue hS j) ∧
    (∀ j k : Fin n, j ≤ k →
      NumStability.hermitianOrderedEigenvalue hT k ≤
        NumStability.hermitianOrderedEigenvalue hT j) ∧
    (∀ j : Fin n,
      S.toEuclideanLin (NumStability.hermitianOrderedEigenbasis hS j) =
        NumStability.hermitianOrderedEigenvalue hS j •
          NumStability.hermitianOrderedEigenbasis hS j ∧
      T.toEuclideanLin (NumStability.hermitianOrderedEigenbasis hT j) =
        NumStability.hermitianOrderedEigenvalue hT j •
          NumStability.hermitianOrderedEigenbasis hT j ∧
      ‖NumStability.hermitianOrderedEigenbasis hS j‖ = 1 ∧
      ‖NumStability.hermitianOrderedEigenbasis hT j‖ = 1) ∧
    Real.sin
        (InnerProductGeometry.angle
          (NumStability.hermitianOrderedEigenbasis hS i)
          (NumStability.hermitianOrderedEigenbasis hT i)) ≤
      2 * NumStability.realMatrixOperatorNorm (S - T) / δ := by
  refine ⟨NumStability.hermitianOrderedEigenvalue_antitone hS,
    NumStability.hermitianOrderedEigenvalue_antitone hT, ?_,
    NumStability.HDP.Matrix.sin_angle_orderedEigenvectors_le_two_operatorNorm_div_gap
      S T hS hT i δ hδ hgap.1⟩
  intro j
  exact ⟨NumStability.hermitianOrderedEigenbasis_apply hS j,
    NumStability.hermitianOrderedEigenbasis_apply hT j,
    NumStability.norm_hermitianOrderedEigenbasis hS j,
    NumStability.norm_hermitianOrderedEigenbasis hT j⟩

end NumStability.HDP.Contract
