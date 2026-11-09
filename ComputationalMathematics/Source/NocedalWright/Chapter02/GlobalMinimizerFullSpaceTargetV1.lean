import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.Order.Filter.Extr

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The full-space branch of the global minimizer definition in Chapter 2,
printed page 12, with the ambient smoothness convention of pages 10 and 17. -/
def globalMinimizerFullSpaceTargetV1 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (f : EuclideanSpace ℝ (Fin n) → ℝ), ContDiff ℝ 2 f →
      ∀ (xstar : EuclideanSpace ℝ (Fin n)),
        IsMinOn f Set.univ xstar ↔ ∀ x, f xstar ≤ f x

end ComputationalMathematics.Source.NocedalWright.Chapter02
