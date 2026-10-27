/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.ZMod.Basic
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LocalFaceErrorVariation
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Sampling a periodic integer grid

A periodic sequence can be sampled through the canonical representatives
of `ZMod n`. The next cell agrees with the unwrapped next index, even
at the seam.
-/

namespace NumStability

/-- Sample a sequence at the canonical representative of a periodic cell. -/
def periodicGridSample {E : Type*} (n : ℕ) (values : ℕ → E)
    (i : ZMod n) : E := values i.val

/-- The right neighbor of a periodic sample is the next unwrapped value. -/
theorem periodicGridSample_add_one
    {E : Type*} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (values : ℕ → E)
    (hperiod : ∀ j, values (j + n) = values j)
    (i : ZMod n) :
    periodicGridSample n values (i + 1) = values (i.val + 1) := by
  have hne : n ≠ 1 := by omega
  have hone : (1 : ZMod n).val = 1 := ZMod.val_one'' hne
  by_cases h : i.val + 1 < n
  · have hval : (i + 1).val = i.val + 1 := by
      simpa only [hone] using
        (ZMod.val_add_of_lt (a := i) (b := 1) (by simpa only [hone] using h))
    simp only [periodicGridSample, hval]
  · have hle : n ≤ i.val + 1 := by omega
    have heq : i.val + 1 = n := by
      have hlt := ZMod.val_lt i
      omega
    have hval : (i + 1).val = 0 := by
      rw [ZMod.val_add_of_le (by simpa only [hone] using hle), hone]
      omega
    have hzero : values n = values 0 := by
      simpa using hperiod 0
    simp only [periodicGridSample, hval, heq, hzero]

/-- Away from the seam, the left neighbor has the preceding representative. -/
theorem periodicGridSample_sub_one_of_pos
    {E : Type*} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (values : ℕ → E) (i : ZMod n) (hi : 0 < i.val) :
    periodicGridSample n values (i - 1) = values (i.val - 1) := by
  have hne : n ≠ 1 := by omega
  have hone : (1 : ZMod n).val = 1 := ZMod.val_one'' hne
  have hle : (1 : ZMod n).val ≤ i.val := by rw [hone]; omega
  have hval : (i - 1).val = i.val - 1 :=
    by simpa only [hone] using ZMod.val_sub hle
  exact congrArg values hval

/-- At the seam, the left neighbor has representative `n - 1`. -/
theorem periodicGridSample_sub_one_of_zero
    {E : Type*} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (values : ℕ → E) (i : ZMod n) (hi : i.val = 0) :
    periodicGridSample n values (i - 1) = values (n - 1) := by
  have hne : n ≠ 1 := by omega
  have hone : (1 : ZMod n).val = 1 := ZMod.val_one'' hne
  have hi0 : i = 0 := (ZMod.val_eq_zero i).mp hi
  subst i
  have h1ne : (1 : ZMod n) ≠ 0 := by
    intro h
    have := congrArg ZMod.val h
    simp only [hone, ZMod.val_zero] at this
    omega
  have hval : (-1 : ZMod n).val = n - 1 := by
    simpa only [hone, if_neg h1ne] using ZMod.neg_val (1 : ZMod n)
  simp only [periodicGridSample, zero_sub, hval]

/-- A periodic smooth face-error extension with derivative of order `width`
has adjacent sampled variation of order `width²`, including the seam. -/
theorem periodicSmoothFaceError_adjacent_bound
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (error error' : ℝ → ℝ) (width bound : ℝ)
    (hwidth : 0 < width)
    (hperiod : ∀ x, error (x + (n : ℝ) * width) = error x)
    (hderiv : ∀ x, HasDerivAt error (error' x) x)
    (hderivBound : ∀ x, |error' x| ≤ bound * width)
    (i : ZMod n) :
    |error (((i + 1).val : ℝ) * width) -
        error ((i.val : ℝ) * width)| ≤ bound * width ^ 2 := by
  let values : ℕ → ℝ := fun j => error ((j : ℝ) * width)
  have hvaluesPeriod : ∀ j, values (j + n) = values j := by
    intro j
    simpa only [values, Nat.cast_add, add_mul] using
      hperiod ((j : ℝ) * width)
  have hnext := periodicGridSample_add_one n hn values hvaluesPeriod i
  dsimp [periodicGridSample, values] at hnext
  have hlocal := localFaceError_endpoint_bound error error'
    ((i.val : ℝ) * width) ((i.val : ℝ) * width + width)
    (bound * width) (by linarith) (fun x _ => hderiv x)
    (fun x _ => hderivBound x)
  have hcoordinate : (((i.val + 1 : ℕ) : ℝ) * width) =
      (i.val : ℝ) * width + width := by push_cast; ring
  rw [hnext, hcoordinate]
  simpa only [add_sub_cancel_left, mul_assoc, pow_two] using hlocal

end NumStability
