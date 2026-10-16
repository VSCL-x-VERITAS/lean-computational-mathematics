import ComputationalMathematics.Source.NocedalWright.Chapter01.UnitBallTargetV2

/-! # Nocedal--Wright Euclidean unit balls -/

noncomputable section

namespace ComputationalMathematics.Source.NocedalWright.Chapter01

/-- Every finite-dimensional Euclidean unit ball is convex. -/
theorem euclideanUnitBallConvex : euclideanUnitBallConvexTargetV2 := by
  unfold euclideanUnitBallConvexTargetV2
  intro n
  simpa [Metric.closedBall, dist_zero_right] using
    (convex_closedBall (0 : EuclideanSpace ℝ (Fin n)) (1 : ℝ))

end ComputationalMathematics.Source.NocedalWright.Chapter01
