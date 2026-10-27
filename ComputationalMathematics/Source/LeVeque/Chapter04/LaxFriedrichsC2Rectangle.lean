/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsClosedC2Rectangle

/-!
# Positive-time compatibility for the actual C2 Lax–Friedrichs residual

The original regional statement and its public name remain unchanged.
The endpoint-inclusive actual physical producer now supplies its proof,
avoiding a second derivative-budget and stencil argument.
-/

namespace NumStability
open Set LocalConservationLaw LocalLinearAdvection

theorem leveque04_laxFriedrichs_c2RectangleReference_regionalResidual
    {m : ℕ} [NeZero m] (q : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (states : Set (Fin m → ℝ)) (L R H a b c d left right start finish ratio : ℝ)
    (_hhyperbolic : IsHyperbolicFluxOn flux states)
    (hreference : RectangleReferenceOn q flux L R H)
    (hq : ContDiffOn ℝ 2 (Function.uncurry q) (Icc L R ×ˢ Icc 0 H))
    (_hstates : ∀ x ∈ Icc L R, ∀ τ ∈ Icc 0 H, q x τ ∈ states)
    (hflux : ContDiffOn ℝ 2
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
  have h0f : 0 < finish := by linarith
  obtain ⟨threshold,C,hthreshold,hC,hbound⟩ :=
    leveque04_laxFriedrichs_c2RectangleReference_closedTimeRegionalResidual
      q flux states L R H a b d left right finish ratio _hhyperbolic
      hreference hq _hstates hflux hLa hal _hlr hrb hbR h0f hfd hdH hratio
  refine ⟨threshold,C,hthreshold,hC,?_⟩
  intro center hx time ht
  exact hbound center hx time ⟨by linarith [ht.1],ht.2⟩

end NumStability
