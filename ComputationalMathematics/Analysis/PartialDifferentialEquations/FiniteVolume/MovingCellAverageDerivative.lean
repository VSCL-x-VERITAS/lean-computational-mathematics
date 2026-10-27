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
# MovingCellAverageDerivative

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem moving_intervalAverage_hasDerivAt_of_local_continuity
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] [CompleteSpace E]
    (f : ℝ → E) (L R leftShift rightShift center : ℝ)
    (horder : leftShift < rightShift) (hc : ContinuousOn f (Ioo L R))
    (hl : center+leftShift ∈ Ioo L R) (hr : center+rightShift ∈ Ioo L R) :
    HasDerivAt
      (fun c => oneDimensionalCellAverage f (c+leftShift) (c+rightShift))
      ((rightShift-leftShift)⁻¹ • (f (center+rightShift)-f (center+leftShift))) center := by
  have hint : IntervalIntegrable f volume (center+leftShift) (center+rightShift) :=
    (hc.mono (show uIcc (center+leftShift) (center+rightShift) ⊆ Ioo L R from by
      rw [uIcc_of_le (by linarith : center+leftShift ≤ center+rightShift)]
      intro y hy
      exact ⟨lt_of_lt_of_le hl.1 hy.1,lt_of_le_of_lt hy.2 hr.2⟩)).intervalIntegrable
  have h := (intervalIntegral.integral_hasFDerivAt hint
    (hc.stronglyMeasurableAtFilter isOpen_Ioo _ hl)
    (hc.stronglyMeasurableAtFilter isOpen_Ioo _ hr)
    (hc.continuousAt (isOpen_Ioo.mem_nhds hl))
    (hc.continuousAt (isOpen_Ioo.mem_nhds hr))).comp_hasDerivAt center
    (((hasDerivAt_id center).add_const leftShift).prodMk
      ((hasDerivAt_id center).add_const rightShift))
  convert h.const_smul (rightShift-leftShift)⁻¹ using 1
  · funext c
    simp only [oneDimensionalCellAverage,Function.comp_def,id_eq]
    congr 1
    ring
  · simp

end NumStability
