import ComputationalMathematics.Analysis.FiniteProbabilityOption

/-! Expectation adapters for finite laws with an explicit fallback outcome. -/

namespace NumStability.FiniteProbability

variable {Ω : Type*} [Fintype Ω]

/-- Lifting a law to `some` does not change expectations of its observable. -/
theorem expectationReal_onSome (P : FiniteProbability Ω) (X : Option Ω → ℝ) :
    (onSome P).expectationReal X = P.expectationReal (fun x => X (some x)) := by
  classical
  simp [expectationReal, onSome, Fintype.sum_option]

/-- The deterministic `none` law evaluates its observable at `none`. -/
theorem expectationReal_atNone (X : Option Ω → ℝ) :
    (atNone : FiniteProbability (Option Ω)).expectationReal X = X none := by
  classical
  simp [expectationReal, atNone, Fintype.sum_option]

end NumStability.FiniteProbability
