/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellConstraintPropagationTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellCurlDivergence
import Mathlib.Analysis.Calculus.MeanValue

/-!
# Propagation of the charge-free Maxwell divergence constraints
-/

namespace NumStability.Leveque02Tracer

/-- Ampère and Faraday evolution preserve both initial divergence constraints
on every finite forward interval with the stated classical regularity. -/
theorem maxwellConstraintPropagation : maxwellConstraintPropagationTarget := by
  intro electricDisplacement magneticInduction electricField magneticField
    endTime htime hAmpere hFaraday hmixed hcommute hspatial hinitial
  have hAmpereField :
      maxwellTimeDerivativeField electricDisplacement =
        maxwellScaledCurlField 1 magneticField := by
    funext position time component
    have h := congrFun (hAmpere position time).2.2 component
    simpa [maxwellTimeDerivativeField, maxwellScaledCurlField] using h
  have hFaradayField :
      maxwellTimeDerivativeField magneticInduction =
        maxwellScaledCurlField (-1) electricField := by
    funext position time component
    have h := congrFun (hFaraday position time).2.2 component
    dsimp [maxwellTimeDerivativeField, maxwellScaledCurlField] at *
    linarith
  intro position time htimeIcc
  have hdivD_zero : ∀ τ ∈ Set.Icc 0 endTime,
      HasDerivAt (fun s => maxwellDivergence electricDisplacement position s)
        0 τ := by
    intro τ hτ
    have h := (hcommute position τ hτ).1
    rw [hAmpereField] at h
    have hcurl := maxwellScaledCurl_divergence_zero
      1 magneticField position τ (hmixed position τ hτ).1
    rw [hcurl] at h
    exact h
  have hdivB_zero : ∀ τ ∈ Set.Icc 0 endTime,
      HasDerivAt (fun s => maxwellDivergence magneticInduction position s)
        0 τ := by
    intro τ hτ
    have h := (hcommute position τ hτ).2
    rw [hFaradayField] at h
    have hcurl := maxwellScaledCurl_divergence_zero
      (-1) electricField position τ (hmixed position τ hτ).2
    rw [hcurl] at h
    exact h
  have hDcontinuous :
      ContinuousOn (fun s => maxwellDivergence electricDisplacement position s)
        (Set.Icc 0 endTime) := by
    intro τ hτ
    exact (hdivD_zero τ hτ).continuousAt.continuousWithinAt
  have hBcontinuous :
      ContinuousOn (fun s => maxwellDivergence magneticInduction position s)
        (Set.Icc 0 endTime) := by
    intro τ hτ
    exact (hdivB_zero τ hτ).continuousAt.continuousWithinAt
  have hDright : ∀ τ ∈ Set.Ico 0 endTime,
      HasDerivWithinAt (fun s => maxwellDivergence electricDisplacement position s)
        0 (Set.Ici τ) τ := by
    intro τ hτ
    exact (hdivD_zero τ ⟨hτ.1, hτ.2.le⟩).hasDerivWithinAt
  have hBright : ∀ τ ∈ Set.Ico 0 endTime,
      HasDerivWithinAt (fun s => maxwellDivergence magneticInduction position s)
        0 (Set.Ici τ) τ := by
    intro τ hτ
    exact (hdivB_zero τ ⟨hτ.1, hτ.2.le⟩).hasDerivWithinAt
  have hDconstant : maxwellDivergence electricDisplacement position time =
      maxwellDivergence electricDisplacement position 0 :=
    (constant_of_has_deriv_right_zero hDcontinuous hDright) time htimeIcc
  have hBconstant : maxwellDivergence magneticInduction position time =
      maxwellDivergence magneticInduction position 0 :=
    (constant_of_has_deriv_right_zero hBcontinuous hBright) time htimeIcc
  exact ⟨⟨(hspatial position time htimeIcc).1,
      hDconstant.trans (hinitial position).1.2⟩,
    ⟨(hspatial position time htimeIcc).2,
      hBconstant.trans (hinitial position).2.2⟩⟩

end NumStability.Leveque02Tracer
