import Mathlib.Topology.MetricSpace.Cover

/-!
# Vershynin, Chapter 4, maximal separated subsets

Source-correspondence wrapper for the footnote following Lemma 4.2.6.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, the footnote following
Lemma 4.2.6: an `ε`-separated subset of `K` is maximal precisely when adding
any new point of `K` destroys the separation property. The characterization
also holds at zero radius, beyond the source's positive-radius context. -/
theorem hdp_04_maximal_separated_definition {T : Type*} [MetricSpace T]
    {K N : Set T} {ε : ℝ≥0} :
    Maximal (fun M : Set T ↦ M ⊆ K ∧ Metric.IsSeparated ε M) N ↔
      (N ⊆ K ∧ Metric.IsSeparated ε N) ∧
        ∀ x ∈ K, x ∉ N → ¬ Metric.IsSeparated ε (insert x N) := by
  let P : Set T → Prop := fun M ↦ M ⊆ K ∧ Metric.IsSeparated ε M
  have hP : ∀ ⦃S U : Set T⦄, P U → S ⊆ U → P S := by
    intro S U hU hSU
    exact ⟨hSU.trans hU.1, Metric.IsSeparated.subset hSU hU.2⟩
  rw [Set.maximal_iff_forall_insert hP]
  constructor
  · rintro ⟨hN, hmax⟩
    refine ⟨hN, fun x hxK hxN hxsep ↦ ?_⟩
    exact hmax x hxN ⟨Set.insert_subset hxK hN.1, hxsep⟩
  · rintro ⟨hN, hmax⟩
    refine ⟨hN, fun x hxN hxinsert ↦ ?_⟩
    exact hmax x (hxinsert.1 (Set.mem_insert x N)) hxN hxinsert.2

end NumStability.HDP.Contract
