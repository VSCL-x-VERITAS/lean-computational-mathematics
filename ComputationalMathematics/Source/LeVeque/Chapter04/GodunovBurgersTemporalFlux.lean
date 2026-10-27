/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSmoothSpatial

/-!
# Time variation of the physical Burgers face divergence

Spatial FTC identifies the divergence with the average of `q qX`.
Pointwise time regularity then bounds its time variation independently
of the cell width, preserving cancellation of the two face fluxes.
-/

open MeasureTheory

namespace NumStability

/-- Physical outward face-flux divergence over the centered cell. -/
noncomputable def leveque04_burgersPhysicalFaceDivergence
    (q : ℝ → ℝ → ℝ) (center width time : ℝ) : ℝ :=
  (q (center + width / 2) time ^ 2 / 2 - q (center - width / 2) time ^ 2 / 2) / width

/-- Time variation of physical face divergence follows from value,
space-derivative and pointwise time-variation bounds, without a `1/width`
loss from separately estimating the two faces. -/
theorem leveque04_burgersPhysicalFaceDivergence_time_lipschitz
    (q qX : ℝ → ℝ → ℝ) (B M T S center width : ℝ)
    (hB : 0 ≤ B) (hT : 0 ≤ T) (hwidth : 0 < width)
    (hq : ∀ x τ, HasDerivAt (fun y => q y τ) (qX x τ) x)
    (hqX : ∀ τ, Continuous (fun x => qX x τ))
    (hvalue : ∀ x τ, |q x τ| ≤ B) (hderiv : ∀ x τ, |qX x τ| ≤ M)
    (hTime : ∀ x τ σ, |q x τ - q x σ| ≤ T * |τ - σ|)
    (hXTime : ∀ x τ σ, |qX x τ - qX x σ| ≤ S * |τ - σ|)
    (time₁ time₂ : ℝ) :
    |leveque04_burgersPhysicalFaceDivergence q center width time₁ -
      leveque04_burgersPhysicalFaceDivergence q center width time₂| ≤
      (B * S + M * T) * |time₁ - time₂| := by
  have hcont (τ : ℝ) : Continuous (fun x => q x τ) :=
    continuous_iff_continuousAt.mpr (fun x => (hq x τ).continuousAt)
  have hphysical (τ : ℝ) : leveque04_burgersPhysicalFaceDivergence q center width τ =
      oneDimensionalCellAverage (fun x => q x τ * qX x τ)
        (center - width / 2) (center + width / 2) := by
    have hflux (x : ℝ) : HasDerivAt (fun y => q y τ ^ 2 / 2) (q x τ * qX x τ) x := by
      apply (((hq x τ).pow 2).div_const 2).congr_deriv
      ring
    rw [oneDimensionalCellAverage_derivativeProfile_eq_faceSlope _ _ _ _ hflux
      ((hcont τ).mul (hqX τ))]
    dsimp [leveque04_burgersPhysicalFaceDivergence]
    congr 1
    ring
  rw [hphysical time₁, hphysical time₂]
  have hinterval : center - width / 2 < center + width / 2 := by linarith
  have h := norm_oneDimensionalCellAverage_sub_le
    (f := fun x => q x time₁ * qX x time₁)
    (g := fun x => q x time₂ * qX x time₂) hinterval
    (((hcont time₁).mul (hqX time₁)).intervalIntegrable _ _)
    (((hcont time₂).mul (hqX time₂)).intervalIntegrable _ _)
    (bound := (B * S + M * T) * |time₁ - time₂|) (fun x _ => by
      rw [Real.norm_eq_abs]
      calc
        _ = |q x time₁ * (qX x time₁ - qX x time₂) +
            (q x time₁ - q x time₂) * qX x time₂| := by congr 1; ring
        _ ≤ |q x time₁ * (qX x time₁ - qX x time₂)| +
            |(q x time₁ - q x time₂) * qX x time₂| := abs_add_le _ _
        _ = |q x time₁| * |qX x time₁ - qX x time₂| +
            |q x time₁ - q x time₂| * |qX x time₂| := by rw [abs_mul, abs_mul]
        _ ≤ B * (S * |time₁ - time₂|) + (T * |time₁ - time₂|) * M := by
          exact add_le_add
            (mul_le_mul (hvalue x time₁) (hXTime x time₁ time₂) (abs_nonneg _) hB)
            (mul_le_mul (hTime x time₁ time₂) (hderiv x time₂) (abs_nonneg _) (by positivity))
        _ = _ := by ring)
  simpa only [Real.norm_eq_abs] using h

end NumStability
