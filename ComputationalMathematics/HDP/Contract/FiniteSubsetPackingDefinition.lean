import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Finite positive-radius numerical packing definition

This source contract records the independently audited finite-subset case of
Definition 4.2.4. The ambient metric space is arbitrary and the empty subset is
included. Finiteness is an explicit analyst qualification. The strict separation
predicate and a shared attaining cardinality optimizer are both preserved.
The unrestricted source's infinite-cardinality, standalone radius and later
volume conventions remain outside this contract. Existing Mathlib packing
attainment and finite cast laws supply the result.
-/

noncomputable section
open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The selected finite numerical definition, including literal strictness and
an optimizer whose natural count dominates every admissible candidate. -/
def finiteSubsetNumericalPackingPositiveRadius : Prop :=
  ∀ {T : Type*} [MetricSpace T] {ε : ℝ≥0}, 0 < ε →
    ∀ K : Set T, K.Finite →
      (∀ N : Set T, Metric.IsSeparated ε N ↔
        ∀ x ∈ N, ∀ y ∈ N, x ≠ y → (ε : ℝ) < dist x y) ∧
      ∃ P : Set T, P ⊆ K ∧ P.Finite ∧ Metric.IsSeparated ε P ∧
        (P.ncard : ℕ∞) = Metric.packingNumber ε K ∧
        ∀ Q : Set T, Q ⊆ K → Metric.IsSeparated ε Q → Q.ncard ≤ P.ncard

/-- Qualified source alias composing existing finite packing and cast laws. -/
theorem hdp_04_definition_4_2_4_finite_subset_positive_radius :
    finiteSubsetNumericalPackingPositiveRadius := by
  intro T _inst ε _hε K hK
  constructor
  · intro N
    simp only [Metric.IsSeparated, Set.Pairwise, edist_dist, ENNReal.coe_lt_ofReal]
  · have hbound : Metric.packingNumber ε K < ⊤ :=
      (Metric.packingNumber_le_encard_self K).trans_lt hK.encard_lt_top
    obtain ⟨P, hPK, hPfinite, hPsep, hPcount⟩ :=
      Metric.exists_set_encard_eq_packingNumber hbound.ne
    refine ⟨P, hPK, hPfinite, hPsep, hPfinite.cast_ncard_eq.trans hPcount, ?_⟩
    intro Q hQK hQsep
    have h := Metric.IsSeparated.encard_le_packingNumber hQK hQsep
    rw [← hPcount, ← hPfinite.cast_ncard_eq,
      ← (hK.subset hQK).cast_ncard_eq] at h
    simpa only [ENat.toNat_coe] using ENat.toNat_le_of_le_coe h

end NumStability.HDP.Contract
