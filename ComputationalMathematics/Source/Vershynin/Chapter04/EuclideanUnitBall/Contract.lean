import Mathlib.Analysis.Normed.Module.Ball.Pointwise

/-!
# Vershynin, Chapter 4, Euclidean unit-ball convention

Source-correspondence contract for `B₂ⁿ` and its nonnegative scalar dilates.
-/

open Set
open scoped Pointwise

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Chapter 4, footnote after
Proposition 4.2.12: the unit ball is the norm sublevel set, and multiplying it
by a nonnegative scalar produces the closed ball of that radius.  The normed
space formulation applies in particular to Euclidean space `ℝⁿ`. -/
theorem hdp_04_euclidean_unit_ball_definition
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (ε : ℝ) (hε : 0 ≤ ε) :
    Metric.closedBall (0 : E) 1 = {x | ‖x‖ ≤ 1} ∧
      ε • Metric.closedBall (0 : E) 1 = Metric.closedBall (0 : E) ε := by
  constructor
  · ext x
    simp only [Metric.mem_closedBall, Set.mem_setOf_eq, dist_zero_right]
  · exact smul_unitClosedBall_of_nonneg hε

end NumStability.HDP.Contract
