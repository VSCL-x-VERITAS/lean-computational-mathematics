import Mathlib.Analysis.Calculus.Gradient.Basic
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Calculus.ContDiff.Basic

/-!
Proof-free Taylor mean-value target from Chapter 2.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The first assertion of Nocedal and Wright, Theorem 2.1 (equation 2.4). -/
def taylorMeanValueTargetV1 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (f : EuclideanSpace ℝ (Fin n) → ℝ), ContDiff ℝ (1 : ℕ) f →
      ∀ (x p : EuclideanSpace ℝ (Fin n)),
        ∃ t : ℝ, 0 < t ∧ t < 1 ∧
          f (x + p) = f x + inner ℝ (gradient f (x + t • p)) p

end ComputationalMathematics.Source.NocedalWright.Chapter02
