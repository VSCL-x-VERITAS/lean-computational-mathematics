/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsSmoothFlux
import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylorApproximateSlope

/-!
# Time regularity in the nonlinear Lax–Friedrichs residual

The exact next cell average is controlled by its temporal derivative
and a width-order approximation of that derivative by the pointwise
flux derivative times the spatial average slope.
-/

namespace NumStability

/-- The exact next-average Taylor premise in the smooth-flux residual
follows from temporal regularity and a width-order PDE slope defect. -/
theorem leveque04_laxFriedrichs_smoothFluxTimeResidual
    (flux flux' : ℝ → ℝ) (ratio width time slope
      valueBound K M maxWidth Ktime D : ℝ)
    (old : ℤ → ℝ) (i : ℤ)
    (average averageTimeDeriv : ℝ → ℝ)
    (hratio : 0 < ratio) (hwidth : 0 < width)
    (hmax : width ≤ maxWidth)
    (hvalueBound : 0 ≤ valueBound)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hKtime : 0 ≤ Ktime)
    (hslope : |slope| ≤ M)
    (hcfl : |flux' (average time) * ratio| ≤ 1)
    (hfluxDeriv : ∀ y, HasDerivAt flux (flux' y) y)
    (hfluxLip : ∀ y z, |flux' y - flux' z| ≤ K * |y - z|)
    (haverageDeriv : ∀ τ, HasDerivAt average (averageTimeDeriv τ) τ)
    (haverageLip : ∀ s τ,
      |averageTimeDeriv s - averageTimeDeriv τ| ≤ Ktime * |s - τ|)
    (hPdeSlope : |averageTimeDeriv time +
      flux' (average time) * slope| ≤ D * width)
    (hbudget : Ktime * ratio ^ 2 + D * ratio ≤ valueBound)
    (hleft : |old (i - 1) -
      (average time - width * slope)| ≤ valueBound * width ^ 2)
    (hright : |old (i + 1) -
      (average time + width * slope)| ≤ valueBound * width ^ 2) :
    |(leveque04_finiteVolumeUpdate (ratio * width) width
        (fun (j : ℤ) (_ : Fin 1) => old j)
        (leveque04_localInterfaceFlux
          (leveque04_laxFriedrichsFlux (ratio * width) width
            (fun (state : Fin 1 → ℝ) (_ : Fin 1) => flux (state 0)))
          (fun (j : ℤ) (_ : Fin 1) => old j)) i 0 -
        average (time + ratio * width)) / (ratio * width)| ≤
      ((2 * valueBound + ratio * (K * (M + valueBound * maxWidth) ^ 2)) /
        ratio) * width := by
  apply leveque04_laxFriedrichs_smoothFluxTaylorResidual_of_slopeBound
    flux flux' ratio width (average time) slope
    (average (time + ratio * width)) valueBound K M maxWidth
    old i hratio hwidth hmax hvalueBound hK hM hslope hcfl
    hfluxDeriv hfluxLip hleft hright
  have htaylor := firstOrderTaylorError_le_of_approximateSlope
    average averageTimeDeriv time
    (-(flux' (average time) * slope)) ratio width Ktime D
    hratio.le hwidth.le hKtime haverageDeriv haverageLip
    (by simpa only [sub_neg_eq_add] using hPdeSlope)
  have hscaled := mul_le_mul_of_nonneg_right hbudget (sq_nonneg width)
  calc
    |average (time + ratio * width) -
        (average time - flux' (average time) * ratio * width * slope)| =
      |average (time + ratio * width) -
        (average time + -(flux' (average time) * slope) *
          (ratio * width))| := by congr 1; ring
    _ ≤ (Ktime * ratio ^ 2 + D * ratio) * width ^ 2 := htaylor
    _ ≤ valueBound * width ^ 2 := hscaled

end NumStability
