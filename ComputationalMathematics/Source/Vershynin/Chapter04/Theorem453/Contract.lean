import ComputationalMathematics.HDP.Matrix.Weyl
import ComputationalMathematics.Analysis.Eigenvalues.OrderedSpectrum

/-!
# Vershynin Chapter 4, Theorem 4.5.3
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Theorem 4.5.3 (Weyl's inequality): corresponding ordered
eigenvalues of real symmetric matrices differ by at most the operator norm of
the matrix perturbation. -/
theorem hdp_04_theorem_4_5_3
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n) :
    (∀ j k : Fin n, j ≤ k →
      NumStability.hermitianOrderedEigenvalue hS k ≤
        NumStability.hermitianOrderedEigenvalue hS j) ∧
    (∀ j k : Fin n, j ≤ k →
      NumStability.hermitianOrderedEigenvalue hT k ≤
        NumStability.hermitianOrderedEigenvalue hT j) ∧
    spectrum ℝ S.toEuclideanLin =
      Set.range (NumStability.hermitianOrderedEigenvalue hS) ∧
    (∀ μ : ℝ, Module.End.HasEigenvalue S.toEuclideanLin μ →
      Finset.card {j | NumStability.hermitianOrderedEigenvalue hS j = μ} =
        Module.finrank ℝ (Module.End.eigenspace S.toEuclideanLin μ)) ∧
    spectrum ℝ T.toEuclideanLin =
      Set.range (NumStability.hermitianOrderedEigenvalue hT) ∧
    (∀ μ : ℝ, Module.End.HasEigenvalue T.toEuclideanLin μ →
      Finset.card {j | NumStability.hermitianOrderedEigenvalue hT j = μ} =
        Module.finrank ℝ (Module.End.eigenspace T.toEuclideanLin μ)) ∧
    |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hT i| ≤
      NumStability.realMatrixOperatorNorm (S - T) := by
  exact ⟨NumStability.hermitianOrderedEigenvalue_antitone hS,
    NumStability.hermitianOrderedEigenvalue_antitone hT,
    NumStability.spectrum_eq_range_hermitianOrderedEigenvalue hS,
    fun _ hμ ↦ NumStability.card_hermitianOrderedEigenvalue_eq hS hμ,
    NumStability.spectrum_eq_range_hermitianOrderedEigenvalue hT,
    fun _ hμ ↦ NumStability.card_hermitianOrderedEigenvalue_eq hT hμ,
    NumStability.HDP.Matrix.abs_hermitianOrderedEigenvalue_sub_le_operatorNorm
      S T hS hT i⟩

end NumStability.HDP.Contract
