import ComputationalMathematics.HDP.Metric.EuclideanBallCovering

/-!
# Vershynin Chapter 4, Equation (4.10)
-/

noncomputable section

open Metric
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Equation (4.10): in the nontrivial range `0 < ε ≤ 1`,
the covering number of the Euclidean unit ball lies between `(1 / ε)ⁿ`
and the simplified upper bound `(3 / ε)ⁿ`. -/
theorem hdp_04_equation_4_10
    (n : ℕ) {ε : ℝ≥0} (hε : 0 < ε) (hεone : ε ≤ 1) :
    (1 / (ε : ℝ)) ^ n ≤
        ((_root_.Metric.coveringNumber ε
          (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ∧
      ((_root_.Metric.coveringNumber ε
          (closedBall (0 : EuclideanSpace ℝ (Fin n)) 1)).toNat : ℝ) ≤
        (3 / (ε : ℝ)) ^ n := by
  rcases NumStability.HDP.Metric.euclideanUnitBall_coveringNumber_bounds n hε with
    ⟨hlower, hupper⟩
  refine ⟨hlower, hupper.trans ?_⟩
  gcongr
  have hεreal : (0 : ℝ) < ε := by exact_mod_cast hε
  have hεoneReal : (ε : ℝ) ≤ 1 := by exact_mod_cast hεone
  apply (le_div_iff₀ hεreal).2
  field_simp
  linarith

end NumStability.HDP.Contract
