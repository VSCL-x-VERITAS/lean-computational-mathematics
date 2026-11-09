import ComputationalMathematics.Source.NocedalWright.Chapter01.ConcavityTarget

/-!
# Nocedal--Wright Chapter 1 concavity

This file proves the Chapter 1 definition that a function is concave exactly
when its pointwise negative is convex.
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- A function is concave on a set exactly when its pointwise negative is convex there. -/
theorem concavityDefinition : concavityDefinitionTarget := by
  intro n s f
  constructor
  · exact ConcaveOn.neg
  · intro h
    have h' := h.neg
    change ConcaveOn ℝ s (fun x => -(-f x)) at h'
    simpa only [neg_neg] using h'

end ComputationalMathematics.Source.NocedalWright.Chapter01
