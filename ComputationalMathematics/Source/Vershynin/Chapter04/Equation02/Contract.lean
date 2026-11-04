import ComputationalMathematics.Analysis.Eigenvalues.CourantFischer

/-!
# Vershynin, Chapter 4, Equation (4.2)

Source-correspondence contract for the Courant--Fischer max--min theorem.
-/

namespace NumStability.HDP.Contract

/-- Printed page 76, Equation (4.2): the decreasingly ordered eigenvalues of a
real symmetric matrix have the Courant--Fischer max--min characterization.
The reusable predicate states the maximum and minimum by their attaining and
universal witness properties. -/
theorem hdp_04_heq_h4_d2 {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (hA : A.IsHermitian) :
    Antitone (NumStability.hermitianOrderedEigenvalue hA) ∧
      ∀ i : Fin n, NumStability.IsCourantFischerMaxMin A
        (NumStability.hermitianOrderedEigenvalue hA) i := by
  exact ⟨NumStability.hermitianOrderedEigenvalue_antitone hA,
    fun i => NumStability.hermitian_courantFischer_maxMin A hA i⟩

end NumStability.HDP.Contract
