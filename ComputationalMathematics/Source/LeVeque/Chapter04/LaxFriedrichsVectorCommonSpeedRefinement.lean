/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicRefinement
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorCommonSpeedStability

/-!
# Fixed-period common-speed vector Lax–Friedrichs refinement

The scalar Courant bound proves the vector stability premise for a
common-speed linear flux. The remaining hypotheses specify the smooth
periodic exact solution and shared error budgets on all grids.
-/

namespace NumStability

open MeasureTheory
open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_commonSpeed_fixedPeriodRefinement
    {m : ℕ} (q qX : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (period ratio Kspace Kflux Ktime Kjac S initialTime speed : ℝ)
    (times : (n : ℕ) → ℕ → ℝ)
    (approx : (n : ℕ) → ℕ → ZMod n → Fin m → ℝ)
    (hperiodPos : 0 < period) (hratio : 0 < ratio)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hcommon : flux = fun state => speed • state)
    (hcfl : |speed * ratio| ≤ 1)
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
  apply leveque04_periodicVectorLaxFriedrichs_fixedPeriodRefinement_of_l1_contract
    q qX flux jacobian period ratio Kspace Kflux Ktime Kjac S initialTime
    times approx hperiodPos hratio hKspace hKflux hKtime hKjac hS
    hq hstart htimes hperiod hprofile hprofileLip hflux hjacobianLip
    hfluxSlopeLip hfaceLeftClose hfaceRightClose hfluxTimeCont haverageRateLip
    ?_ happrox hinit
  intro n _ hn u v
  rw [hcommon]
  exact leveque04_periodicVectorLaxFriedrichs_commonSpeed_l1_contract
    n speed ratio hcfl u v

end NumStability
