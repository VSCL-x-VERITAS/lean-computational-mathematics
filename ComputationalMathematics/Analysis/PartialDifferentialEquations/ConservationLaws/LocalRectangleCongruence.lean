/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalRectangleReference

/-!
# Congruence of local rectangle conservation

Equality on the closed space/time box preserves interval integrability and every physical rectangle balance.
-/

namespace NumStability

theorem LocalConservationLaw.rectangleReferenceOn_congr
    {m : ℕ} (q q' : ℝ → ℝ → Fin m → ℝ) (flux : (Fin m → ℝ) → Fin m → ℝ)
    (left right horizon : ℝ) (hleft : left ≤ right) (hhorizon : 0 ≤ horizon)
    (hq : LocalConservationLaw.RectangleReferenceOn q flux left right horizon)
    (heq : ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 horizon, q x time = q' x time) :
    LocalConservationLaw.RectangleReferenceOn q' flux left right horizon := by
  have hspace (time : ℝ) (htime : time ∈ Set.Icc 0 horizon) (a b : ℝ)
      (ha : a ∈ Set.Icc left right) (hb : b ∈ Set.Icc left right) :
      (∫ x in a..b, q' x time) = ∫ x in a..b, q x time := by
    apply intervalIntegral.integral_congr
    intro x hx
    exact (heq x (Set.ordConnected_Icc.uIcc_subset ha hb hx) time htime).symm
  refine ⟨?_, ?_, ?_⟩
  · intro time ht
    apply (hq.1 time ht).congr
    intro x hx
    exact heq x (by simpa only [Set.uIcc_of_le hleft] using Set.uIoc_subset_uIcc hx) time ht
  · intro x hx
    apply (hq.2.1 x hx).congr
    intro time ht
    exact congrArg flux (heq x hx time
      (by simpa only [Set.uIcc_of_le hhorizon] using Set.uIoc_subset_uIcc ht))
  · intro a ha b hb s hs t ht
    rw [hspace t ht a b ha hb, hspace s hs a b ha hb, hq.2.2 a ha b hb s hs t ht]
    apply intervalIntegral.integral_congr
    intro time htime
    have htime' := Set.ordConnected_Icc.uIcc_subset hs ht htime
    change flux (q a time) - flux (q b time) = flux (q' a time) - flux (q' b time)
    rw [heq a ha time htime', heq b hb time htime']

end NumStability
