import ComputationalMathematics.HDP.Metric.EuclideanBallCovering

/-!
# Vershynin Chapter 4, Corollary 4.2.13
-/

noncomputable section

open Metric
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Corollary 4.2.13: for every positive radius, the internal
covering number of the Euclidean unit ball lies between `(1 / ε)ⁿ` and
`(2 / ε + 1)ⁿ`; the same upper bound holds for the Euclidean unit sphere.

Mathlib's covering number is `ℕ∞`; compactness makes it finite here, so the
displayed source bounds are stated on its exact natural value. -/
theorem hdp_04_corollary_4_2_13
    (n : ℕ) {ε : ℝ≥0} (hε : 0 < ε) :
    (1 / (ε : ℝ)) ^ n ≤
        ((_root_.Metric.coveringNumber ε
          (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ∧
      ((_root_.Metric.coveringNumber ε
          (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ≤
        (2 / (ε : ℝ) + 1) ^ n ∧
      ((_root_.Metric.coveringNumber ε
          (sphere (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ≤
        (2 / (ε : ℝ) + 1) ^ n := by
  rcases NumStability.HDP.Metric.euclideanUnitBall_coveringNumber_bounds n hε with
    ⟨hlower, hupper⟩
  exact ⟨hlower, hupper,
    NumStability.HDP.Metric.euclideanUnitSphere_coveringNumber_upper_bound n hε⟩

end NumStability.HDP.Contract
