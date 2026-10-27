/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.LocalDerivativeVariation
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLocalPointResidual

/-!
# Local smooth consistency of the coupled-vector Lax–Friedrichs step

Twice continuous differentiability of the state and physical flux profiles
at the evaluation point supplies one positive mesh threshold and one
first-order residual constant. The theorem applies to every smaller
positive width with the fixed positive time-to-width ratio.

The actual Eq. (4.20) update uses exact point data as in Eq. (8.1), which the
source permits for these smooth finite-volume comparisons. The conservation
PDE slope identity is evaluated at the same point and time.
-/

namespace NumStability

theorem leveque04_laxFriedrichs_vectorLocalSmoothPointResidual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (center time ratio : ℝ) (hratio : 0 < ratio)
    (hspace : ContDiffAt ℝ 2 (fun x => q x time) center)
    (hflux : ContDiffAt ℝ 2 (fun x => flux (q x time)) center)
    (htime : ContDiffAt ℝ 2 (fun τ => q center τ) time)
    (hpde : deriv (fun τ => q center τ) time + deriv (fun x => flux (q x time)) center = 0) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ width : ℝ, 0 < width → width < threshold →
        ∀ (old : ℤ → Fin m → ℝ) (i : ℤ),
          old (i - 1) = q (center - width) time →
          old i = q center time → old (i + 1) = q (center + width) time →
          ‖(ratio * width)⁻¹ •
              (leveque04_finiteVolumeUpdate (ratio * width) width old
                (leveque04_localInterfaceFlux
                  (leveque04_laxFriedrichsFlux (ratio * width) width flux) old) i -
                q center (time + ratio * width))‖ ≤ C * width := by
  obtain ⟨rs, Ks, hrs, hKs, hBs⟩ := contDiffAt_two_exists_local_deriv_variation (fun x => q x time) center hspace
  obtain ⟨rf, Kf, hrf, hKf, hBf⟩ := contDiffAt_two_exists_local_deriv_variation (fun x => flux (q x time)) center hflux
  obtain ⟨rt, Kt, hrt, hKt, hBt⟩ := contDiffAt_two_exists_local_deriv_variation (fun τ => q center τ) time htime
  let threshold := min rs (min rf (rt / ratio))
  let C := (Ks + ratio * Kf + Kt * ratio ^ 2) / ratio
  have hthreshold : 0 < threshold := lt_min hrs (lt_min hrf (div_pos hrt hratio))
  have hC : 0 ≤ C := by dsimp [C]; positivity
  refine ⟨threshold, C, hthreshold, hC, ?_⟩
  intro width hwidth hsmall old i hleft hcenter hright
  have hws : width < rs := hsmall.trans_le (min_le_left _ _)
  have hwf : width < rf := hsmall.trans_le ((min_le_right _ _).trans (min_le_left _ _))
  have hwt : width < rt / ratio := hsmall.trans_le ((min_le_right _ _).trans (min_le_right _ _))
  have hdt : ratio * width < rt := by simpa only [mul_comm ratio width] using (lt_div_iff₀ hratio).mp hwt
  have hspaceInside (x : ℝ) (hx : x ∈ Set.Icc (center - width) (center + width)) :
      x ∈ Set.Icc (center - rs) (center + rs) := ⟨by linarith [hx.1], by linarith [hx.2]⟩
  have hfluxInside (x : ℝ) (hx : x ∈ Set.Icc (center - width) (center + width)) :
      x ∈ Set.Icc (center - rf) (center + rf) := ⟨by linarith [hx.1], by linarith [hx.2]⟩
  have htimeInside (τ : ℝ) (hτ : τ ∈ Set.Icc time (time + ratio * width)) :
      τ ∈ Set.Icc (time - rt) (time + rt) := ⟨by linarith [hτ.1], by linarith [hτ.2]⟩
  exact leveque04_laxFriedrichs_vectorLocalPointResidual q
    (deriv (fun x => q x time)) (deriv (fun x => flux (q x time))) (deriv (fun τ => q center τ))
    flux old i center time ratio width Ks Kf Kt hratio hwidth hKs hKf hKt hleft hcenter hright
    (fun x hx => (hBs x (hspaceInside x hx)).1)
    (fun x hx => (hBs x (hspaceInside x hx)).2)
    (fun x hx => (hBf x (hfluxInside x hx)).1)
    (fun x hx => (hBf x (hfluxInside x hx)).2)
    (fun τ hτ => (hBt τ (htimeInside τ hτ)).1)
    (fun τ hτ => (hBt τ (htimeInside τ hτ)).2) hpde

end NumStability
