import ComputationalMathematics.Analysis.SingularValues.OrderedDecay
import ComputationalMathematics.Analysis.SingularValues.CourantFischer

/-!
# Vershynin, Chapter 4, Exercise 4.1.2

Thin source contract for the one-based decay bound on the ordered singular
values of a real rectangular matrix.
-/

namespace NumStability.HDP.Contract

/-- Vershynin, Chapter 4, Exercise 4.1.2: the `i`-th singular value in
one-based mathematical indexing is at most `||A||_F / sqrt i`.

The witness sequence is characterized transparently by the full
Courant--Fischer property at every index, rather than by Mathlib's opaque
implementation of an ordered eigenvalue enumeration. Lean's `Fin n` index is
zero-based, so the denominator is `sqrt (i.1 + 1)`. No positive-row premise is
needed, including for the unique zero-row matrix. -/
theorem hdp_04_exercise_4_1_2 {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (i : Fin n) :
    ∃ singularValue : Fin n → ℝ,
      Antitone singularValue ∧
      (∀ j, NumStability.IsSingularValueMaxMin A singularValue j) ∧
      singularValue i ≤
        NumStability.frobNormRect A / Real.sqrt (i.1 + 1 : ℕ) := by
  refine ⟨NumStability.rectCourantFischerSingularValue A,
    NumStability.rectCourantFischerSingularValue_antitone A, ?_,
    NumStability.rectCourantFischerSingularValue_le_frobenius_div_sqrt_succ A i⟩
  intro j
  exact NumStability.rect_singularValue_courantFischer_maxMin A j

end NumStability.HDP.Contract
