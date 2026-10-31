import ComputationalMathematics.HDP.Contract.FiniteSubsetPackingDefinition
import ComputationalMathematics.HDP.Metric.Packing
import ComputationalMathematics.Source.Vershynin.Chapter04.Exercise05.TwoPointNumerical

/-!
# Selected finite positive numerical Exercise 4.2.5

The real normed-space setting of part (a), finite subsets in both parts and
positive radius are explicit analyst qualifications. Empty and singleton sets
remain included. The target asserts attained numerical equality in part (a)
and an existential general-metric numerical discrepancy in part (b).
Acceptance concerns this selected component; unrestricted scalar and infinite
cardinality conventions are separate source questions.
-/

open Set
open scoped ENNReal NNReal

universe u

namespace NumStability.HDP.Contract

/-- Proof-free transparent statement for the independently extracted selection. -/
def exercise425RealFinitePositiveNumericalBothParts : Prop :=
  (∀ {E : Type u} [NormedAddCommGroup E] [NormedSpace ℝ E]
      {ε : ℝ≥0}, 0 < ε → ∀ K : Set E, K.Finite →
      ∃ P : Set E, P ⊆ K ∧ P.Finite ∧
        P.Pairwise (fun x y ↦
          Disjoint (Metric.closedBall x ((ε : ℝ) / 2))
            (Metric.closedBall y ((ε : ℝ) / 2))) ∧
        P.encard = Metric.packingNumber ε K ∧
        ∀ Q : Set E, Q ⊆ K →
          Q.Pairwise (fun x y ↦
            Disjoint (Metric.closedBall x ((ε : ℝ) / 2))
              (Metric.closedBall y ((ε : ℝ) / 2))) →
          Q.encard ≤ P.encard) ∧
    ∃ (T : Type) (inst : MetricSpace T),
      letI := inst
      ∃ ε : ℝ≥0, 0 < ε ∧ ∃ K : Set T, K.Finite ∧
        ∃ P : Set T, P ⊆ K ∧ P.Finite ∧
          P.Pairwise (fun x y ↦
            Disjoint (Metric.closedBall x ((ε : ℝ) / 2))
              (Metric.closedBall y ((ε : ℝ) / 2))) ∧
          (∀ Q : Set T, Q ⊆ K →
            Q.Pairwise (fun x y ↦
              Disjoint (Metric.closedBall x ((ε : ℝ) / 2))
                (Metric.closedBall y ((ε : ℝ) / 2))) →
            Q.encard ≤ P.encard) ∧
          P.encard ≠ Metric.packingNumber ε K

/-- Selected legacy-row alias composing existing finite packing and witness producers. -/
theorem exercise425_real_finite_positive_numerical_both_parts :
    exercise425RealFinitePositiveNumericalBothParts.{u} := by
  constructor
  · intro E _ _ ε hε K hK
    obtain ⟨_, P, hPK, hPfinite, hPsep, hPnumber, _⟩ :=
      hdp_04_definition_4_2_4_finite_subset_positive_radius hε K hK
    have hCount : P.encard = Metric.packingNumber ε K :=
      hPfinite.cast_ncard_eq.symm.trans hPnumber
    refine ⟨P, hPK, hPfinite,
      NumStability.HDP.Metric.isSeparated_iff_pairwise_disjoint_closedBall.mp hPsep,
      hCount, ?_⟩
    intro Q hQK hQballs
    exact (Metric.IsSeparated.encard_le_packingNumber hQK
      (NumStability.HDP.Metric.isSeparated_iff_pairwise_disjoint_closedBall.mpr hQballs)).trans_eq
        hCount.symm
  · obtain ⟨x, y, hFinite, hEnc, hPack, hBalls, hMax⟩ :=
      exists_exercise425_two_point_numerical_packing_obstruction
    refine ⟨HDPExercise425TwoPoint, inferInstance, 1, zero_lt_one,
      {x, y}, hFinite, {x, y}, Set.Subset.rfl, hFinite, hBalls, ?_, ?_⟩
    · intro Q hQK _hQballs
      simpa only [hEnc] using hMax Q hQK
    · simpa only [hEnc, hPack] using (by decide : (2 : ℕ∞) ≠ 1)

end NumStability.HDP.Contract
