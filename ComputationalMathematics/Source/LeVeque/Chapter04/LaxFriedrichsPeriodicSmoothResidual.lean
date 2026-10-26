/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicCellAverages
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicExactResidual

/-!
# Local nonlinear residual on the exact periodic scalar state

The exact periodic cell-average state supplies the neighbor Taylor
bounds needed by the source stencil's local residual theorem.
-/

namespace NumStability

/-- At every selected periodic cell, the actual nonlinear Lax–Friedrichs
step has a first-order normalized residual against the exact scalar
cell average under explicit mesh-uniform smoothness and CFL bounds. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_smoothExactResidual
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux flux' profileDeriv : ℝ → ℝ)
    (a b width time ratio Kspace K S M maxWidth Ktime : ℝ)
    (i : ZMod n)
    (ha : a = (i.val : ℝ) * width - width / 2)
    (hb : b = (i.val : ℝ) * width + width / 2)
    (hwidth : 0 < width) (hratio : 0 < ratio)
    (hmax : width ≤ maxWidth)
    (hKspace : 0 ≤ Kspace) (hK : 0 ≤ K)
    (hS : 0 ≤ S) (hM : 0 ≤ M) (hKtime : 0 ≤ Ktime)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hperiod : ∀ x, q (x + (n : ℝ) * width) time 0 = q x time 0)
    (hprofile : ∀ x, HasDerivAt
      (fun y => q y time 0) (profileDeriv x) x)
    (hspaceLip : ∀ x y,
      |profileDeriv x - profileDeriv y| ≤ Kspace * |x - y|)
    (hcont : Continuous (fun τ => flux (q a τ 0) - flux (q b τ 0)))
    (hfluxDeriv : ∀ y, HasDerivAt flux (flux' y) y)
    (hfluxLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (haverageRateLip : ∀ s τ,
      |(flux (q a s 0) - flux (q b s 0)) / width -
        (flux (q a τ 0) - flux (q b τ 0)) / width| ≤
        Ktime * |s - τ|)
    (hfaceLeft : |q a time 0 -
      (oneDimensionalCellAverage (fun x => q x time) a b) 0| ≤
        S * width)
    (hfaceRight : |q b time 0 -
      (oneDimensionalCellAverage (fun x => q x time) a b) 0| ≤
        S * width)
    (hslope : |(q b time 0 - q a time 0) / width| ≤ M)
    (hcfl : |flux' ((oneDimensionalCellAverage
      (fun x => q x time) a b) 0) * ratio| ≤ 1)
    (hbudget : Ktime * ratio ^ 2 +
      (2 * (K * S ^ 2)) * ratio ≤ Kspace) :
    let exactState := leveque04_periodicScalarExactCellAverage n q width
    |(leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio
        (exactState time) i -
        exactState (time + ratio * width) i) / (ratio * width)| ≤
      ((2 * Kspace + ratio *
        (K * (M + Kspace * maxWidth) ^ 2)) / ratio) * width := by
  have hwidthEq : b - a = width := by rw [ha, hb]; ring
  have hneighbor := leveque04_periodicScalarExactCellAverage_neighborTaylor
    n hn q flux profileDeriv Kspace width time hKspace hwidth
    hq hperiod hprofile hspaceLip i
  dsimp only at hneighbor
  have hcenter :
      leveque04_periodicScalarExactCellAverage n q width time i =
      (oneDimensionalCellAverage (fun x => q x time) a b) 0 := by
    simp only [leveque04_periodicScalarExactCellAverage,
      periodicGridSample, ha, hb]
  have hslopeEq :
      (q b time 0 - q a time 0) / (b - a) =
      (q ((i.val : ℝ) * width + width / 2) time 0 -
        q ((i.val : ℝ) * width - width / 2) time 0) / width := by
    rw [hwidthEq, ha, hb]
  have hleft :
      |leveque04_periodicScalarExactCellAverage n q width time (i - 1) -
        ((oneDimensionalCellAverage (fun x => q x time) a b) 0 -
          (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
        Kspace * (b - a) ^ 2 := by
    rw [hslopeEq, hwidthEq, ← hcenter]
    exact hneighbor.1
  have hright :
      |leveque04_periodicScalarExactCellAverage n q width time (i + 1) -
        ((oneDimensionalCellAverage (fun x => q x time) a b) 0 +
          (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
        Kspace * (b - a) ^ 2 := by
    rw [hslopeEq, hwidthEq, ← hcenter]
    exact hneighbor.2
  have hlocal := leveque04_periodicNonlinearLaxFriedrichs_exactLocalResidual
    n q flux flux' a b time ratio Kspace K S M maxWidth Ktime
    (leveque04_periodicScalarExactCellAverage n q width time) i
    (by rw [hwidthEq]; exact hwidth) hratio
    (by rw [hwidthEq]; exact hmax)
    hKspace hK hS hM hKtime hq hcont hfluxDeriv hfluxLip
    (by simpa only [hwidthEq] using haverageRateLip)
    (by simpa only [hwidthEq] using hfaceLeft)
    (by simpa only [hwidthEq] using hfaceRight)
    (by simpa only [hwidthEq] using hslope)
    hcfl hbudget hleft hright
  have hnext :
      leveque04_periodicScalarExactCellAverage n q width
        (time + ratio * width) i =
      (oneDimensionalCellAverage
        (fun x => q x (time + ratio * width)) a b) 0 := by
    simp only [leveque04_periodicScalarExactCellAverage,
      periodicGridSample, ha, hb]
  simpa only [hwidthEq, ← hnext] using hlocal

end NumStability
