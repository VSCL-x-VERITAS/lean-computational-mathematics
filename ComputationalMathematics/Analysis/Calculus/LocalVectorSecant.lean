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
# LocalVectorSecant

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem local_vector_firstOrder_secant
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (f f' : ℝ → E) (K face width : ℝ) (hK : 0 ≤ K) (hwidth : 0 < width)
    (hf : ∀ x ∈ Set.Icc (face - width / 2) (face + width / 2), HasDerivAt f (f' x) x)
    (hv : ∀ x ∈ Set.Icc (face - width / 2) (face + width / 2),
      ‖f' x - f' face‖ ≤ K * |x - face|) :
    ‖width⁻¹ • (f (face + width / 2) - f (face - width / 2)) - f' face‖ ≤
      K * width / 2 := by
  have herr := (local_firstOrderTaylor_symmetric_errors f f' K face (width / 2)
    hK (by positivity) hf hv).2
  have hid : width⁻¹ • (f (face + width / 2) - f (face - width / 2)) - f' face =
      width⁻¹ • ((f (face + width / 2) - f (face - width / 2)) - width • f' face) := by
    symm
    rw [smul_sub, smul_smul, inv_mul_cancel₀ hwidth.ne', one_smul]
  rw [hid, norm_smul, Real.norm_eq_abs, abs_of_pos (inv_pos.mpr hwidth)]
  calc
    _ ≤ width⁻¹ * (2 * K * (width / 2) ^ 2) :=
      mul_le_mul_of_nonneg_left (by simpa only [mul_div_cancel₀ _ (by norm_num : (2 : ℝ) ≠ 0)] using herr) (by positivity)
    _ = K * width / 2 := by field_simp

end NumStability
