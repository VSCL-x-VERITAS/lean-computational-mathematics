import Mathlib.Topology.MetricSpace.CoveringNumbers
import Mathlib.Data.Set.Card
import Mathlib.Data.Fintype.Sigma
import Mathlib.Tactic

/-!
# A packing supremum without an attaining set

Finite blocks have increasing sizes, distance two inside a block and distance
one across blocks. The core proof is recovered from the reviewed finite-cluster
witness. The dedicated point type confines its metric instance. No source
cardinality convention is selected by this ordinary mathematical example.
-/
open scoped ENNReal NNReal

noncomputable section

namespace NumStability.HDP.Metric.PackingNonattainment

structure Point where
  fst : ℕ
  snd : Fin (fst + 1)
  deriving DecidableEq

def pointDist (x y : Point) : ℝ :=
  if x = y then 0 else if x.1 = y.1 then 2 else 1

instance : MetricSpace Point where
  dist := pointDist
  dist_self := by intro x; simp [pointDist]
  dist_comm := by intro x y; simp [pointDist, eq_comm]
  dist_triangle := by
    intro x y z
    unfold pointDist
    split_ifs <;> subst_vars <;> simp_all
    all_goals norm_num
  eq_of_dist_eq_zero := by
    intro x y h
    by_contra hne
    by_cases hblock : x.1 = y.1 <;> simp [pointDist, hne, hblock] at h

def block (k : ℕ) : Set Point := Set.range (fun i : Fin (k + 1) => (⟨k, i⟩ : Point))

theorem block_finite (k : ℕ) : (block k).Finite := Set.finite_range _

theorem block_ncard (k : ℕ) : (block k).ncard = k + 1 := by
  unfold block
  rw [Set.ncard_range_of_injective]
  · simp
  · intro i j h
    cases h
    rfl

theorem block_separated (k : ℕ) : _root_.Metric.IsSeparated 1 (block k) := by
  intro x hx y hy hne
  obtain ⟨i, rfl⟩ := hx
  obtain ⟨j, rfl⟩ := hy
  rw [edist_dist]
  change (1 : ENNReal) < ENNReal.ofReal (pointDist ⟨k, i⟩ ⟨k, j⟩)
  norm_num [pointDist, hne]

theorem separated_set_finite (S : Set Point) (hS : _root_.Metric.IsSeparated 1 S) : S.Finite := by
  rcases S.eq_empty_or_nonempty with hempty | ⟨x, hx⟩
  · rw [hempty]
    exact Set.finite_empty
  · apply (block_finite x.1).subset
    intro y hy
    have hindex : y.1 = x.1 := by
      by_cases hxy : y = x
      · exact congrArg Point.fst hxy
      · by_contra hne
        have hdist := hS hy hx hxy
        change (1 : ENNReal) < edist y x at hdist
        rw [edist_dist] at hdist
        change (1 : ENNReal) < ENNReal.ofReal (pointDist y x) at hdist
        simp [pointDist, hxy, hne] at hdist
    rcases y with ⟨k, i⟩
    dsimp only at hindex
    subst k
    exact ⟨i, rfl⟩

theorem exists_larger_separated_set (S : Set Point) :
    ∃ T : Set Point, T.Finite ∧ _root_.Metric.IsSeparated 1 T ∧ S.ncard < T.ncard := by
  refine ⟨block S.ncard, block_finite _, block_separated _, ?_⟩
  rw [block_ncard]
  exact Nat.lt_succ_self _

theorem no_largest_separated_set :
    ¬ ∃ S : Set Point, _root_.Metric.IsSeparated 1 S ∧
      ∀ T : Set Point, _root_.Metric.IsSeparated 1 T → T.ncard ≤ S.ncard := by
  rintro ⟨S, hS, hmax⟩
  obtain ⟨T, _, hT, hlt⟩ := exists_larger_separated_set S
  exact (not_le_of_gt hlt) (hmax T hT)

theorem singleton_cover :
    _root_.Metric.IsCover 1 (Set.univ : Set Point) {(⟨0, 0⟩ : Point)} := by
  intro x _
  refine ⟨⟨0, 0⟩, by simp, ?_⟩
  change edist x (⟨0, 0⟩ : Point) ≤ (1 : ENNReal)
  rw [edist_dist]
  have hbound : pointDist x (⟨0, 0⟩ : Point) ≤ 1 := by
    rcases x with ⟨k, i⟩
    by_cases hk : k = 0
    · subst k
      have hi : i = 0 := by apply Fin.ext; omega
      subst i
      simp [pointDist]
    · have hx : (⟨k, i⟩ : Point) ≠ ⟨0, 0⟩ := by
        intro heq
        exact hk (congrArg Point.fst heq)
      simp [pointDist, hx, hk]
  simpa using ENNReal.ofReal_le_ofReal hbound

/-- The extended cardinality agrees with the finite block size. -/
theorem block_encard (k : ℕ) : (block k).encard = (k + 1 : ℕ) := by
  rw [← (block_finite k).cast_ncard_eq, block_ncard]

/-- Unbounded finite packing sizes give an infinite extended-natural supremum. -/
theorem packingNumber_one_univ_eq_top :
    _root_.Metric.packingNumber (1 : ℝ≥0) (Set.univ : Set Point) = ⊤ := by
  apply ENat.eq_top_iff_forall_ge.mpr
  intro n
  have h := _root_.Metric.IsSeparated.encard_le_packingNumber (ε := 1)
    (Set.subset_univ (block n)) (block_separated n)
  rw [block_encard] at h
  have hn : (n : ℕ∞) ≤ (n + 1 : ℕ) :=
    ENat.coe_le_coe.mpr (Nat.le_succ _)
  exact hn.trans h

/-- The supremum is infinite although every admissible packing is finite. -/
theorem packingNumber_top_not_attained :
    _root_.Metric.packingNumber (1 : ℝ≥0) (Set.univ : Set Point) = ⊤ ∧
      ¬ ∃ P : Set Point, _root_.Metric.IsSeparated (1 : ℝ≥0∞) P ∧ P.encard = ⊤ := by
  refine ⟨packingNumber_one_univ_eq_top, ?_⟩
  rintro ⟨P, hP, hcard⟩
  exact (separated_set_finite P hP).encard_lt_top.ne hcard

end NumStability.HDP.Metric.PackingNonattainment
