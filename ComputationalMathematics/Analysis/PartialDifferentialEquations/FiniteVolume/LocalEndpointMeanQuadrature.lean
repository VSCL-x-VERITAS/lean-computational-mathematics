/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageEstimates
import ComputationalMathematics.Analysis.Calculus.LocalFirstOrderTaylor
import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic

open MeasureTheory
/-!
# Local accuracy of endpoint averaging

Affine fields have their exact normalized interval average at the mean
of the two endpoint values. A local quadratic Taylor remainder controls
the error for a smooth field. Local C2 smoothness supplies a common
positive step threshold and quadratic error constant, with integrability
derived only on the current forward interval.
-/

namespace NumStability

theorem oneDimensionalCellAverage_affine_eq_endpointMean
    (slope intercept left right : ℝ) (hinterval : left < right) :
    oneDimensionalCellAverage (fun t => slope * t + intercept) left right =
      ((slope * left + intercept) + (slope * right + intercept)) / 2 := by
  have hc : Continuous (fun t : ℝ => slope * t) := continuous_const.mul continuous_id
  simp only [oneDimensionalCellAverage, smul_eq_mul]
  rw [intervalIntegral.integral_add (hc.intervalIntegrable _ _) intervalIntegrable_const,
    intervalIntegral.integral_const_mul, intervalIntegral.integral_const, integral_id]
  simp only [smul_eq_mul]
  field_simp [(sub_pos.mpr hinterval).ne']
  <;> ring

theorem endpointMean_oneDimensionalCellAverage_error_le_of_local_deriv_variation
    (f f' : ℝ → ℝ) (K time step : ℝ) (hK : 0 ≤ K) (hstep : 0 < step)
    (hf : ∀ t ∈ Set.Icc time (time + step), HasDerivAt f (f' t) t)
    (hvariation : ∀ t ∈ Set.Icc time (time + step), |f' t - f' time| ≤ K * |t - time|) :
    |(f time + f (time + step)) / 2 -
      oneDimensionalCellAverage f time (time + step)| ≤ (3 * K / 2) * step ^ 2 := by
  let p : ℝ → ℝ := fun t => f' time * t + (f time - time * f' time)
  have hpc : Continuous p := (continuous_const.mul continuous_id).add continuous_const
  have hc : ContinuousOn f (Set.Icc time (time + step)) :=
    fun t ht => (hf t ht).continuousAt.continuousWithinAt
  have herr (t : ℝ) (ht : t ∈ Set.Icc time (time + step)) : ‖f t - p t‖ ≤ K * step ^ 2 := by
    have htime : time ∈ Set.Icc time (time + step) := ⟨le_rfl, by linarith⟩
    have hsub := Set.uIcc_subset_Icc htime ht
    have h := norm_firstOrderTaylorError_le_of_local_deriv_variation
      f f' K time t hK (fun y hy => hf y (hsub hy))
      (fun y hy => by simpa only [Real.norm_eq_abs] using hvariation y (hsub hy))
    have hd : |t - time| ≤ step := abs_le.mpr ⟨by linarith [ht.1], by linarith [ht.2]⟩
    have hb := mul_le_mul_of_nonneg_left (pow_le_pow_left₀ (abs_nonneg _) hd 2) hK
    have hid : f time + (t - time) * f' time = p t := by dsimp [p]; ring
    rw [smul_eq_mul, hid] at h
    exact h.trans (by simpa only [sq_abs] using hb)
  have havg : ‖oneDimensionalCellAverage f time (time + step) -
      oneDimensionalCellAverage p time (time + step)‖ ≤ K * step ^ 2 := by
    apply norm_oneDimensionalCellAverage_sub_le (by linarith : time < time + step)
    · exact hc.intervalIntegrable_of_Icc (by linarith)
    · exact hpc.intervalIntegrable _ _
    · intro t ht
      rw [Set.uIoc_of_le (by linarith : time ≤ time + step)] at ht
      exact herr t ⟨ht.1.le, ht.2⟩
  have hend := herr (time + step) ⟨by linarith, le_rfl⟩
  have hpmean : oneDimensionalCellAverage p time (time + step) =
      (p time + p (time + step)) / 2 :=
    oneDimensionalCellAverage_affine_eq_endpointMean _ _ _ _ (by linarith)
  have hptime : p time = f time := by dsimp [p]; ring
  have hmean : |(f time + f (time + step)) / 2 -
      oneDimensionalCellAverage p time (time + step)| ≤ K * step ^ 2 / 2 := by
    rw [hpmean, hptime]
    have hid : (f time + f (time + step)) / 2 - (f time + p (time + step)) / 2 =
      (f (time + step) - p (time + step)) / 2 := by ring
    rw [hid, abs_div]
    norm_num only [abs_of_pos (by norm_num : (0:ℝ) < 2)]
    simpa only [Real.norm_eq_abs] using div_le_div_of_nonneg_right hend (by norm_num : (0:ℝ) ≤ 2)
  have htri : |(f time + f (time + step)) / 2 - oneDimensionalCellAverage f time (time + step)| ≤
      |(f time + f (time + step)) / 2 - oneDimensionalCellAverage p time (time + step)| +
      |oneDimensionalCellAverage f time (time + step) - oneDimensionalCellAverage p time (time + step)| := by
    have hid : (f time + f (time + step)) / 2 - oneDimensionalCellAverage f time (time + step) =
      ((f time + f (time + step)) / 2 - oneDimensionalCellAverage p time (time + step)) -
      (oneDimensionalCellAverage f time (time + step) - oneDimensionalCellAverage p time (time + step)) := by ring
    rw [hid]; exact abs_sub _ _
  simp only [Real.norm_eq_abs] at havg
  nlinarith

theorem endpointMean_oneDimensionalCellAverage_error_le_of_contDiffAt_two
    (f : ℝ → ℝ) (time : ℝ) (hsmooth : ContDiffAt ℝ 2 f time) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ step : ℝ, 0 < step → step < threshold →
        |(f time + f (time + step)) / 2 -
          oneDimensionalCellAverage f time (time + step)| ≤ C * step ^ 2 := by
  obtain ⟨radius, K, hr, hK, hb⟩ := contDiffAt_two_exists_local_deriv_variation f time hsmooth
  refine ⟨radius, 3 * K / 2, hr, by positivity, ?_⟩
  intro step hstep hsmall
  have hsub (t : ℝ) (ht : t ∈ Set.Icc time (time + step)) :
      t ∈ Set.Icc (time - radius) (time + radius) := ⟨by linarith [ht.1], by linarith [ht.2]⟩
  exact endpointMean_oneDimensionalCellAverage_error_le_of_local_deriv_variation f (deriv f)
    K time step hK hstep (fun t ht => (hb t (hsub t ht)).1)
    (fun t ht => by simpa only [Real.norm_eq_abs] using (hb t (hsub t ht)).2)

end NumStability
