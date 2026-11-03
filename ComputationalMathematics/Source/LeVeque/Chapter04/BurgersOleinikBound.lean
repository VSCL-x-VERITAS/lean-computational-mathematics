/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersOleinikBoundTarget
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# One-sided forward bound for the selected Burgers field

The ascending branch uses the existing clamp's Lipschitz bound; the compressive
branch is nonincreasing, including its specified value at the front.
-/

namespace NumStability

private theorem burgersSelectedField_forward_difference_le
    (left right x increment time : ℝ) (hincrement : 0 < increment) (htime : 0 < time) :
    leveque04_burgersSelectedField left right (x + increment) time -
      leveque04_burgersSelectedField left right x time ≤ increment / time := by
  by_cases horder : left ≤ right
  · have h := (leveque04_burgersRarefactionProfile_lipschitz left right).le_add_mul
      ((x + increment) / time) (x / time)
    have hray : (x + increment) / time - x / time = increment / time := by ring
    simp only [NNReal.coe_one, one_mul, Real.dist_eq, hray,
      abs_of_pos (div_pos hincrement htime)] at h
    simp only [leveque04_burgersSelectedField, if_pos horder,
      leveque04_burgersRarefactionGlobalCandidate_positive left right
        (x + increment) time htime,
      leveque04_burgersRarefactionGlobalCandidate_positive left right x time htime,
      leveque04_burgersRarefactionForward]
    linarith
  · have hnonincreasing :
        travelingWave (riemannData left right right) ((left + right) / 2)
          (x + increment) time ≤
        travelingWave (riemannData left right right) ((left + right) / 2) x time := by
      simp only [travelingWave, riemannData, ite_self]
      split_ifs <;> linarith [le_of_not_ge horder]
    simp only [leveque04_burgersSelectedField, if_neg horder]
    linarith [div_pos hincrement htime]

/-- The sharp forward estimate holds for all real state pairs. -/
theorem leveque04_burgersSelectedField_forward_quotient_le
    (left right x increment time : ℝ) (hincrement : 0 < increment) (htime : 0 < time) :
    (leveque04_burgersSelectedField left right (x + increment) time -
      leveque04_burgersSelectedField left right x time) / increment ≤ 1 / time := by
  apply (div_le_iff₀ hincrement).2
  calc
    _ ≤ increment / time :=
      burgersSelectedField_forward_difference_le left right x increment time hincrement htime
    _ = (1 / time) * increment := by ring

/-- The explicit state-independent constant two gives the strict source bound. -/
theorem leveque04_burgersSelectedField_forward_quotient_lt
    (left right x increment time : ℝ) (hincrement : 0 < increment) (htime : 0 < time) :
    (leveque04_burgersSelectedField left right (x + increment) time -
      leveque04_burgersSelectedField left right x time) / increment < 2 / time := by
  exact lt_of_le_of_lt
    (leveque04_burgersSelectedField_forward_quotient_le left right x increment time
      hincrement htime)
    (div_lt_div_of_pos_right (by norm_num : (1 : ℝ) < 2) htime)

/-- Exact source-facing bound, uniform witness and member-wise consequence. -/
theorem leveque04_burgersOleinikBound : Leveque04BurgersOleinikBoundTarget := by
  refine ⟨?_, ⟨2, rfl, by norm_num, ?_⟩, ?_⟩
  · intro left right x increment time hincrement htime
    exact ⟨leveque04_burgersSelectedField_forward_quotient_le left right x increment time
      hincrement htime,
      leveque04_burgersSelectedField_forward_quotient_lt left right x increment time
        hincrement htime⟩
  · intro left right x increment time hincrement htime
    exact leveque04_burgersSelectedField_forward_quotient_lt left right x increment time
      hincrement htime
  · intro left right
    refine ⟨2, by norm_num, ?_⟩
    intro x increment time hincrement htime
    exact leveque04_burgersSelectedField_forward_quotient_lt left right x increment time
      hincrement htime

end NumStability
