import ComputationalMathematics.Source.NocedalWright.Chapter02.TrustRegionBallTargetV3

/-!
Checked usual trust-region-ball definition from Chapter 2.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- The printed coordinate condition for the usual trust-region ball. -/
theorem trustRegionBallV3 : trustRegionBallTargetV3 := by
  intro n hn Δ hΔ p
  rfl

end ComputationalMathematics.Source.NocedalWright.Chapter02
