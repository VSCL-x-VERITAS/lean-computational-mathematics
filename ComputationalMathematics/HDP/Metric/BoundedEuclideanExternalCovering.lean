import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.MetricSpace.Bounded
import ComputationalMathematics.HDP.Metric.CoveringNumber
import ComputationalMathematics.HDP.Metric.CoveringComparisons
import ComputationalMathematics.HDP.Metric.ExternalCoverAttainment

/-! # Numerical covering minima for bounded Euclidean sets

Every bounded set in positive-dimensional real Euclidean space has finite
external and internal covering minima at a positive radius, and a finite
external minimum at half that radius. Empty, infinite and nonclosed bounded
sets are included. The ordinary natural counts satisfy the factor-two
comparison of the covering numbers.
-/

open scoped NNReal ENNReal

namespace NumStability.HDP.Metric

/-- Finite external and internal covering minima for a bounded subset of
positive-dimensional real Euclidean space, with natural counts and actual
center sets at the given radius and half-radius. -/
theorem exists_euclidean_external_covering_minima :
  ∀ n : ℕ, 0 < n →
    ∀ K : Set (EuclideanSpace ℝ (Fin n)), Bornology.IsBounded K →
      ∀ ε : ℝ≥0, 0 < ε →
        ∃ (externalCount internalCount halfExternalCount : ℕ)
          (E C H : Set (EuclideanSpace ℝ (Fin n))),
          E.Finite ∧ Metric.IsCover ε K E ∧
          E.encard = (externalCount : ℕ∞) ∧
          Metric.externalCoveringNumber ε K = (externalCount : ℕ∞) ∧
          C ⊆ K ∧ C.Finite ∧ Metric.IsCover ε K C ∧
          C.encard = (internalCount : ℕ∞) ∧
          Metric.coveringNumber ε K = (internalCount : ℕ∞) ∧
          H.Finite ∧ Metric.IsCover (ε / 2) K H ∧
          H.encard = (halfExternalCount : ℕ∞) ∧
          Metric.externalCoveringNumber (ε / 2) K = (halfExternalCount : ℕ∞) ∧
          externalCount ≤ internalCount ∧ internalCount ≤ halfExternalCount := by
  intro n _hn K hK ε hε
  have hfinite : ∀ δ : ℝ≥0, 0 < δ → Metric.coveringNumber δ K < ⊤ :=
    (NumStability.HDP.Metric.isCompact_closure_iff_coveringNumber_lt_top).mp
      hK.isCompact_closure
  have hhalf : 0 < ε / 2 := by positivity
  obtain ⟨hleft, hright⟩ :=
    NumStability.HDP.Metric.externalCoveringNumber_comparison K ε
  have hinternal : Metric.coveringNumber ε K < ⊤ := hfinite ε hε
  have hexternal : Metric.externalCoveringNumber ε K < ⊤ :=
    hleft.trans_lt hinternal
  have hhalfExternal : Metric.externalCoveringNumber (ε / 2) K < ⊤ :=
    (Metric.externalCoveringNumber_le_coveringNumber (ε / 2) K).trans_lt
      (hfinite (ε / 2) hhalf)
  obtain ⟨E, hEfinite, hEcover, hEcard⟩ :=
    NumStability.HDP.Metric.exists_set_encard_eq_externalCoveringNumber hexternal.ne
  obtain ⟨C, hCK, hCfinite, hCcover, hCcard⟩ :=
    Metric.exists_set_encard_eq_coveringNumber hinternal.ne
  obtain ⟨H, hHfinite, hHcover, hHcard⟩ :=
    NumStability.HDP.Metric.exists_set_encard_eq_externalCoveringNumber hhalfExternal.ne
  have he : Metric.externalCoveringNumber ε K = (hEfinite.toFinset.card : ℕ∞) :=
    hEcard.symm.trans hEfinite.encard_eq_coe_toFinset_card
  have hi : Metric.coveringNumber ε K = (hCfinite.toFinset.card : ℕ∞) :=
    hCcard.symm.trans hCfinite.encard_eq_coe_toFinset_card
  have hh : Metric.externalCoveringNumber (ε / 2) K = (hHfinite.toFinset.card : ℕ∞) :=
    hHcard.symm.trans hHfinite.encard_eq_coe_toFinset_card
  refine ⟨hEfinite.toFinset.card, hCfinite.toFinset.card, hHfinite.toFinset.card,
    E, C, H, hEfinite, hEcover, hEfinite.encard_eq_coe_toFinset_card, he,
    hCK, hCfinite, hCcover, hCfinite.encard_eq_coe_toFinset_card, hi,
    hHfinite, hHcover, hHfinite.encard_eq_coe_toFinset_card, hh, ?_, ?_⟩
  · exact ENat.coe_le_coe.mp (by simpa only [he, hi] using hleft)
  · exact ENat.coe_le_coe.mp (by simpa only [hi, hh] using hright)

end NumStability.HDP.Metric

