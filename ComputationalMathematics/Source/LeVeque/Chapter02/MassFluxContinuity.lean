/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MassFluxContinuityTarget
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection

/-!
# Mass continuity from local conservation

Differentiate mass on every section, apply the spatial fundamental theorem,
and extend the continuous zero residual to section endpoints.
-/

open MeasureTheory Set
open NumStability.LocalLinearAdvection

namespace NumStability.Leveque02Tracer

/-- Actual local mass conservation gives the continuity equation (2.32). -/
theorem massFluxContinuity : massFluxContinuityTarget := by
  intro density velocity densityTime fluxDerivative L R c d t hLR ht hc hct hdt hdx hcx hbalance
  have htcc : t ∈ Icc c d := Ioo_subset_Icc_self ht
  have htime : ContinuousOn (fun x => densityTime x t) (Icc L R) :=
    hct.comp (continuous_id.prodMk continuous_const).continuousOn (fun _ hx => ⟨hx, htcc⟩)
  have hflux : ContinuousOn (fun x => density x t * velocity x t) (Icc L R) :=
    fun x hx => (hdx x hx).continuousWithinAt
  have hres : ContinuousOn (fun x => densityTime x t + fluxDerivative x) (Icc L R) :=
    htime.add hcx
  have hi_ordered (a b : ℝ) (ha : a ∈ Ioo L R) (hb : b ∈ Ioo L R) (hab : a ≤ b) :
      ∫ x in a..b, (densityTime x t + fluxDerivative x) = 0 := by
    have hsub : Icc a b ⊆ Icc L R :=
      Icc_subset_Icc ha.1.le hb.2.le
    have hmass := local_integral_hasDerivAt (fun τ x => density x τ)
      (fun τ x => densityTime x τ) hab ht
      (hc.comp continuous_swap.continuousOn (fun _ hp => ⟨hsub hp.2, hp.1⟩))
      (hct.comp continuous_swap.continuousOn (fun _ hp => ⟨hsub hp.2, hp.1⟩))
      (fun τ hτ x hx => hdt τ hτ x (hsub hx))
    have hit := (htime.mono hsub).intervalIntegrable_of_Icc (μ := volume) hab
    have hix := (hcx.mono hsub).intervalIntegrable_of_Icc (μ := volume) hab
    have hspace : (∫ x in a..b, fluxDerivative x) =
        density b t * velocity b t - density a t * velocity a t := by
      apply intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le hab (hflux.mono hsub) ?_ hix
      intro x hx
      have hxLR : x ∈ Ioo L R := ⟨lt_trans ha.1 hx.1, lt_trans hx.2 hb.2⟩
      exact (hdx x (Ioo_subset_Icc_self hxLR)).hasDerivAt
        (Icc_mem_nhds hxLR.1 hxLR.2)
    have hmassEq := hmass.unique
      (hbalance a (Ioo_subset_Icc_self ha) b (Ioo_subset_Icc_self hb) hab)
    rw [intervalIntegral.integral_add hit hix, hmassEq, hspace]
    ring
  have hinterior : ∀ x ∈ Ioo L R, densityTime x t + fluxDerivative x = 0 := by
    intro x hx
    apply eq_zero_of_local_integrals _ (hres.mono Ioo_subset_Icc_self) hx
    intro a ha b hb
    rcases le_total a b with hab | hba
    · exact hi_ordered a b ha hb hab
    · rw [intervalIntegral.integral_symm, hi_ordered b a hb ha hba, neg_zero]
  intro x hx
  apply ((hres x hx).mono Ioo_subset_Icc_self).eq_const_of_mem_closure ?_ hinterior
  simpa only [closure_Ioo hLR.ne] using hx

end NumStability.Leveque02Tracer
