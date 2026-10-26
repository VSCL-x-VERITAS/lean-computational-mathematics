/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CrankNicolsonExactAverageSlope

/-!
# Periodic exact-average slope budgets

The generic smooth face-slope estimates are specialized to the integer
lift of a finite periodic exact-average state.
-/

namespace NumStability

/-- Every face slope of a periodic exact-average state has the uniform
budget needed by approximate-coefficient CN transfer. -/
theorem leveque04_periodicExactAverage_faceSlope_bound
    (n : ℕ) [NeZero n] (f f' f'' : ℝ → ℝ)
    (u : ZMod n → ℝ) (K B width maxWidth : ℝ)
    (hK : 0 ≤ K) (hwidth : 0 < width) (hmax : width ≤ maxWidth)
    (hstate : ∀ j : ℤ,
      leveque04_periodicLift n u j = oneDimensionalCellAverage f
        ((j : ℝ) * width - width / 2)
        ((j : ℝ) * width + width / 2))
    (hf : ∀ x, HasDerivAt f (f' x) x)
    (hf' : ∀ x, HasDerivAt f' (f'' x) x)
    (hLip : ∀ x y, |f'' x - f'' y| ≤ K * |x - y|)
    (hderiv : ∀ x, |f' x| ≤ B) :
    ∀ j : ℤ,
      |(leveque04_periodicLift n u (j + 1) -
        leveque04_periodicLift n u j) / width| ≤
        B + K * maxWidth ^ 2 / 2 := by
  intro j
  let face := (j : ℝ) * width + width / 2
  have h := leveque04_exactAverage_faceSlope_bound
    f f' f'' K B face width maxWidth
    hK hwidth hmax hf hf' hLip hderiv
  rw [hstate (j + 1), hstate j]
  have hplus : oneDimensionalCellAverage f
      (((j + 1 : ℤ) : ℝ) * width - width / 2)
      (((j + 1 : ℤ) : ℝ) * width + width / 2) =
        oneDimensionalCellAverage f face (face + width) := by
    congr 1 <;> dsimp [face] <;> push_cast <;> ring
  have hzero : oneDimensionalCellAverage f
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2) =
        oneDimensionalCellAverage f (face - width) face := by
    congr 1 <;> dsimp [face] <;> ring
  simpa only [hplus, hzero] using h

/-- Adjacent slopes of the same periodic exact-average state vary by
at most a mesh-width multiple under smooth derivative bounds. -/
theorem leveque04_periodicExactAverage_adjacentFaceSlope_bound
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
    (hderivLip : ∀ x y, |f' x - f' y| ≤ B2 * |x - y|) :
    ∀ j : ℤ,
      |(leveque04_periodicLift n u (j + 1) -
        leveque04_periodicLift n u j) / width -
        (leveque04_periodicLift n u j -
          leveque04_periodicLift n u (j - 1)) / width| ≤
        (B2 + K * maxWidth) * width := by
  intro j
  let face := (j : ℝ) * width - width / 2
  have h := leveque04_exactAverage_adjacentFaceSlope_bound
    f f' f'' K B2 face width maxWidth
    hK hwidth hmax hf hf' hLip hderivLip
  rw [hstate (j + 1), hstate j, hstate (j - 1)]
  have hplus : oneDimensionalCellAverage f
      (((j + 1 : ℤ) : ℝ) * width - width / 2)
      (((j + 1 : ℤ) : ℝ) * width + width / 2) =
        oneDimensionalCellAverage f (face + width) (face + 2 * width) := by
    congr 1 <;> dsimp [face] <;> push_cast <;> ring
  have hzero : oneDimensionalCellAverage f
      ((j : ℝ) * width - width / 2)
      ((j : ℝ) * width + width / 2) =
        oneDimensionalCellAverage f face (face + width) := by
    congr 1 <;> dsimp [face] <;> ring
  have hminus : oneDimensionalCellAverage f
      (((j - 1 : ℤ) : ℝ) * width - width / 2)
      (((j - 1 : ℤ) : ℝ) * width + width / 2) =
        oneDimensionalCellAverage f (face - width) face := by
    congr 1 <;> dsimp [face] <;> push_cast <;> ring
  simpa only [hplus, hzero, hminus] using h

end NumStability
