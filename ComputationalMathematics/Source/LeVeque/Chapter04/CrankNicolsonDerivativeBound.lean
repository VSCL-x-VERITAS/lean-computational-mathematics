/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonPeriodicExactSlope

/-!
# Derivative bound used by the smooth CN slope budgets

A global bound on the profile's second derivative supplies the
Lipschitz premise for its first derivative. This is the step needed to
instantiate the adjacent exact-average face-slope estimate.
-/

namespace NumStability

/-- A bounded real derivative gives a global Lipschitz estimate, in the
absolute-value form used by the exact-average slope transfer. -/
theorem leveque04_lipschitz_of_bounded_derivative
    (f f' : ℝ → ℝ) (B : ℝ)
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hbound : ∀ x, |f' x| ≤ B) :
    ∀ x y, |f x - f y| ≤ B * |x - y| := by
  intro x y
  have hle (a b : ℝ) (hab : a ≤ b) :
      |f b - f a| ≤ B * (b - a) := by
    have h := (norm_image_sub_le_of_norm_deriv_le_segment'
      (a := a) (b := b) (f := f) (f' := f') (C := B)
      (fun z _ => (hf z).hasDerivWithinAt)
      (fun z _ => by simpa [Real.norm_eq_abs] using hbound z))
      b ⟨hab, le_refl _⟩
    simpa only [Real.norm_eq_abs] using h
  rcases le_total y x with hyx | hxy
  · simpa [abs_of_nonneg (sub_nonneg.mpr hyx)] using hle y x hyx
  · have h := hle x y hxy
    rw [abs_sub_comm x y, abs_sub_comm (f x) (f y)]
    simpa [abs_of_nonneg (sub_nonneg.mpr hxy)] using h

/-- A uniform second-derivative bound discharges the adjacent
exact-average slope premise on a finite periodic grid. -/
theorem leveque04_periodicExactAverage_adjacentSlope_of_secondBound
    (n : ℕ) [NeZero n] (f f' f'' : ℝ → ℝ)
    (u : ZMod n → ℝ) (K B2 width maxWidth : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width) (hmax : width ≤ maxWidth)
    (hstate : ∀ j : ℤ,
      leveque04_periodicLift n u j = oneDimensionalCellAverage f
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|)
    (hsecondBound : ∀ x, |f'' x| ≤ B2) :
    ∀ j : ℤ,
      |(leveque04_periodicLift n u (j + 1) -
        leveque04_periodicLift n u j) / width -
        (leveque04_periodicLift n u j -
          leveque04_periodicLift n u (j - 1)) / width| ≤
        (B2 + K * maxWidth) * width := by
  exact leveque04_periodicExactAverage_adjacentFaceSlope_bound
    n f f' f'' u K B2 width maxWidth
    hK hwidth hmax hstate hf hf' hLip
    (leveque04_lipschitz_of_bounded_derivative f' f'' B2 hf'
      hsecondBound)

end NumStability
