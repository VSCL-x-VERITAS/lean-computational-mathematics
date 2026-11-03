/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovBurgersSelectedSolver

/-!
# A one-sided bound for the actual selected Burgers field

This supporting target concerns the existing all-real shock/fan construction,
including its right value at a compressive front. Its non-strict bound `1 / t`
implies the strict printed Oleinik inequality with the derived witness `E = 2`.
That witness is uniform in both states; the source itself only asks for a
constant attached to each fixed solution.

This is a pointwise bound at positive time. It does not assert a weak-solution
or entropy-solution characterization, initial-data attainment, uniqueness, or
equivalence between a rectangle law and the printed distributional definition.
The separate broad source ambiguities and the printed (11.33) defect remain
outside this target.
-/

namespace NumStability

/-- The sharp non-strict forward estimate, a convenient strict uniform witness,
and the source-order member-wise existential consequence for the actual field. -/
def Leveque04BurgersOleinikBoundTarget : Prop :=
  (∀ left right x increment time : ℝ, 0 < increment → 0 < time →
    (leveque04_burgersSelectedField left right (x + increment) time -
        leveque04_burgersSelectedField left right x time) / increment ≤ 1 / time ∧
    (leveque04_burgersSelectedField left right (x + increment) time -
        leveque04_burgersSelectedField left right x time) / increment < 2 / time) ∧
  (∃ E : ℝ, E = 2 ∧ 0 < E ∧
    ∀ left right x increment time : ℝ, 0 < increment → 0 < time →
      (leveque04_burgersSelectedField left right (x + increment) time -
          leveque04_burgersSelectedField left right x time) / increment < E / time) ∧
  (∀ left right : ℝ, ∃ E : ℝ, 0 < E ∧
    ∀ x increment time : ℝ, 0 < increment → 0 < time →
      (leveque04_burgersSelectedField left right (x + increment) time -
          leveque04_burgersSelectedField left right x time) / increment < E / time)

end NumStability
