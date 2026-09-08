/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalance
import ComputationalMathematics.MeasureTheory.Integral.IntervalIntegral.LebesgueDifferentiation

/-!
# Temporal mass derivatives with internal production

For finite real vectors, rectangle balance gives the mass-rate identity almost
everywhere in time. The exceptional null set may depend on the fixed spatial interval.
-/

open MeasureTheory

namespace NumStability

/-- The a.e. mass-rate statement follows from the integral balance. Its null
exceptional set can depend on the fixed spatial interval. -/
theorem IsRectangleBalanceLawSolution.hasDerivAt_mass_ae
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ} {production : ℝ → ℝ → ι → ℝ}
    (h : IsRectangleBalanceLawSolution q flux production) (a b : ℝ) :
    ∀ᵐ t, HasDerivAt (fun s => ∫ x in a..b, q x s)
      (flux (q a t) - flux (q b t) + ∫ x in a..b, production x t) t := by
  have hint (s t : ℝ) : IntervalIntegrable
      (fun r => flux (q a r) - flux (q b r) + ∫ x in a..b, production x r)
      volume s t :=
    ((h.2.1 a s t).sub (h.2.1 b s t)).add (h.2.2.2.1 a b s t)
  filter_upwards [ae_hasDerivAt_intervalIntegral_pi _ hint] with t ht
  have heq : (fun s => ∫ x in a..b, q x s) =
      (fun s => (∫ r in (0 : ℝ)..s,
        flux (q a r) - flux (q b r) + ∫ x in a..b, production x r) +
          ∫ x in a..b, q x 0) := by
    funext s
    rw [intervalIntegral.integral_add
      ((h.2.1 a 0 s).sub (h.2.1 b 0 s)) (h.2.2.2.1 a b 0 s)]
    exact sub_eq_iff_eq_add.mp (h.2.2.2.2 a b 0 s)
  rw [heq]
  exact (ht 0).add_const _

end NumStability
