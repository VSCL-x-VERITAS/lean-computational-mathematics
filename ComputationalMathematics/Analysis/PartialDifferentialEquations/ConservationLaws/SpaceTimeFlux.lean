/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Local conservation for a space-time dependent flux

The flux is an independent field, so this result applies when it cannot be
expressed as a function of the conserved density alone. Exact section balances,
ordinary differentiation under the integral, and the spatial fundamental
theorem give a zero residual on every subinterval. Continuity extends it to
the ends of the modeled section.
-/

open MeasureTheory Set
open NumStability.LocalLinearAdvection

namespace NumStability

/-- Every smooth fixed-section balance for an independent flux field yields
the local scalar conservation equation, with within derivatives at endpoints. -/
theorem local_scalarConservation_of_sectionBalance
    (q qTime flux : ℝ → ℝ → ℝ) (fluxDerivative : ℝ → ℝ)
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
  have htcc : t ∈ Icc c d := Ioo_subset_Icc_self ht
  have htime : ContinuousOn (fun x => qTime x t) (Icc L R) :=
    hct.comp (continuous_id.prodMk continuous_const).continuousOn (fun _ hx => ⟨hx, htcc⟩)
  have hflux : ContinuousOn (fun x => flux x t) (Icc L R) :=
    fun x hx => (hdx x hx).continuousWithinAt
  have hres : ContinuousOn (fun x => qTime x t + fluxDerivative x) (Icc L R) :=
    htime.add hcx
  have hi_ordered (a b : ℝ) (ha : a ∈ Ioo L R) (hb : b ∈ Ioo L R) (hab : a ≤ b) :
      ∫ x in a..b, (qTime x t + fluxDerivative x) = 0 := by
    have hsub : Icc a b ⊆ Icc L R := Icc_subset_Icc ha.1.le hb.2.le
    have hmass := local_integral_hasDerivAt (fun τ x => q x τ)
      (fun τ x => qTime x τ) hab ht
      (hc.comp continuous_swap.continuousOn (fun _ hp => ⟨hsub hp.2, hp.1⟩))
      (hct.comp continuous_swap.continuousOn (fun _ hp => ⟨hsub hp.2, hp.1⟩))
      (fun τ hτ x hx => hdt τ hτ x (hsub hx))
    have hit := (htime.mono hsub).intervalIntegrable_of_Icc (μ := volume) hab
    have hix := (hcx.mono hsub).intervalIntegrable_of_Icc (μ := volume) hab
    have hspace : (∫ x in a..b, fluxDerivative x) = flux b t - flux a t := by
      apply intervalIntegral.integral_eq_sub_of_hasDerivAt_of_le hab (hflux.mono hsub) ?_ hix
      intro x hx
      have hxLR : x ∈ Ioo L R := ⟨lt_trans ha.1 hx.1, lt_trans hx.2 hb.2⟩
      exact (hdx x (Ioo_subset_Icc_self hxLR)).hasDerivAt
        (Icc_mem_nhds hxLR.1 hxLR.2)
    have hmassEq := hmass.unique
      (hbalance a (Ioo_subset_Icc_self ha) b (Ioo_subset_Icc_self hb) hab)
    rw [intervalIntegral.integral_add hit hix, hmassEq, hspace]
    ring
  have hinterior : ∀ x ∈ Ioo L R, qTime x t + fluxDerivative x = 0 := by
    intro x hx
    apply eq_zero_of_local_integrals _ (hres.mono Ioo_subset_Icc_self) hx
    intro a ha b hb
    rcases le_total a b with hab | hba
    · exact hi_ordered a b ha hb hab
    · rw [intervalIntegral.integral_symm, hi_ordered b a hb ha hba, neg_zero]
  intro x hx
  apply ((hres x hx).mono Ioo_subset_Icc_self).eq_const_of_mem_closure ?_ hinterior
  simpa only [closure_Ioo hLR.ne] using hx

end NumStability
