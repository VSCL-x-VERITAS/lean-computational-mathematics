/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.VectorSectionBalance

open MeasureTheory Filter Set
open scoped Topology
/-!
# Classical conservation from C2 rectangle references

The existing rectangle integral law yields the mass derivative from
continuous physical fluxes. Joint C2 state and physical flux fields
yield the actual classical PDE in the physical interior. Vector
section conservation and the existing actual partial derivatives
are reused; no new solution-eligibility predicate is introduced.
-/

namespace NumStability
namespace LocalConservationLaw
open NumStability NumStability.LocalLinearAdvection

theorem rectangleReference_mass_derivative
    {m : ℕ} {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    {L R H a b t : ℝ}
    (hq : RectangleReferenceOn q flux L R H)
    (hflux : ContinuousOn (Function.uncurry (fun x τ => flux (q x τ)))
      (Icc L R ×ˢ Icc 0 H))
    (ha : a ∈ Ioo L R) (hb : b ∈ Ioo L R) (ht : t ∈ Ioo 0 H) :
    HasDerivAt (fun r => ∫ x in a..b, q x r) (flux (q a t) - flux (q b t)) t := by
  have hboundary : ContinuousOn (fun r => flux (q a r) - flux (q b r)) (Ioo 0 H) :=
    (hflux.comp (continuous_const.prodMk continuous_id).continuousOn
      (fun _ hr => ⟨Ioo_subset_Icc_self ha, Ioo_subset_Icc_self hr⟩)).sub
    (hflux.comp (continuous_const.prodMk continuous_id).continuousOn
      (fun _ hr => ⟨Ioo_subset_Icc_self hb, Ioo_subset_Icc_self hr⟩))
  have hd := intervalIntegral.integral_hasDerivAt_right
    (IntervalIntegrable.refl (f := fun r => flux (q a r) - flux (q b r)) (a := t))
    (ContinuousOn.stronglyMeasurableAtFilter isOpen_Ioo hboundary t ht)
    (hboundary.continuousAt (Ioo_mem_nhds ht.1 ht.2))
  apply (hd.add_const (∫ x in a..b, q x t)).congr_of_eventuallyEq
  filter_upwards [Ioo_mem_nhds ht.1 ht.2] with r hr
  exact sub_eq_iff_eq_add.mp (hq.2.2 a (Ioo_subset_Icc_self ha)
    b (Ioo_subset_Icc_self hb) t (Ioo_subset_Icc_self ht) r (Ioo_subset_Icc_self hr))

theorem rectangleReference_contDiffOn_two_interior_classical
    {m : ℕ} {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    {L R H x t : ℝ}
    (hreference : RectangleReferenceOn q flux L R H)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 H))
    (hflux : ContDiffOn ℝ 2
      (Function.uncurry (fun y τ => flux (q y τ))) (Icc L R ×ˢ Icc 0 H))
    (hx : x ∈ Ioo L R) (ht : t ∈ Ioo 0 H) :
    qt q x t + qx (fun y τ => flux (q y τ)) x t = 0 := by
  let F := fun y τ => flux (q y τ)
  have hs := hq.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hf := hflux.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hcq := hs.continuousOn_fderiv_of_isOpen (isOpen_Ioo.prod isOpen_Ioo) (by norm_num)
  have hcf := hf.continuousOn_fderiv_of_isOpen (isOpen_Ioo.prod isOpen_Ioo) (by norm_num)
  have hp : ContinuousOn (Function.uncurry (qt q)) (Ioo L R ×ˢ Ioo 0 H) ∧
      ContinuousOn (Function.uncurry (qx q)) (Ioo L R ×ˢ Ioo 0 H) :=
    ⟨hcq.clm_apply continuousOn_const,hcq.clm_apply continuousOn_const⟩
  have hfp : ContinuousOn (Function.uncurry (qt F)) (Ioo L R ×ˢ Ioo 0 H) ∧
      ContinuousOn (Function.uncurry (qx F)) (Ioo L R ×ˢ Ioo 0 H) :=
    ⟨hcf.clm_apply continuousOn_const,hcf.clm_apply continuousOn_const⟩
  have hdq (y τ : ℝ) (hy : y ∈ Ioo L R) (hτ : τ ∈ Ioo 0 H) :
      DifferentiableAt ℝ (Function.uncurry q) (y,τ) :=
    ((hs.of_le (m := 1) (by norm_num)).differentiableOn_one _ ⟨hy,hτ⟩).differentiableAt
      (prod_mem_nhds (Ioo_mem_nhds hy.1 hy.2) (Ioo_mem_nhds hτ.1 hτ.2))
  have hdf (y τ : ℝ) (hy : y ∈ Ioo L R) (hτ : τ ∈ Ioo 0 H) :
      DifferentiableAt ℝ (Function.uncurry F) (y,τ) :=
    ((hf.of_le (m := 1) (by norm_num)).differentiableOn_one _ ⟨hy,hτ⟩).differentiableAt
      (prod_mem_nhds (Ioo_mem_nhds hy.1 hy.2) (Ioo_mem_nhds hτ.1 hτ.2))
  let l := (L + x) / 2
  let r := (x + R) / 2
  let c := t / 2
  let d := (t + H) / 2
  have hspace : Icc l r ⊆ Ioo L R := by
    intro y hy; dsimp [l,r] at hy
    constructor <;> linarith [hy.1,hy.2,hx.1,hx.2]
  have htime : Icc c d ⊆ Ioo 0 H := by
    intro τ hτ; dsimp [c,d] at hτ
    constructor <;> linarith [hτ.1,hτ.2,ht.1,ht.2]
  have hbox : Icc l r ×ˢ Icc c d ⊆ Ioo L R ×ˢ Ioo 0 H :=
    prod_mono hspace htime
  have htinner : t ∈ Ioo c d := by dsimp [c,d]; constructor <;> linarith [ht.1,ht.2]
  have h := local_vectorConservation_of_sectionBalance q (qt q) F
    (fun y => qx F y t) l r c d t (by dsimp [l,r]; linarith [hx.1,hx.2]) htinner
    (hs.continuousOn.mono hbox) (hp.1.mono hbox)
    (fun τ hτ y hy => partial_time (hdq y τ
      (hspace hy) (htime (Ioo_subset_Icc_self hτ))))
    (fun y hy => (partial_space (hdf y t (hspace hy) ht)).hasDerivWithinAt)
    ((hfp.2.comp (continuous_id.prodMk continuous_const).continuousOn
      (fun _ hy => ⟨hspace hy,ht⟩)))
    (fun a ha b hb _ => rectangleReference_mass_derivative hreference hflux.continuousOn
      (hspace ha) (hspace hb) ht) x
    (show x ∈ Icc l r by dsimp [l,r]; constructor <;> linarith [hx.1,hx.2])
  exact h


end LocalConservationLaw
end NumStability
