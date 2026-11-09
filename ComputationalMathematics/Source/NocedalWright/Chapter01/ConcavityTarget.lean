import ComputationalMathematics.Optimization.Convex.Basic

/-!
# Nocedal--Wright Chapter 1 concavity target

Proof-free target for the printed definition that a function is concave when
its negative is convex.
-/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- The proof-free proposition corresponding to the Chapter 1 definition of concavity. -/
def concavityDefinitionTarget : Prop :=
  ∀ {n : ℕ} (s : Set (Fin n → ℝ)) (f : (Fin n → ℝ) → ℝ),
    ConcaveOn ℝ s f ↔ ConvexOn ℝ s (fun x => -f x)

end ComputationalMathematics.Source.NocedalWright.Chapter01
