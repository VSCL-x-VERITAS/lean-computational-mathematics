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
# LocalWithinFirstOrderTaylor

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem norm_firstOrderTaylorError_le_of_local_within_deriv_variation
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f f' : ℝ → E) (K center x : ℝ) (hK : 0 ≤ K)
    (hf : ∀ y ∈ Set.uIcc center x,
      HasDerivWithinAt f (f' y) (Set.uIcc center x) y)
    (hvariation : ∀ y ∈ Set.uIcc center x, ‖f' y - f' center‖ ≤ K * |y - center|) :
    ‖f x - (f center + (x - center) • f' center)‖ ≤ K * (x - center) ^ 2 := by
  let error : ℝ → E := fun y => f y - (f center + (y - center) • f' center)
  have herror (y : ℝ) (hy : y ∈ Set.uIcc center x) :
      HasDerivWithinAt error (f' y - f' center) (Set.uIcc center x) y := by
    have hlinear : HasDerivAt (fun z : ℝ => f center + (z - center) • f' center) (f' center) y := by
      simpa only [one_smul] using (((hasDerivAt_id y).sub_const center).smul_const (f' center)).const_add (f center)
    exact (hf y hy).sub hlinear.hasDerivWithinAt
  have hbound (y : ℝ) (hy : y ∈ Set.uIcc center x) :
      ‖f' y - f' center‖ ≤ K * |x - center| :=
    (hvariation y hy).trans (mul_le_mul_of_nonneg_left (Set.abs_sub_left_of_mem_uIcc hy) hK)
  have hm := (convex_uIcc center x : Convex ℝ (Set.uIcc center x)).norm_image_sub_le_of_norm_hasDerivWithin_le
    herror hbound Set.left_mem_uIcc Set.right_mem_uIcc
  have hm' : ‖f x - (f center + (x - center) • f' center)‖ ≤
      K * (|x - center| * |x - center|) := by
    simpa only [error, sub_self, zero_smul, add_zero, sub_zero, Real.norm_eq_abs,
      mul_assoc] using hm
  simpa only [← pow_two, sq_abs] using hm'

end NumStability
