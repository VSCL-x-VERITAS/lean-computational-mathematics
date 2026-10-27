/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicResidual
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorPeriodicTransfer

/-!
# Conditional fixed-horizon accuracy of the coupled-vector stencil

Uniform smooth exact-solution residuals at all periodic cells and forward
steps compose with an explicit vector L¹ stability hypothesis. The
conclusion controls the actual equation-(4.20) iterate over a fixed time
horizon, with one coefficient independent of the number of cells and steps.
-/

namespace NumStability

open MeasureTheory
open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_smoothFixedHorizonAccuracy_of_l1_contract
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q qX : ℝ → ℝ → Fin m → ℝ)
    (flux : (Fin m → ℝ) → Fin m → ℝ)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (width ratio Kspace Kflux Ktime Kjac S horizon : ℝ)
    (times : ℕ → ℝ)
    (approx : ℕ → ZMod n → Fin m → ℝ)
    (steps : ℕ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q flux)
    (htimes : ∀ k, times (k + 1) = times k + ratio * width)
    (hperiod : ∀ k, k < steps → ∀ x,
      q (x + (n : ℝ) * width) (times k) = q x (times k))
    (hprofile : ∀ k, k < steps → ∀ x, HasDerivAt
      (fun y => q y (times k)) (qX x (times k)) x)
    (hprofileLip : ∀ k, k < steps → ∀ x y,
      ‖qX x (times k) - qX y (times k)‖ ≤ Kspace * |x - y|)
    (hflux : ∀ u, HasFDerivAt flux (jacobian u) u)
    (hjacobianLip : ∀ u v,
      ‖jacobian u - jacobian v‖ ≤ Kjac * ‖u - v‖)
    (hfluxSlopeLip : ∀ k, k < steps → ∀ c d,
      ‖jacobian
          (oneDimensionalCellAverage (fun x => q x (times k))
            (c - width / 2) (c + width / 2))
          (width⁻¹ •
            (q (c + width / 2) (times k) - q (c - width / 2) (times k))) -
        jacobian
          (oneDimensionalCellAverage (fun x => q x (times k))
            (d - width / 2) (d + width / 2))
          (width⁻¹ •
            (q (d + width / 2) (times k) - q (d - width / 2) (times k)))‖ ≤
        Kflux * |c - d|)
    (hfaceLeftClose : ∀ k, k < steps → ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ‖q (c - width / 2) (times k) -
        oneDimensionalCellAverage (fun x => q x (times k))
          (c - width / 2) (c + width / 2)‖ ≤ S * width)
    (hfaceRightClose : ∀ k, k < steps → ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ‖q (c + width / 2) (times k) -
        oneDimensionalCellAverage (fun x => q x (times k))
          (c - width / 2) (c + width / 2)‖ ≤ S * width)
    (hfluxTimeCont : ∀ k, k < steps → ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      Continuous (fun τ =>
        flux (q (c - width / 2) τ) -
          flux (q (c + width / 2) τ)))
    (haverageRateLip : ∀ k, k < steps → ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ∀ s τ,
        ‖width⁻¹ •
            (flux (q (c - width / 2) s) -
              flux (q (c + width / 2) s)) -
          width⁻¹ •
            (flux (q (c - width / 2) τ) -
              flux (q (c + width / 2) τ))‖ ≤
          Ktime * |s - τ|)
    (hcontract : ∀ u v : ZMod n → Fin m → ℝ,
      (∑ i : ZMod n,
        ‖leveque04_periodicVectorLaxFriedrichsStep n flux ratio u i -
          leveque04_periodicVectorLaxFriedrichsStep n flux ratio v i‖) ≤
        ∑ i : ZMod n, ‖u i - v i‖)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicVectorLaxFriedrichsStep n flux ratio (approx k) i)
    (hhorizon : (steps : ℝ) * (ratio * width) ≤ horizon) :
    let exactState : ℕ → ZMod n → Fin m → ℝ := fun k =>
      leveque04_periodicVectorExactCellAverage n q width (times k)
    (∑ i : ZMod n, ‖approx steps i - exactState steps i‖) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n, ‖approx 0 i - exactState 0 i‖) /
        (Fintype.card (ZMod n) : ℝ) +
      horizon *
        ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
          ratio * (2 * (Kjac * S ^ 2))) / ratio) * width := by
  let exactState : ℕ → ZMod n → Fin m → ℝ := fun k =>
    leveque04_periodicVectorExactCellAverage n q width (times k)
  let localBound : ℝ :=
    (Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
      ratio * (2 * (Kjac * S ^ 2))) / ratio
  have hbound : 0 ≤ localBound := by
    dsimp [localBound]
    positivity
  have hlocal : ∀ k, k < steps → ∀ i,
      ‖(ratio * width)⁻¹ •
          (leveque04_periodicVectorLaxFriedrichsStep n flux ratio
            (exactState k) i - exactState (k + 1) i)‖ ≤
        localBound * width := by
    intro k hk i
    have h := leveque04_periodicVectorLaxFriedrichs_smoothExactResidual
      n hn q qX flux jacobian width (times k) ratio
      Kspace Kflux Ktime Kjac S
      hratio hwidth hKspace hKflux hKtime hKjac hS
      hq (hperiod k hk) (hprofile k hk) (hprofileLip k hk)
      hflux hjacobianLip (hfluxSlopeLip k hk)
      (hfaceLeftClose k hk) (hfaceRightClose k hk)
      (hfluxTimeCont k hk) (haverageRateLip k hk) i
    simpa only [exactState, localBound, htimes k] using h
  exact leveque04_periodicVectorLaxFriedrichs_finiteHorizonAccuracy_of_l1_contract
    n flux ratio (ratio * width) width localBound horizon
    (mul_pos hratio hwidth) hwidth.le hbound hcontract
    approx exactState happrox steps hlocal hhorizon

end NumStability
