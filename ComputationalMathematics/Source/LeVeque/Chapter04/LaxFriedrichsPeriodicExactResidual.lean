/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicBridge
import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsExactSolution

/-!
# Exact-solution residual for the periodic nonlinear stencil

The local residual theorem for a scalar rectangle solution applies to
the actual periodic Lax–Friedrichs step once its two neighboring states
are the old exact cell averages and satisfy their Taylor bounds.
-/

namespace NumStability

/-- The periodic nonlinear stencil has the exact-solution local
first-order residual at one selected cell under the explicit smoothness
and neighbor-average hypotheses. -/
theorem leveque04_periodicNonlinearLaxFriedrichs_exactLocalResidual
    (n : ℕ) [NeZero n]
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux flux' : ℝ → ℝ)
    (a b time ratio valueBound K S M maxWidth Ktime : ℝ)
    (u : ZMod n → ℝ) (i : ZMod n)
    (hwidth : 0 < b - a) (hratio : 0 < ratio)
    (hmax : b - a ≤ maxWidth)
    (hvalueBound : 0 ≤ valueBound)
    (hK : 0 ≤ K) (hS : 0 ≤ S) (hM : 0 ≤ M)
    (hKtime : 0 ≤ Ktime)
    (hq : IsRectangleConservationLawSolution q
      (fun state _ => flux (state 0)))
    (hcont : Continuous (fun τ => flux (q a τ 0) - flux (q b τ 0)))
    (hfluxDeriv : ∀ y, HasDerivAt flux (flux' y) y)
    (hfluxLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (haverageRateLip : ∀ s τ,
      |(flux (q a s 0) - flux (q b s 0)) / (b - a) -
        (flux (q a τ 0) - flux (q b τ 0)) / (b - a)| ≤
        Ktime * |s - τ|)
    (hfaceLeft : |q a time 0 -
      (oneDimensionalCellAverage (fun x => q x time) a b) 0| ≤
        S * (b - a))
    (hfaceRight : |q b time 0 -
      (oneDimensionalCellAverage (fun x => q x time) a b) 0| ≤
        S * (b - a))
    (hslope : |(q b time 0 - q a time 0) / (b - a)| ≤ M)
    (hcfl : |flux' ((oneDimensionalCellAverage
      (fun x => q x time) a b) 0) * ratio| ≤ 1)
    (hbudget : Ktime * ratio ^ 2 +
      (2 * (K * S ^ 2)) * ratio ≤ valueBound)
    (hleft : |u (i - 1) -
      ((oneDimensionalCellAverage (fun x => q x time) a b) 0 -
        (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
          valueBound * (b - a) ^ 2)
    (hright : |u (i + 1) -
      ((oneDimensionalCellAverage (fun x => q x time) a b) 0 +
        (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
          valueBound * (b - a) ^ 2) :
    |(leveque04_periodicNonlinearLaxFriedrichsStep n flux ratio u i -
        (oneDimensionalCellAverage
          (fun x => q x (time + ratio * (b - a))) a b) 0) /
        (ratio * (b - a))| ≤
      ((2 * valueBound + ratio *
        (K * (M + valueBound * maxWidth) ^ 2)) / ratio) * (b - a) := by
  let old : ℤ → Fin 1 → ℝ := fun j _ =>
    if j = -1 then u (i - 1) else u (i + 1)
  have hleft' : |old (-1) 0 -
      ((oneDimensionalCellAverage (fun x => q x time) a b) 0 -
        (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
          valueBound * (b - a) ^ 2 := by
    simpa [old] using hleft
  have hright' : |old 1 0 -
      ((oneDimensionalCellAverage (fun x => q x time) a b) 0 +
        (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
          valueBound * (b - a) ^ 2 := by
    simpa [old] using hright
  have h := leveque04_laxFriedrichs_exactSolution_localResidual
    q flux flux' a b time ratio valueBound K S M maxWidth Ktime
    (fun j => old j 0) 0 hwidth hratio hmax hvalueBound
    hK hS hM hKtime hq hcont hfluxDeriv hfluxLip
    haverageRateLip hfaceLeft hfaceRight hslope hcfl hbudget
    (by simpa [old] using hleft')
    (by simpa [old] using hright')
  have hbridge := leveque04_periodicNonlinearLaxFriedrichs_eq_equation20
    n flux ratio (b - a) hratio hwidth u i
  simpa only [old] using hbridge ▸ h

end NumStability
