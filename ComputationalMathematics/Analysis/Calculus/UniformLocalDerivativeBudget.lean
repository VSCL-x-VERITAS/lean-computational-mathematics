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
# UniformLocalDerivativeBudget

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

/-- A pairwise budget can be recentered at either moving cell midpoint. -/
theorem uniform_local_derivative_budget
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f : ℝ → E) (center : ℝ) (hf : ContDiffAt ℝ 2 f center) :
    ∃ radius K : ℝ, 0 < radius ∧ 0 ≤ K ∧
      (∀ y ∈ Icc (center - radius) (center + radius), HasDerivAt f (deriv f y) y) ∧
      (∀ y ∈ Icc (center - radius) (center + radius),
        ∀ z ∈ Icc (center - radius) (center + radius),
          ‖deriv f y - deriv f z‖ ≤ K * |y - z|) := by
  have hderiv : ContDiffAt ℝ 1 (deriv f) center := hf.derivWithin (by norm_num)
  obtain ⟨K, region, hregion, hLip⟩ := hderiv.exists_lipschitzOnWith
  have hdiff : ∀ᶠ y in nhds center, DifferentiableAt ℝ f y :=
    (hf.eventually (by simp)).mono (fun y hy => hy.differentiableAt (by decide))
  obtain ⟨ε, hε, hinside⟩ := Metric.mem_nhds_iff.mp (Filter.inter_mem hregion hdiff)
  have hin (y : ℝ) (hy : y ∈ Icc (center - ε / 2) (center + ε / 2)) :
      y ∈ region ∩ {z | DifferentiableAt ℝ f z} := by
    apply hinside
    rw [Metric.mem_ball, Real.dist_eq]
    have habs : |y - center| ≤ ε / 2 := abs_le.mpr ⟨by linarith [hy.1], by linarith [hy.2]⟩
    linarith
  refine ⟨ε / 2, K, by linarith, K.coe_nonneg, ?_, ?_⟩
  · intro y hy
    exact (hin y hy).2.hasDerivAt
  · intro y hy z hz
    simpa only [Real.norm_eq_abs] using hLip.norm_sub_le (hin y hy).1 (hin z hz).1

end NumStability
