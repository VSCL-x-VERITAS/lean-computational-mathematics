/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPdeSlope

/-!
# Nonlinear Lax–Friedrichs residual on an exact scalar solution

The temporal slope of an exact rectangle-conserving solution is the
physical-flux secant. Smooth flux and nearby face states make the
linearization defect first order in width. This combines with temporal
and neighboring spatial Taylor estimates to bound the actual stencil.
-/

namespace NumStability

/-- A smooth exact scalar rectangle solution has a first-order
time-normalized nonlinear Lax–Friedrichs local residual, under uniform
temporal, spatial, and CFL bounds. -/
theorem leveque04_laxFriedrichs_exactSolution_localResidual
    (q : ℝ → ℝ → Fin 1 → ℝ) (flux flux' : ℝ → ℝ)
    (a b time ratio valueBound K S M maxWidth Ktime : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
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
    (hleft : |old (i - 1) -
      ((oneDimensionalCellAverage (fun x => q x time) a b) 0 -
        (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
          valueBound * (b - a) ^ 2)
    (hright : |old (i + 1) -
      ((oneDimensionalCellAverage (fun x => q x time) a b) 0 +
        (b - a) * ((q b time 0 - q a time 0) / (b - a)))| ≤
          valueBound * (b - a) ^ 2) :
    |(leveque04_finiteVolumeUpdate (ratio * (b - a)) (b - a)
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * (b - a)) (b - a)
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => flux (state 0)))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
        (oneDimensionalCellAverage
          (fun x => q x (time + ratio * (b - a))) a b) 0) /
        (ratio * (b - a))| ≤
      ((2 * valueBound + ratio *
        (K * (M + valueBound * maxWidth) ^ 2)) / ratio) * (b - a) := by
  let average : ℝ → ℝ := fun τ =>
    (oneDimensionalCellAverage (fun x => q x τ) a b) 0
  let rate : ℝ → ℝ := fun τ =>
    (flux (q a τ 0) - flux (q b τ 0)) / (b - a)
  have htime : ∀ τ, HasDerivAt average (rate τ) τ := by
    intro τ
    exact leveque04_scalarCellAverage_hasDerivAt_time
      q flux a b τ hq hcont
  have hpde := leveque04_scalarCellAverage_pdeSlopeDefect
    q flux flux' a b time K S hwidth hK hS
    hfluxDeriv hfluxLip hfaceLeft hfaceRight
  have h := leveque04_laxFriedrichs_smoothFluxTimeResidual
    flux flux' ratio (b - a) time
    ((q b time 0 - q a time 0) / (b - a))
    valueBound K M maxWidth Ktime (2 * (K * S ^ 2))
    old i average rate hratio hwidth hmax hvalueBound hK hM
    hKtime hslope hcfl hfluxDeriv hfluxLip htime
    haverageRateLip hpde hbudget hleft hright
  exact h

end NumStability
