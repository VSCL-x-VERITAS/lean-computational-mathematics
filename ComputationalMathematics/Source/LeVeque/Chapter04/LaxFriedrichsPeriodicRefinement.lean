/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicSmoothGlobal

/-!
# Uniform fixed-period refinement for periodic scalar Lax–Friedrichs

All meshes cover the same physical period. Their cell widths are the
period divided by the cell count, and their first `n` time steps reach
the same physical time. The smoothness and stability constants are
independent of the cell count.
-/

namespace NumStability

/-- A fixed physical period and mesh-independent smoothness constants
give a uniform first-order mean error along periodic refinements,
starting each mesh from its exact cell averages. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_fixedPeriodRefinement
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux flux' : ℝ → ℝ)
    (profileDeriv : (n : ℕ) → ℕ → ℝ → ℝ)
    (period ratio L Kspace K S M maxWidth Ktime : ℝ)
    (times : (n : ℕ) → ℕ → ℝ)
    (a b : (n : ℕ) → ZMod n → ℝ)
    (approx : (n : ℕ) → ℕ → ZMod n → ℝ)
    (hperiodPos : 0 < period) (hratio : 0 < ratio)
    (hcflGlobal : ratio * L ≤ 1)
    (hfluxGlobal : ∀ x y, |flux x - flux y| ≤ L * |x - y|)
    (hKspace : 0 ≤ Kspace) (hK : 0 ≤ K)
    (hS : 0 ≤ S) (hM : 0 ≤ M) (hKtime : 0 ≤ Ktime)
    (hbudget : Ktime * ratio ^ 2 +
      (2 * (K * S ^ 2)) * ratio ≤ Kspace)
    (hmax : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      period / (n : ℝ) ≤ maxWidth)
    (ha : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ i,
      a n i = (i.val : ℝ) * (period / (n : ℝ)) -
        (period / (n : ℝ)) / 2)
    (hb : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ i,
      b n i = (i.val : ℝ) * (period / (n : ℝ)) +
        (period / (n : ℝ)) / 2)
    (htimes : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ k,
      times n (k + 1) = times n k + ratio * (period / (n : ℝ)))
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ x,
        q (x + period) (times n k) 0 = q x (times n k) 0)
    (hprofile : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ x, HasDerivAt
        (fun y => q y (times n k) 0) (profileDeriv n k x) x)
    (hspaceLip : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ x y,
        |profileDeriv n k x - profileDeriv n k y| ≤ Kspace * |x - y|)
    (hfluxDeriv : ∀ y, HasDerivAt flux (flux' y) y)
    (hfluxLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (hcell : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ i,
      Continuous (fun τ => flux (q (a n i) τ 0) - flux (q (b n i) τ 0)) ∧
      (∀ s τ,
        |(flux (q (a n i) s 0) - flux (q (b n i) s 0)) /
            (period / (n : ℝ)) -
          (flux (q (a n i) τ 0) - flux (q (b n i) τ 0)) /
            (period / (n : ℝ))| ≤ Ktime * |s - τ|) ∧
      |q (a n i) (times n k) 0 -
        (oneDimensionalCellAverage (fun x => q x (times n k))
          (a n i) (b n i)) 0| ≤ S * (period / (n : ℝ)) ∧
      |q (b n i) (times n k) 0 -
        (oneDimensionalCellAverage (fun x => q x (times n k))
          (a n i) (b n i)) 0| ≤ S * (period / (n : ℝ)) ∧
      |(q (b n i) (times n k) 0 - q (a n i) (times n k) 0) /
          (period / (n : ℝ))| ≤ M ∧
      |flux' ((oneDimensionalCellAverage
        (fun x => q x (times n k)) (a n i) (b n i)) 0) * ratio| ≤ 1)
    (happrox : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ k i,
      approx n (k + 1) i =
        leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
          (approx n k) i)
    (hinit : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ i,
      approx n 0 i =
        leveque04_periodicScalarExactCellAverage n q
          (period / (n : ℝ)) (times n 0) i) :
    ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      (∑ i : ZMod n,
        |approx n n i -
          leveque04_periodicScalarExactCellAverage n q
            (period / (n : ℝ)) (times n n) i|) /
          (Fintype.card (ZMod n) : ℝ) ≤
        (ratio * period) *
          ((2 * Kspace + ratio *
            (K * (M + Kspace * maxWidth) ^ 2)) / ratio) *
              (period / (n : ℝ)) := by
  intro n _ hn
  have hnpos : (0 : ℝ) < n := by exact_mod_cast (lt_of_lt_of_le (by decide : 0 < 2) hn)
  have hwidth : 0 < period / (n : ℝ) := div_pos hperiodPos hnpos
  have hnwidth : (n : ℝ) * (period / (n : ℝ)) = period := by
    field_simp
  have hper : ∀ k, k < n → ∀ x,
      q (x + (n : ℝ) * (period / (n : ℝ))) (times n k) 0 =
        q x (times n k) 0 := by
    intro k hk x
    simpa only [hnwidth] using hperiod n hn k hk x
  have hhorizon : (n : ℝ) * (ratio * (period / (n : ℝ))) ≤
      ratio * period := by
    rw [← mul_assoc, mul_comm (n : ℝ) ratio, mul_assoc, hnwidth]
  have h := leveque04_periodicNonlinearLaxFriedrichs_smoothFixedHorizonAccuracy
    n hn q flux flux' (profileDeriv n)
    (period / (n : ℝ)) ratio L Kspace K S M maxWidth Ktime
    (ratio * period) (times n) (a n) (b n) (approx n) n
    hwidth hratio hcflGlobal hfluxGlobal (hmax n hn)
    hKspace hK hS hM hKtime hbudget
    (ha n hn) (hb n hn) (htimes n hn) hq hper
    (hprofile n hn) (hspaceLip n hn) hfluxDeriv hfluxLip
    (hcell n hn) (happrox n hn) hhorizon
  have hzero : (∑ i : ZMod n,
      |approx n 0 i -
        leveque04_periodicScalarExactCellAverage n q
          (period / (n : ℝ)) (times n 0) i|) = 0 := by
    simp [hinit n hn]
  simpa only [hzero, zero_div, zero_add] using h

end NumStability
