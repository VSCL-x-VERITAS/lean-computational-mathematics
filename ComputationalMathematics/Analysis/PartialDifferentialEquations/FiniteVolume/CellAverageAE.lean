/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage

/-!
# Almost-everywhere equality of cell averages

Normalized interval averages respect almost-everywhere equality. Translation
also transports interval integrability. Positivity of cell width is a separate
condition when these totalized expressions represent physical cell means.
-/
namespace NumStability
open MeasureTheory

/-- AE-equivalent fields have identical normalized interval averages.
No integrability/order/nonzero-width premise is needed for this equality of
existing totalized expressions. Physical cell means require their own
positive-width and integrability assertions. -/
theorem oneDimensionalCellAverage_congr_ae
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {field profile : ℝ → E} {left right : ℝ}
    (hfield : field =ᵐ[volume.restrict (Set.uIoc left right)] profile) :
    oneDimensionalCellAverage field left right =
      oneDimensionalCellAverage profile left right := by
  unfold oneDimensionalCellAverage
  rw [intervalIntegral.integral_congr_ae_restrict hfield]

/-- An integrable local profile transfers to an AE-equivalent translated
field, together with equality of their actual normalized interval integrals.
The endpoints can be reversed or equal. The integral-transfer hypotheses
exclude reliance on a nonintegrable fallback; positive width is required
separately when a caller interprets the result as a physical cell mean. -/
theorem oneDimensionalCellAverage_integrable_of_ae_eq_translate
    {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]
    {field profile : ℝ → E} {left right shift : ℝ}
    (hprofile : IntervalIntegrable profile volume left right)
    (hfield : (fun x => field (x + shift))
      =ᵐ[volume.restrict (Set.uIoc left right)] profile) :
    IntervalIntegrable field volume (left + shift) (right + shift) ∧
    oneDimensionalCellAverage field (left + shift) (right + shift) =
      oneDimensionalCellAverage profile left right := by
  have hlocal : IntervalIntegrable (fun x => field (x + shift)) volume left right :=
    hprofile.congr_ae hfield.symm
  have hglobal : IntervalIntegrable field volume (left + shift) (right + shift) :=
    (IntervalIntegrable.comp_add_right_iff
      (f := field) (a := left) (b := right) (c := shift)).mp hlocal
  have haverage : oneDimensionalCellAverage (fun x => field (x + shift)) left right =
      oneDimensionalCellAverage field (left + shift) (right + shift) := by
    simpa only [sub_neg_eq_add] using
      oneDimensionalCellAverage_comp_sub_right field left right (-shift)
  exact ⟨hglobal, haverage.symm.trans (oneDimensionalCellAverage_congr_ae hfield)⟩

end NumStability
