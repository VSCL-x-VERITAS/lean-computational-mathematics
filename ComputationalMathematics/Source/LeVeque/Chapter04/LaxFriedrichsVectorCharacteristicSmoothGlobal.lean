/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorCharacteristicResidual
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsVectorCharacteristicTransfer

/-!
# Conditional fixed-horizon accuracy in characteristic coordinates

The physical matrix-flux update has a smooth exact-average residual in
every characteristic coordinate. Scalar characteristic stability then
transfers those local errors across a fixed horizon. The common constants
and diagonalizing basis remain explicit.
-/

namespace NumStability

open MeasureTheory
open scoped BigOperators

theorem leveque04_periodicVectorLaxFriedrichs_smoothCharacteristicFixedHorizonAccuracy
    {m : ℕ} (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q qX : ℝ → ℝ → Fin m → ℝ)
    (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) =
      waveSpeed p • basis p)
    (jacobian : (Fin m → ℝ) →
      (Fin m → ℝ) →L[ℝ] (Fin m → ℝ))
    (width ratio Kspace Kflux Ktime Kjac S horizon : ℝ)
    (times : ℕ → ℝ)
    (approx : ℕ → ZMod n → Fin m → ℝ)
    (steps : ℕ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hcfl : ∀ p, |waveSpeed p * ratio| ≤ 1)
    (hKspace : 0 ≤ Kspace) (hKflux : 0 ≤ Kflux)
    (hKtime : 0 ≤ Ktime) (hKjac : 0 ≤ Kjac) (hS : 0 ≤ S)
    (hq : IsRectangleConservationLawSolution q coefficient.mulVec)
    (htimes : ∀ k, times (k + 1) = times k + ratio * width)
    (hperiod : ∀ k, k < steps → ∀ x,
      q (x + (n : ℝ) * width) (times k) = q x (times k))
    (hprofile : ∀ k, k < steps → ∀ x, HasDerivAt
      (fun y => q y (times k)) (qX x (times k)) x)
    (hprofileLip : ∀ k, k < steps → ∀ x y,
      ‖qX x (times k) - qX y (times k)‖ ≤ Kspace * |x - y|)
    (hflux : ∀ u, HasFDerivAt coefficient.mulVec (jacobian u) u)
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
        coefficient.mulVec (q (c - width / 2) τ) -
          coefficient.mulVec (q (c + width / 2) τ)))
    (haverageRateLip : ∀ k, k < steps → ∀ i : ZMod n,
      let c := (i.val : ℝ) * width
      ∀ s τ,
        ‖width⁻¹ •
            (coefficient.mulVec (q (c - width / 2) s) -
              coefficient.mulVec (q (c + width / 2) s)) -
          width⁻¹ •
            (coefficient.mulVec (q (c - width / 2) τ) -
              coefficient.mulVec (q (c + width / 2) τ))‖ ≤
          Ktime * |s - τ|)
    (happrox : ∀ k i, approx (k + 1) i =
      leveque04_periodicVectorLaxFriedrichsStep n coefficient.mulVec ratio (approx k) i)
    (hhorizon : (steps : ℝ) * (ratio * width) ≤ horizon) :
    let exactState : ℕ → ZMod n → Fin m → ℝ := fun k =>
      leveque04_periodicVectorExactCellAverage n q width (times k)
    (∑ p : Fin m,
      (∑ i : ZMod n,
        |basis.equivFun (approx steps i) p -
          basis.equivFun (exactState steps i) p|) /
        (Fintype.card (ZMod n) : ℝ)) ≤
      ∑ p : Fin m,
        ((∑ i : ZMod n,
          |basis.equivFun (approx 0 i) p -
            basis.equivFun (exactState 0 i) p|) /
          (Fintype.card (ZMod n) : ℝ) +
            horizon * (‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ *
              ((Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
                ratio * (2 * (Kjac * S ^ 2))) / ratio)) * width) := by
  let exactState : ℕ → ZMod n → Fin m → ℝ := fun k =>
    leveque04_periodicVectorExactCellAverage n q width (times k)
  let localBound : ℝ :=
    (Kspace + ratio * Kflux + Ktime * ratio ^ 2 +
      ratio * (2 * (Kjac * S ^ 2))) / ratio
  have hbound : 0 ≤ localBound := by
    dsimp [localBound]
    positivity
  have hlocal : ∀ k, k < steps → ∀ i p,
      |(basis.equivFun
          (leveque04_periodicVectorLaxFriedrichsStep n
            coefficient.mulVec ratio (exactState k) i) p -
        basis.equivFun (exactState (k + 1) i) p) / (ratio * width)| ≤
        ‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ *
          (localBound * width) := by
    intro k hk i p
    have h := leveque04_periodicVectorLaxFriedrichs_smoothExactBasisCoordinateResidual
      n hn q qX basis coefficient.mulVec jacobian width (times k) ratio
      Kspace Kflux Ktime Kjac S
      hratio hwidth hKspace hKflux hKtime hKjac hS
      hq (hperiod k hk) (hprofile k hk) (hprofileLip k hk)
      hflux hjacobianLip (hfluxSlopeLip k hk)
      (hfaceLeftClose k hk) (hfaceRightClose k hk)
      (hfluxTimeCont k hk) (haverageRateLip k hk) i p
    simpa only [exactState, localBound, htimes k] using h
  exact leveque04_periodicVectorLaxFriedrichs_characteristic_finiteHorizonAccuracy
    n coefficient basis waveSpeed heigen ratio (ratio * width) width
    (‖basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap‖ * localBound)
    horizon hratio.le hcfl (mul_pos hratio hwidth) hwidth
    (mul_nonneg (norm_nonneg _) hbound) approx exactState happrox steps
    (by
      intro k hk i p
      simpa only [mul_assoc] using hlocal k hk i p)
    hhorizon

end NumStability
