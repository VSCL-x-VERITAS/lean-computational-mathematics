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
# LocalSmoothFluxExtension

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

/-- A flux smooth only on an open admissible state domain can be replaced by
a globally smooth, compactly supported flux near any interior state. -/
theorem local_contDiff_extension
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [FiniteDimensional ℝ E] [NormedAddCommGroup F] [NormedSpace ℝ F]
    {order : ℕ∞} {domain : Set E} {f : E → F} {center : E}
    (hopen : IsOpen domain) (hcenter : center ∈ domain)
    (hsmooth : ContDiffOn ℝ order f domain) :
    ∃ radius : ℝ, 0 < radius ∧ ∃ extension : E → F,
      ContDiff ℝ order extension ∧ HasCompactSupport extension ∧
        ∀ x ∈ ball center radius, extension x = f x := by
  obtain ⟨radius, hpos, hball⟩ := Metric.nhds_basis_closedBall.mem_iff.mp
    (hopen.mem_nhds hcenter)
  let cutoff : ContDiffBump center :=
    ⟨radius / 2, radius, half_pos hpos, half_lt_self hpos⟩
  let extension : E → F := fun x => cutoff x • f x
  refine ⟨radius / 2, half_pos hpos, extension, ?_, ?_, ?_⟩
  · rw [contDiff_iff_contDiffAt]
    intro x
    by_cases hx : x ∈ domain
    · exact cutoff.contDiffAt.smul ((hsmooth x hx).contDiffAt (hopen.mem_nhds hx))
    · have hout : x ∉ tsupport cutoff := by
        rw [cutoff.tsupport_eq]
        exact fun h => hx (hball h)
      have hzero : (fun y => cutoff y) =ᶠ[𝓝 x] 0 :=
        notMem_tsupport_iff_eventuallyEq.mp hout
      apply (contDiffAt_const (c := (0 : F))).congr_of_eventuallyEq
      exact hzero.mono (fun y hy => by simp [extension, hy])
  · exact cutoff.hasCompactSupport.smul_right
  · intro x hx
    have hcut : cutoff x = 1 := cutoff.one_of_mem_closedBall (ball_subset_closedBall hx)
    simp [extension, hcut]

theorem local_extension_hasFDerivAt_original
    {E F : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    [NormedAddCommGroup F] [NormedSpace ℝ F]
    (extension flux : E → F) (center : E) (radius : ℝ)
    (hext : ContDiff ℝ 1 extension)
    (hagree : ∀ state ∈ Metric.ball center radius, extension state = flux state)
    (state : E) (hs : state ∈ Metric.ball center radius) :
    HasFDerivAt flux (fderiv ℝ flux state) state := by
  have hgerm : flux =ᶠ[nhds state] extension := by
    filter_upwards [Metric.isOpen_ball.mem_nhds hs] with y hy
    exact (hagree y hy).symm
  have hd := ((hext.differentiable (by decide) state).hasFDerivAt).congr_of_eventuallyEq hgerm
  have heq : fderiv ℝ flux state = fderiv ℝ extension state := hgerm.fderiv_eq
  rw [← heq] at hd
  exact hd

end NumStability
