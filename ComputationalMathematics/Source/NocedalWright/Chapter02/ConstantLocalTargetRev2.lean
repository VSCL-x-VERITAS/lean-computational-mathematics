import ComputationalMathematics.Optimization.Convex.Euclidean

/-! Chapter 2: the constant-two objective has every point as a weak local minimizer. -/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Proof-free source target for the constant-function example in the chapter's R^n setting. -/
def constantTwoLocalMinTargetRev2 : Prop :=
  ∀ {n : ℕ}, 0 < n →
    ∀ x : Fin n → ℝ,
      IsLocalMin (fun _ : Fin n → ℝ => (2 : ℝ)) x

end ComputationalMathematics.Source.NocedalWright.Chapter02
