/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLocalSmoothConsistency

/-!
# LeVeque: local accuracy on smooth exact hyperbolic solutions

The source domain consists of smooth exact solutions on an open physical
space-time region, with the flux hyperbolic on their admissible states.
The existing local coupled-vector consistency theorem supplies first-order
normalized error. The mesh threshold also keeps all three spatial samples
and the forward exact time inside the region. Hyperbolicity classifies
the source equation; the local Taylor estimate needs only smoothness
and the exact conservation PDE.
-/

namespace NumStability

theorem leveque04_laxFriedrichs_localHyperbolicSolution_pointResidual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (spaceRegion timeRegion : Set ℝ)
    (hhyperbolic : IsHyperbolicFluxOn flux states)
    (hvalues : ∀ x ∈ spaceRegion, ∀ τ ∈ timeRegion, q x τ ∈ states)
    (hspaceOpen : IsOpen spaceRegion) (htimeOpen : IsOpen timeRegion)
    (hspace : ∀ τ ∈ timeRegion, ContDiffOn ℝ 2 (fun x => q x τ) spaceRegion)
    (hflux : ∀ τ ∈ timeRegion, ContDiffOn ℝ 2 (fun x => flux (q x τ)) spaceRegion)
    (htime : ∀ x ∈ spaceRegion, ContDiffOn ℝ 2 (fun τ => q x τ) timeRegion)
    (hpde : ∀ x ∈ spaceRegion, ∀ τ ∈ timeRegion,
      deriv (fun σ => q x σ) τ + deriv (fun y => flux (q y τ)) x = 0)
    (center time ratio : ℝ) (hcenter : center ∈ spaceRegion) (ht : time ∈ timeRegion)
    (hratio : 0 < ratio) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ width : ℝ, 0 < width → width < threshold →
        center - width ∈ spaceRegion ∧ center + width ∈ spaceRegion ∧
        time + ratio * width ∈ timeRegion ∧
        ∀ (old : ℤ → Fin m → ℝ) (i : ℤ),
          old (i - 1) = q (center - width) time →
          old i = q center time → old (i + 1) = q (center + width) time →
          ‖(ratio * width)⁻¹ •
              (leveque04_finiteVolumeUpdate (ratio * width) width old
                (leveque04_localInterfaceFlux
                  (leveque04_laxFriedrichsFlux (ratio * width) width flux) old) i -
                q center (time + ratio * width))‖ ≤ C * width := by
  obtain ⟨threshold, C, hthreshold, hC, hb⟩ :=
    leveque04_laxFriedrichs_vectorLocalSmoothPointResidual q flux center time ratio hratio
      ((hspace time ht).contDiffAt (hspaceOpen.mem_nhds hcenter))
      ((hflux time ht).contDiffAt (hspaceOpen.mem_nhds hcenter))
      ((htime center hcenter).contDiffAt (htimeOpen.mem_nhds ht))
      (hpde center hcenter time ht)
  obtain ⟨rs, hrs, hBs⟩ := Metric.mem_nhds_iff.mp (hspaceOpen.mem_nhds hcenter)
  obtain ⟨rt, hrt, hBt⟩ := Metric.mem_nhds_iff.mp (htimeOpen.mem_nhds ht)
  refine ⟨min threshold (min rs (rt / ratio)), C,
    lt_min hthreshold (lt_min hrs (div_pos hrt hratio)), hC, ?_⟩
  intro width hw hsmall
  have hws : width < rs := hsmall.trans_le ((min_le_right _ _).trans (min_le_left _ _))
  have hwt : width < rt / ratio := hsmall.trans_le ((min_le_right _ _).trans (min_le_right _ _))
  have hdt : ratio * width < rt := by
    simpa only [mul_comm] using (lt_div_iff₀ hratio).mp hwt
  refine ⟨hBs ?_, hBs ?_, hBt ?_, hb width hw (hsmall.trans_le (min_le_left _ _))⟩
  · rw [Metric.mem_ball, Real.dist_eq]
    have hdiff : center - width - center = -width := by ring
    simpa only [hdiff, abs_neg, abs_of_pos hw] using hws
  · rw [Metric.mem_ball, Real.dist_eq]
    simpa only [add_sub_cancel_left, abs_of_pos hw] using hws
  · rw [Metric.mem_ball, Real.dist_eq]
    simpa only [add_sub_cancel_left, abs_of_pos (mul_pos hratio hw)] using hdt

end NumStability
