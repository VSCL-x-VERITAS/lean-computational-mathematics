/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorCharacteristicSmoothGlobal

/-!
# Fixed-period characteristic Lax–Friedrichs refinement

A single diagonalizing basis, CFL condition, and smoothness budgets serve
all grids. The conclusion retains the number of characteristic coordinates
and the basis conditioning explicitly.
-/

namespace NumStability

open MeasureTheory
open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_characteristic_fixedPeriodRefinement
    {m : ℕ} (q qX : ℝ → ℝ → Fin m → ℝ)
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) =
      waveSpeed p • basis p)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (period ratio Kspace Kflux Ktime Kjac S initialTime : ℝ)
    (times : (n : ℕ) → ℕ → ℝ)
    (approx : (n : ℕ) → ℕ → ZMod n → Fin m → ℝ)
    (hperiodPos : 0 < period) (hratio : 0 < ratio)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hq : IsRectangleConservationLawSolution q coefficient.mulVec)
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
    (hflux : ∀ u, HasFDerivAt coefficient.mulVec (jacobian u) u)
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
        coefficient.mulVec (q (c - width / 2) τ) -
          coefficient.mulVec (q (c + width / 2) τ)))
    (haverageRateLip : ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      ∀ k, k < n → ∀ i : ZMod n,
      let width := period / (n : ℝ)
      let c := (i.val : ℝ) * width
      ∀ s τ,
        ‖width⁻¹ •
            (coefficient.mulVec (q (c - width / 2) s) -
              coefficient.mulVec (q (c + width / 2) s)) -
          width⁻¹ •
            (coefficient.mulVec (q (c - width / 2) τ) -
              coefficient.mulVec (q (c + width / 2) τ))‖ ≤
          Ktime * |s - τ|)
    (happrox : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ k i,
      approx n (k + 1) i =
        leveque04_periodicVectorLaxFriedrichsStep n coefficient.mulVec ratio
          (approx n k) i)
    (hinit : ∀ (n : ℕ) [NeZero n], 2 ≤ n → ∀ i,
      approx n 0 i =
        leveque04_periodicVectorExactCellAverage n q
          (period / (n : ℝ)) (times n 0) i) :
    ∀ (n : ℕ) [NeZero n], 2 ≤ n →
      (∑ p : Fin m,
        (∑ i : ZMod n,
          |basis.equivFun (approx n n i) p -
            basis.equivFun
              (leveque04_periodicVectorExactCellAverage n q
                (period / (n : ℝ)) (initialTime + ratio * period) i) p|) /
          (Fintype.card (ZMod n) : ℝ)) ≤
        ∑ _p : Fin m,
          (ratio * period) *
            (‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ *
              ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
                ratio * (2 * (Kjac * S ^ 2))) / ratio)) *
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
  have h := leveque04_periodicVectorLaxFriedrichs_smoothCharacteristicFixedHorizonAccuracy
    n hn q qX coefficient basis waveSpeed heigen jacobian
    (period / (n : ℝ)) ratio Kspace Kflux Ktime Kjac S
    (ratio * period) (times n) (approx n) n
    hratio hwidth hcfl hKspace hKflux hKtime hKjac hS
    hq (htimes n hn) hper (hprofile n hn) (hprofileLip n hn)
    hflux hjacobianLip (hfluxSlopeLip n hn)
    (hfaceLeftClose n hn) (hfaceRightClose n hn)
    (hfluxTimeCont n hn) (haverageRateLip n hn)
    (happrox n hn) hhorizon
  have hzero (p : Fin m) : (∑ i : ZMod n,
      |basis.equivFun (approx n 0 i) p -
        basis.equivFun
          (leveque04_periodicVectorExactCellAverage n q
            (period / (n : ℝ)) (times n 0) i) p|) = 0 := by
    simp [hinit n hn]
  simpa only [hzero, zero_div, zero_add, hfinal] using h

end NumStability
