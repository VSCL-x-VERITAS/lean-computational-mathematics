import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
open MeasureTheory NumStability
noncomputable def lateJumpDebug (_x τ : ℝ) : ℝ := if τ ≤ 1 then 0 else 1
set_option pp.all true in
example (h : IsRectangleConservationLawSolution lateJumpDebug (fun _ => (0 : ℝ))) : False := by
  have balance := h.2.2 0 1 1 2
  norm_num [lateJumpDebug, intervalIntegral.integral_const] at balance
  trace_state
