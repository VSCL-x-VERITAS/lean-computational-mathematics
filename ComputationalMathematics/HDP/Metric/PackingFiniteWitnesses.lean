import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Finite witnesses for infinite packing capacity

An extended-natural packing number is infinite precisely when finite separated
subsets have arbitrarily large cardinality. This makes no assertion that an
infinite separated subset exists.
-/

namespace NumStability.HDP.Metric

open Set
open scoped ENNReal NNReal

/-- Infinite packing capacity is witnessed by arbitrarily large finite packings. -/
theorem packingNumber_eq_top_iff_finite_witnesses
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) :
    _root_.Metric.packingNumber ε K = ⊤ ↔
      ∀ m : ℕ, ∃ S : Set T, S ⊆ K ∧ S.Finite ∧ _root_.Metric.IsSeparated ε S ∧
        (m : ℕ∞) ≤ S.encard := by
  constructor
  · intro htop m
    have hm : (m : ℕ∞) < _root_.Metric.packingNumber ε K := by
      rw [htop]
      exact WithTop.coe_lt_top m
    simp only [_root_.Metric.packingNumber, lt_iSup_iff] at hm
    obtain ⟨S, hSK, hsep, hm⟩ := hm
    obtain ⟨Q, hQS, hQm⟩ := Set.exists_subset_encard_eq hm.le
    exact ⟨Q, hQS.trans hSK, Set.finite_of_encard_eq_coe hQm,
      hsep.subset hQS, hQm.ge⟩
  · intro h
    apply ENat.eq_top_iff_forall_ge.mpr
    intro m
    obtain ⟨S, hSK, _, hsep, hm⟩ := h m
    exact hm.trans (hsep.encard_le_packingNumber hSK)

end NumStability.HDP.Metric
