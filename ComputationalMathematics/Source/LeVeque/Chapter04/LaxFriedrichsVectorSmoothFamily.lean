/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorSmoothExactAccuracy

/-!
# Uniform coupled-vector Lax–Friedrichs local accuracy

The exact-solution local estimate has one width-independent coefficient
when the spatial, temporal, flux, and face-proximity budgets are shared
by a changing mesh family.
-/

namespace NumStability

open MeasureTheory

theorem leveque04_laxFriedrichs_vectorSmoothExactSolution_familyLocalAccuracy
    {m : ℕ} (q qX : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (width : ℕ → ℝ)
    (avg fluxSlope : ℕ → ℝ → Fin m → ℝ)
    (old : ℕ → ℤ → Fin m → ℝ)
    (i : ℕ → ℤ) (center : ℕ → ℝ)
    (time ratio Kspace Kflux Ktime Kjac S : ℝ)
    (hratio : 0 < ratio) (hwidth : ∀ r, 0 < width r)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q flux)
    (havg : ∀ r c, avg r c = oneDimensionalCellAverage
      (fun x => q x time)
      (c - width r / 2) (c + width r / 2))
    (hfluxSlope : ∀ r c, fluxSlope r c =
      jacobian (avg r c)
        ((width r)⁻¹ •
          (q (c + width r / 2) time - q (c - width r / 2) time)))
    (hleft : ∀ r, old r (i r - 1) = avg r (center r - width r))
    (hcenter : ∀ r, old r (i r) = avg r (center r))
    (hright : ∀ r, old r (i r + 1) = avg r (center r + width r))
    (hprofile : ∀ x, HasDerivAt
      (fun y => q y time) (qX x time) x)
    (hprofileLip : ∀ x y,
      ‖qX x time - qX y time‖ ≤ Kspace * |x - y|)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hjacobianLip : ∀ u v,
      ‖jacobian u - jacobian v‖ ≤ Kjac * ‖u - v‖)
    (hfluxSlopeLip : ∀ r x y,
      ‖fluxSlope r x - fluxSlope r y‖ ≤ Kflux * |x - y|)
    (hfaceLeftClose : ∀ r,
      ‖q (center r - width r / 2) time - avg r (center r)‖ ≤
        S * width r)
    (hfaceRightClose : ∀ r,
      ‖q (center r + width r / 2) time - avg r (center r)‖ ≤
        S * width r)
    (hfluxTimeCont : ∀ r, Continuous (fun τ =>
      flux (q (center r - width r / 2) τ) -
        flux (q (center r + width r / 2) τ)))
    (haverageRateLip : ∀ r s τ,
      ‖(width r)⁻¹ •
          (flux (q (center r - width r / 2) s) -
            flux (q (center r + width r / 2) s)) -
        (width r)⁻¹ •
          (flux (q (center r - width r / 2) τ) -
            flux (q (center r + width r / 2) τ))‖ ≤
        Ktime * |s - τ|) :
    ∀ r,
      ‖(ratio * width r)⁻¹ •
          (leveque04_finiteVolumeUpdate (ratio * width r) (width r)
            (old r)
            (leveque04_localInterfaceFlux
              (leveque04_laxFriedrichsFlux
                (ratio * width r) (width r) flux) (old r))
            (i r) -
          oneDimensionalCellAverage
            (fun x => q x (time + ratio * width r))
            (center r - width r / 2)
            (center r + width r / 2))‖ ≤
        ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
            ratio * (2 * (Kjac * S ^ 2))) / ratio) * width r := by
  intro r
  exact leveque04_laxFriedrichs_vectorSmoothExactSolution_localAccuracy
    q qX flux jacobian (avg r) (fluxSlope r) (old r)
    (i r) (center r) time ratio (width r)
    Kspace Kflux Ktime Kjac S
    hratio (hwidth r) hKspace hKflux hKtime hKjac hS
    hq (havg r) (hfluxSlope r) (hleft r) (hcenter r) (hright r)
    hprofile hprofileLip hflux hjacobianLip
    (hfluxSlopeLip r) (hfaceLeftClose r) (hfaceRightClose r)
    (hfluxTimeCont r) (haverageRateLip r)

end NumStability
