/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverage
import Mathlib.MeasureTheory.Integral.IntervalIntegral.TrapezoidalRule
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Local trapezoidal accuracy of normalized averages

Only curvature on the current interval is bounded. Outside that closed interval,
the within-derivative vanishes; no global curvature assumption is needed.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- Endpoint averaging approximates the actual normalized interval integral to
quadratic order under a local second-derivative bound. -/
theorem endpointMean_physicalAverage_error_le_of_local_c2
    (f : ℝ → ℝ) (a step bound : ℝ) (hstep : 0 < step) (hbound : 0 ≤ bound)
    (hsmooth : ContDiffOn ℝ 2 f [[a, a + step]])
    (hcurv : ∀ t ∈ Set.Icc a (a + step),
      |iteratedDerivWithin 2 f [[a, a + step]] t| ≤ bound) :
    |(f a + f (a + step)) / 2 - oneDimensionalCellAverage f a (a + step)| ≤
      bound * step ^ 2 / 12 := by
  have hu : Set.uIcc a (a + step) = Set.Icc a (a + step) :=
    Set.uIcc_of_le (by linarith)
  have hglobal (t : ℝ) : |iteratedDerivWithin 2 f [[a, a + step]] t| ≤ bound := by
    by_cases ht : t ∈ Set.Icc a (a + step)
    · exact hcurv t ht
    · have hn : ¬ AccPt t (Filter.principal (Set.uIcc a (a + step))) := by
        intro ha
        have hm : t ∈ closure (Set.uIcc a (a + step)) :=
          mem_closure_iff_clusterPt.mpr ha.clusterPt
        rw [hu, isClosed_Icc.closure_eq] at hm
        exact ht hm
      rw [iteratedDerivWithin_succ, derivWithin_zero_of_not_accPt hn]
      simpa using hbound
  have h := trapezoidal_error_le_of_c2 hsmooth hglobal (N := 1) (by norm_num)
  rw [trapezoidal_error, trapezoidal_integral_one] at h
  have hw : |a + step - a| = step := by simp [abs_of_pos hstep]
  simp only [hw, Nat.cast_one, one_pow, mul_one] at h
  have heq : (f a + f (a + step)) / 2 - oneDimensionalCellAverage f a (a + step) =
      (step / 2 * (f a + f (a + step)) - ∫ t in a..a + step, f t) / step := by
    simp only [oneDimensionalCellAverage, smul_eq_mul]
    field_simp [hstep.ne']; ring
  rw [heq, abs_div, abs_of_pos hstep]
  apply (div_le_iff₀ hstep).mpr
  have hlen : a + step - a = step := by ring
  rw [hlen] at h
  convert h using 1; ring

end NumStability
