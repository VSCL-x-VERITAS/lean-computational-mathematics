import ComputationalMathematics.HDP.Metric.EuclideanBallCovering

/-!
# Vershynin Chapter 4, Proposition 4.2.12
-/

noncomputable section

open Metric Set MeasureTheory
open scoped ENNReal NNReal Pointwise

namespace NumStability.HDP.Contract

/-- Vershynin, Proposition 4.2.12: the covering number is bounded below by
the volume comparison with radius-`ε` balls, bounded above by the packing
number, and the packing number is bounded above by the volume comparison with
the Minkowski enlargement by a radius-`ε / 2` ball.

The two volume-ratio inequalities are written in cross-multiplied form in
`ENNReal`. Positive finite-dimensional balls have nonzero finite volume, so
this retains the source ratios while also covering infinite covering or packing
numbers without an extra boundedness assumption on `K`. -/
theorem hdp_04_proposition_4_2_12
    (n : ℕ) (K : Set (EuclideanSpace ℝ (Fin n)))
    {ε : ℝ≥0} (hε : 0 < ε) :
    NumStability.HDP.Metric.borelAddHaarVolume K ≤
        (_root_.Metric.coveringNumber ε K : ℝ≥0∞) *
          NumStability.HDP.Metric.borelAddHaarVolume
            (closedBall (0 : EuclideanSpace ℝ (Fin n)) (ε : ℝ)) ∧
      (_root_.Metric.coveringNumber ε K : ℝ≥0∞) ≤
        (_root_.Metric.packingNumber ε K : ℝ≥0∞) ∧
      (_root_.Metric.packingNumber ε K : ℝ≥0∞) *
          NumStability.HDP.Metric.borelAddHaarVolume
            (ball (0 : EuclideanSpace ℝ (Fin n)) ((ε : ℝ) / 2)) ≤
        NumStability.HDP.Metric.borelAddHaarVolume
          (K + closedBall (0 : EuclideanSpace ℝ (Fin n)) ((ε : ℝ) / 2)) := by
  refine ⟨NumStability.HDP.Metric.measure_le_coveringNumber_mul_measure_closedBall
    K hε, ?_,
    NumStability.HDP.Metric.packingNumber_mul_measure_ball_le_measure_add_closedBall
      K hε⟩
  exact ENat.toENNReal_mono (_root_.Metric.coveringNumber_le_packingNumber ε K)

end NumStability.HDP.Contract
