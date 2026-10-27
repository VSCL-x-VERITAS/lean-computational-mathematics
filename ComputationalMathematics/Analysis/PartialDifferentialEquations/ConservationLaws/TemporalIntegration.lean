/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.IntegralConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle

/-!
# Integrating a differential integral conservation law in time

Temporal integrability of the physical boundary fluxes lets the fundamental
theorem of calculus turn the differential cell balance into a rectangle balance.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- Integrate the differential law on one space-time rectangle. Only the two
boundary fluxes on the selected time interval need to be integrable. -/
theorem IsIntegralConservationLawSolution.integratedBalance
    {ι : Type*} [Fintype ι]
    {q : ℝ → ℝ → (ι → ℝ)} {flux : (ι → ℝ) → (ι → ℝ)}
    (hq : IsIntegralConservationLawSolution q flux)
    (a b s t : ℝ)
    (hleft : IntervalIntegrable (fun τ => flux (q a τ)) volume s t)
    (hright : IntervalIntegrable (fun τ => flux (q b τ)) volume s t) :
    (∫ x in a..b, q x t) - (∫ x in a..b, q x s) =
      (∫ τ in s..t, flux (q a τ)) -
        ∫ τ in s..t, flux (q b τ) := by
  have hderiv : ∀ τ ∈ Set.uIcc s t,
      HasDerivAt (fun v => ∫ x in a..b, q x v)
        (flux (q a τ) - flux (q b τ)) τ := by
    intro τ _
    exact (hq a b τ).2
  have hint : IntervalIntegrable
      (fun τ => flux (q a τ) - flux (q b τ)) volume s t :=
    hleft.sub hright
  simpa only [intervalIntegral.integral_sub hleft hright] using
    (intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint).symm

/-- Local temporal integrability at every boundary upgrades the differential
integral law to the all-rectangle balance. -/
theorem IsIntegralConservationLawSolution.toRectangle
    {ι : Type*} [Fintype ι]
    {q : ℝ → ℝ → (ι → ℝ)} {flux : (ι → ℝ) → (ι → ℝ)}
    (hq : IsIntegralConservationLawSolution q flux)
    (hflux : ∀ x s t, IntervalIntegrable (fun τ => flux (q x τ)) volume s t) :
    IsRectangleConservationLawSolution q flux := by
  refine ⟨fun a b t => (hq a b t).1, hflux, ?_⟩
  intro a b s t
  rw [hq.integratedBalance a b s t (hflux a s t) (hflux b s t)]
  exact (intervalIntegral.integral_sub (hflux a s t) (hflux b s t)).symm

end NumStability
