import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic

/-!
# Restricted degrees in binomial random graphs

This module starts the decoupling infrastructure for sparse random-graph lower
bounds.  A vertex is tested only against a prescribed finite set of possible
neighbors.  Its restricted degree has the canonical binomial law with one
trial per vertex in that set.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- The number of neighbors of `v` belonging to the finite vertex set `S`. -/
noncomputable def graphRestrictedDegree {V : Type*}
    (v : V) (S : Finset V) (G : SimpleGraph V) : ℕ := by
  classical
  exact ∑ w ∈ S, if G.Adj v w then 1 else 0

lemma measurable_graphRestrictedDegree {V : Type*} (v : V) (S : Finset V) :
    Measurable (graphRestrictedDegree v S) := by
  unfold graphRestrictedDegree
  refine Finset.measurable_fun_sum S ?_
  intro w hw
  have hAdj : Measurable (fun G : SimpleGraph V => G.Adj v w) := by
    fun_prop
  have hset : MeasurableSet {G : SimpleGraph V | G.Adj v w} := by
    convert hAdj (measurableSet_singleton True) using 1
    ext G
    simp
  exact Measurable.ite hset measurable_const measurable_const

lemma graphStarExactCardEvent_eq_preimage_graphRestrictedDegree
    {V : Type*} [DecidableEq V] {v : V} {S : Finset V} (k : ℕ) :
    graphStarExactCardEvent v S k =
      graphRestrictedDegree v S ⁻¹' ({k} : Set ℕ) := by
  classical
  ext G
  rw [Set.mem_preimage, Set.mem_singleton_iff]
  unfold graphRestrictedDegree
  rw [Finset.sum_boole]
  constructor
  · intro hG
    simp only [graphStarExactCardEvent, Set.mem_iUnion] at hG
    rcases hG with ⟨T, hTC, hGT⟩
    have hTsub : T ⊆ S := (Finset.mem_powersetCard.mp hTC).1
    have hfilter : S.filter (fun w => G.Adj v w) = T := by
      ext w
      by_cases hwS : w ∈ S
      · simp [hwS, (hGT w hwS)]
      · have hwT : w ∉ T := fun h => hwS (hTsub h)
        simp [hwS, hwT]
    rw [hfilter]
    exact (Finset.mem_powersetCard.mp hTC).2
  · intro hcard
    let T : Finset V := S.filter fun w => G.Adj v w
    have hTsub : T ⊆ S := Finset.filter_subset _ _
    have hGT : G ∈ graphStarExactEvent v S T := by
      intro w hwS
      simp [T, hwS]
    simp only [graphStarExactCardEvent, Set.mem_iUnion]
    exact ⟨T, Finset.mem_powersetCard.mpr ⟨hTsub, hcard⟩, hGT⟩

/-- The canonical natural-valued binomial law for a restricted degree. -/
noncomputable def graphRestrictedBinomialLaw
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) : Measure ℕ :=
  (LimitTheorems.binomialNatPMF (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) S.card).toMeasure

lemma graphRestrictedDegree_map_apply
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {v : V} {S : Finset V} (hvS : v ∉ S) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).map (graphRestrictedDegree v S) {k} =
      graphRestrictedBinomialLaw S p {k} := by
  rw [Measure.map_apply (measurable_graphRestrictedDegree v S)
    (measurableSet_singleton k)]
  rw [← graphStarExactCardEvent_eq_preimage_graphRestrictedDegree k]
  rw [binomialRandom_graphStarExactCardEvent_probability (p := p) hvS k]
  rw [graphRestrictedBinomialLaw,
    PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  unfold LimitTheorems.binomialNatPMF
  rw [PMF.map_apply, tsum_fintype]
  by_cases hk : k < S.card + 1
  · rw [Finset.sum_eq_single (⟨k, hk⟩ : Fin (S.card + 1))]
    · have hq : 1 - unitInterval.toNNReal p =
          unitInterval.toNNReal (unitInterval.symm p) := by
        exact (eq_tsub_of_add_eq (unitInterval.toNNReal_symm_add_toNNReal p)).symm
      have hqE : (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
          1 - (unitInterval.toNNReal p : ℝ≥0∞) := by
        calc
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
              (1 - unitInterval.toNNReal p : ℝ≥0∞) :=
            congrArg (fun x : ℝ≥0 => (x : ℝ≥0∞)) hq.symm
          _ = 1 - (unitInterval.toNNReal p : ℝ≥0∞) := by rfl
      simp [PMF.binomial_apply, hqE]
      ring
    · intro b _hb hbk
      by_cases h : k = (b : ℕ)
      · exfalso
        apply hbk
        apply Fin.ext
        exact h.symm
      · simp [h]
    · simp
  · have hlt : S.card < k := by omega
    have hne : ∀ b : Fin (S.card + 1), k ≠ (b : ℕ) := by
      intro b h
      omega
    simp [Nat.choose_eq_zero_of_lt hlt, hne]

theorem graphRestrictedDegree_hasLaw
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {v : V} {S : Finset V} (hvS : v ∉ S) :
    HasLaw (graphRestrictedDegree v S) (graphRestrictedBinomialLaw S p)
      (SimpleGraph.binomialRandom V p) := by
  refine {
    aemeasurable := (measurable_graphRestrictedDegree v S).aemeasurable
    map_eq := ?_ }
  apply Measure.ext_of_singleton
  intro k
  exact graphRestrictedDegree_map_apply p hvS k

end NumStability.HDP.Scalar.IndependentSums.Chernoff
