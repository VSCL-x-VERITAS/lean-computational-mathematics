/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.CompactCoordinateDerivativeBudgets
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsSmoothRectangle
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLocalPointResidual

/-!
# LeVeque: uniform regional Lax–Friedrichs consistency

The existing smooth physical rectangle conservation reference yields
a common normalized first-order defect bound on a compact evaluation
rectangle. An enclosing compact rectangle supplies common actual
derivative budgets. The existing vector LF residual estimate is reused,
and every stencil and forward time remains in the physical interior.
-/

namespace NumStability
open Set LocalConservationLaw LocalLinearAdvection

theorem leveque04_laxFriedrichs_smoothRectangleReference_regionalResidual
    {m : ℕ} (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H a b c d left right start finish ratio : ℝ)
    (_hhyperbolic : IsHyperbolicFluxOn flux states)
    (hq : SmoothReferenceOn q flux states L R H)
    (hflux : ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)
      (Function.uncurry (fun x τ => flux (q x τ))) (Icc L R ×ˢ Icc 0 H))
    (hLa : L < a) (hal : a < left) (_hlr : left ≤ right) (hrb : right < b)
    (hbR : b < R) (h0c : 0 < c) (hcs : c ≤ start) (_hsf : start ≤ finish)
    (hfd : finish < d) (hdH : d < H) (hratio : 0 < ratio) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ center ∈ Icc left right, ∀ time ∈ Icc start finish,
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
  have hbox : Icc a b ×ˢ Icc c d ⊆ Ioo L R ×ˢ Ioo 0 H := by
    intro p hp
    exact ⟨⟨by linarith [hp.1.1], by linarith [hp.1.2]⟩,
      ⟨by linarith [hp.2.1], by linarith [hp.2.2]⟩⟩
  obtain ⟨Ks,Kt,hKs,hKt⟩ := contDiffOn_two_exists_compact_coordinate_derivative_budgets
    q (Ioo L R) (Ioo 0 H) a b c d isOpen_Ioo isOpen_Ioo
    (hs.of_le (m := 2) (WithTop.coe_le_coe.mpr (le_top : (2 : ℕ∞) ≤ ⊤))) hbox
  obtain ⟨Kf,_,hKf,_⟩ := contDiffOn_two_exists_compact_coordinate_derivative_budgets
    (fun x τ => flux (q x τ)) (Ioo L R) (Ioo 0 H) a b c d isOpen_Ioo isOpen_Ioo
    (hf.of_le (m := 2) (WithTop.coe_le_coe.mpr (le_top : (2 : ℕ∞) ≤ ⊤))) hbox
  let threshold := min (left - a) (min (b - right) ((d - finish) / ratio))
  have hthreshold : 0 < threshold := by
    exact lt_min (sub_pos.mpr hal) (lt_min (sub_pos.mpr hrb) (div_pos (sub_pos.mpr hfd) hratio))
  let C : ℝ := ((Ks : ℝ) + ratio * Kf + Kt * ratio ^ 2) / ratio
  have hC : 0 ≤ C := by
    dsimp [C]
    positivity
  refine ⟨threshold,C,hthreshold,hC,?_⟩
  intro center hx time ht width hw hwt
  have hwa : width < left - a := lt_of_lt_of_le hwt (min_le_left _ _)
  have hwb : width < b - right := lt_of_lt_of_le hwt
    (le_trans (min_le_right _ _) (min_le_left _ _))
  have hwd : ratio * width < d - finish := by
    have h := lt_of_lt_of_le hwt (le_trans (min_le_right _ _) (min_le_right _ _))
    simpa only [mul_comm] using (lt_div_iff₀ hratio).mp h
  have hslice (x : ℝ) (h : x ∈ Icc (center - width) (center + width)) :
      (x,time) ∈ Icc a b ×ˢ Icc c d := by
    exact ⟨⟨by linarith [h.1,hx.1],by linarith [h.2,hx.2]⟩,
      ⟨by linarith [ht.1],by linarith [ht.2]⟩⟩
  have hcenter : (center,time) ∈ Icc a b ×ˢ Icc c d :=
    hslice center ⟨by linarith,by linarith⟩
  have htimeslice (τ : ℝ) (h : τ ∈ Icc time (time + ratio * width)) :
      (center,τ) ∈ Icc a b ×ˢ Icc c d := by
    exact ⟨hcenter.1,⟨by linarith [h.1,ht.1],by linarith [h.2,ht.2]⟩⟩
  have hleft := hbox (hslice (center-width) ⟨le_rfl,by linarith⟩)
  have hright := hbox (hslice (center+width) ⟨by linarith,le_rfl⟩)
  have hforward := hbox (htimeslice (time+ratio*width) ⟨by linarith [mul_pos hratio hw],le_rfl⟩)
  refine ⟨hleft.1,hright.1,hforward.2,?_⟩
  intro old i holdleft holdcenter holdright
  apply leveque04_laxFriedrichs_vectorLocalPointResidual q
    (fun x => qx q x time) (fun x => qx (fun y τ => flux (q y τ)) x time)
    (qt q center) flux old i center time ratio width Ks Kf Kt
    hratio hw Ks.coe_nonneg Kf.coe_nonneg Kt.coe_nonneg holdleft holdcenter holdright
  · intro x hx'
    exact partial_space (interior_differentiableAt hs (hbox (hslice x hx')).1
      (hbox (hslice x hx')).2)
  · intro x hx'
    simpa [Function.uncurry_apply_pair,Prod.norm_def,Real.norm_eq_abs] using
      hKs.norm_sub_le (hslice x hx') hcenter
  · intro x hx'
    exact partial_space (interior_differentiableAt hf (hbox (hslice x hx')).1
      (hbox (hslice x hx')).2)
  · intro x hx'
    simpa [Function.uncurry_apply_pair,Prod.norm_def,Real.norm_eq_abs] using
      hKf.norm_sub_le (hslice x hx') hcenter
  · intro τ hτ
    exact partial_time (interior_differentiableAt hs (hbox (htimeslice τ hτ)).1
      (hbox (htimeslice τ hτ)).2)
  · intro τ hτ
    simpa [Function.uncurry_apply_pair,Prod.norm_def,Real.norm_eq_abs] using
      hKt.norm_sub_le (htimeslice τ hτ) hcenter
  · exact smoothReference_interior_classical hq hflux (hbox hcenter).1 (hbox hcenter).2

end NumStability
