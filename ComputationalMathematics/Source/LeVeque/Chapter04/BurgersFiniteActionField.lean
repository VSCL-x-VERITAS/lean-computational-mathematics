/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteAction
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.QuadraticActionMinimizerOrder

/-!
# A fixed finite-action selection and its signed one-sided bound

The selected index minimizes the actual finite action menu and has largest
foot among its tied candidates. This is one fixed selection as a function of
the supplied finite data, grid, observation and time. It does not depend on an
executed duration or a propagation bound.

For nonnegative width and positive time the selected foot is a global action
minimizer over all real feet. Quadratic-action comparison then orders the feet
at strictly ordered observations and bounds the signed velocity difference.
The resulting forward quotient satisfies the strict printed one-sided form
with the single constant `E = 2`.

These are variational and pointwise inequalities only. No global-maximality
characterization among all real minimizing feet, initial trace, weak law,
entropy equivalence, wave ancestry or Godunov update theorem is asserted.
The formulas are total in time; only the positive-time conclusions below have
an action-minimization or one-sided-bound meaning. No time-zero datum convention
is imposed by division's total real definition.
-/

namespace NumStability

/-- A fixed finite minimizing index with largest foot among tied candidates. -/
noncomputable def leveque04_burgersFiniteActionMinIndex {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : Fin (N + 2) :=
  Classical.choose
    (leveque04_burgersActionCandidate_exists_largest_min old origin width x time)

theorem leveque04_burgersFiniteActionMinIndex_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (j : Fin (N + 2)) :
    leveque04_burgersActionCandidate old origin width x time
        (leveque04_burgersFiniteActionMinIndex old origin width x time) ≤
      leveque04_burgersActionCandidate old origin width x time j :=
  (Classical.choose_spec
    (leveque04_burgersActionCandidate_exists_largest_min old origin width x time)).1 j

/-- The selected foot; no duration or encountered-speed parameter is present. -/
noncomputable def leveque04_burgersFiniteActionFoot {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : ℝ :=
  leveque04_burgersClampedFoot old origin width x time
    (leveque04_burgersFiniteActionMinIndex old origin width x time)

theorem leveque04_burgersFiniteActionFoot_largest_candidate {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (j : Fin (N + 2))
    (hj : leveque04_burgersActionCandidate old origin width x time j =
      leveque04_burgersActionCandidate old origin width x time
        (leveque04_burgersFiniteActionMinIndex old origin width x time)) :
    leveque04_burgersClampedFoot old origin width x time j ≤
      leveque04_burgersFiniteActionFoot old origin width x time :=
  (Classical.choose_spec
    (leveque04_burgersActionCandidate_exists_largest_min old origin width x time)).2 j hj

theorem leveque04_burgersFiniteActionFoot_mem {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) (hwidth : 0 ≤ width) :
    leveque04_burgersActionSegment origin width
      (leveque04_burgersFiniteActionMinIndex old origin width x time)
      (leveque04_burgersFiniteActionFoot old origin width x time) :=
  leveque04_burgersClampedFoot_mem old origin width x time hwidth _

/-- The finite action minimum, evaluated at the actual fixed selected foot. -/
noncomputable def leveque04_burgersFiniteActionPotential {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : ℝ :=
  leveque04_burgersAction old origin width x time
    (leveque04_burgersFiniteActionFoot old origin width x time)

/-- The chosen finite minimizer is a true global minimizer over all real feet. -/
theorem leveque04_burgersFiniteActionFoot_global_min {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (y : ℝ) :
    leveque04_burgersAction old origin width x time
        (leveque04_burgersFiniteActionFoot old origin width x time) ≤
      leveque04_burgersAction old origin width x time y := by
  obtain ⟨j, hj⟩ := leveque04_burgersActionSegment_cover origin width hwidth y
  exact (leveque04_burgersFiniteActionMinIndex_min old origin width x time j).trans
    (leveque04_burgersActionCandidate_le old origin width x time hwidth htime j y hj)

theorem leveque04_burgersFiniteActionPotential_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (y : ℝ) :
    leveque04_burgersFiniteActionPotential old origin width x time ≤
      leveque04_burgersInitialPrimitive old origin width y + (x - y) ^ 2 / (2 * time) :=
  leveque04_burgersFiniteActionFoot_global_min old origin width x time hwidth htime y

/-- Strictly ordered observations have noncrossing selected minimizing feet.
No order of independently chosen tied feet at an equal observation is claimed. -/
theorem leveque04_burgersFiniteActionFoot_ordered {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x₁ x₂ : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (hx : x₁ < x₂) :
    leveque04_burgersFiniteActionFoot old origin width x₁ time ≤
      leveque04_burgersFiniteActionFoot old origin width x₂ time := by
  exact quadraticAction_minimizers_ordered
    (leveque04_burgersInitialPrimitive old origin width) time x₁ x₂
    (leveque04_burgersFiniteActionFoot old origin width x₁ time)
    (leveque04_burgersFiniteActionFoot old origin width x₂ time) htime hx
    (leveque04_burgersFiniteActionFoot_global_min old origin width x₁ time hwidth htime _)
    (leveque04_burgersFiniteActionFoot_global_min old origin width x₂ time hwidth htime _)

/-- Equal observations use the same fixed selection, so the selected-foot map
is monotone even in the presence of ties. -/
theorem leveque04_burgersFiniteActionFoot_monotone {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) :
    Monotone (fun x => leveque04_burgersFiniteActionFoot old origin width x time) := by
  intro x₁ x₂ hx
  rcases hx.eq_or_lt with heq | hlt
  · subst x₂
    exact le_rfl
  · exact leveque04_burgersFiniteActionFoot_ordered old origin width time x₁ x₂
      hwidth htime hlt

/-- The selected positive-time variational velocity. Its physical evolution
properties are separate proof obligations, not part of this definition. -/
noncomputable def leveque04_burgersFiniteActionVelocity {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x time : ℝ) : ℝ :=
  (x - leveque04_burgersFiniteActionFoot old origin width x time) / time

theorem leveque04_burgersFiniteActionVelocity_oneSided {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time x₁ x₂ : ℝ)
    (hwidth : 0 ≤ width) (htime : 0 < time) (hx : x₁ ≤ x₂) :
    leveque04_burgersFiniteActionVelocity old origin width x₂ time -
      leveque04_burgersFiniteActionVelocity old origin width x₁ time ≤ (x₂ - x₁) / time := by
  exact quadraticAction_selectedVelocity_oneSided
    (leveque04_burgersInitialPrimitive old origin width)
    (fun x => leveque04_burgersFiniteActionFoot old origin width x time) time htime
    (fun x y => leveque04_burgersFiniteActionFoot_global_min old origin width x time
      hwidth htime y) x₁ x₂ hx

theorem leveque04_burgersFiniteActionVelocity_forward_quotient_le {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x increment time : ℝ)
    (hwidth : 0 ≤ width) (hincrement : 0 < increment) (htime : 0 < time) :
    (leveque04_burgersFiniteActionVelocity old origin width (x + increment) time -
      leveque04_burgersFiniteActionVelocity old origin width x time) / increment ≤ 1 / time := by
  apply (div_le_iff₀ hincrement).2
  calc
    _ ≤ ((x + increment) - x) / time :=
      leveque04_burgersFiniteActionVelocity_oneSided old origin width time x (x + increment)
        hwidth htime (by linarith)
    _ = (1 / time) * increment := by ring

/-- The strict one-sided form of printed Condition 11.2, with the one fixed
constant two, for this actual selected variational velocity at positive times.
This pointwise condition alone does not assert the weak law or its converse. -/
theorem leveque04_burgersFiniteActionVelocity_oleinikCondition {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width) :
    ∃ E : ℝ, E = 2 ∧ 0 < E ∧
      ∀ x increment time : ℝ, 0 < increment → 0 < time →
        (leveque04_burgersFiniteActionVelocity old origin width (x + increment) time -
          leveque04_burgersFiniteActionVelocity old origin width x time) / increment < E / time := by
  refine ⟨2, rfl, by norm_num, ?_⟩
  intro x increment time hincrement htime
  exact lt_of_le_of_lt
    (leveque04_burgersFiniteActionVelocity_forward_quotient_le old origin width x increment time
      hwidth hincrement htime)
    (div_lt_div_of_pos_right (by norm_num : (1 : ℝ) < 2) htime)

end NumStability
