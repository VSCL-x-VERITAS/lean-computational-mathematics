/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLipschitzTrace
import Mathlib.Topology.MetricSpace.Lipschitz

/-!
# Exact cell-average truncation from physical rectangle balance

The numerical divergence enters only through its separately proved spatial
error. Physical balance and time regularity supply the temporal error.
-/

open MeasureTheory

namespace NumStability

/-- A spatial divergence estimate and physical forward rectangle balance
give a normalized one-step error, without assuming a global physical solution. -/
theorem cellAverage_step_error_of_divergence
    (q : ℝ → ℝ → ℝ) (physicalFlux : ℝ → ℝ)
    (numericalDivergence spatialBound D center width oldTime timeStep : ℝ)
    (hD : 0 ≤ D) (hwidth : 0 < width) (htime : 0 < timeStep)
    (hspatial : |numericalDivergence -
      (physicalFlux (q (center + width / 2) oldTime) -
        physicalFlux (q (center - width / 2) oldTime)) / width| ≤ spatialBound)
    (hTime : ∀ τ σ,
      |(physicalFlux (q (center + width / 2) τ) - physicalFlux (q (center - width / 2) τ)) / width -
        (physicalFlux (q (center + width / 2) σ) - physicalFlux (q (center - width / 2) σ)) / width| ≤
          D * |τ - σ|)
    (hbalance :
      (∫ x in center - width / 2..center + width / 2, q x (oldTime + timeStep)) -
          (∫ x in center - width / 2..center + width / 2, q x oldTime) =
        ∫ τ in oldTime..oldTime + timeStep,
          (physicalFlux (q (center - width / 2) τ) - physicalFlux (q (center + width / 2) τ))) :
    let avg := fun τ => oneDimensionalCellAverage (fun x => q x τ) (center - width / 2) (center + width / 2)
    |((avg oldTime - timeStep * numericalDivergence) - avg (oldTime + timeStep)) / timeStep| ≤
      spatialBound + D * timeStep := by
  let avg := fun τ => oneDimensionalCellAverage (fun x => q x τ) (center - width / 2) (center + width / 2)
  let G := fun τ => (physicalFlux (q (center + width / 2) τ) -
    physicalFlux (q (center - width / 2) τ)) / width
  let meanG := oneDimensionalCellAverage G oldTime (oldTime + timeStep)
  have hGLip : LipschitzWith ⟨D, hD⟩ G := LipschitzWith.of_dist_le_mul (by
    intro τ σ
    simpa only [Real.dist_eq, NNReal.coe_mk] using hTime τ σ)
  have hinterval : center - width / 2 < center + width / 2 := by linarith
  have hstepInterval : oldTime < oldTime + timeStep := by linarith
  have htimeError : |meanG - G oldTime| ≤ D * timeStep := by
    have h := norm_oneDimensionalCellAverage_sub_le (f := G) (g := fun _ => G oldTime)
      hstepInterval (hGLip.continuous.intervalIntegrable _ _) intervalIntegrable_const
      (bound := D * timeStep) (fun τ hτ => by
        have hlo : oldTime ≤ τ := by simpa only [min_eq_left hstepInterval.le] using hτ.1.le
        have hhi : τ ≤ oldTime + timeStep := by simpa only [max_eq_right hstepInterval.le] using hτ.2
        have hdist : |τ - oldTime| ≤ timeStep := by rw [abs_of_nonneg (sub_nonneg.mpr hlo)]; linarith
        simpa only [Real.norm_eq_abs] using (hTime τ oldTime).trans
          (mul_le_mul_of_nonneg_left hdist hD))
    rw [oneDimensionalCellAverage_const _ _ _ (ne_of_lt hstepInterval)] at h
    simpa only [Real.norm_eq_abs] using h
  have hmass (τ : ℝ) : width * avg τ =
      ∫ x in center - width / 2..center + width / 2, q x τ := by
    have h := cellWidth_smul_oneDimensionalCellAverage (fun x => q x τ) hinterval
    simpa only [smul_eq_mul, show center + width / 2 - (center - width / 2) = width by ring] using h
  have hmean : timeStep * meanG = ∫ τ in oldTime..oldTime + timeStep, G τ := by
    have h := cellWidth_smul_oneDimensionalCellAverage G hstepInterval
    simpa only [smul_eq_mul, add_sub_cancel_left] using h
  have hGintegral : width * (∫ τ in oldTime..oldTime + timeStep, G τ) =
      -(∫ τ in oldTime..oldTime + timeStep,
        (physicalFlux (q (center - width / 2) τ) - physicalFlux (q (center + width / 2) τ))) := by
    have hrepr : G = fun τ => -(width⁻¹) *
        (physicalFlux (q (center - width / 2) τ) - physicalFlux (q (center + width / 2) τ)) := by
      funext τ
      dsimp [G]
      ring
    rw [hrepr, intervalIntegral.integral_const_mul]
    field_simp
  have hexact : avg (oldTime + timeStep) = avg oldTime - timeStep * meanG := by
    apply (mul_left_cancel₀ (ne_of_gt hwidth))
    have hscaled := congrArg (fun z => width * z) hmean
    nlinarith [hmass (oldTime + timeStep), hmass oldTime, hbalance, hGintegral, hscaled]
  have hnormalized : ((avg oldTime - timeStep * numericalDivergence) -
      avg (oldTime + timeStep)) / timeStep = meanG - numericalDivergence := by
    rw [hexact]
    field_simp
    ring
  have htriangle := abs_sub_le meanG (G oldTime) numericalDivergence
  rw [abs_sub_comm (G oldTime) numericalDivergence] at htriangle
  change |((avg oldTime - timeStep * numericalDivergence) - avg (oldTime + timeStep)) / timeStep| ≤ _
  rw [hnormalized]
  change |numericalDivergence - G oldTime| ≤ spatialBound at hspatial
  linarith

end NumStability
