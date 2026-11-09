import Mathlib.Analysis.SpecialFunctions.Pow.Real

/-!
Proof-free usual trust-region-ball target from Chapter 2.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The usual trust-region displacement set in the printed coordinate
formula (A.2b) for the Euclidean norm. -/
def bookTrustRegionBallV3 (n : ℕ) (Δ : ℝ) : Set (Fin n → ℝ) :=
  {p | Real.sqrt (∑ i, (p i) ^ 2) ≤ Δ}

/-- Membership in the usual closed Euclidean ball is exactly the printed
coordinate norm inequality, for positive dimension and radius. -/
def trustRegionBallTargetV3 : Prop :=
  ∀ (n : ℕ), 0 < n →
    ∀ (Δ : ℝ), 0 < Δ →
      ∀ p : Fin n → ℝ,
        p ∈ bookTrustRegionBallV3 n Δ ↔
          Real.sqrt (∑ i, (p i) ^ 2) ≤ Δ

end ComputationalMathematics.Source.NocedalWright.Chapter02
