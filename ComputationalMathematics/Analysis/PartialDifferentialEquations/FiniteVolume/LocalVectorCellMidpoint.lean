/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSecondOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Analysis.Calculus.UniformLocalDerivativeBudget
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
# LocalVectorCellMidpoint

Source-independent local calculus and actual physical cell-average mathematics. Closed forward-time endpoints and explicit quantitative domains are preserved.
-/

namespace NumStability
open Set Metric Filter MeasureTheory
open scoped Topology

theorem local_scalar_cellMidpoint_error
    (f f' : ℝ → ℝ) (K center radius : ℝ)
    (hK : 0 ≤ K) (hradius : 0 < radius)
    (hf : ∀ x ∈ Set.Icc (center - radius) (center + radius), HasDerivAt f (f' x) x)
    (hvariation : ∀ x ∈ Set.Icc (center - radius) (center + radius),
      |f' x - f' center| ≤ K * |x - center|) :
    |oneDimensionalCellAverage f (center - radius) (center + radius) - f center| ≤
      K * radius ^ 2 := by
  let p : ℝ → ℝ := fun x => f' center * x + (f center - center * f' center)
  have hpc : Continuous p := (continuous_const.mul continuous_id).add continuous_const
  have hfc : ContinuousOn f (Set.Icc (center - radius) (center + radius)) :=
    fun x hx => (hf x hx).continuousAt.continuousWithinAt
  have hpavg : oneDimensionalCellAverage p (center - radius) (center + radius) =
      f center := by
    rw [oneDimensionalCellAverage_affine_eq_endpointMean _ _ _ _ (by linarith)]
    ring
  have herr (x : ℝ) (hx : x ∈ Set.Icc (center - radius) (center + radius)) :
      ‖f x - p x‖ ≤ K * radius ^ 2 := by
    have hsub := Set.uIcc_subset_Icc
      (show center ∈ Set.Icc (center - radius) (center + radius) from ⟨by linarith, by linarith⟩) hx
    have h := norm_firstOrderTaylorError_le_of_local_deriv_variation
      f f' K center x hK (fun y hy => hf y (hsub hy))
      (fun y hy => by simpa only [Real.norm_eq_abs] using hvariation y (hsub hy))
    have hd : |x - center| ≤ radius := abs_le.mpr ⟨by linarith [hx.1], by linarith [hx.2]⟩
    have hb := mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (abs_nonneg _) hd 2) hK
    have hid : f center + (x - center) • f' center = p x := by
      change f center + (x - center) * f' center = f' center * x + (f center - center * f' center)
      ring
    rw [hid] at h
    exact h.trans (by simpa only [sq_abs] using hb)
  have havg := norm_oneDimensionalCellAverage_sub_le (by linarith : center - radius < center + radius)
    (hfc.intervalIntegrable_of_Icc (by linarith)) (hpc.intervalIntegrable _ _)
    (fun x hx => herr x (by
      rw [Set.uIoc_of_le (by linarith : center - radius ≤ center + radius)] at hx
      exact ⟨hx.1.le, hx.2⟩))
  simpa only [hpavg, Real.norm_eq_abs] using havg

theorem local_vector_cellMidpoint_error
    {m : ℕ} (f f' : ℝ → Fin m → ℝ) (K center radius : ℝ)
    (hK : 0 ≤ K) (hradius : 0 < radius)
    (hf : ∀ x ∈ Set.Icc (center - radius) (center + radius), HasDerivAt f (f' x) x)
    (hvariation : ∀ x ∈ Set.Icc (center - radius) (center + radius),
      ‖f' x - f' center‖ ≤ K * |x - center|) :
    ‖oneDimensionalCellAverage f (center - radius) (center + radius) - f center‖ ≤
      K * radius ^ 2 := by
  have hc : ContinuousOn f (Set.Icc (center - radius) (center + radius)) :=
    fun x hx => (hf x hx).continuousAt.continuousWithinAt
  have hi : IntervalIntegrable f volume (center - radius) (center + radius) :=
    hc.intervalIntegrable_of_Icc (by linarith : center - radius ≤ center + radius)
  apply (pi_norm_le_iff_of_nonneg (by positivity : 0 ≤ K * radius ^ 2)).2
  intro p
  have hs := local_scalar_cellMidpoint_error
    (fun x => f x p) (fun x => f' x p) K center radius hK hradius
    (fun x hx => (hasDerivAt_pi.mp (hf x hx)) p)
    (fun x hx => by
      have hcoord := norm_le_pi_norm (f' x - f' center) p
      have hcoord' : |f' x p - f' center p| ≤ ‖f' x - f' center‖ := by
        simpa only [Real.norm_eq_abs, Pi.sub_apply] using hcoord
      exact hcoord'.trans (hvariation x hx))
  simpa only [Pi.sub_apply, Real.norm_eq_abs, oneDimensionalCellAverage_apply f _ _ hi p] using hs

theorem uniform_local_vector_cellMidpoint_budget
    {m : ℕ} (f : ℝ → Fin m → ℝ) (center : ℝ)
    (hsmooth : ContDiffAt ℝ 2 f center) :
    ∃ threshold K : ℝ, 0 < threshold ∧ 0 ≤ K ∧
      ∀ cellCenter radius : ℝ, 0 < radius →
        |cellCenter - center| + radius ≤ threshold →
        ‖oneDimensionalCellAverage f (cellCenter - radius) (cellCenter + radius) -
          f cellCenter‖ ≤ K * radius ^ 2 := by
  obtain ⟨threshold, K, hpos, hK, hderiv, hLip⟩ :=
    uniform_local_derivative_budget f center hsmooth
  refine ⟨threshold, K, hpos, hK, ?_⟩
  intro cellCenter radius hradius hcover
  have hdist := abs_le.mp (le_sub_iff_add_le.mpr hcover)
  have hsub (x : ℝ) (hx : x ∈ Set.Icc (cellCenter - radius) (cellCenter + radius)) :
      x ∈ Set.Icc (center - threshold) (center + threshold) := by
    constructor <;> linarith [hx.1, hx.2, hdist.1, hdist.2]
  have hc : cellCenter ∈ Set.Icc (center - threshold) (center + threshold) :=
    hsub cellCenter ⟨by linarith, by linarith⟩
  exact local_vector_cellMidpoint_error f (deriv f) K cellCenter radius hK hradius
    (fun x hx => hderiv x (hsub x hx))
    (fun x hx => hLip x (hsub x hx) cellCenter hc)

theorem adjacent_vector_average_mean
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    (profile : ℝ → E) (face width : ℝ) (hwidth : 0 < width)
    (hleft : IntervalIntegrable profile volume (face - width) face)
    (hright : IntervalIntegrable profile volume face (face + width)) :
    (1 / 2 : ℝ) • (oneDimensionalCellAverage profile (face - width) face +
      oneDimensionalCellAverage profile face (face + width)) =
      oneDimensionalCellAverage profile (face - width) (face + width) := by
  have hsplit := intervalIntegral.integral_add_adjacent_intervals hleft hright
  simp only [oneDimensionalCellAverage,
    show face - (face - width) = width by ring,
    show face + width - face = width by ring,
    show face + width - (face - width) = 2 * width by ring]
  rw [← smul_add,← hsplit,smul_smul]
  congr 1
  field_simp

end NumStability
