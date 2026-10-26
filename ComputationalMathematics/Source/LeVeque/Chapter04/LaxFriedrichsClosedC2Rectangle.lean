/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.ClosedInteriorDerivativeBudgets
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.C2RectangleReference
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLocalHyperbolicSolution
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsLocalPointResidual

/-!
# LeVeque: actual Lax–Friedrichs residual including initial time

The actual closed physical C2 conservation reference derives the
interior PDE and common derivative budgets valid arbitrarily near
initial time. The existing actual LF point estimate yields a uniform
positive-time residual. Continuity of the actual stencil and forward
field extends this same bound to the initial step at time zero.
No outside-time extension or boundary total derivative is assumed.
-/

namespace NumStability
open Set LocalConservationLaw LocalLinearAdvection

theorem leveque04_laxFriedrichs_c2RectangleReference_positiveTimeUniformResidual
    {m : ℕ} [NeZero m] (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H a b d left right finish ratio : ℝ)
    (_hhyperbolic : IsHyperbolicFluxOn flux states)
    (hreference : RectangleReferenceOn q flux L R H)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 H))
    (_hstates : ∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 H, q x τ ∈ states)
    (hflux : ContDiffOn ℝ 2
      (Function.uncurry (fun x τ => flux (q x τ))) (Icc L R ×ˢ Icc 0 H))
    (hLa : L < a) (hal : a < left) (_hlr : left ≤ right) (hrb : right < b)
    (hbR : b < R) (h0f : 0 < finish)
    (hfd : finish < d) (hdH : d < H) (hratio : 0 < ratio) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ center ∈ Icc left right, ∀ time ∈ Ioc 0 finish,
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
  have hs := hq.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hf := hflux.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hdq (y τ : ℝ) (hy : y ∈ Ioo L R) (hτ : τ ∈ Ioo 0 H) :
      DifferentiableAt ℝ (Function.uncurry q) (y,τ) :=
    ((hs.of_le (m := 1) (by norm_num)).differentiableOn_one _ ⟨hy,hτ⟩).differentiableAt
      (prod_mem_nhds (Ioo_mem_nhds hy.1 hy.2) (Ioo_mem_nhds hτ.1 hτ.2))
  have hdf (y τ : ℝ) (hy : y ∈ Ioo L R) (hτ : τ ∈ Ioo 0 H) :
      DifferentiableAt ℝ (Function.uncurry (fun x σ => flux (q x σ))) (y,τ) :=
    ((hf.of_le (m := 1) (by norm_num)).differentiableOn_one _ ⟨hy,hτ⟩).differentiableAt
      (prod_mem_nhds (Ioo_mem_nhds hy.1 hy.2) (Ioo_mem_nhds hτ.1 hτ.2))
  have hbox : Icc a b ×ˢ Ioc 0 d ⊆ Ioo L R ×ˢ Ioo 0 H := by
    intro p hp
    exact ⟨⟨by linarith [hp.1.1], by linarith [hp.1.2]⟩,
      ⟨hp.2.1, by linarith [hp.2.2]⟩⟩
  have hLR : L < R := by linarith
  have h0H : 0 < H := by linarith
  obtain ⟨Ks,hKs,hKt⟩ :=
    contDiffOn_two_closedRectangle_exists_interior_coordinate_derivative_budgets
      q L R 0 H hLR h0H hq
  obtain ⟨Kf,hKf,_⟩ :=
    contDiffOn_two_closedRectangle_exists_interior_coordinate_derivative_budgets
      (fun x τ => flux (q x τ)) L R 0 H hLR h0H hflux
  let threshold := min (left - a) (min (b - right) ((d - finish) / ratio))
  have hthreshold : 0 < threshold := by
    exact lt_min (sub_pos.mpr hal) (lt_min (sub_pos.mpr hrb) (div_pos (sub_pos.mpr hfd) hratio))
  let C : ℝ := ((Ks : ℝ) + ratio * Kf + Ks * ratio ^ 2) / ratio
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
      (x,time) ∈ Icc a b ×ˢ Ioc 0 d := by
    exact ⟨⟨by linarith [h.1,hx.1],by linarith [h.2,hx.2]⟩,
      ⟨ht.1,by linarith [ht.2]⟩⟩
  have hcenter : (center,time) ∈ Icc a b ×ˢ Ioc 0 d :=
    hslice center ⟨by linarith,by linarith⟩
  have htimeslice (τ : ℝ) (h : τ ∈ Icc time (time + ratio * width)) :
      (center,τ) ∈ Icc a b ×ˢ Ioc 0 d := by
    exact ⟨hcenter.1,⟨by linarith [h.1,ht.1],by linarith [h.2,ht.2]⟩⟩
  have hleft := hbox (hslice (center-width) ⟨le_rfl,by linarith⟩)
  have hright := hbox (hslice (center+width) ⟨by linarith,le_rfl⟩)
  have hforward := hbox (htimeslice (time+ratio*width) ⟨by linarith [mul_pos hratio hw],le_rfl⟩)
  refine ⟨hleft.1,hright.1,hforward.2,?_⟩
  intro old i holdleft holdcenter holdright
  apply leveque04_laxFriedrichs_vectorLocalPointResidual q
    (fun x => qx q x time) (fun x => qx (fun y τ => flux (q y τ)) x time)
    (qt q center) flux old i center time ratio width Ks Kf Ks
    hratio hw Ks.coe_nonneg Kf.coe_nonneg Ks.coe_nonneg holdleft holdcenter holdright
  · intro x hx'
    exact partial_space (hdq x time (hbox (hslice x hx')).1
      (hbox (hslice x hx')).2)
  · intro x hx'
    simpa [Function.uncurry_apply_pair,Prod.norm_def,Real.norm_eq_abs] using
      hKs.norm_sub_le (hbox (hslice x hx')) (hbox hcenter)
  · intro x hx'
    exact partial_space (hdf x time (hbox (hslice x hx')).1
      (hbox (hslice x hx')).2)
  · intro x hx'
    simpa [Function.uncurry_apply_pair,Prod.norm_def,Real.norm_eq_abs] using
      hKf.norm_sub_le (hbox (hslice x hx')) (hbox hcenter)
  · intro τ hτ
    exact partial_time (hdq center τ (hbox (htimeslice τ hτ)).1
      (hbox (htimeslice τ hτ)).2)
  · intro τ hτ
    simpa [Function.uncurry_apply_pair,Prod.norm_def,Real.norm_eq_abs] using
      hKt.norm_sub_le (hbox (htimeslice τ hτ)) (hbox hcenter)
  · exact rectangleReference_contDiffOn_two_interior_classical hreference hq hflux (hbox hcenter).1 (hbox hcenter).2


theorem leveque04_laxFriedrichs_c2RectangleReference_closedTimeRegionalResidual
    {m : ℕ} [NeZero m] (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H a b d left right finish ratio : ℝ)
    (_hhyperbolic : IsHyperbolicFluxOn flux states)
    (hreference : RectangleReferenceOn q flux L R H)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 H))
    (_hstates : ∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 H, q x τ ∈ states)
    (hflux : ContDiffOn ℝ 2
      (Function.uncurry (fun x τ => flux (q x τ))) (Icc L R ×ˢ Icc 0 H))
    (hLa : L < a) (hal : a < left) (_hlr : left ≤ right) (hrb : right < b)
    (hbR : b < R) (h0f : 0 < finish)
    (hfd : finish < d) (hdH : d < H) (hratio : 0 < ratio) :
    ∃ threshold C : ℝ, 0 < threshold ∧ 0 ≤ C ∧
      ∀ center ∈ Icc left right, ∀ time ∈ Icc 0 finish,
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
  obtain ⟨threshold,C,hthreshold,hC,hbound⟩ :=
    leveque04_laxFriedrichs_c2RectangleReference_positiveTimeUniformResidual
      q flux states L R H a b d left right finish ratio _hhyperbolic
      hreference hq _hstates hflux hLa hal _hlr hrb hbR h0f hfd hdH hratio
  refine ⟨threshold,C,hthreshold,hC,?_⟩
  intro center hx time ht width hw hsmall
  by_cases hpos : 0 < time
  · exact hbound center hx time ⟨hpos,ht.2⟩ width hw hsmall
  · have hzero : time = 0 := le_antisymm (le_of_not_gt hpos) ht.1
    subst time
    obtain ⟨hleft,hright,hfinish,_⟩ :=
      hbound center hx finish ⟨h0f,le_rfl⟩ width hw hsmall
    have hcenter : center ∈ Ioo L R := by
      constructor <;> linarith [hx.1,hx.2]
    have hdt : 0 < ratio*width := mul_pos hratio hw
    refine ⟨hleft,hright,⟨by simpa using hdt,by linarith [hfinish.2]⟩,?_⟩
    intro old i holdleft holdcenter holdright
    let update := fun τ => (1/2 : ℝ) • (q (center-width) τ+q (center+width) τ) -
      (ratio/2) • (flux (q (center+width) τ)-flux (q (center-width) τ))
    let residual := fun τ => ‖(ratio*width)⁻¹ • (update τ-q center (τ+ratio*width))‖
    have hupdate (τ : ℝ) (old : ℤ → Fin m → ℝ) (i : ℤ)
        (hl : old (i-1) = q (center-width) τ) (hr : old (i+1) = q (center+width) τ) :
        leveque04_finiteVolumeUpdate (ratio*width) width old
          (leveque04_localInterfaceFlux (leveque04_laxFriedrichsFlux (ratio*width) width flux) old) i =
            update τ := by
      funext p
      rw [leveque04_equation20 (ratio*width) width flux old i p hdt hw,hl,hr]
      dsimp [update]
      have hcoef : ratio*width/(2*width) = ratio/2 := by field_simp [hw.ne']
      rw [hcoef]
      ring
    have hc (x : ℝ) (hphysical : x ∈ Icc L R) :
        ContinuousOn (fun τ => q x τ) (Icc 0 finish) :=
      hq.continuousOn.comp (continuous_const.prodMk continuous_id).continuousOn
        (fun τ hτ => ⟨hphysical,hτ.1,by change τ ≤ H;linarith [hτ.2]⟩)
    have hf (x : ℝ) (hphysical : x ∈ Icc L R) :
        ContinuousOn (fun τ => flux (q x τ)) (Icc 0 finish) :=
      hflux.continuousOn.comp (continuous_const.prodMk continuous_id).continuousOn
        (fun τ hτ => ⟨hphysical,hτ.1,by change τ ≤ H;linarith [hτ.2]⟩)
    have hforward : ContinuousOn (fun τ => q center (τ+ratio*width)) (Icc 0 finish) :=
      hq.continuousOn.comp
        (continuous_const.prodMk (continuous_id.add continuous_const)).continuousOn
        (fun τ hτ => ⟨Ioo_subset_Icc_self hcenter,
          by change 0 ≤ τ+ratio*width;linarith [hτ.1],by change τ+ratio*width ≤ H;linarith [hτ.2,hfinish.2]⟩)
    have hresidual : ContinuousOn residual (Icc 0 finish) := by
      exact (continuousOn_const.smul
        (((continuousOn_const.smul ((hc _ (Ioo_subset_Icc_self hleft)).add
          (hc _ (Ioo_subset_Icc_self hright)))).sub
          (continuousOn_const.smul ((hf _ (Ioo_subset_Icc_self hright)).sub
            (hf _ (Ioo_subset_Icc_self hleft))))).sub hforward)).norm
    have hpositive (τ : ℝ) (hτ : τ ∈ Ioc 0 finish) : residual τ ≤ C*width := by
      let oldTime : ℤ → Fin m → ℝ := fun j => q (center+(j:ℝ)*width) τ
      have hl : oldTime (0-1) = q (center-width) τ := by
        simp [oldTime,sub_eq_add_neg]
      have hc' : oldTime 0 = q center τ := by simp [oldTime]
      have hr : oldTime (0+1) = q (center+width) τ := by simp [oldTime]
      have h := (hbound center hx τ hτ width hw hsmall).2.2.2 oldTime 0 hl hc' hr
      rw [hupdate τ oldTime 0 hl hr] at h
      exact h
    have hz : (0 : ℝ) ∈ closure (Ioc 0 finish) := by
      rw [closure_Ioc h0f.ne]
      exact ⟨le_rfl,h0f.le⟩
    have hzeroBound : residual 0 ≤ C*width :=
      ContinuousWithinAt.closure_le hz
        ((hresidual 0 ⟨le_rfl,h0f.le⟩).mono Ioc_subset_Icc_self)
        continuousWithinAt_const hpositive
    rw [hupdate 0 old i holdleft holdright]
    simpa [residual] using hzeroBound

end NumStability
