/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedTimePartialRegularity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalEndpointMeanQuadrature
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFluxBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalRectangleCellAverage
import Mathlib.Analysis.Calculus.BumpFunction.FiniteDimension
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.FDeriv.Symmetric
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Tactic

/-!
# LocalStateRectangle

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem continuous_closedTime_exists_local_state_rectangle
    {E : Type*} [NormedAddCommGroup E] (q : ℝ → ℝ → E)
    (L R finish face stateRadius : ℝ)
    (hfinish : 0 < finish) (hface : face ∈ Ioo L R) (hstateRadius : 0 < stateRadius)
    (hq : ContinuousOn (Function.uncurry q) (Ioo L R ×ˢ Icc 0 finish)) :
    ∃ spatialRadius horizon : ℝ, 0 < spatialRadius ∧ 0 < horizon ∧ horizon ≤ finish ∧
      Icc (face - spatialRadius) (face + spatialRadius) ⊆ Ioo L R ∧
      ∀ x ∈ Icc (face - spatialRadius) (face + spatialRadius), ∀ τ ∈ Icc 0 horizon,
        q x τ ∈ ball (q face 0) stateRadius := by
  have hmem : (face,0) ∈ Ioo L R ×ˢ Icc 0 finish := ⟨hface,le_rfl,hfinish.le⟩
  have hpre := (hq (face,0) hmem).preimage_mem_nhdsWithin
    (isOpen_ball.mem_nhds (mem_ball_self hstateRadius))
  obtain ⟨ε,hε,hinside⟩ := Metric.mem_nhdsWithin_iff.mp hpre
  let spatialRadius := min (ε / 2) (min ((face-L)/2) ((R-face)/2))
  let horizon := min finish (ε / 2)
  have hrs : 0 < spatialRadius := lt_min (half_pos hε)
    (lt_min (by linarith [hface.1]) (by linarith [hface.2]))
  have hht : 0 < horizon := lt_min hfinish (half_pos hε)
  have hrl : spatialRadius ≤ (face-L)/2 :=
    (min_le_right _ _).trans (min_le_left _ _)
  have hrr : spatialRadius ≤ (R-face)/2 :=
    (min_le_right _ _).trans (min_le_right _ _)
  have hspace : Icc (face-spatialRadius) (face+spatialRadius) ⊆ Ioo L R := by
    intro x hx
    constructor <;> linarith [hx.1,hx.2,hface.1,hface.2]
  refine ⟨spatialRadius,horizon,hrs,hht,min_le_left _ _,hspace,?_⟩
  intro x hx τ hτ
  change (x,τ) ∈ Function.uncurry q ⁻¹' ball (Function.uncurry q (face,0)) stateRadius
  apply hinside
  constructor
  · rw [Metric.mem_ball,Prod.dist_eq,Real.dist_eq,Real.dist_eq,sub_zero,
      max_lt_iff,abs_of_nonneg hτ.1]
    have hdist : |x-face| ≤ spatialRadius := abs_le.mpr ⟨by linarith [hx.1],by linarith [hx.2]⟩
    have hre : spatialRadius ≤ ε/2 := min_le_left _ _
    have hte : horizon ≤ ε/2 := min_le_right _ _
    constructor <;> linarith [hτ.2]
  · exact ⟨hspace hx,hτ.1,hτ.2.trans (min_le_left _ _)⟩

end NumStability
