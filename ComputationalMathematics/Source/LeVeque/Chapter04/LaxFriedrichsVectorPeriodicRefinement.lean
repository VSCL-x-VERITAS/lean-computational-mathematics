/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicSmoothGlobal

/-!
# Fixed-period coupled-vector Lax–Friedrichs refinement

Each grid covers the same physical period, takes `n` steps of fixed
time/width ratio, and begins with exact vector cell averages. Shared
smoothness budgets and an explicitly assumed vector stability estimate
yield a mesh-independent first-order mean-error coefficient.
-/

namespace NumStability

open MeasureTheory
open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_fixedPeriodRefinement_of_l1_contract
    {m : ℕ} (q qX : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (period ratio Kspace Kflux Ktime Kjac S initialTime : ℝ)
    (times : (n : ℕ) → ℕ → ℝ)
    (approx : (n : ℕ) → ℕ → ZMod n → Fin m → ℝ)
    (hperiodPos : 0 < period) (hratio : 0 < ratio)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q flux)
    (hstart : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      times n 0 = initialTime)
    (htimes : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ k,
      times n (k + 1) = times n k + ratio * (period / (n : ℝ)))
    (hperiod : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ x,
        q (x + period) (times n k) = q x (times n k))
    (hprofile : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ x, HasDerivAt
        (fun y => q y (times n k)) (qX x (times n k)) x)
    (hprofileLip : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ x y,
        ‖qX x (times n k) - qX y (times n k)‖ ≤ Kspace * |x - y|)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hjacobianLip : ∀ u v,
      ‖jacobian u - jacobian v‖ ≤ Kjac * ‖u - v‖)
    (hfluxSlopeLip : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ c d,
      ‖jacobian
          (oneDimensionalCellAverage (fun x => q x (times n k))
            (c - (period / (n : ℝ)) / 2)
            (c + (period / (n : ℝ)) / 2))
          ((period / (n : ℝ))⁻¹ •
            (q (c + (period / (n : ℝ)) / 2) (times n k) -
              q (c - (period / (n : ℝ)) / 2) (times n k))) -
        jacobian
          (oneDimensionalCellAverage (fun x => q x (times n k))
            (d - (period / (n : ℝ)) / 2)
            (d + (period / (n : ℝ)) / 2))
          ((period / (n : ℝ))⁻¹ •
            (q (d + (period / (n : ℝ)) / 2) (times n k) -
              q (d - (period / (n : ℝ)) / 2) (times n k)))‖ ≤
        Kflux * |c - d|)
    (hfaceLeftClose : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ i : ZMod n,
      let width := period / (n : ℝ)
      let c := (i.val : ℝ) * width
      ‖q (c - width / 2) (times n k) -
        oneDimensionalCellAverage (fun x => q x (times n k))
          (c - width / 2) (c + width / 2)‖ ≤ S * width)
    (hfaceRightClose : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ i : ZMod n,
      let width := period / (n : ℝ)
      let c := (i.val : ℝ) * width
      ‖q (c + width / 2) (times n k) -
        oneDimensionalCellAverage (fun x => q x (times n k))
          (c - width / 2) (c + width / 2)‖ ≤ S * width)
    (hfluxTimeCont : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ i : ZMod n,
      let width := period / (n : ℝ)
      let c := (i.val : ℝ) * width
      Continuous (fun τ =>
        flux (q (c - width / 2) τ) -
          flux (q (c + width / 2) τ)))
    (haverageRateLip : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ i : ZMod n,
      let width := period / (n : ℝ)
      let c := (i.val : ℝ) * width
      ∀ s τ,
        ‖width⁻¹ •
            (flux (q (c - width / 2) s) -
              flux (q (c + width / 2) s)) -
          width⁻¹ •
            (flux (q (c - width / 2) τ) -
              flux (q (c + width / 2) τ))‖ ≤
          Ktime * |s - τ|)
    (hcontract : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ u v : ZMod n → Fin m → ℝ,
      (∑ i : ZMod n,
        ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio u i -
          leveque04_periodicVectorLaxFriedrichsStep n flux ratio v i‖) ≤
        ∑ i : ZMod n, ‖u i - v i‖)
    (happrox : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ k i,
      approx n (k + 1) i =
        leveque04_periodicVectorLaxFriedrichsStep n flux ratio
          (approx n k) i)
    (hinit : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ i,
      approx n 0 i =
        leveque04_periodicVectorExactCellAverage n q
          (period / (n : ℝ)) (times n 0) i) :
    ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      (∑ i : ZMod n,
        ‖approx n n i -
          leveque04_periodicVectorExactCellAverage n q
            (period / (n : ℝ)) (initialTime + ratio * period) i‖) /
          (Fintype.card (ZMod n) : ℝ) ≤
        (ratio * period) *
          ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
            ratio * (2 * (Kjac * S ^ 2))) / ratio) *
              (period / (n : ℝ)) := by
  intro n _ hn
  have hnpos : (0 : ℝ) < n := by
    exact_mod_cast (lt_of_lt_of_le (by decide : 0 < 2) hn)
  have hwidth : 0 < period / (n : ℝ) := div_pos hperiodPos hnpos
  have hnwidth : (n : ℝ) * (period / (n : ℝ)) = period := by
    field_simp
  have hper : ∀ k, k < n → ∀ x,
      q (x + (n : ℝ) * (period / (n : ℝ))) (times n k) =
        q x (times n k) := by
    intro k hk x
    simpa only [hnwidth] using hperiod n hn k hk x
  have hhorizon : (n : ℝ) * (ratio * (period / (n : ℝ))) ≤
      ratio * period := by
    rw [← mul_assoc, mul_comm (n : ℝ) ratio, mul_assoc, hnwidth]
  have htime (k : ℕ) :
      times n k = initialTime + (k : ℝ) *
        (ratio * (period / (n : ℝ))) := by
    induction k with
    | zero => simpa using hstart n hn
    | succ k ih =>
        rw [htimes n hn k, ih]
        push_cast
        ring
  have hfinal : times n n = initialTime + ratio * period := by
    rw [htime, ← mul_assoc, mul_comm (n : ℝ) ratio,
      mul_assoc, hnwidth]
  have h := leveque04_periodicVectorLaxFriedrichs_smoothFixedHorizonAccuracy_of_l1_contract
    n hn q qX flux jacobian
    (period / (n : ℝ)) ratio Kspace Kflux Ktime Kjac S
    (ratio * period) (times n) (approx n) n
    hratio hwidth hKspace hKflux hKtime hKjac hS
    hq (htimes n hn) hper (hprofile n hn) (hprofileLip n hn)
    hflux hjacobianLip (hfluxSlopeLip n hn)
    (hfaceLeftClose n hn) (hfaceRightClose n hn)
    (hfluxTimeCont n hn) (haverageRateLip n hn)
    (hcontract n hn) (happrox n hn) hhorizon
  have hzero : (∑ i : ZMod n,
      ‖approx n 0 i -
        leveque04_periodicVectorExactCellAverage n q
          (period / (n : ℝ)) (times n 0) i‖) = 0 := by
    simp [hinit n hn]
  simpa only [hzero, zero_div, zero_add, hfinal] using h

end NumStability
