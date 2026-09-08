/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Conservation
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.HuberShock.Jump

/-!
# LeVeque Chapter 1: shocks from smooth initial data

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, printed
pages 4–5 (raw PDF pages 26–27). A nonlinear conservation law can develop a
discontinuity from smooth initial data. The proof uses a convex C1 Huber flux
and unbounded smooth initial data; these choices are not a displayed source example.
Conservation is expressed by the time-integrated rectangle law. No full entropy
test-function inequality is part of this statement.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

noncomputable section



/-- A nonlinear C1 flux admits a conserved field that starts smoothly, remains
spatially continuous before a positive time, and has distinct shock traces then. -/
theorem leveque01_nonlinear_shock_formation :
    ∃ (flux : ℝ → ℝ) (q : ℝ → ℝ → ℝ) (T ξ qL qR : ℝ),
      ContDiff ℝ 1 flux ∧
      (¬ ∃ a b : ℝ, ∀ u, flux u = a * u + b) ∧
      IsRectangleConservationLawSolution q flux ∧
      ContDiff ℝ ⊤ (fun x => q x 0) ∧
      0 < T ∧
      (∀ t, 0 ≤ t → t < T → Continuous (fun x => q x t)) ∧
      Tendsto (fun x => q x T) (𝓝[<] ξ) (𝓝 qL) ∧
      Tendsto (fun x => q x T) (𝓝[>] ξ) (𝓝 qR) ∧ qR < qL := by
  refine ⟨huberFlux, HuberShock.shockState, 1, 0, 1, -1,
    huberFlux_contDiff_one, huberFlux_not_affine,
    HuberShock.shockState_isRectangleConservationLawSolution,
    HuberShock.shockState_initial_smooth, by norm_num, ?_, ?_⟩
  · intro t _ ht
    exact HuberShock.shockState_continuous_before ht
  · exact HuberShock.shockState_jump_traces (by norm_num)

end

end NumStability
