import Mathlib.Analysis.Normed.Module.Ball.Pointwise
import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Packing by closed balls in real normed spaces

Reusable metric facts relating separated center sets to pairwise disjoint
closed balls of half the separation radius.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- In a real normed space, a set is `ε`-separated exactly when the closed
balls of radius `ε / 2` around distinct points of the set are disjoint. -/
theorem isSeparated_iff_pairwise_disjoint_closedBall
    {E : Type*} [SeminormedAddCommGroup E] [NormedSpace ℝ E]
    {N : Set E} {ε : ℝ≥0} :
    _root_.Metric.IsSeparated ε N ↔
      N.Pairwise fun x y ↦
        Disjoint (_root_.Metric.closedBall x ((ε : ℝ) / 2))
          (_root_.Metric.closedBall y ((ε : ℝ) / 2)) := by
  simp only [_root_.Metric.IsSeparated, Set.Pairwise, edist_dist]
  apply forall_congr'
  intro x
  apply forall_congr'
  intro hx
  apply forall_congr'
  intro y
  apply forall_congr'
  intro hy
  apply forall_congr'
  intro hxy
  rw [disjoint_closedBall_closedBall_iff (by positivity) (by positivity)]
  norm_num

/-- The ENat-valued packing number can therefore be computed by maximizing
the cardinalities of center sets whose closed half-radius balls are pairwise
disjoint. -/
theorem packingNumber_eq_iSup_encard_pairwise_disjoint_closedBall
    {E : Type*} [SeminormedAddCommGroup E] [NormedSpace ℝ E]
    {K : Set E} {ε : ℝ≥0} :
    _root_.Metric.packingNumber ε K =
      ⨆ (C : Set E) (_ : C ⊆ K)
        (_ : C.Pairwise fun x y ↦
          Disjoint (_root_.Metric.closedBall x ((ε : ℝ) / 2))
            (_root_.Metric.closedBall y ((ε : ℝ) / 2))), C.encard := by
  simp only [_root_.Metric.packingNumber,
    isSeparated_iff_pairwise_disjoint_closedBall]

/-- The packing number of a compact metric set is finite at every positive
scale. -/
theorem packingNumber_lt_top_of_isCompact
    {T : Type*} [MetricSpace T] {K : Set T} {ε : ℝ≥0}
    (hε : 0 < ε) (hK : IsCompact K) :
    _root_.Metric.packingNumber ε K < ⊤ := by
  obtain ⟨C, _hCK, hCfin, hcover⟩ :=
    _root_.Metric.exists_finite_isCover_of_isCompact
      (s := K) (ε := ε / 2) (by positivity) hK
  calc
    _root_.Metric.packingNumber ε K =
        _root_.Metric.packingNumber (2 * (ε / 2)) K := by
      congr 2
      ring
    _ ≤ _root_.Metric.externalCoveringNumber (ε / 2) K :=
      _root_.Metric.packingNumber_two_mul_le_externalCoveringNumber (ε / 2) K
    _ ≤ C.encard := hcover.externalCoveringNumber_le_encard
    _ < ⊤ := Set.encard_lt_top_iff.mpr hCfin

/-- A compact metric set has a finite maximal separated subset, which is also
a cover at the same scale. -/
theorem exists_finite_isSeparated_isCover_of_isCompact
    {T : Type*} [MetricSpace T] {K : Set T} {ε : ℝ≥0}
    (hε : 0 < ε) (hK : IsCompact K) :
    ∃ N : Set T, N ⊆ K ∧ N.Finite ∧
      _root_.Metric.IsSeparated ε N ∧ _root_.Metric.IsCover ε K N := by
  have hp : _root_.Metric.packingNumber ε K ≠ ⊤ :=
    (packingNumber_lt_top_of_isCompact hε hK).ne
  refine ⟨_root_.Metric.maximalSeparatedSet ε K,
    _root_.Metric.maximalSeparatedSet_subset, ?_,
    _root_.Metric.isSeparated_maximalSeparatedSet,
    _root_.Metric.isCover_maximalSeparatedSet hp⟩
  exact Set.encard_lt_top_iff.mp <|
    (_root_.Metric.encard_maximalSeparatedSet hp).trans_lt
      (packingNumber_lt_top_of_isCompact hε hK)

/-- A compact metric set admits no infinite sequence whose distinct terms are
uniformly separated at a fixed positive scale. This is the termination
principle behind greedy constructions of finite nets. -/
theorem no_infinite_isSeparated_sequence_of_isCompact
    {T : Type*} [MetricSpace T] {K : Set T} {ε : ℝ≥0}
    (hε : 0 < ε) (hK : IsCompact K) :
    ¬ ∃ x : ℕ → T, (∀ i, x i ∈ K) ∧
      ∀ i j, i ≠ j → (ε : ℝ≥0∞) < edist (x i) (x j) := by
  rintro ⟨x, hxK, hxsep⟩
  have hxinj : Function.Injective x := by
    intro i j hij
    by_contra hne
    have hpos := hxsep i j hne
    rw [hij, edist_self] at hpos
    exact (not_lt_of_ge bot_le) hpos
  have hrangeK : Set.range x ⊆ K := by
    rintro _ ⟨i, rfl⟩
    exact hxK i
  have hrangesep : _root_.Metric.IsSeparated ε (Set.range x) := by
    rintro _ ⟨i, rfl⟩ _ ⟨j, rfl⟩ hne
    exact hxsep i j (fun hij ↦ hne (congrArg x hij))
  have hle : (Set.range x).encard ≤ _root_.Metric.packingNumber ε K :=
    le_iSup_of_le (Set.range x) <|
      le_iSup_of_le hrangeK <| le_iSup_of_le hrangesep le_rfl
  have htop : _root_.Metric.packingNumber ε K = ⊤ := by
    apply top_unique
    simpa [Set.Infinite.encard_eq (Set.infinite_range_of_injective hxinj)] using hle
  exact (packingNumber_lt_top_of_isCompact hε hK).ne htop

/-- If a separated set does not yet cover `K`, a point of `K` can be adjoined
while preserving separation. This is one step of the greedy-net algorithm. -/
theorem exists_isSeparated_insert_of_not_isCover
    {T : Type*} [MetricSpace T] {K N : Set T} {ε : ℝ≥0}
    (hN : _root_.Metric.IsSeparated ε N)
    (hcover : ¬ _root_.Metric.IsCover ε K N) :
    ∃ x ∈ K, x ∉ N ∧ _root_.Metric.IsSeparated ε (insert x N) := by
  simp only [_root_.Metric.IsCover, SetRel.IsCover] at hcover
  push_neg at hcover
  obtain ⟨x, hxK, hx⟩ := hcover
  have hxN : x ∉ N := by
    intro hxmem
    exact (hx x hxmem) (by simp)
  refine ⟨x, hxK, hxN, (_root_.Metric.isSeparated_insert_of_notMem hxN).2 ⟨hN, ?_⟩⟩
  intro y hy
  exact lt_of_not_ge (hx y hy)

end NumStability.HDP.Metric
