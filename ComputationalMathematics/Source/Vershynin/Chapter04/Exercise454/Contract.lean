import ComputationalMathematics.HDP.Matrix.Weyl

/-!
# Vershynin Chapter 4, Exercise 4.5.4
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.5.4: Weyl's inequality, here proved by the reusable
theorem whose proof proceeds from the Courant--Fischer max--min
characterization as requested by the exercise. -/
theorem hdp_04_exercise_4_5_4
    {n : ℕ} (S T : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hT : T.IsHermitian) (i : Fin n) :
    (∀ j k : Fin n, j ≤ k →
      NumStability.hermitianOrderedEigenvalue hS k ≤
        NumStability.hermitianOrderedEigenvalue hS j) ∧
    (∀ j k : Fin n, j ≤ k →
      NumStability.hermitianOrderedEigenvalue hT k ≤
        NumStability.hermitianOrderedEigenvalue hT j) ∧
    |NumStability.hermitianOrderedEigenvalue hS i -
        NumStability.hermitianOrderedEigenvalue hT i| ≤
      NumStability.realMatrixOperatorNorm (S - T) := by
  exact ⟨NumStability.hermitianOrderedEigenvalue_antitone hS,
    NumStability.hermitianOrderedEigenvalue_antitone hT,
    NumStability.HDP.Matrix.abs_hermitianOrderedEigenvalue_sub_le_operatorNorm
      S T hS hT i⟩

end NumStability.HDP.Contract
