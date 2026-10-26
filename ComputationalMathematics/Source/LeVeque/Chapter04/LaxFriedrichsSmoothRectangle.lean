/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VectorSectionBalance
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLocalHyperbolicSolution

/-!
# LeVeque: local Lax–Friedrichs accuracy from integral conservation

The existing smooth physical rectangle reference supplies the exact
conservation law. The resolved general-flux bridge derives the classical
PDE, which feeds the existing local consistency estimate. The resulting
mesh threshold keeps both spatial neighbors and the exact forward time
in the interior physical box. Hyperbolicity uses the existing state class.
-/

namespace NumStability
open Set LocalConservationLaw LocalLinearAdvection

theorem leveque04_laxFriedrichs_smoothRectangleReference_pointResidual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H center time ratio : ℝ)
    (hhyperbolic : IsHyperbolicFluxOn flux states)
    (hq : SmoothReferenceOn q flux states L R H)
    (hflux : ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)
      (Function.uncurry (fun x τ => flux (q x τ))) (Icc L R ×ˢ Icc 0 H))
    (hcenter : center ∈ Ioo L R) (ht : time ∈ Ioo 0 H) (hratio : 0 < ratio) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ width : ℝ, 0 < width → width < threshold →
        center - width ∈ Ioo L R ∧ center + width ∈ Ioo L R ∧
        time + ratio * width ∈ Ioo 0 H ∧
        ∀ (old : ℤ → Fin m → ℝ) (i : ℤ),
          old (i - 1) = q (center - width) time →
          old i = q center time → old (i + 1) = q (center + width) time →
          ‖(ratio * width)⁻¹ •
              (leveque04_finiteVolumeUpdate (ratio * width) width old
                (leveque04_localInterfaceFlux
                  (leveque04_laxFriedrichsFlux (ratio * width) width flux) old) i -
                q center (time + ratio * width))‖ ≤ C * width := by
  have hs := hq.1.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hf := hflux.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  apply leveque04_laxFriedrichs_localHyperbolicSolution_pointResidual
    q flux states (Ioo L R) (Ioo 0 H) hhyperbolic
    (fun x hx τ hτ => hq.2.2 x (Ioo_subset_Icc_self hx) τ (Ioo_subset_Icc_self hτ))
    isOpen_Ioo isOpen_Ioo
  · intro τ hτ
    exact (hq.1.of_le (m := 2) (by exact WithTop.coe_le_coe.mpr (le_top : (2 : ℕ∞) ≤ ⊤))).comp (contDiffOn_id.prodMk contDiffOn_const)
      (fun _ hx => ⟨Ioo_subset_Icc_self hx, Ioo_subset_Icc_self hτ⟩)
  · intro τ hτ
    exact (hflux.of_le (m := 2) (by exact WithTop.coe_le_coe.mpr (le_top : (2 : ℕ∞) ≤ ⊤))).comp (contDiffOn_id.prodMk contDiffOn_const)
      (fun _ hx => ⟨Ioo_subset_Icc_self hx, Ioo_subset_Icc_self hτ⟩)
  · intro x hx
    exact (hq.1.of_le (m := 2) (by exact WithTop.coe_le_coe.mpr (le_top : (2 : ℕ∞) ≤ ⊤))).comp (contDiffOn_const.prodMk contDiffOn_id)
      (fun _ hτ => ⟨Ioo_subset_Icc_self hx, Ioo_subset_Icc_self hτ⟩)
  · intro x hx τ hτ
    rw [(partial_time (interior_differentiableAt hs hx hτ)).deriv,
      (partial_space (interior_differentiableAt hf hx hτ)).deriv]
    exact smoothReference_interior_classical hq hflux hx hτ
  · exact hcenter
  · exact ht
  · exact hratio

end NumStability
