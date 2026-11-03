/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionPotentialRegularity
import Mathlib.MeasureTheory.Integral.IntervalIntegral.AbsolutelyContinuousFun

/-!
# Spatial integrals of the actual variational velocity

The actual spatial Lipschitz potential is absolutely continuous on every finite
interval. Its almost-everywhere derivative is the same selected velocity, so
the fundamental theorem of calculus computes its genuine spatial integral.
No time-evolution balance or rectangle-to-distribution implication is assumed.
-/

noncomputable section
open MeasureTheory Filter
open scoped Interval

namespace NumStability

theorem leveque04_burgersFiniteActionVelocity_spatial_integral {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time left right : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    IntervalIntegrable (fun x => leveque04_burgersFiniteActionVelocity old origin width x time)
      volume left right ∧
      (∫ x in left..right, leveque04_burgersFiniteActionVelocity old origin width x time) =
        leveque04_burgersFiniteActionPotential old origin width right time -
          leveque04_burgersFiniteActionPotential old origin width left time := by
  have hac := (leveque04_burgersFiniteActionPotential_spatial_lipschitz old origin width time
    hwidth htime).lipschitzOnWith (s := Set.uIcc left right) |>.absolutelyContinuousOnInterval
  have heq : (fun x => deriv (fun z =>
      leveque04_burgersFiniteActionPotential old origin width z time) x) =ᵐ[volume]
      (fun x => leveque04_burgersFiniteActionVelocity old origin width x time) := by
    filter_upwards [leveque04_burgersFiniteActionPotential_spatial_ae_hasDerivAt
      old origin width time hwidth htime] with x hx
    exact hx.deriv
  refine ⟨hac.intervalIntegrable_deriv.congr_ae (ae_restrict_of_ae heq), ?_⟩
  calc
    _ = ∫ x in left..right, deriv
        (fun z => leveque04_burgersFiniteActionPotential old origin width z time) x :=
      (intervalIntegral.integral_congr_ae (heq.mono (fun _ h _ => h))).symm
    _ = _ := hac.integral_deriv_eq_sub

end NumStability
