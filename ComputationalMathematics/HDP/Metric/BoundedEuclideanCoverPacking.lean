import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.MetricSpace.Bounded
import Mathlib.Topology.MetricSpace.CoveringNumbers
import ComputationalMathematics.HDP.Metric.CoveringNumber

/-!
# Finite covering and packing extrema in bounded Euclidean sets

A bounded subset of positive-dimensional real Euclidean space has finite
attaining internal covers and strict packings at every positive radius.
The natural extrema satisfy both packing-covering comparisons. The subset
may be empty, infinite, or nonclosed.
-/

open scoped NNReal ENNReal

namespace NumStability.HDP.Metric

/-- Finite attaining internal-cover and strict-packing cardinalities for
bounded sets in positive-dimensional Euclidean space, with the exact
comparison at radii `ε` and `2 * ε`. -/
theorem exists_euclidean_cover_packing_extrema :
  ∀ n : ℕ, 0 < n →
    ∀ K : Set (EuclideanSpace ℝ (Fin n)), Bornology.IsBounded K →
      ∀ ε : ℝ≥0, 0 < ε →
        ∃ (coverCount packCount doublePackCount : ℕ)
          (C P Q : Set (EuclideanSpace ℝ (Fin n))),
          C ⊆ K ∧ C.Finite ∧ Metric.IsCover ε K C ∧
          C.encard = (coverCount : ℕ∞) ∧
          Metric.coveringNumber ε K = (coverCount : ℕ∞) ∧
          P ⊆ K ∧ P.Finite ∧ Metric.IsSeparated (ε : ℝ≥0∞) P ∧
          P.encard = (packCount : ℕ∞) ∧
          Metric.packingNumber ε K = (packCount : ℕ∞) ∧
          Q ⊆ K ∧ Q.Finite ∧ Metric.IsSeparated ((2 * ε : ℝ≥0) : ℝ≥0∞) Q ∧
          Q.encard = (doublePackCount : ℕ∞) ∧
          Metric.packingNumber (2 * ε) K = (doublePackCount : ℕ∞) ∧
          doublePackCount ≤ coverCount ∧ coverCount ≤ packCount := by
  classical
  intro n _hn K hK ε hε
  have hfinite : ∀ r : ℝ≥0, 0 < r → Metric.coveringNumber r K < ⊤ :=
    NumStability.HDP.Metric.isCompact_closure_iff_coveringNumber_lt_top.mp
      hK.isCompact_closure
  have hhalf : 0 < ε / 2 := by positivity
  have htwo : 2 * (ε / 2) = ε := by ring
  have hp : Metric.packingNumber ε K < ⊤ := by
    calc
      Metric.packingNumber ε K = Metric.packingNumber (2 * (ε / 2)) K := by rw [htwo]
      _ ≤ Metric.externalCoveringNumber (ε / 2) K :=
        Metric.packingNumber_two_mul_le_externalCoveringNumber (ε / 2) K
      _ ≤ Metric.coveringNumber (ε / 2) K :=
        Metric.externalCoveringNumber_le_coveringNumber (ε / 2) K
      _ < ⊤ := hfinite (ε / 2) hhalf
  have hq : Metric.packingNumber (2 * ε) K < ⊤ :=
    ((Metric.packingNumber_two_mul_le_externalCoveringNumber ε K).trans
      (Metric.externalCoveringNumber_le_coveringNumber ε K)).trans_lt (hfinite ε hε)
  obtain ⟨C, hCK, hCfin, hCcover, hCc⟩ :=
    Metric.exists_set_encard_eq_coveringNumber (hfinite ε hε).ne
  obtain ⟨P, hPK, hPfin, hPsep, hPp⟩ := Metric.exists_set_encard_eq_packingNumber hp.ne
  obtain ⟨Q, hQK, hQfin, hQsep, hQq⟩ := Metric.exists_set_encard_eq_packingNumber hq.ne
  obtain ⟨c, hc⟩ := hCfin.exists_encard_eq_coe
  obtain ⟨p, hpcount⟩ := hPfin.exists_encard_eq_coe
  obtain ⟨q, hqcount⟩ := hQfin.exists_encard_eq_coe
  have hcover : Metric.coveringNumber ε K = (c : ℕ∞) := hCc.symm.trans hc
  have hpack : Metric.packingNumber ε K = (p : ℕ∞) := hPp.symm.trans hpcount
  have hdouble : Metric.packingNumber (2 * ε) K = (q : ℕ∞) := hQq.symm.trans hqcount
  refine ⟨c, p, q, C, P, Q, hCK, hCfin, hCcover, hc, hcover,
    hPK, hPfin, hPsep, hpcount, hpack, hQK, hQfin, hQsep, hqcount, hdouble, ?_, ?_⟩
  · have h := (Metric.packingNumber_two_mul_le_externalCoveringNumber ε K).trans
      (Metric.externalCoveringNumber_le_coveringNumber ε K)
    rw [hdouble, hcover] at h
    exact ENat.coe_le_coe.mp h
  · have h := Metric.coveringNumber_le_packingNumber ε K
    rw [hcover, hpack] at h
    exact ENat.coe_le_coe.mp h

end NumStability.HDP.Metric
