import ComputationalMathematics.HDP.Metric.Packing
import ComputationalMathematics.HDP.Metric.PackingCoveringWitness
import ComputationalMathematics.HDP.Metric.CountableCovering
import Mathlib.Topology.MetricSpace.ProperSpace

/-!
# Positive-radius packing maxima

Packing in a proper metric space attains its extended-natural supremum.
In a second countable metric space, every positive-radius separated subset
has at most countable cardinality. Together these facts identify an attained
exact cardinal maximum with the decoded extended-natural packing number.
-/

noncomputable section
open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

theorem exists_isSeparated_encard_eq_packingNumber_of_proper
    {T : Type*} [MetricSpace T] [ProperSpace T]
    {ε : ℝ≥0} (hε : 0 < ε) (K : Set T) :
    ∃ P : Set T, P ⊆ K ∧ _root_.Metric.IsSeparated ε P ∧
      P.encard = _root_.Metric.packingNumber ε K := by
  classical
  by_cases htop : _root_.Metric.packingNumber ε K = ⊤
  · obtain ⟨P, hPK, hPsep, hPcover⟩ := exists_isSeparated_isCover ε K
    refine ⟨P, hPK, hPsep, ?_⟩
    rw [htop]
    by_contra hPnot
    have hPfin : P.Finite := Set.encard_lt_top_iff.mp (lt_top_iff_ne_top.mpr hPnot)
    let L : Set T := ⋃ y ∈ P, _root_.Metric.closedBall y (ε : ℝ)
    have hLcompact : IsCompact L :=
      hPfin.isCompact_biUnion fun y _hy => isCompact_closedBall y (ε : ℝ)
    have hKL : K ⊆ L := _root_.Metric.isCover_iff_subset_iUnion_closedBall.mp hPcover
    have hpackle : _root_.Metric.packingNumber ε K ≤
        _root_.Metric.packingNumber ε L := by
      simp only [_root_.Metric.packingNumber, iSup_le_iff]
      intro C hCK hCsep
      exact _root_.Metric.IsSeparated.encard_le_packingNumber (hCK.trans hKL) hCsep
    have hfinite : _root_.Metric.packingNumber ε K < ⊤ :=
      hpackle.trans_lt (packingNumber_lt_top_of_isCompact hε hLcompact)
    exact hfinite.ne htop
  · exact ⟨_root_.Metric.maximalSeparatedSet ε K,
      _root_.Metric.maximalSeparatedSet_subset,
      _root_.Metric.isSeparated_maximalSeparatedSet,
      _root_.Metric.encard_maximalSeparatedSet htop⟩

/-- Positive-radius separated subsets have at most countable exact cardinality
in a second countable metric space, by injection into an existing countable
internal cover at half radius. -/
theorem cardinalMk_le_aleph0_of_isSeparated_of_secondCountable
    {T : Type*} [MetricSpace T] [SecondCountableTopology T]
    {ε : ℝ≥0} (hε : 0 < ε) {P : Set T}
    (hPsep : _root_.Metric.IsSeparated ε P) :
    Cardinal.mk P ≤ Cardinal.aleph0 := by
  have hhalf : 0 < ((ε : ℝ) / 2) := half_pos (by exact_mod_cast hε)
  obtain ⟨N, _hNP, hNcount, hNnet⟩ :=
    exists_countable_internal_net_of_secondCountable P hhalf
  have hcover : _root_.Metric.IsCover (ε / 2) P N :=
    _root_.Metric.isCover_iff_subset_iUnion_closedBall.mpr
      (internalNet_iff_subset_iUnion_closedBall.mp hNnet)
  have htwo : 2 * (ε / 2) = ε := by
    calc
      2 * (ε / 2) = (ε / 2) * 2 := mul_comm _ _
      _ = ε := div_mul_cancel₀ _ (by norm_num)
  have hsep : _root_.Metric.IsSeparated (2 * (ε / 2) : ℝ≥0) P := by
    rw [htwo]
    exact hPsep
  exact (cardinalMk_le_of_isSeparated_two_mul_of_isCover
    (ε := ε / 2) Set.Subset.rfl (by simpa using hsep) hcover).trans hNcount.le_aleph0

/-- On the positive-radius proper and second countable domain, a packing
attains the exact largest cardinality, and decoding the ENat packing number
recovers that cardinality. No book-specific infinity convention is imposed. -/
theorem exists_isSeparated_cardinal_greatest_eq_ofENat_packingNumber
    {T : Type*} [MetricSpace T] [ProperSpace T] [SecondCountableTopology T]
    {ε : ℝ≥0} (hε : 0 < ε) (K : Set T) :
    ∃ P : Set T, P ⊆ K ∧ _root_.Metric.IsSeparated ε P ∧
      Cardinal.mk P = (_root_.Metric.packingNumber ε K : Cardinal) ∧
      ∀ Q : Set T, Q ⊆ K → _root_.Metric.IsSeparated ε Q →
        Cardinal.mk Q ≤ Cardinal.mk P := by
  obtain ⟨P, hPK, hPsep, hPcard⟩ :=
    exists_isSeparated_encard_eq_packingNumber_of_proper hε K
  have hPcount := cardinalMk_le_aleph0_of_isSeparated_of_secondCountable hε hPsep
  refine ⟨P, hPK, hPsep, ?_, ?_⟩
  · calc
      Cardinal.mk P = (Cardinal.toENat (Cardinal.mk P) : Cardinal) :=
        (Cardinal.ofENat_toENat hPcount).symm
      _ = (P.encard : Cardinal) := by rw [Set.toENat_cardinalMk]
      _ = (_root_.Metric.packingNumber ε K : Cardinal) := by rw [hPcard]
  · intro Q hQK hQsep
    apply (Cardinal.toENat_le_iff_of_le_aleph0
      (cardinalMk_le_aleph0_of_isSeparated_of_secondCountable hε hQsep)).mp
    rw [Set.toENat_cardinalMk, Set.toENat_cardinalMk, hPcard]
    exact hQsep.encard_le_packingNumber hQK

end NumStability.HDP.Metric
