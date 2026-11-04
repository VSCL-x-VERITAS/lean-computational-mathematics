import ComputationalMathematics.HDP.Metric.Packing

/-!
# Vershynin, Chapter 4, Remark 4.2.7

Source-correspondence contract for the greedy construction of a finite net in
a compact metric set.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Remark 4.2.7: at a positive
scale, the greedy separated-point construction on a compact set cannot run
forever; every non-covering separated stage can be extended; and a finite
separated net exists. -/
theorem hdp_04_hremark_h4_d2_d7
    {T : Type*} [MetricSpace T] {K : Set T} {ε : ℝ≥0}
    (hε : 0 < ε) (hK : IsCompact K) :
    (¬ ∃ x : ℕ → T, (∀ i, x i ∈ K) ∧
      ∀ i j, i ≠ j → (ε : ℝ≥0∞) < edist (x i) (x j)) ∧
    (∀ N : Set T, N.Finite → N ⊆ K → Metric.IsSeparated ε N →
      ¬ Metric.IsCover ε K N →
        ∃ x ∈ K, x ∉ N ∧ Metric.IsSeparated ε (insert x N)) ∧
    ∃ N : Set T, N ⊆ K ∧ N.Finite ∧
      Metric.IsSeparated ε N ∧ Metric.IsCover ε K N := by
  refine ⟨
    NumStability.HDP.Metric.no_infinite_isSeparated_sequence_of_isCompact hε hK,
    ?_,
    NumStability.HDP.Metric.exists_finite_isSeparated_isCover_of_isCompact hε hK⟩
  intro N _hNfin _hNK hNsep hNcover
  exact NumStability.HDP.Metric.exists_isSeparated_insert_of_not_isCover hNsep hNcover

end NumStability.HDP.Contract
