/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Normed.Module.Convex

/-!
# Error bounds for convex combinations

Two errors in a common norm ball remain in that ball under nonnegative weights
whose sum is one. Subtracting a third error in the same ball gives a bound of
twice the radius. The estimates apply in a real seminormed vector space.
-/

namespace NumStability

/-- A convex combination of two errors, minus a third error, has norm at most
twice their common bound. No separate sign hypothesis on the radius is needed. -/
theorem norm_convexCombination_sub_le
    {E : Type*} [SeminormedAddCommGroup E] [NormedSpace ℝ E]
    (leftWeight rightWeight radius : ℝ) (leftError rightError targetError : E)
    (hleftWeight : 0 ≤ leftWeight) (hrightWeight : 0 ≤ rightWeight)
    (hweights : leftWeight + rightWeight = 1)
    (hleft : ‖leftError‖ ≤ radius) (hright : ‖rightError‖ ≤ radius)
    (htarget : ‖targetError‖ ≤ radius) :
    ‖leftWeight • leftError + rightWeight • rightError - targetError‖ ≤
      2 * radius
 := by
  have hconv :
      ‖leftWeight • leftError + rightWeight • rightError‖ ≤
        leftWeight * ‖leftError‖ + rightWeight * ‖rightError‖ := by
    simpa only [smul_eq_mul] using
      (convexOn_univ_norm (E := E)).2 (Set.mem_univ leftError)
        (Set.mem_univ rightError) hleftWeight hrightWeight hweights
  have hcomb : ‖leftWeight • leftError + rightWeight • rightError‖ ≤ radius :=
    calc
      ‖leftWeight • leftError + rightWeight • rightError‖ ≤
          leftWeight * ‖leftError‖ + rightWeight * ‖rightError‖ := hconv
      _ ≤ leftWeight * radius + rightWeight * radius :=
        add_le_add (mul_le_mul_of_nonneg_left hleft hleftWeight)
          (mul_le_mul_of_nonneg_left hright hrightWeight)
      _ = radius := by rw [← add_mul, hweights, one_mul]
  calc
    ‖leftWeight • leftError + rightWeight • rightError - targetError‖ ≤
        ‖leftWeight • leftError + rightWeight • rightError‖ + ‖targetError‖ :=
      norm_sub_le _ _
    _ ≤ radius + radius := add_le_add hcomb htarget
    _ = 2 * radius := (two_mul radius).symm

end NumStability
