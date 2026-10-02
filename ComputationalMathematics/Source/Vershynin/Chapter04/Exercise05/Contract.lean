import ComputationalMathematics.HDP.Metric.Packing

/-!
# Vershynin, Chapter 4, Exercise 4.2.5

Packing by closed half-radius balls in real normed spaces and a two-point
metric-space counterexample.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Exercise 4.2.5(a): among
subsets of `K`, `ε`-separated center sets are exactly the center sets whose
closed `ε / 2`-balls are pairwise disjoint. -/
theorem hdp_04_hex_h4_d2_d5_a
    {E : Type*} [SeminormedAddCommGroup E] [NormedSpace ℝ E]
    {K N : Set E} {ε : ℝ≥0} (_hε : 0 < ε) :
    (N ⊆ K ∧ Metric.IsSeparated ε N) ↔
      N ⊆ K ∧
        N.Pairwise fun x y ↦
          Disjoint (Metric.closedBall x ((ε : ℝ) / 2))
            (Metric.closedBall y ((ε : ℝ) / 2)) :=
  and_congr_right fun _ ↦
    NumStability.HDP.Metric.isSeparated_iff_pairwise_disjoint_closedBall

/-- The two-point subspace `{0, 1}` of the real line, used for the general
metric-space counterexample in Exercise 4.2.5(b). -/
abbrev HDPExercise425TwoPoint : Type := {x : ℝ // x = 0 ∨ x = 1}

private def exercise425Left : HDPExercise425TwoPoint := ⟨0, Or.inl rfl⟩
private def exercise425Right : HDPExercise425TwoPoint := ⟨1, Or.inr rfl⟩

private theorem exercise425_closedBall_left :
    Metric.closedBall exercise425Left (1 / 2 : ℝ) = {exercise425Left} := by
  ext x
  rcases x.property with hx | hx
  · have : x = exercise425Left := Subtype.ext hx
    subst x
    simp
  · have : x = exercise425Right := Subtype.ext hx
    subst x
    simp [exercise425Left, exercise425Right, Metric.mem_closedBall, Subtype.dist_eq]
    norm_num

private theorem exercise425_closedBall_right :
    Metric.closedBall exercise425Right (1 / 2 : ℝ) = {exercise425Right} := by
  ext x
  rcases x.property with hx | hx
  · have : x = exercise425Left := Subtype.ext hx
    subst x
    simp [exercise425Left, exercise425Right, Metric.mem_closedBall, Subtype.dist_eq]
    norm_num
  · have : x = exercise425Right := Subtype.ext hx
    subst x
    simp

/-- Vershynin, *High-Dimensional Probability*, Exercise 4.2.5(b): in the
two-point metric subspace `{0, 1}`, the closed half-radius balls around the
two points are disjoint at `ε = 1`, although the two-point center set is not
`1`-separated. Thus the normed-space characterization fails for a general
metric space. -/
theorem hdp_04_hex_h4_d2_d5_b :
    Disjoint (Metric.closedBall exercise425Left (1 / 2 : ℝ))
        (Metric.closedBall exercise425Right (1 / 2 : ℝ)) ∧
      ¬ Metric.IsSeparated (1 : ℝ≥0)
        ({exercise425Left, exercise425Right} : Set HDPExercise425TwoPoint) := by
  constructor
  · rw [exercise425_closedBall_left, exercise425_closedBall_right]
    exact Set.disjoint_singleton.mpr (by simp [exercise425Left, exercise425Right])
  · simp [Metric.IsSeparated, Set.Pairwise, exercise425Left, exercise425Right,
      edist_dist, Subtype.dist_eq, Real.dist_eq]

/-- Combined source contract for both parts of Vershynin Exercise 4.2.5. -/
theorem hdp_04_hex_h4_d2_d5
    {E : Type*} [SeminormedAddCommGroup E] [NormedSpace ℝ E]
    {K N : Set E} {ε : ℝ≥0} (hε : 0 < ε) :
    ((N ⊆ K ∧ Metric.IsSeparated ε N) ↔
      N ⊆ K ∧
        N.Pairwise fun x y ↦
          Disjoint (Metric.closedBall x ((ε : ℝ) / 2))
            (Metric.closedBall y ((ε : ℝ) / 2))) ∧
    (Disjoint (Metric.closedBall exercise425Left (1 / 2 : ℝ))
        (Metric.closedBall exercise425Right (1 / 2 : ℝ)) ∧
      ¬ Metric.IsSeparated (1 : ℝ≥0)
        ({exercise425Left, exercise425Right} : Set HDPExercise425TwoPoint)) :=
  ⟨hdp_04_hex_h4_d2_d5_a hε, hdp_04_hex_h4_d2_d5_b⟩

end NumStability.HDP.Contract
