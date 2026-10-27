/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.SpaceTimeFlux

open MeasureTheory Set
open scoped Topology
/-!
# Vector section balances and smooth rectangle conservation

A finite-vector section balance yields the local conservation PDE by
reusing the scalar theorem in each coordinate. Continuous linear
evaluation commutes with the actual interval integrals and derivatives.
The existing smooth rectangle reference for a general state flux
supplies the mass derivative, and smoothness of its physical flux
field yields the actual classical conservation equation in the interior.
-/

namespace NumStability

theorem local_vectorConservation_of_sectionBalance
    {m : ℕ} (q qTime flux : ℝ → ℝ → (Fin m → ℝ))
    (fluxDerivative : ℝ → (Fin m → ℝ))
    (L R c d t : ℝ) (hLR : L < R) (ht : t ∈ Ioo c d)
    (hc : ContinuousOn (Function.uncurry q) (Icc L R ×ˢ Icc c d))
    (hct : ContinuousOn (Function.uncurry qTime) (Icc L R ×ˢ Icc c d))
    (hdt : ∀ τ ∈ Ioo c d, ∀ x ∈ Icc L R,
      HasDerivAt (q x) (qTime x τ) τ)
    (hdx : ∀ x ∈ Icc L R,
      HasDerivWithinAt (fun ξ => flux ξ t) (fluxDerivative x) (Icc L R) x)
    (hcx : ContinuousOn fluxDerivative (Icc L R))
    (hbalance : ∀ a ∈ Icc L R, ∀ b ∈ Icc L R, a ≤ b →
      HasDerivAt (fun τ => ∫ x in a..b, q x τ)
        (flux a t - flux b t) t) :
    ∀ x ∈ Icc L R, qTime x t + fluxDerivative x = 0 := by
  intro x hx
  ext p
  let eval : (Fin m → ℝ) →L[ℝ] ℝ := ContinuousLinearMap.proj p
  have hq : ContinuousOn (Function.uncurry (fun x τ => eval (q x τ)))
      (Icc L R ×ˢ Icc c d) := eval.continuous.comp_continuousOn hc
  have hqt : ContinuousOn (Function.uncurry (fun x τ => eval (qTime x τ)))
      (Icc L R ×ˢ Icc c d) := eval.continuous.comp_continuousOn hct
  have hderivTime (τ : ℝ) (hτ : τ ∈ Ioo c d) (y : ℝ) (hy : y ∈ Icc L R) :
      HasDerivAt (fun σ => eval (q y σ)) (eval (qTime y τ)) τ :=
    eval.hasFDerivAt.comp_hasDerivAt τ (hdt τ hτ y hy)
  have hderivSpace (y : ℝ) (hy : y ∈ Icc L R) :
      HasDerivWithinAt (fun ξ => eval (flux ξ t)) (eval (fluxDerivative y)) (Icc L R) y :=
    eval.hasFDerivAt.comp_hasDerivWithinAt y (hdx y hy)
  have hmass (a : ℝ) (ha : a ∈ Icc L R) (b : ℝ) (hb : b ∈ Icc L R) (hab : a ≤ b) :
      HasDerivAt (fun τ => ∫ y in a..b, eval (q y τ)) (eval (flux a t) - eval (flux b t)) t := by
    have h := eval.hasFDerivAt.comp_hasDerivAt t (hbalance a ha b hb hab)
    rw [map_sub] at h
    apply h.congr_of_eventuallyEq
    filter_upwards [Icc_mem_nhds ht.1 ht.2] with τ hτ
    have hslice : ContinuousOn (fun y => q y τ) (Icc L R) :=
      hc.comp (continuous_id.prodMk continuous_const).continuousOn (fun _ hy => ⟨hy,hτ⟩)
    have hsub : Icc a b ⊆ Icc L R := Icc_subset_Icc ha.1 hb.2
    exact eval.intervalIntegral_comp_comm ((hslice.mono hsub).intervalIntegrable_of_Icc hab)
  have h := local_scalarConservation_of_sectionBalance
    (fun y τ => eval (q y τ)) (fun y τ => eval (qTime y τ))
    (fun y τ => eval (flux y τ)) (fun y => eval (fluxDerivative y))
    L R c d t hLR ht hq hqt hderivTime hderivSpace
    (eval.continuous.comp_continuousOn hcx) hmass x hx
  exact h


namespace LocalConservationLaw
open NumStability.LocalLinearAdvection

theorem smoothReference_mass_derivative
    {m : ℕ} {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    {states : Set (Fin m → ℝ)} {L R H a b t : ℝ}
    (hq : SmoothReferenceOn q flux states L R H)
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
  exact sub_eq_iff_eq_add.mp (hq.2.1.2.2 a (Ioo_subset_Icc_self ha)
    b (Ioo_subset_Icc_self hb) t (Ioo_subset_Icc_self ht) r (Ioo_subset_Icc_self hr))

theorem smoothReference_interior_classical
    {m : ℕ} {q : ℝ → ℝ → (Fin m → ℝ)} {flux : (Fin m → ℝ) → (Fin m → ℝ)}
    {states : Set (Fin m → ℝ)} {L R H x t : ℝ}
    (hq : SmoothReferenceOn q flux states L R H)
    (hflux : ContDiffOn ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)
      (Function.uncurry (fun y τ => flux (q y τ))) (Icc L R ×ˢ Icc 0 H))
    (hx : x ∈ Ioo L R) (ht : t ∈ Ioo 0 H) :
    qt q x t + qx (fun y τ => flux (q y τ)) x t = 0 := by
  let F := fun y τ => flux (q y τ)
  have hs := hq.1.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hf := hflux.mono (prod_mono Ioo_subset_Icc_self Ioo_subset_Icc_self)
  have hp := interior_partials_continuous hs
  have hfp := interior_partials_continuous hf
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
    (fun τ hτ y hy => partial_time (interior_differentiableAt hs
      (hspace hy) (htime (Ioo_subset_Icc_self hτ))))
    (fun y hy => (partial_space (interior_differentiableAt hf (hspace hy) ht)).hasDerivWithinAt)
    ((hfp.2.comp (continuous_id.prodMk continuous_const).continuousOn
      (fun _ hy => ⟨hspace hy,ht⟩)))
    (fun a ha b hb _ => smoothReference_mass_derivative hq hflux.continuousOn
      (hspace ha) (hspace hb) ht) x
    (show x ∈ Icc l r by dsimp [l,r]; constructor <;> linarith [hx.1,hx.2])
  exact h

end LocalConservationLaw

end NumStability
