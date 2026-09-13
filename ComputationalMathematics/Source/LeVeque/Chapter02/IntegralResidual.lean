/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.LocalLinearAdvection
import ComputationalMathematics.Source.LeVeque.Chapter02.IntegralResidualTarget

/-!
# LeVeque equation (2.9)

The existing local differentiation-under-integral theorem identifies the mass
derivative with the integral of the actual time derivative. Combining it with
the inherited balance (2.8) gives the integrated conservation residual.
-/

open MeasureTheory Set

namespace NumStability.Leveque02Tracer

/-- Classical differentiation under the spatial integral yields equation (2.9). -/
theorem integralResidual : integralResidualTarget := by
  intro q flux qt fluxDerivative a b c d t hab ht hq hqt htime _hflux hint hbalance
  have hswap : MapsTo Prod.swap (Icc c d ×ˢ Icc a b) (Icc a b ×ˢ Icc c d) :=
    fun _ hz => ⟨hz.2, hz.1⟩
  have hmass := LocalLinearAdvection.local_integral_hasDerivAt
    (fun τ x => q x τ) (fun τ x => qt x τ) hab ht
    (hq.comp continuous_swap.continuousOn hswap)
    (hqt.comp continuous_swap.continuousOn hswap) htime
  have hslice : ContinuousOn (fun x => qt x t) (Icc a b) :=
    hqt.comp (continuous_id.prodMk continuous_const).continuousOn
      (fun _ hx => ⟨hx, Ioo_subset_Icc_self ht⟩)
  rw [intervalIntegral.integral_add (hslice.intervalIntegrable_of_Icc hab) hint,
    hmass.unique hbalance, neg_add_cancel]

end NumStability.Leveque02Tracer
