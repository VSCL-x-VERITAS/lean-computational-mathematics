import ComputationalMathematics.Analysis.SingularValues.CourantFischer

/-!
# Vershynin, Chapter 4, singular-value max--min formula

Source-correspondence contract for the singular-value consequence of the
Courant--Fischer theorem following Equation (4.2).
-/

namespace NumStability.HDP.Contract

/-- Printed page 76: the decreasingly ordered singular values of a real
rectangular matrix have the Courant--Fischer max--min characterization.  The
sequence is the repository's explicit canonical right-Gram singular-value
sequence, rather than an existentially chosen sequence unrelated to the SVD.
The reusable predicate states the maximum and minimum through their attaining
and universal witness properties. -/
theorem hdp_04_singular_value_minmax {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    Antitone (NumStability.rectCourantFischerSingularValue A) ∧
      ∀ i : Fin n,
        NumStability.IsSingularValueMaxMin A
          (NumStability.rectCourantFischerSingularValue A) i := by
  exact ⟨NumStability.rectCourantFischerSingularValue_antitone A,
    fun i => NumStability.rect_singularValue_courantFischer_maxMin A i⟩

end NumStability.HDP.Contract
