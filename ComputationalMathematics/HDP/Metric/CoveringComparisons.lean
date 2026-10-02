import Mathlib.Topology.MetricSpace.CoveringNumbers

/-!
# Comparisons for internal and external covering numbers

This module records the standard factor-two comparisons for metric covering
numbers and an explicit three-point counterexample showing that internal
covering numbers need not be monotone under set inclusion.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Metric

/-- An external `ε / 2`-cover can be moved into the covered set to produce an
internal `ε`-cover with no larger exact cardinality. -/
theorem exists_internalCover_cardinalMk_le_of_isCover_half
    {T : Type*} [PseudoEMetricSpace T] {ε : ℝ≥0} {K C : Set T}
    (hCcover : _root_.Metric.IsCover (ε / 2) K C) :
    ∃ N : Set T, N ⊆ K ∧ _root_.Metric.IsCover ε K N ∧
      Cardinal.mk N ≤ Cardinal.mk C := by
  let relevant : Set T :=
    {c | c ∈ C ∧ ∃ x ∈ K, edist x c ≤ (ε / 2 : ℝ≥0)}
  let rep : relevant → K := fun c =>
    ⟨c.2.2.choose, c.2.2.choose_spec.1⟩
  have hrep (c : relevant) : edist (rep c : T) c ≤ (ε / 2 : ℝ≥0) :=
    c.2.2.choose_spec.2
  let N : Set T := Set.range fun c : relevant => (rep c : T)
  refine ⟨N, ?_, ?_, ?_⟩
  · rintro y ⟨c, rfl⟩
    exact (rep c).2
  · intro x hx
    obtain ⟨c, hcC, hxc⟩ := hCcover hx
    let cr : relevant := ⟨c, hcC, x, hx, hxc⟩
    have hcrep : edist c (rep cr : T) ≤ (ε / 2 : ℝ≥0) := by
      rw [edist_comm]
      exact hrep cr
    refine ⟨rep cr, ⟨cr, rfl⟩, ?_⟩
    calc
      edist x (rep cr : T) ≤ edist x c + edist c (rep cr : T) := edist_triangle ..
      _ ≤ (ε / 2 : ℝ≥0) + (ε / 2 : ℝ≥0) := add_le_add hxc hcrep
      _ = ε := by
        rw [← ENNReal.coe_add, add_halves]
  · calc
      Cardinal.mk N ≤ Cardinal.mk relevant := Cardinal.mk_range_le
      _ ≤ Cardinal.mk C := Cardinal.mk_subtype_mono fun _ hc => hc.1

/-- Exact-cardinal real counterexample to fixed-radius monotonicity of internal
covering numbers: a three-point set has a one-center radius-one cover, while
its two-point subset has exact internal covering cardinality two. -/
theorem exists_real_internalCover_cardinal_counterexample :
    ∃ (L K : Set ℝ) (ε : ℝ≥0), 0 < ε ∧ L ⊆ K ∧
      (∃ C : Set ℝ, C ⊆ K ∧
        (∀ ⦃x⦄, x ∈ K → ∃ y ∈ C, dist x y ≤ (ε : ℝ)) ∧
        Cardinal.mk C = 1) ∧
      (∃ N : Set ℝ, N ⊆ L ∧
        (∀ ⦃x⦄, x ∈ L → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ∧
        Cardinal.mk N = 2) ∧
      ∀ N : Set ℝ, N ⊆ L →
        (∀ ⦃x⦄, x ∈ L → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) →
        2 ≤ Cardinal.mk N := by
  let L : Set ℝ := {-1, 1}
  let K : Set ℝ := {-1, 0, 1}
  refine ⟨L, K, 1, by norm_num, ?_, ?_, ?_, ?_⟩
  · intro x hx
    simp only [L, K, Set.mem_insert_iff, Set.mem_singleton_iff] at hx ⊢
    aesop
  · refine ⟨{0}, ?_, ?_, ?_⟩
    · simp [K]
    · intro x hx
      simp only [K, Set.mem_insert_iff, Set.mem_singleton_iff] at hx
      refine ⟨0, by simp, ?_⟩
      rcases hx with h | h | h <;> subst x <;> norm_num [Real.dist_eq]
      exact le_rfl
    · simp
  · refine ⟨L, Subset.rfl, ?_, ?_⟩
    · intro x hx
      exact ⟨x, hx, (dist_self x).trans_le (by norm_num)⟩
    · rw [show L = {-1, 1} by rfl, Cardinal.mk_insert (by norm_num),
        Cardinal.mk_singleton]
      norm_num
  · intro N hNL hNcover
    have hneg_cover := hNcover (show (-1 : ℝ) ∈ L by simp [L])
    obtain ⟨yneg, hynegN, hnegdist⟩ := hneg_cover
    have hynegL := hNL hynegN
    have hyneg : yneg = -1 := by
      simp only [L, Set.mem_insert_iff, Set.mem_singleton_iff] at hynegL
      rcases hynegL with h | h
      · exact h
      · rw [h] at hnegdist
        norm_num [Real.dist_eq] at hnegdist
    have hpos_cover := hNcover (show (1 : ℝ) ∈ L by simp [L])
    obtain ⟨ypos, hyposN, hposdist⟩ := hpos_cover
    have hyposL := hNL hyposN
    have hypos : ypos = 1 := by
      simp only [L, Set.mem_insert_iff, Set.mem_singleton_iff] at hyposL
      rcases hyposL with h | h
      · rw [h] at hposdist
        norm_num [Real.dist_eq] at hposdist
        exact (not_le_of_gt (by norm_num : (1 : ℝ) < 2) hposdist).elim
      · exact h
    have hLN : L ⊆ N := by
      intro x hx
      simp only [L, Set.mem_insert_iff, Set.mem_singleton_iff] at hx
      rcases hx with h | h
      · simpa [h, hyneg] using hynegN
      · simpa [h, hypos] using hyposN
    rw [← show Cardinal.mk L = 2 by
      rw [show L = {-1, 1} by rfl, Cardinal.mk_insert (by norm_num),
        Cardinal.mk_singleton]
      norm_num]
    exact Cardinal.mk_subtype_mono hLN

/-- External centers can only decrease a covering number, while replacing an
external center by a nearby point of the covered set loses at most a factor of
two in the radius. -/
theorem externalCoveringNumber_comparison
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) :
    _root_.Metric.externalCoveringNumber ε K ≤
        _root_.Metric.coveringNumber ε K ∧
      _root_.Metric.coveringNumber ε K ≤
        _root_.Metric.externalCoveringNumber (ε / 2) K := by
  refine ⟨_root_.Metric.externalCoveringNumber_le_coveringNumber ε K, ?_⟩
  calc
    _root_.Metric.coveringNumber ε K =
        _root_.Metric.coveringNumber (2 * (ε / 2)) K := by
      congr 2
      symm
      calc
        2 * (ε / 2) = (ε / 2) * 2 := mul_comm _ _
        _ = ε := div_mul_cancel₀ ε (by norm_num)
    _ ≤ _root_.Metric.externalCoveringNumber (ε / 2) K :=
      _root_.Metric.coveringNumber_two_mul_le_externalCoveringNumber (ε / 2) K

/-- Internal covering numbers are approximately monotone under inclusion,
with radius loss by a factor of two. -/
theorem coveringNumber_subset_half_radius
    {T : Type*} [PseudoEMetricSpace T] {L K : Set T} {ε : ℝ≥0}
    (hLK : L ⊆ K) :
    _root_.Metric.coveringNumber ε L ≤
      _root_.Metric.coveringNumber (ε / 2) K :=
  _root_.Metric.coveringNumber_subset_le hLK

/-- The three-point set `{-1, 0, 1}` can be covered internally at radius one
by its center, whereas its two-point subset `{-1, 1}` needs both points. -/
theorem coveringNumber_real_three_point_counterexample :
    let L : Set ℝ := {-1, 1}
    let K : Set ℝ := {-1, 0, 1}
    L ⊆ K ∧
      _root_.Metric.coveringNumber 1 L = 2 ∧
      _root_.Metric.coveringNumber 1 K = 1 := by
  dsimp only
  have hKcover : _root_.Metric.IsCover 1 ({-1, 0, 1} : Set ℝ) {0} := by
    simp [Metric.IsCover, SetRel.IsCover, edist_dist]
    constructor <;> norm_num [Real.dist_eq] <;> exact le_rfl
  have hKnumber :
      _root_.Metric.coveringNumber 1 ({-1, 0, 1} : Set ℝ) = 1 := by
    apply le_antisymm
    · exact (hKcover.coveringNumber_le_encard (by simp)).trans (by simp)
    · simpa [Order.one_le_iff_pos]
  have hLnumber :
      _root_.Metric.coveringNumber 1 ({-1, 1} : Set ℝ) = 2 := by
    apply le_antisymm
    · calc
        _root_.Metric.coveringNumber 1 ({-1, 1} : Set ℝ) ≤
            ({-1, 1} : Set ℝ).encard :=
          _root_.Metric.coveringNumber_le_encard_self _
        _ = 2 := Set.encard_pair (by norm_num)
    · simp only [_root_.Metric.coveringNumber]
      refine le_iInf fun C => le_iInf fun hCL => le_iInf fun hcover => ?_
      have hneg_cover := hcover (show (-1 : ℝ) ∈ ({-1, 1} : Set ℝ) by simp)
      obtain ⟨yneg, hynegC, hnegdist⟩ := hneg_cover
      have hynegL := hCL hynegC
      have hyneg : yneg = -1 := by
        simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hynegL
        rcases hynegL with h | h
        · exact h
        · subst yneg
          norm_num [edist_dist, Real.dist_eq] at hnegdist
      have hpos_cover := hcover (show (1 : ℝ) ∈ ({-1, 1} : Set ℝ) by simp)
      obtain ⟨ypos, hyposC, hposdist⟩ := hpos_cover
      have hyposL := hCL hyposC
      have hypos : ypos = 1 := by
        simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hyposL
        rcases hyposL with h | h
        · subst ypos
          norm_num [edist_dist, Real.dist_eq] at hposdist
        · exact h
      have hLC : ({-1, 1} : Set ℝ) ⊆ C := by
        intro x hx
        simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx
        rcases hx with rfl | rfl
        · simpa [hyneg] using hynegC
        · simpa [hypos] using hyposC
      calc
        2 = ({-1, 1} : Set ℝ).encard :=
          (Set.encard_pair (by norm_num)).symm
        _ ≤ C.encard := Set.encard_le_encard hLC
  refine ⟨?_, hLnumber, hKnumber⟩
  intro x hx
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hx ⊢
  tauto

/-- Consequently internal covering numbers are not monotone under set
inclusion at a fixed radius. -/
theorem not_coveringNumber_mono_set :
    ∃ (L K : Set ℝ) (ε : ℝ≥0),
      L ⊆ K ∧
        ¬ _root_.Metric.coveringNumber ε L ≤
          _root_.Metric.coveringNumber ε K := by
  refine ⟨{-1, 1}, {-1, 0, 1}, 1,
    coveringNumber_real_three_point_counterexample.1, ?_⟩
  rw [coveringNumber_real_three_point_counterexample.2.1,
    coveringNumber_real_three_point_counterexample.2.2]
  exact not_le_of_gt (ENat.coe_lt_coe.mpr one_lt_two)

end NumStability.HDP.Metric
