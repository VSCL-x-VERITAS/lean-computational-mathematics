import Mathlib.Algebra.Group.Pointwise.Set.Basic

/-!
# Vershynin, Chapter 4, Definition 4.2.11

Source-correspondence contract for the Minkowski sum of two sets.
-/

open Set
open scoped Pointwise

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Definition 4.2.11: the
Minkowski sum consists exactly of sums of one point from each input set.
The additive formulation applies in particular to subsets of `ℝⁿ`. -/
theorem hdp_04_hdef_h4_d2_d11
    {E : Type*} [Add E] (A B : Set E) :
    A + B = {x | ∃ a ∈ A, ∃ b ∈ B, a + b = x} := by
  ext x
  simp only [Set.mem_add, Set.mem_setOf_eq]

end NumStability.HDP.Contract
