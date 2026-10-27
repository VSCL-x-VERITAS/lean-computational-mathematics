/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorNeighborTaylor
import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredAndLaxFriedrichsFlux

/-!
# Coupled vector Taylor residual for Lax–Friedrichs

Spatial and temporal Taylor errors combine for the actual Eq. (4.20) stencil.
-/

namespace NumStability

/-- The three vector Taylor defects needed for the source's three-point
Lax–Friedrichs stencil combine without decoupling the nonlinear flux. -/
theorem leveque04_laxFriedrichs_vectorTaylorResidual
    {m : ℕ} (left right center next fluxLeft fluxRight slope : Fin m → ℝ)
    (ratio width A B T : ℝ) (hratio : 0 ≤ ratio)
    (hmean : ‖(1 / 2 : ℝ) • (left + right) - center‖ ≤
      A * width ^ 2)
    (hflux : ‖(fluxRight - fluxLeft) - (2 * width) • slope‖ ≤
      B * width ^ 2)
    (hnext : ‖next - (center - (ratio * width) • slope)‖ ≤
      T * width ^ 2) :
    ‖((1 / 2 : ℝ) • (left + right) -
        (ratio / 2) • (fluxRight - fluxLeft)) - next‖ ≤
      (A + ratio / 2 * B + T) * width ^ 2 := by
  have hid :
      ((1 / 2 : ℝ) • (left + right) -
          (ratio / 2) • (fluxRight - fluxLeft)) - next =
        ((1 / 2 : ℝ) • (left + right) - center) -
          (ratio / 2) •
            ((fluxRight - fluxLeft) - (2 * width) • slope) -
          (next - (center - (ratio * width) • slope)) := by
    module
  rw [hid]
  have hratioHalf : 0 ≤ ratio / 2 := by positivity
  have hmiddle :
      ‖(ratio / 2) •
          ((fluxRight - fluxLeft) - (2 * width) • slope)‖ ≤
        ratio / 2 * (B * width ^ 2) := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg hratioHalf]
    exact mul_le_mul_of_nonneg_left hflux hratioHalf
  calc
    ‖((1 / 2 : ℝ) • (left + right) - center) -
        (ratio / 2) •
          ((fluxRight - fluxLeft) - (2 * width) • slope) -
        (next - (center - (ratio * width) • slope))‖ ≤
      ‖(1 / 2 : ℝ) • (left + right) - center‖ +
        ‖(ratio / 2) •
          ((fluxRight - fluxLeft) - (2 * width) • slope)‖ +
        ‖next - (center - (ratio * width) • slope)‖ := by
      exact (norm_sub_le _ _).trans
        (add_le_add_left (norm_sub_le _ _) _)
    _ ≤ A * width ^ 2 + ratio / 2 * (B * width ^ 2) +
        T * width ^ 2 := by
      exact add_le_add (add_le_add hmean hmiddle) hnext
    _ = (A + ratio / 2 * B + T) * width ^ 2 := by ring

/-- The vector Taylor residual applies to the actual conservative
Lax–Friedrichs update identified with Eq. (4.20). -/
theorem leveque04_laxFriedrichs_equation20_vectorTaylorDefect
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ) (next slope : Fin m → ℝ)
    (i : ℤ) (ratio width A B T : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hmean : ‖(1 / 2 : ℝ) • (old (i - 1) + old (i + 1)) - old i‖ ≤
      A * width ^ 2)
    (hflux : ‖(flux (old (i + 1)) - flux (old (i - 1))) -
        (2 * width) • slope‖ ≤ B * width ^ 2)
    (hnext : ‖next - (old i - (ratio * width) • slope)‖ ≤
      T * width ^ 2) :
    ‖leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
        i - next‖ ≤
      (A + ratio / 2 * B + T) * width ^ 2 := by
  have hratioWidth : 0 < ratio * width := mul_pos hratio hwidth
  have hcoef : ratio * width / (2 * width) = ratio / 2 := by
    field_simp [ne_of_gt hwidth]
  have heq :
      leveque04_finiteVolumeUpdate (ratio * width) width old
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
          i =
        (1 / 2 : ℝ) • (old (i - 1) + old (i + 1)) -
          (ratio / 2) • (flux (old (i + 1)) - flux (old (i - 1))) := by
    funext k
    rw [leveque04_equation20 (ratio * width) width flux old i k
      hratioWidth hwidth]
    simp only [Pi.sub_apply, Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    rw [hcoef]
    ring
  rw [heq]
  exact leveque04_laxFriedrichs_vectorTaylorResidual
    (old (i - 1)) (old (i + 1)) (old i) next
    (flux (old (i - 1))) (flux (old (i + 1))) slope
    ratio width A B T hratio.le hmean hflux hnext

/-- Smooth exact vector cell averages and a smooth coupled physical flux
discharge the spatial defects in the actual Eq. (4.20) local update. -/
theorem leveque04_laxFriedrichs_vectorExactAverage_spatialTaylorDefect
    {m : ℕ} (profile profile' : ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (avg fluxSlope : ℝ → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ) (next : Fin m → ℝ)
    (i : ℤ) (center ratio width Kspace Kflux T : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (havg : ∀ c, avg c = oneDimensionalCellAverage profile
      (c - width / 2) (c + width / 2))
    (hleft : old (i - 1) = avg (center - width))
    (hcenter : old i = avg center)
    (hright : old (i + 1) = avg (center + width))
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofileLip : ∀ x y,
      ‖profile' x - profile' y‖ ≤ Kspace * |x - y|)
    (hfluxAlong : ∀ c,
      HasDerivAt (fun x => flux (avg x)) (fluxSlope c) c)
    (hfluxSlopeLip : ∀ x y,
      ‖fluxSlope x - fluxSlope y‖ ≤ Kflux * |x - y|)
    (hnext : ‖next -
        (old i - (ratio * width) • fluxSlope center)‖ ≤
      T * width ^ 2) :
    ‖leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
        i - next‖ ≤
      (Kspace + ratio * Kflux + T) * width ^ 2 := by
  have hmean0 := leveque04_laxFriedrichs_vectorExactCellAverage_neighborMean
    profile profile' Kspace center width hKspace hwidth
    hprofile hprofileLip
  have hmean :
      ‖(1 / 2 : ℝ) • (old (i - 1) + old (i + 1)) - old i‖ ≤
        Kspace * width ^ 2 := by
    rw [hleft, hright, hcenter]
    simpa only [havg] using hmean0
  have hflux0 := leveque04_laxFriedrichs_vectorCenteredDifference_error
    (fun x => flux (avg x)) fluxSlope Kflux center width
    hKflux hfluxAlong hfluxSlopeLip
  have hflux :
      ‖(flux (old (i + 1)) - flux (old (i - 1))) -
          (2 * width) • fluxSlope center‖ ≤
        (2 * Kflux) * width ^ 2 := by
    rw [hleft, hright]
    exact hflux0
  have hbound := leveque04_laxFriedrichs_equation20_vectorTaylorDefect
    flux old next (fluxSlope center) i ratio width
    Kspace (2 * Kflux) T hratio hwidth hmean hflux hnext
  convert hbound using 1 <;> ring

/-- Temporal Taylor control of a vector cell-average trajectory when
its initial time derivative is the negative spatial flux slope. -/
theorem leveque04_laxFriedrichs_vectorExactAverage_timeTaylorDefect
    {m : ℕ} (average averageTimeDerivative : ℝ → Fin m → ℝ)
    (fluxSlope : Fin m → ℝ)
    (time ratio width Ktime : ℝ) (hKtime : 0 ≤ Ktime)
    (haverage : ∀ τ,
      HasDerivAt average (averageTimeDerivative τ) τ)
    (hLip : ∀ s τ,
      ‖averageTimeDerivative s - averageTimeDerivative τ‖ ≤
        Ktime * |s - τ|)
    (hpde : averageTimeDerivative time = -fluxSlope) :
    ‖average (time + ratio * width) -
        (average time - (ratio * width) • fluxSlope)‖ ≤
      Ktime * (ratio * width) ^ 2 := by
  have h := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    average averageTimeDerivative Ktime time
    (time + ratio * width) hKtime haverage hLip
  have hid :
      average time + (time + ratio * width - time) •
          averageTimeDerivative time =
        average time - (ratio * width) • fluxSlope := by
    rw [hpde]
    module
  rw [hid] at h
  simpa only [add_sub_cancel_left] using h

/-- A first-order PDE slope mismatch still gives a quadratic next-cell
average defect at a fixed positive time-to-width ratio. -/
theorem leveque04_laxFriedrichs_vectorExactAverage_timeTaylorDefect_of_pdeError
    {m : ℕ} (average averageTimeDerivative : ℝ → Fin m → ℝ)
    (fluxSlope : Fin m → ℝ)
    (time ratio width Ktime P : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKtime : 0 ≤ Ktime)
    (haverage : ∀ τ,
      HasDerivAt average (averageTimeDerivative τ) τ)
    (hLip : ∀ s τ,
      ‖averageTimeDerivative s - averageTimeDerivative τ‖ ≤
        Ktime * |s - τ|)
    (hpdeError : ‖averageTimeDerivative time + fluxSlope‖ ≤
      P * width) :
    ‖average (time + ratio * width) -
        (average time - (ratio * width) • fluxSlope)‖ ≤
      (Ktime * ratio ^ 2 + ratio * P) * width ^ 2 := by
  have htaylor := vectorFirstOrderTaylorError_le_of_lipschitzDeriv
    average averageTimeDerivative Ktime time
    (time + ratio * width) hKtime haverage hLip
  have hid :
      average (time + ratio * width) -
          (average time - (ratio * width) • fluxSlope) =
        (average (time + ratio * width) -
            (average time + (ratio * width) •
              averageTimeDerivative time)) +
          (ratio * width) •
            (averageTimeDerivative time + fluxSlope) := by
    module
  rw [hid]
  have hstep : 0 ≤ ratio * width := (mul_pos hratio hwidth).le
  have hpdeScaled :
      ‖(ratio * width) •
          (averageTimeDerivative time + fluxSlope)‖ ≤
        (ratio * width) * (P * width) := by
    rw [norm_smul, Real.norm_eq_abs, abs_of_nonneg hstep]
    exact mul_le_mul_of_nonneg_left hpdeError hstep
  calc
    _ ≤ ‖average (time + ratio * width) -
          (average time + (ratio * width) •
            averageTimeDerivative time)‖ +
        ‖(ratio * width) •
          (averageTimeDerivative time + fluxSlope)‖ := norm_add_le _ _
    _ ≤ Ktime * (ratio * width) ^ 2 +
        (ratio * width) * (P * width) := by
      have htaylor' :
          ‖average (time + ratio * width) -
            (average time + (ratio * width) •
              averageTimeDerivative time)‖ ≤
            Ktime * (ratio * width) ^ 2 := by
        simpa only [add_sub_cancel_left] using htaylor
      exact add_le_add htaylor' hpdeScaled
    _ = (Ktime * ratio ^ 2 + ratio * P) * width ^ 2 := by ring

/-- Spatial exact-average smoothness, coupled-flux smoothness, and a
first-order PDE slope match yield a quadratic defect for the actual
Lax–Friedrichs step. -/
theorem leveque04_laxFriedrichs_vectorExactAverage_spaceTimeDefect
    {m : ℕ} (profile profile' : ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (avg fluxSlope timeAverage timeDerivative : ℝ → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ)
    (i : ℤ) (center time ratio width Kspace Kflux Ktime P : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime)
    (havg : ∀ c, avg c = oneDimensionalCellAverage profile
      (c - width / 2) (c + width / 2))
    (hleft : old (i - 1) = avg (center - width))
    (hcenter : old i = avg center)
    (hright : old (i + 1) = avg (center + width))
    (hprofile : ∀ x, HasDerivAt profile (profile' x) x)
    (hprofileLip : ∀ x y,
      ‖profile' x - profile' y‖ ≤ Kspace * |x - y|)
    (hfluxAlong : ∀ c,
      HasDerivAt (fun x => flux (avg x)) (fluxSlope c) c)
    (hfluxSlopeLip : ∀ x y,
      ‖fluxSlope x - fluxSlope y‖ ≤ Kflux * |x - y|)
    (hstart : timeAverage time = old i)
    (htimeDerivative : ∀ τ,
      HasDerivAt timeAverage (timeDerivative τ) τ)
    (htimeLip : ∀ s τ,
      ‖timeDerivative s - timeDerivative τ‖ ≤
        Ktime * |s - τ|)
    (hpdeError : ‖timeDerivative time + fluxSlope center‖ ≤
      P * width) :
    ‖leveque04_finiteVolumeUpdate (ratio * width) width old
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
        i - timeAverage (time + ratio * width)‖ ≤
      (Kspace + ratio * Kflux + Ktime * ratio ^ 2 + ratio * P) *
        width ^ 2 := by
  have hnext :=
    leveque04_laxFriedrichs_vectorExactAverage_timeTaylorDefect_of_pdeError
      timeAverage timeDerivative (fluxSlope center)
      time ratio width Ktime P hratio hwidth hKtime
      htimeDerivative htimeLip hpdeError
  rw [hstart] at hnext
  have hbound :=
    leveque04_laxFriedrichs_vectorExactAverage_spatialTaylorDefect
      profile profile' flux avg fluxSlope old
      (timeAverage (time + ratio * width)) i center ratio width
      Kspace Kflux (Ktime * ratio ^ 2 + ratio * P)
      hratio hwidth hKspace hKflux havg hleft hcenter hright
      hprofile hprofileLip hfluxAlong hfluxSlopeLip hnext
  convert hbound using 1 <;> ring

/-- A quadratic one-step defect becomes a first-order time-normalized
local residual when the time-to-width ratio is fixed and positive. -/
theorem leveque04_laxFriedrichs_vectorNormalizedResidual_of_quadraticDefect
    {m : ℕ} (flux : (Fin m → ℝ) → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ) (next : Fin m → ℝ)
    (i : ℤ) (ratio width C : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hdefect :
      ‖leveque04_finiteVolumeUpdate (ratio * width) width old
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
          i - next‖ ≤ C * width ^ 2) :
    ‖(ratio * width)⁻¹ •
        (leveque04_finiteVolumeUpdate (ratio * width) width old
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
          i - next)‖ ≤ (C / ratio) * width := by
  have hdt : 0 < ratio * width := mul_pos hratio hwidth
  rw [norm_smul, Real.norm_eq_abs, abs_inv, abs_of_pos hdt,
    inv_mul_eq_div]
  apply (div_le_iff₀ hdt).2
  calc
    _ ≤ C * width ^ 2 := hdefect
    _ = (C / ratio) * width * (ratio * width) := by
      field_simp [ne_of_gt hratio]

end NumStability
