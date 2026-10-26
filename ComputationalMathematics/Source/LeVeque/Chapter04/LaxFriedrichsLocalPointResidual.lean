/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalSymmetricTaylor
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorTaylorResidual

/-!
# Local smooth point-data residual for Lax–Friedrichs

The actual Eq. (4.20) update has a first-order time-normalized residual
from derivative budgets on its spatial stencil and forward time interval.
The physical flux can couple all vector components. Only the conservation
PDE slope identity at the evaluation point is needed.

The exact point-data convention is Eq. (8.1); the source explicitly permits
its use for these smooth finite-volume comparisons on printed page 140.
A separate smoothness-to-budget result supplies uniform local constants.
-/

namespace NumStability

theorem leveque04_laxFriedrichs_vectorLocalPointResidual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ)
    (qX fluxX qT : ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (old : ℤ → Fin m → ℝ) (i : ℤ)
    (center time ratio width Kspace Kflux Ktime : ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux) (hKtime : 0 ≤ Ktime)
    (hleft : old (i - 1) = q (center - width) time)
    (hcenter : old i = q center time)
    (hright : old (i + 1) = q (center + width) time)
    (hspaceDeriv : ∀ x ∈ Set.Icc (center - width) (center + width),
      HasDerivAt (fun y => q y time) (qX x) x)
    (hspaceVariation : ∀ x ∈ Set.Icc (center - width) (center + width),
      ‖qX x - qX center‖ ≤ Kspace * |x - center|)
    (hfluxDeriv : ∀ x ∈ Set.Icc (center - width) (center + width),
      HasDerivAt (fun y => flux (q y time)) (fluxX x) x)
    (hfluxVariation : ∀ x ∈ Set.Icc (center - width) (center + width),
      ‖fluxX x - fluxX center‖ ≤ Kflux * |x - center|)
    (htimeDeriv : ∀ τ ∈ Set.Icc time (time + ratio * width),
      HasDerivAt (fun s => q center s) (qT τ) τ)
    (htimeVariation : ∀ τ ∈ Set.Icc time (time + ratio * width),
      ‖qT τ - qT time‖ ≤ Ktime * |τ - time|)
    (hpde : qT time + fluxX center = 0) :
    ‖(ratio * width)⁻¹ •
        (leveque04_finiteVolumeUpdate (ratio * width) width old
          (leveque04_localInterfaceFlux
            (leveque04_laxFriedrichsFlux (ratio * width) width flux) old) i -
          q center (time + ratio * width))‖ ≤
      ((Kspace + ratio * Kflux + Ktime * ratio ^ 2) / ratio) * width := by
  have hspatial := local_firstOrderTaylor_symmetric_errors (fun x => q x time) qX
    Kspace center width hKspace hwidth.le hspaceDeriv hspaceVariation
  have hmean : ‖(1 / 2 : ℝ) • (old (i - 1) + old (i + 1)) - old i‖ ≤ Kspace * width ^ 2 := by
    simpa only [hleft, hcenter, hright] using hspatial.1
  have hfluxPair := local_firstOrderTaylor_symmetric_errors (fun x => flux (q x time)) fluxX
    Kflux center width hKflux hwidth.le hfluxDeriv hfluxVariation
  have hfluxError : ‖(flux (old (i + 1)) - flux (old (i - 1))) -
      (2 * width) • fluxX center‖ ≤ (2 * Kflux) * width ^ 2 := by
    simpa only [hleft, hright, mul_assoc] using hfluxPair.2
  have hdt : 0 < ratio * width := mul_pos hratio hwidth
  have htimeInterval : Set.uIcc time (time + ratio * width) = Set.Icc time (time + ratio * width) :=
    Set.uIcc_of_le (by linarith)
  have htaylor := norm_firstOrderTaylorError_le_of_local_deriv_variation (fun τ => q center τ) qT
    Ktime time (time + ratio * width) hKtime
    (fun τ hτ => htimeDeriv τ (by simpa only [htimeInterval] using hτ))
    (fun τ hτ => htimeVariation τ (by simpa only [htimeInterval] using hτ))
  have hqt : qT time = -fluxX center := eq_neg_of_add_eq_zero_left hpde
  have hnext : ‖q center (time + ratio * width) - (old i - (ratio * width) • fluxX center)‖ ≤
      (Ktime * ratio ^ 2) * width ^ 2 := by
    rw [hcenter]
    have htaylor' : ‖q center (time + ratio * width) -
        (q center time - (ratio * width) • fluxX center)‖ ≤ Ktime * (ratio * width) ^ 2 := by
      simpa only [add_sub_cancel_left, hqt, smul_neg, ← sub_eq_add_neg] using htaylor
    convert htaylor' using 1 <;> ring
  have hdefect := leveque04_laxFriedrichs_equation20_vectorTaylorDefect flux old
    (q center (time + ratio * width)) (fluxX center) i ratio width
    Kspace (2 * Kflux) (Ktime * ratio ^ 2) hratio hwidth hmean hfluxError hnext
  have hnormalized := leveque04_laxFriedrichs_vectorNormalizedResidual_of_quadraticDefect
    flux old (q center (time + ratio * width)) i ratio width
    (Kspace + ratio / 2 * (2 * Kflux) + Ktime * ratio ^ 2) hratio hwidth hdefect
  convert hnormalized using 1 <;> ring

end NumStability
