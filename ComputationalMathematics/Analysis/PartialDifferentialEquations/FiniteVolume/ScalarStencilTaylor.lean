/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Error.Measures.ConvexCombination
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Positivity

/-!
# A scalar convex stencil Taylor-error estimate

The existing estimate is owned here without changing its public declaration.
-/

namespace NumStability

/-- The positive-speed upwind/Godunov stencil has second-order one-step
error, hence first-order normalized residual, under local second-order
Taylor bounds for the old and exact translated cell averages. -/
theorem leveque04_positiveGodunov_taylorError
    (courant width base slope current left shifted bound : ℝ)
    (hcfl : 0 ≤ courant ∧ courant ≤ 1)
    (hcurrent : |current - base| ≤ bound * width ^ 2)
    (hleft : |left - (base - width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted - (base - courant * width * slope)| ≤
      bound * width ^ 2) :
    |courant * left + (1 - courant) * current - shifted| ≤
      2 * bound * width ^ 2 := by
  have hweight : 0 ≤ 1 - courant := sub_nonneg.mpr hcfl.2
  have hweights : courant + (1 - courant) = 1 := by ring
  have hnorm := norm_convexCombination_sub_le (E := ℝ)
    courant (1 - courant) (bound * width ^ 2)
    (left - (base - width * slope)) (current - base)
    (shifted - (base - courant * width * slope))
    hcfl.1 hweight hweights
    (by simpa only [Real.norm_eq_abs] using hleft)
    (by simpa only [Real.norm_eq_abs] using hcurrent)
    (by simpa only [Real.norm_eq_abs] using hshift)
  have hidentity :
      courant * left + (1 - courant) * current - shifted =
        courant * (left - (base - width * slope)) +
          (1 - courant) * (current - base) -
          (shifted - (base - courant * width * slope)) := by ring
  rw [hidentity]
  simpa only [Real.norm_eq_abs, smul_eq_mul, mul_assoc] using hnorm



/-- A second-order Taylor bound on the two old cell averages and the exact
translated new average gives a second-order one-step error for the scalar
Lax–Friedrichs stencil at Courant number at most one. Dividing by a time
step proportional to width yields first-order local truncation. -/
theorem leveque04_laxFriedrichs_taylorError
    (courant width base slope left right shifted bound : ℝ)
    (hwidth : 0 ≤ width) (hbound : 0 ≤ bound)
    (hcfl : |courant| ≤ 1)
    (hleft : |left - (base - width * slope)| ≤ bound * width ^ 2)
    (hright : |right - (base + width * slope)| ≤ bound * width ^ 2)
    (hshift : |shifted - (base - courant * width * slope)| ≤
      bound * width ^ 2) :
    |(left + right) / 2 - courant / 2 * (right - left) - shifted| ≤
      2 * bound * width ^ 2 := by
  let radius := bound * width ^ 2
  let leftError := left - (base - width * slope)
  let rightError := right - (base + width * slope)
  let shiftError := shifted - (base - courant * width * slope)
  let leftWeight := (1 + courant) / 2
  let rightWeight := (1 - courant) / 2
  have hweights : 0 ≤ leftWeight ∧ 0 ≤ rightWeight ∧
      leftWeight + rightWeight = 1 := by
    have hc := abs_le.mp hcfl
    dsimp [leftWeight, rightWeight]
    constructor
    · linarith
    constructor <;> linarith
  have hnorm := norm_convexCombination_sub_le (E := ℝ)
    leftWeight rightWeight radius leftError rightError shiftError
    hweights.1 hweights.2.1 hweights.2.2
    (by simpa only [leftError, radius, Real.norm_eq_abs] using hleft)
    (by simpa only [rightError, radius, Real.norm_eq_abs] using hright)
    (by simpa only [shiftError, radius, Real.norm_eq_abs] using hshift)
  have hidentity :
      (left + right) / 2 - courant / 2 * (right - left) - shifted =
        leftWeight * leftError + rightWeight * rightError - shiftError := by
    dsimp [leftWeight, rightWeight, leftError, rightError, shiftError]
    ring
  rw [hidentity]
  simpa only [leftWeight, rightWeight, leftError, rightError, shiftError,
    radius, Real.norm_eq_abs, smul_eq_mul, mul_assoc] using hnorm


/-- A nonlinear physical flux changes the fixed-ratio Lax–Friedrichs
stencil by at most `ratio * fluxBound * width²` when its two interface
values have a controlled first-order linearization. The constant part
of the flux cancels between interfaces. -/
theorem leveque04_laxFriedrichs_fluxLinearizationError
    (ratio width speed fluxBase fluxBound left right fluxLeft fluxRight : ℝ)
    (hratio : 0 ≤ ratio)
    (hleft : |fluxLeft - (fluxBase + speed * left)| ≤
      fluxBound * width ^ 2)
    (hright : |fluxRight - (fluxBase + speed * right)| ≤
      fluxBound * width ^ 2) :
    |((left + right) / 2 - ratio / 2 * (fluxRight - fluxLeft)) -
      ((left + right) / 2 - speed * ratio / 2 * (right - left))| ≤
      ratio * fluxBound * width ^ 2 := by
  have hl := abs_le.mp hleft
  have hr := abs_le.mp hright
  have hratio' : 0 ≤ ratio / 2 := by positivity
  have hrUpper := mul_le_mul_of_nonneg_left hr.2 hratio'
  have hrLower := mul_le_mul_of_nonneg_left hr.1 hratio'
  have hlUpper := mul_le_mul_of_nonneg_left hl.2 hratio'
  have hlLower := mul_le_mul_of_nonneg_left hl.1 hratio'
  apply abs_le.mpr
  constructor <;> nlinarith

end NumStability
