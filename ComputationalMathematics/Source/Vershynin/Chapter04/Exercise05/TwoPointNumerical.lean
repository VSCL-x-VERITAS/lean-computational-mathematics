import ComputationalMathematics.HDP.Metric.PackingPair
import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise05.Contract

/-!
# Numerical two-point packing obstruction

The existing Exercise 4.2.5(b) witness has packing count one and an attained
disjoint-ball count two. This concrete witness supplies the independently
selected existential numerical discrepancy; its metric is not a restriction
on that existential target.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Numerical refinement of the existing Exercise 4.2.5(b) witness: the
packing number is one, while two disjoint closed half-radius balls are
attainable and every family of centers in the same pair has size at most two. -/
theorem exists_exercise425_two_point_numerical_packing_obstruction :
    ∃ x y : HDPExercise425TwoPoint,
      ({x, y} : Set HDPExercise425TwoPoint).Finite ∧
      ({x, y} : Set HDPExercise425TwoPoint).encard = 2 ∧
      Metric.packingNumber (1 : ℝ≥0) ({x, y} : Set HDPExercise425TwoPoint) = 1 ∧
      ({x, y} : Set HDPExercise425TwoPoint).Pairwise
        (fun a b ↦ Disjoint (Metric.closedBall a (1 / 2 : ℝ))
          (Metric.closedBall b (1 / 2 : ℝ))) ∧
      ∀ C ⊆ ({x, y} : Set HDPExercise425TwoPoint), C.encard ≤ 2 := by
  have hex : ∃ x y : HDPExercise425TwoPoint,
      Disjoint (Metric.closedBall x (1 / 2 : ℝ))
        (Metric.closedBall y (1 / 2 : ℝ)) ∧
      ¬ Metric.IsSeparated (1 : ℝ≥0) ({x, y} : Set HDPExercise425TwoPoint) :=
    ⟨_, _, hdp_04_hex_h4_d2_d5_b⟩
  obtain ⟨x, y, hballs, hsep⟩ := hex
  have hxy : x ≠ y := by
    rintro rfl
    have hx : x ∈ Metric.closedBall x (1 / 2 : ℝ) := by simp
    exact Set.disjoint_left.mp hballs hx hx
  refine ⟨x, y, (by simp), Set.encard_pair hxy,
    NumStability.HDP.Metric.packingNumber_pair_eq_one_of_not_isSeparated 1 x y hsep,
    Set.pairwise_pair.mpr (fun _ ↦ ⟨hballs, hballs.symm⟩), ?_⟩
  intro C hC
  exact (Set.encard_le_encard hC).trans_eq (Set.encard_pair hxy)

end NumStability.HDP.Contract
