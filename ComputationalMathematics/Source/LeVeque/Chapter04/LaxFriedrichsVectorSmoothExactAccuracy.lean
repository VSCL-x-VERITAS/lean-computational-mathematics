/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorFluxSecant

/-!
# Smooth coupled-vector Lax–Friedrichs local accuracy

The actual Eq. (4.20) update has first-order normalized local error on
exact vector cell averages of a rectangle-conserving smooth solution.
The regularity budgets are uniform across the neighboring cells and
the current forward time step.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_laxFriedrichs_vectorSmoothExactSolution_localAccuracy
    {m : ℕ} (q qX : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (avg fluxSlope : ℝ → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ)
    (i : ℤ) (center time ratio width Kspace Kflux Ktime Kjac S : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q flux)
    (havg : ∀ c, avg c = oneDimensionalCellAverage
      (fun x => q x time) (c - width / 2) (c + width / 2))
    (hfluxSlope : ∀ c, fluxSlope c =
      jacobian (avg c)
        (width⁻¹ •
          (q (c + width / 2) time - q (c - width / 2) time)))
    (hleft : old (i - 1) = avg (center - width))
    (hcenter : old i = avg center)
    (hright : old (i + 1) = avg (center + width))
    (hprofile : ∀ x, HasDerivAt
      (fun y => q y time) (qX x time) x)
    (hprofileLip : ∀ x y,
      ‖qX x time - qX y time‖ ≤ Kspace * |x - y|)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hjacobianLip : ∀ u v,
      ‖jacobian u - jacobian v‖ ≤ Kjac * ‖u - v‖)
    (hfluxSlopeLip : ∀ x y,
      ‖fluxSlope x - fluxSlope y‖ ≤ Kflux * |x - y|)
    (hfaceLeftClose :
      ‖q (center - width / 2) time - avg center‖ ≤ S * width)
    (hfaceRightClose :
      ‖q (center + width / 2) time - avg center‖ ≤ S * width)
    (hfluxTimeCont : Continuous (fun τ =>
      flux (q (center - width / 2) τ) -
        flux (q (center + width / 2) τ)))
    (haverageRateLip : ∀ s τ,
      ‖width⁻¹ •
          (flux (q (center - width / 2) s) -
            flux (q (center + width / 2) s)) -
        width⁻¹ •
          (flux (q (center - width / 2) τ) -
            flux (q (center + width / 2) τ))‖ ≤
        Ktime * |s - τ|) :
    ‖(ratio * width)⁻¹ •
        (leveque04_finiteVolumeUpdate (ratio * width) width old
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width flux) old)
          i -
        oneDimensionalCellAverage
          (fun x => q x (time + ratio * width))
          (center - width / 2) (center + width / 2))‖ ≤
      ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
          ratio * (2 * (Kjac * S ^ 2))) / ratio) * width := by
  let a := center - width / 2
  let b := center + width / 2
  let timeAverage : ℝ → Fin m → ℝ :=
    fun τ => oneDimensionalCellAverage (fun x => q x τ) a b
  let timeDerivative : ℝ → Fin m → ℝ :=
    fun τ => width⁻¹ • (flux (q a τ) - flux (q b τ))
  have hspan : b - a = width := by dsimp [a, b]; ring
  have hprofileCont : Continuous (fun x => q x time) :=
    continuous_iff_continuousAt.mpr
      (fun x => (hprofile x).continuousAt)
  have hAvgDerivative (c : ℝ) :
      HasDerivAt avg
        (width⁻¹ •
          (q (c + width / 2) time - q (c - width / 2) time)) c := by
    have heq : avg = fun d => oneDimensionalCellAverage
        (fun x => q x time) (d - width / 2) (d + width / 2) := by
      funext d
      exact havg d
    rw [heq]
    exact leveque04_laxFriedrichs_vectorExactCellAverage_hasDerivAt_center
      (fun x => q x time) c width hprofileCont hwidth
  have hFluxAlong (c : ℝ) :
      HasDerivAt (fun x => flux (avg x)) (fluxSlope c) c := by
    rw [hfluxSlope c]
    exact (hflux (avg c)).comp_hasDerivAt c (hAvgDerivative c)
  have hTimeDerivative (τ : ℝ) :
      HasDerivAt timeAverage (timeDerivative τ) τ := by
    simpa only [timeAverage, timeDerivative, hspan] using
      (hq.hasDerivAt_cellAverage_of_continuous_flux
        a b τ (by simpa only [a, b] using hfluxTimeCont))
  have hPdeRaw :=
    leveque04_laxFriedrichs_vectorCellAverage_pdeSlope_of_lipschitzJacobian
      q flux jacobian (avg center) a b time Kjac S
      (by rw [hspan]; exact hwidth) hKjac hS hq
      (by simpa only [a, b] using hfluxTimeCont)
      (by simpa only [a, b] using havg center)
      hflux hjacobianLip
      (by simpa only [a, hspan] using hfaceLeftClose)
      (by simpa only [b, hspan] using hfaceRightClose)
  have hPde :
      ‖timeDerivative time + fluxSlope center‖ ≤
        (2 * (Kjac * S ^ 2)) * width := by
    simpa only [timeDerivative, hspan, hfluxSlope center, a, b] using
      hPdeRaw.2
  have hstart : timeAverage time = old i := by
    simpa only [timeAverage, a, b] using (havg center).symm.trans hcenter.symm
  have hspaceTime :=
    leveque04_laxFriedrichs_vectorExactAverage_spaceTimeDefect
      (fun x => q x time) (fun x => qX x time)
      flux avg fluxSlope timeAverage timeDerivative old
      i center time ratio width Kspace Kflux Ktime
      (2 * (Kjac * S ^ 2))
      hratio hwidth hKspace hKflux hKtime havg
      hleft hcenter hright hprofile hprofileLip
      hFluxAlong hfluxSlopeLip hstart hTimeDerivative
      haverageRateLip hPde
  have hnormalized :=
    leveque04_laxFriedrichs_vectorNormalizedResidual_of_quadraticDefect
      flux old (timeAverage (time + ratio * width)) i ratio width
      (Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
        ratio * (2 * (Kjac * S ^ 2)))
      hratio hwidth hspaceTime
  simpa only [timeAverage, a, b] using hnormalized

end NumStability
