import ComputationalMathematics.Data.Set.Card
import ComputationalMathematics.HDP.Metric.PackingNonattainment
import Mathlib.Topology.MetricSpace.Kuratowski
import Mathlib.Topology.MetricSpace.Bounded

/-!
# Bounded packings without a maximum in a real normed space

The existing finite-block metric embeds isometrically in real `ℓ^∞(ℕ)`.
Its image is bounded, has finite packings of unbounded size, and has no
infinite packing at radius one. This ordinary example selects no author's
maximum, cardinality, or infinite-value convention.
-/

open scoped ENNReal NNReal lp

noncomputable section

namespace NumStability.HDP.Metric.PackingNonattainment

/-- A bounded subset of an actual real normed space can have an infinite
packing supremum while every admissible packing is finite. -/
theorem exists_bounded_normed_packing_supremum_without_infinite_packing :
    ∃ K : Set ℓ^∞(ℕ), Bornology.IsBounded K ∧
      _root_.Metric.packingNumber (1 : ℝ≥0) K = ⊤ ∧
      ∀ P : Set ℓ^∞(ℕ), P ⊆ K →
        _root_.Metric.IsSeparated (1 : ℝ≥0∞) P → P.Finite := by
  letI : Countable Point := by
    have hinj : Function.Injective (fun p : Point => (p.fst, p.snd.val)) := by
      rintro ⟨k, i⟩ ⟨l, j⟩ h
      have hk : k = l := congrArg Prod.fst h
      subst l
      have hij : i = j := Fin.ext (congrArg Prod.snd h)
      subst j
      rfl
    exact hinj.countable
  let f := kuratowskiEmbedding Point
  have hf : Isometry f := kuratowskiEmbedding.isometry Point
  refine ⟨Set.range f, ?_, ?_, ?_⟩
  · apply _root_.Metric.isBounded_range_iff.mpr
    refine ⟨2, fun x y => ?_⟩
    rw [hf.dist_eq]
    change pointDist x y ≤ 2
    unfold pointDist
    split_ifs <;> norm_num
  · apply ENat.eq_top_iff_forall_ge.mpr
    intro n
    have hsep : _root_.Metric.IsSeparated (1 : ℝ≥0∞) (f '' block n) := by
      simpa using (block_separated n).image_antilipschitz hf.antilipschitz
        (by norm_num : (0 : ℝ≥0) < 1)
    have hsub : f '' block n ⊆ Set.range f := Set.image_subset_range _ _
    have h := hsep.encard_le_packingNumber (ε := 1) hsub
    rw [hf.injective.encard_image, block_encard] at h
    exact (ENat.coe_le_coe.mpr (by omega : n ≤ n + 1)).trans h
  · intro P hsub hP
    have hpre : _root_.Metric.IsSeparated (1 : ℝ≥0∞) (f ⁻¹' P) := by
      intro x hx y hy hne
      simpa only [hf.edist_eq] using hP hx hy (hf.injective.ne hne)
    exact Set.finite_of_finite_preimage (separated_set_finite _ hpre) hsub

/-- The bounded normed-space packing supremum need not have an attaining set. -/
theorem exists_bounded_normed_packing_supremum_not_attained :
    ∃ K : Set ℓ^∞(ℕ), Bornology.IsBounded K ∧
      _root_.Metric.packingNumber (1 : ℝ≥0) K = ⊤ ∧
      ¬ ∃ P : Set ℓ^∞(ℕ), P ⊆ K ∧
        _root_.Metric.IsSeparated (1 : ℝ≥0∞) P ∧ P.encard = ⊤ := by
  obtain ⟨K, hK, htop, hfinite⟩ :=
    exists_bounded_normed_packing_supremum_without_infinite_packing
  refine ⟨K, hK, htop, ?_⟩
  rintro ⟨P, hsub, hP, hcard⟩
  exact (hfinite P hsub hP).encard_lt_top.ne hcard

/-- A top radius-one packing supremum with finite admissible packings
precludes a greatest natural packing cardinality. -/
theorem no_largest_ncard_of_normed_packingNumber_eq_top_of_finite :
    ∀ K : Set ℓ^∞(ℕ),
      _root_.Metric.packingNumber (1 : ℝ≥0) K = ⊤ →
      (∀ P : Set ℓ^∞(ℕ), P ⊆ K →
        _root_.Metric.IsSeparated (1 : ℝ≥0∞) P → P.Finite) →
      ¬ ∃ S : Set ℓ^∞(ℕ), S ⊆ K ∧
        _root_.Metric.IsSeparated (1 : ℝ≥0∞) S ∧
        ∀ T : Set ℓ^∞(ℕ), T ⊆ K →
          _root_.Metric.IsSeparated (1 : ℝ≥0∞) T → T.ncard ≤ S.ncard := by
  intro K htop hfinite
  rintro ⟨S, _, _, hmax⟩
  have hbound : _root_.Metric.packingNumber (1 : ℝ≥0) K ≤
      (S.ncard : ℕ∞) := by
    unfold _root_.Metric.packingNumber
    refine iSup_le fun T => iSup_le fun hTK => iSup_le fun hT => ?_
    exact Set.encard_le_coe_iff_finite_ncard_le.mpr
      ⟨hfinite T hTK hT, hmax T hTK hT⟩
  rw [htop] at hbound
  exact (not_le_of_gt (ENat.coe_lt_top S.ncard)) hbound

/-- A bounded subset of real `ℓ^∞(ℕ)` has no greatest exact cardinality
among its strict radius-one separated subsets. -/
theorem exists_bounded_normed_no_largest_cardinal_separated_set :
  ∃ K : Set ℓ^∞(ℕ), Bornology.IsBounded K ∧
    ¬ ∃ S : Set ℓ^∞(ℕ), S ⊆ K ∧
      _root_.Metric.IsSeparated (1 : ℝ≥0∞) S ∧
      ∀ T : Set ℓ^∞(ℕ), T ⊆ K →
        _root_.Metric.IsSeparated (1 : ℝ≥0∞) T → Cardinal.mk T ≤ Cardinal.mk S := by
  obtain ⟨K, hbounded, htop, hfinite⟩ :=
    NumStability.HDP.Metric.PackingNonattainment.exists_bounded_normed_packing_supremum_without_infinite_packing
  refine ⟨K, hbounded, ?_⟩
  have hn := no_largest_ncard_of_normed_packingNumber_eq_top_of_finite K htop hfinite
  have hc := NumStability.Set.cardinal_nonmaximum_of_finite_ncard_nonmaximum ℓ^∞(ℕ)
    (fun P => P ⊆ K ∧ _root_.Metric.IsSeparated (1 : ℝ≥0∞) P)
    (fun P hP => hfinite P hP.1 hP.2)
    (by
      rintro ⟨S, ⟨hS, hsep⟩, hmax⟩
      exact hn ⟨S, hS, hsep, fun T hTK hT => hmax T ⟨hTK, hT⟩⟩)
  rintro ⟨S, hS, hsep, hmax⟩
  exact hc ⟨S, ⟨hS, hsep⟩, fun T hT => hmax T hT.1 hT.2⟩

end NumStability.HDP.Metric.PackingNonattainment
