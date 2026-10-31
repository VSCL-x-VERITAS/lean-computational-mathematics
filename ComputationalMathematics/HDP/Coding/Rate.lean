import Mathlib.Analysis.SpecialFunctions.Log.Base

/-!
# Rate and error fraction of a binary code

The dimensionless parameters used to compare binary error-correcting codes.
-/

namespace NumStability.HDP.Coding

/-- The information rate `k / n` of a code encoding `k` bits into `n` bits. -/
noncomputable def codingRate (k n : ℕ) : ℝ := (k : ℝ) / (n : ℝ)

/-- The correctable-error fraction `r / n`. -/
noncomputable def errorFraction (r n : ℕ) : ℝ := (r : ℝ) / (n : ℝ)

/-- The rate-loss function `t log₂(e/t)` used in the Gilbert--Varshamov
guarantee. -/
noncomputable def rateLoss (t : ℝ) : ℝ :=
  t * Real.logb 2 (Real.exp 1 / t)

/-- The real-valued boundary in Theorem 4.3.5 rearranges exactly into the
rate threshold displayed in Remark 4.3.6. Integer rounding is deliberately
left to the code-existence theorem rather than hidden in this identity. -/
theorem lengthBoundary_div_eq_one_sub_rateLoss_two_errorFraction
    (n r : ℕ) (hn : 0 < n) (hr : 0 < r) :
    ((n : ℝ) - 2 * (r : ℝ) *
        Real.logb 2 (Real.exp 1 * (n : ℝ) / (2 * (r : ℝ)))) / (n : ℝ) =
      1 - rateLoss (2 * errorFraction r n) := by
  have hnR : (0 : ℝ) < n := by exact_mod_cast hn
  have hrR : (0 : ℝ) < r := by exact_mod_cast hr
  have harg : Real.exp 1 / (2 * ((r : ℝ) / (n : ℝ))) =
      Real.exp 1 * (n : ℝ) / (2 * (r : ℝ)) := by
    field_simp
  unfold rateLoss errorFraction
  rw [harg]
  have hn_ne : (n : ℝ) ≠ 0 := ne_of_gt hnR
  field_simp [hn_ne]

end NumStability.HDP.Coding
