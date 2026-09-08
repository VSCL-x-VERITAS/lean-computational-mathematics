/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation

/-!
# Temporal mass derivatives from rectangle conservation

For any finite real state space and flux, rectangle conservation gives the
mass-rate identity almost everywhere in time on each fixed spatial interval.
The exceptional null set may depend on that spatial interval.
-/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability

theorem IsRectangleConservationLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ}
    (h : IsRectangleConservationLawSolution q flux) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t)) t := by
  have hflux (s t : ℝ) :
      IntervalIntegrable (fun r => flux (q a r) - flux (q b r)) volume s t :=
    (h.2.1 a s t).sub (h.2.1 b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hflux] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s, flux (q a r) - flux (q b r)) +
        (∫ x in a..b, q x 0)) := by
    funext s
    exact sub_eq_iff_eq_add.mp (h.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

end NumStability
