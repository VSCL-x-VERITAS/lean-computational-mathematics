/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Rectangle
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.IntervalIntegral.FundThmCalculus

/-!
# Pointwise mass derivatives under continuous boundary fluxes

Rectangle conservation gives an integrated mass balance. Continuous
boundary-flux traces upgrade the usual almost-everywhere temporal mass
derivative to an identity at every time.
-/

open MeasureTheory

namespace NumStability

/-- The mass over a fixed rectangle base has the exact boundary-flux
derivative at every time when those flux traces are continuous. -/
theorem IsRectangleConservationLawSolution.hasDerivAt_mass_of_continuous_flux
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ}
    (hq : IsRectangleConservationLawSolution q flux)
    (a b t : ℝ)
    (hcont : Continuous (fun τ => flux (q a τ) - flux (q b τ))) :
    HasDerivAt (fun τ => ∫ x in a..b, q x τ)
      (flux (q a t) - flux (q b t)) t := by
  have heq : (fun τ => ∫ x in a..b, q x τ) =
      (fun τ => (∫ s in (0 : ℝ)..τ,
        flux (q a s) - flux (q b s)) +
        (∫ x in a..b, q x 0)) := by
    funext τ
    exact sub_eq_iff_eq_add.mp (hq.2.2 a b 0 τ)
  rw [heq]
  exact (intervalIntegral.integral_hasDerivAt_right
    (hcont.intervalIntegrable 0 t)
    hcont.aestronglyMeasurable.stronglyMeasurableAtFilter
    hcont.continuousAt).add_const _

/-- On a nondegenerate cell, the normalized exact average has the
correspondingly normalized boundary-flux derivative at every time. -/
theorem IsRectangleConservationLawSolution.hasDerivAt_cellAverage_of_continuous_flux
    {ι : Type*} [Fintype ι] {q : ℝ → ℝ → ι → ℝ}
    {flux : (ι → ℝ) → ι → ℝ}
    (hq : IsRectangleConservationLawSolution q flux)
    (a b t : ℝ)
    (hcont : Continuous (fun τ => flux (q a τ) - flux (q b τ))) :
    HasDerivAt
      (fun τ => oneDimensionalCellAverage (fun x => q x τ) a b)
      ((b - a)⁻¹ • (flux (q a t) - flux (q b t))) t := by
  convert (hq.hasDerivAt_mass_of_continuous_flux a b t hcont).const_smul
    (b - a)⁻¹ using 1

end NumStability
