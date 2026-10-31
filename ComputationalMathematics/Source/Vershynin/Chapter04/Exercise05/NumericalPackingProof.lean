import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise05.NumericalPackingTarget
import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise05.TwoPointNumerical

/-!
# Exercise 4.2.5: packing by disjoint half-radius balls

The numerical identity holds in real normed spaces. The two-point metric
example witnesses why the same closed-ball identity does not extend to every
metric space.
-/

namespace NumStability.HDP.Contract

universe u

open Set
open scoped ENNReal NNReal

/-- The full numerical identity and its explicit metric-space obstruction. -/
theorem exercise425_numerical_packing_proved :
    exercise425NumericalPackingTarget.{u} := by
  constructor
  · intro E _ _ K ε _
    exact NumStability.HDP.Metric.packingNumber_eq_iSup_encard_pairwise_disjoint_closedBall
  · obtain ⟨x, y, _, hcard, hpack, hpair, hbound⟩ :=
      exists_exercise425_two_point_numerical_packing_obstruction
    refine ⟨HDPExercise425TwoPoint, inferInstance, 1, by norm_num, {x, y}, ?_⟩
    have hsup : (⨆ (C : Set HDPExercise425TwoPoint)
        (_ : C ⊆ ({x, y} : Set HDPExercise425TwoPoint))
        (_ : C.Pairwise fun a b ↦ Disjoint (Metric.closedBall a (1 / 2 : ℝ))
          (Metric.closedBall b (1 / 2 : ℝ))), C.encard) = 2 := by
      apply le_antisymm
      · exact iSup_le fun C ↦ iSup_le fun hC ↦ iSup_le fun _ ↦ hbound C hC
      · exact le_iSup_of_le ({x, y} : Set HDPExercise425TwoPoint)
          (le_iSup_of_le (by rfl) (le_iSup_of_le hpair hcard.ge))
    simpa only [Nat.cast_ofNat, NNReal.coe_one, hpack, hsup] using
      (by decide : (1 : ℕ∞) ≠ 2)

end NumStability.HDP.Contract
