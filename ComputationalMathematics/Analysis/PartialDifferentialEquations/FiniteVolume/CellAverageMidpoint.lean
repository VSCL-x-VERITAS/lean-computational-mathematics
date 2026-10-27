/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import Mathlib.MeasureTheory.Integral.IntervalIntegral.TrapezoidalRule
import Mathlib.Analysis.Calculus.ContDiff.Bounds
import Mathlib.Analysis.Calculus.FDeriv.Basic
import Mathlib.Analysis.Normed.Group.Bounded
import Mathlib.Tactic

/-!
# Local midpoint error of normalized cell averages

Scalar quadrature and finite-vector coordinate averages give a nonsharp
second-order bound. On any compact subinterval of a smooth neighborhood,
one constant works for every contained positive-width cell.
-/

namespace NumStability
open MeasureTheory intervalIntegral Set
open scoped BigOperators
theorem midpoint_trapezoidal_integral_identity
    (f : ℝ → ℝ) (left right : ℝ) :
    2 * trapezoidal_integral f 2 left right -
      trapezoidal_integral f 1 left right =
        (right - left) * f ((left + right) / 2) := by
  simp [trapezoidal_integral]
  have hmid : left + (right - left) / 2 = (left + right) / 2 := by ring
  rw [hmid]
  ring

/-- A `C²` field with second derivative bounded by `M` has cell-average
midpoint error at most `M Δx²/8`. -/
theorem cellAverage_midpoint_error_le
    (f : ℝ → ℝ) (left right bound : ℝ)
    (hcell : left < right)
    (hsmooth : ContDiffOn ℝ 2 f (Set.Icc left right))
    (hderiv : ∀ x,
      |iteratedDerivWithin 2 f (Set.Icc left right) x| ≤ bound) :
    |oneDimensionalCellAverage f left right -
        f ((left + right) / 2)| ≤
      (right - left) ^ 2 * bound / 8 := by
  let width := right - left
  have hwidth : 0 < width := sub_pos.mpr hcell
  have hE1 := trapezoidal_error_le_of_c2
    (f := f) (a := left) (b := right)
    (by simpa only [Set.uIcc_of_le hcell.le] using hsmooth)
    (by simpa only [Set.uIcc_of_le hcell.le] using hderiv)
    (N := 1) (by norm_num)
  have hE2 := trapezoidal_error_le_of_c2
    (f := f) (a := left) (b := right)
    (by simpa only [Set.uIcc_of_le hcell.le] using hsmooth)
    (by simpa only [Set.uIcc_of_le hcell.le] using hderiv)
    (N := 2) (by norm_num)
  have hidentity := midpoint_trapezoidal_integral_identity f left right
  have heq : oneDimensionalCellAverage f left right -
      f ((left + right) / 2) =
        -(2 * trapezoidal_error f 2 left right -
          trapezoidal_error f 1 left right) / width := by
    have hnum : -(2 * trapezoidal_error f 2 left right -
        trapezoidal_error f 1 left right) =
        (∫ x in left..right, f x) -
          width * f ((left + right) / 2) := by
      simp only [trapezoidal_error]
      have hid : 2 * trapezoidal_integral f 2 left right -
          trapezoidal_integral f 1 left right =
            width * f ((left + right) / 2) := hidentity
      linarith
    rw [hnum]
    simp only [oneDimensionalCellAverage, smul_eq_mul]
    rw [sub_div]
    dsimp [width]
    field_simp [sub_ne_zero.mpr hcell.ne']
  rw [heq, abs_div, abs_neg, abs_of_pos hwidth]
  have htri : |2 * trapezoidal_error f 2 left right -
      trapezoidal_error f 1 left right| ≤
      2 * |trapezoidal_error f 2 left right| +
        |trapezoidal_error f 1 left right| := by
    calc
      |2 * trapezoidal_error f 2 left right -
          trapezoidal_error f 1 left right| ≤
        |2 * trapezoidal_error f 2 left right| +
          |-trapezoidal_error f 1 left right| := by
            simpa only [sub_eq_add_neg] using
              abs_add_le (2 * trapezoidal_error f 2 left right)
                (-trapezoidal_error f 1 left right)
      _ = _ := by simp [abs_mul]
  have hbound :
      2 * |trapezoidal_error f 2 left right| +
        |trapezoidal_error f 1 left right| ≤
      2 * (width ^ 3 * bound / 48) +
        width ^ 3 * bound / 12 := by
    have hE1' : |trapezoidal_error f 1 left right| ≤
        width ^ 3 * bound / 12 := by
      simpa [width, abs_of_pos hwidth] using hE1
    have hE2' : |trapezoidal_error f 2 left right| ≤
        width ^ 3 * bound / 48 := by
      norm_num [width, abs_of_pos hwidth] at hE2 ⊢
      exact hE2
    linarith
  calc
    |2 * trapezoidal_error f 2 left right -
        trapezoidal_error f 1 left right| / width ≤
      (2 * |trapezoidal_error f 2 left right| +
        |trapezoidal_error f 1 left right|) / width :=
          div_le_div_of_nonneg_right htri hwidth.le
    _ ≤ (2 * (width ^ 3 * bound / 48) +
          width ^ 3 * bound / 12) / width :=
            div_le_div_of_nonneg_right hbound hwidth.le
    _ = (right - left) ^ 2 * bound / 8 := by
      dsimp [width]
      field_simp [hwidth.ne']
      ring

private theorem midpointIteratedDerivWithin_zero_off_closure
    {𝕜 : Type*} [NontriviallyNormedField 𝕜]
    {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    (n : ℕ) (f : 𝕜 → F) (s : Set 𝕜) (x : 𝕜) (hx : x ∉ closure s) :
    iteratedDerivWithin (n + 1) f s x = 0 := by
  simp [iteratedDerivWithin, iteratedFDerivWithin_succ_eq_comp_left,
    fderivWithin_zero_of_notMem_closure hx]

private theorem midpointIteratedDerivWithin_closed_bound_iff
    {𝕜 : Type*} [NontriviallyNormedField 𝕜]
    {F : Type*} [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    (n : ℕ) (f : 𝕜 → F) (s : Set 𝕜) (hs : IsClosed s)
    (bound : ℝ) (hb : 0 ≤ bound) :
    (∀ x, ‖iteratedDerivWithin (n + 1) f s x‖ ≤ bound) ↔
      ∀ x ∈ s, ‖iteratedDerivWithin (n + 1) f s x‖ ≤ bound := by
  constructor
  · intro h x _hx
    exact h x
  · intro h x
    by_cases hx : x ∈ s
    · exact h x hx
    · have hc : x ∉ closure s := by simpa only [hs.closure_eq] using hx
      rw [midpointIteratedDerivWithin_zero_off_closure n f s x hc, norm_zero]
      exact hb


theorem scalarCellAverage_midpoint_error_uniform
    (f : ℝ → ℝ) (outerLeft innerLeft innerRight outerRight : ℝ)
    (hleft : outerLeft < innerLeft) (hright : innerRight < outerRight)
    (hsmooth : ContDiffOn ℝ 2 f (Ioo outerLeft outerRight)) :
    ∃ bound : ℝ, 0 ≤ bound ∧ ∀ a b : ℝ, innerLeft ≤ a → b ≤ innerRight → a < b →
      |oneDimensionalCellAverage f a b - f ((a + b) / 2)| ≤
        (b - a) ^ 2 * bound / 8 := by
  have hsub : Icc innerLeft innerRight ⊆ Ioo outerLeft outerRight := by
    intro x hx
    exact ⟨hleft.trans_le hx.1, hx.2.trans_lt hright⟩
  have hcontF := ContinuousOn.continuousOn_iteratedFDeriv (k := 2)
    hsmooth isOpen_Ioo (by norm_num)
  have hcont : ContinuousOn (iteratedDeriv 2 f) (Icc innerLeft innerRight) := by
    rw [iteratedDeriv_eq_equiv_comp]
    exact
      ((ContinuousMultilinearMap.piFieldEquiv ℝ (Fin 2) ℝ).symm.continuous.comp_continuousOn
        hcontF).mono hsub
  obtain ⟨bound,hbound⟩ := isCompact_Icc.exists_bound_of_continuousOn hcont
  refine ⟨max bound 0, le_max_right _ _, ?_⟩
  intro a b ha hb hab
  have hcellsub : Icc a b ⊆ Ioo outerLeft outerRight := by
    intro x hx
    exact hsub ⟨ha.trans hx.1, hx.2.trans hb⟩
  apply cellAverage_midpoint_error_le f a b (max bound 0) hab (hsmooth.mono hcellsub)
  have hlocal : ∀ x ∈ Icc a b, ‖iteratedDerivWithin 2 f (Icc a b) x‖ ≤ max bound 0 := by
    intro x hx
    have hcx := hsmooth.contDiffAt (isOpen_Ioo.mem_nhds (hcellsub hx))
    rw [iteratedDerivWithin_eq_iteratedDeriv (uniqueDiffOn_Icc hab) hcx hx]
    exact (hbound x ⟨ha.trans hx.1, hx.2.trans hb⟩).trans (le_max_left _ _)
  have hglobal := (midpointIteratedDerivWithin_closed_bound_iff 1 f (Icc a b)
    isClosed_Icc (max bound 0) (le_max_right _ _)).mpr hlocal
  simpa only [Real.norm_eq_abs] using hglobal

theorem cellAverage_midpoint_error_le_of_component_bounds
    {m : ℕ} (field : ℝ → Fin m → ℝ) (a b M : ℝ)
    (hab : a < b) (hM : 0 ≤ M)
    (hint : IntervalIntegrable field volume a b)
    (hsmooth : ∀ p, ContDiffOn ℝ 2 (fun x => field x p) (Icc a b))
    (hsecond : ∀ p x, |iteratedDerivWithin 2 (fun y => field y p) (Icc a b) x| ≤ M) :
    ‖oneDimensionalCellAverage field a b-field ((a+b)/2)‖ ≤ (b-a)^2*M/8 := by
  apply (pi_norm_le_iff_of_nonneg (by positivity : 0 ≤ (b-a)^2*M/8)).mpr
  intro p
  have hc := oneDimensionalCellAverage_apply field a b hint p
  have hs := cellAverage_midpoint_error_le (fun x => field x p) a b M hab (hsmooth p) (hsecond p)
  simpa only [Pi.sub_apply,Real.norm_eq_abs,hc] using hs

theorem cellAverage_midpoint_error_uniform
    {m : ℕ} (field : ℝ → Fin m → ℝ) (L l r R : ℝ)
    (hL : L < l) (hR : r < R)
    (hsmooth : ∀ p, ContDiffOn ℝ 2 (fun x => field x p) (Ioo L R)) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ a b : ℝ, l ≤ a → b ≤ r → a < b →
      ‖oneDimensionalCellAverage field a b-field ((a+b)/2)‖ ≤ C*(b-a)^2 := by
  have hall := fun p => scalarCellAverage_midpoint_error_uniform
    (fun x => field x p) L l r R hL hR (hsmooth p)
  choose bound hbound herror using hall
  let C := (∑ p : Fin m, bound p)/8
  have hC : 0 ≤ C := div_nonneg (Finset.sum_nonneg (fun p _ => hbound p)) (by norm_num)
  refine ⟨C,hC,?_⟩
  intro a b ha hb hab
  have hsub : Icc a b ⊆ Ioo L R := by
    intro x hx
    exact ⟨hL.trans_le (ha.trans hx.1),(hx.2.trans hb).trans_lt hR⟩
  have hint : IntervalIntegrable field volume a b :=
    (intervalIntegrable_pi_iff field a b).mpr
      (fun p => ((hsmooth p).mono hsub).continuousOn.intervalIntegrable_of_Icc hab.le)
  apply (pi_norm_le_iff_of_nonneg (mul_nonneg hC (sq_nonneg _))).mpr
  intro p
  have hc := oneDimensionalCellAverage_apply field a b hint p
  have hp : bound p ≤ ∑ q : Fin m, bound q :=
    Finset.single_le_sum (fun q _ => hbound q) (Finset.mem_univ p)
  have hs := herror p a b ha hb hab
  have hbound' : (b-a)^2*bound p/8 ≤ C*(b-a)^2 := by
    dsimp [C]
    nlinarith [mul_le_mul_of_nonneg_left hp (sq_nonneg (b-a))]
  simpa only [Pi.sub_apply,Real.norm_eq_abs,hc] using hs.trans hbound'

end NumStability
