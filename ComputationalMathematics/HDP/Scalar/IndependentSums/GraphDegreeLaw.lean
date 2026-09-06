import Mathlib.Probability.Combinatorics.BinomialRandomGraph.Defs
import Mathlib.Combinatorics.SimpleGraph.Finite
import Mathlib.Probability.HasLaw
import Mathlib.Probability.ProbabilityMassFunction.Binomial
import Mathlib.Tactic

/-!
# Vertex-degree law for binomial random graphs

This reusable support module identifies the degree of a fixed vertex in
Mathlib's binomial random graph with the corresponding binomial law. It is
kept separate from the source-facing Chernoff applications so the finite-event
and measurability lemmas can be reused independently.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- The unordered pairs formed by `v` and the vertices in `S`. -/
def graphStarEdgeFinset {V : Type*} (v : V) (S : Finset V) : Finset (Sym2 V) :=
  S.map (Sym2.mkEmbedding v)

@[simp] theorem graphStarEdgeFinset_card {V : Type*} (v : V) (S : Finset V) :
    (graphStarEdgeFinset v S).card = S.card := by
  simp [graphStarEdgeFinset]

/-- Subsets whose membership agrees with `T` on the finite coordinate set `E`. -/
def setBernoulliFinsetExactEvent {ι : Type*} (E T : Finset ι) : Set (Set ι) :=
  {s | ∀ e ∈ E, (e ∈ s ↔ e ∈ T)}

lemma finset_prod_ite_mem_eq_pow_mul_pow {α M : Type*}
    [DecidableEq α] [CommMonoid M] (E T : Finset α) (hT : T ⊆ E)
    (a b : M) :
    (∏ e ∈ E, if e ∈ T then a else b) =
      a ^ T.card * b ^ (E.card - T.card) := by
  classical
  have hfilter : E.filter (fun e => e ∈ T) = T := by
    ext e
    constructor
    · intro h
      exact (Finset.mem_filter.mp h).2
    · intro heT
      exact Finset.mem_filter.mpr ⟨hT heT, heT⟩
  have hfilterNot : E.filter (fun e => e ∉ T) = E \ T := by
    ext e
    simp
  calc
    (∏ e ∈ E, if e ∈ T then a else b) =
        (∏ e ∈ E.filter (fun e => e ∈ T), if e ∈ T then a else b) *
          (∏ e ∈ E.filter (fun e => e ∉ T), if e ∈ T then a else b) := by
      rw [← Finset.prod_filter_mul_prod_filter_not
        (s := E) (p := fun e => e ∈ T)
        (f := fun e => if e ∈ T then a else b)]
    _ = (∏ _e ∈ T, a) * (∏ _e ∈ E \ T, b) := by
      rw [hfilter, hfilterNot]
      congr 1
      · exact Finset.prod_congr rfl fun e he => by simp [he]
      · refine Finset.prod_congr rfl fun e he => ?_
        have hnot : e ∉ T := (Finset.mem_sdiff.mp he).2
        simp [hnot]
    _ = a ^ T.card * b ^ (E.card - T.card) := by
      simp [Finset.card_sdiff_of_subset hT]

lemma setBernoulliFinsetExactEvent_probability
    {ι : Type*} [DecidableEq ι] (u : Set ι) (p : Set.Icc (0 : ℝ) 1)
    (E T : Finset ι) (hE : (E : Set ι) ⊆ u) (hT : T ⊆ E) :
    setBer(u, p) (setBernoulliFinsetExactEvent E T) =
      (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
          (E.card - T.card) := by
  classical
  rw [ProbabilityTheory.setBernoulli_apply']
  have hpre :
      ((fun q : ι → Prop => {i | q i}) ⁻¹'
          setBernoulliFinsetExactEvent E T) =
        Set.pi (E : Set ι)
          (fun e => if e ∈ T then ({True} : Set Prop) else ({False} : Set Prop)) := by
    ext f
    simp only [Set.mem_preimage, setBernoulliFinsetExactEvent,
      Set.mem_setOf_eq, Set.mem_pi, Finset.mem_coe]
    constructor
    · intro h e heE
      by_cases heT : e ∈ T
      · simp [heT, (h e heE).2 heT]
      · have hnot : ¬ f e := fun hf => heT ((h e heE).1 hf)
        simp [heT, hnot]
    · intro h e heE
      have he := h e heE
      by_cases heT : e ∈ T
      · simp [heT] at he
        exact ⟨fun _ => heT, fun _ => he⟩
      · simp [heT] at he
        exact ⟨fun hf => (he hf).elim, fun hmem => False.elim (heT hmem)⟩
  rw [hpre, Measure.infinitePi_pi]
  · calc
      (∏ e ∈ E,
          (unitInterval.toNNReal p • Measure.dirac (e ∈ u) +
              unitInterval.toNNReal (unitInterval.symm p) • Measure.dirac False)
            (if e ∈ T then ({True} : Set Prop) else ({False} : Set Prop))) =
        ∏ e ∈ E, if e ∈ T then
          (unitInterval.toNNReal p : ℝ≥0∞) else
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) := by
            refine Finset.prod_congr rfl ?_
            intro e heE
            have heu : e ∈ u := hE (by simpa using heE)
            by_cases heT : e ∈ T <;>
              simp [heT, heu, ENNReal.smul_def]
      _ = (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
            (E.card - T.card) :=
          finset_prod_ite_mem_eq_pow_mul_pow E T hT _ _
  · intro e _he
    by_cases heT : e ∈ T <;> simp [heT]

/-- Graphs whose adjacency to `v` agrees with membership in `T` on `S`. -/
def graphStarExactEvent {V : Type*} (v : V) (S T : Finset V) : Set (SimpleGraph V) :=
  {G | ∀ w ∈ S, (G.Adj v w ↔ w ∈ T)}

lemma graphStarEdgeFinset_subset_diag_compl {V : Type*} {v : V} {S : Finset V}
    (hvS : v ∉ S) :
    (graphStarEdgeFinset v S : Set (Sym2 V)) ⊆ Sym2.diagSetᶜ := by
  intro e he
  rcases Finset.mem_map.mp he with ⟨w, hw, rfl⟩
  change s(v, w) ∈ Sym2.diagSetᶜ
  rw [Set.mem_compl_iff, Sym2.mem_diagSet, Sym2.mk_isDiag_iff]
  intro hvw
  exact hvS (by simpa [hvw] using hw)

/-- Graphs whose edge membership on `E` agrees exactly with `T`. -/
def graphEdgesExactFinsetEvent {V : Type*} (E T : Finset (Sym2 V)) :
    Set (SimpleGraph V) :=
  {G | ∀ e ∈ E, (e ∈ G.edgeSet ↔ e ∈ T)}

lemma measurableSet_graphEdgesExactFinsetEvent {V : Type*}
    [DecidableEq (Sym2 V)] (E T : Finset (Sym2 V)) :
    MeasurableSet (graphEdgesExactFinsetEvent E T) := by
  classical
  rw [show graphEdgesExactFinsetEvent E T =
      ⋂ e ∈ E,
        if e ∈ T then {G : SimpleGraph V | e ∈ G.edgeSet}
        else {G : SimpleGraph V | e ∉ G.edgeSet} by
    ext G
    simp only [Set.mem_iInter, graphEdgesExactFinsetEvent, Set.mem_setOf_eq]
    constructor
    · intro h e heE
      by_cases heT : e ∈ T
      · simp [heT, (h e heE).2 heT]
      · have hnot : e ∉ G.edgeSet := fun hmem => heT ((h e heE).1 hmem)
        simp [heT, hnot]
    · intro h e heE
      have he := h e heE
      by_cases heT : e ∈ T
      · simp [heT] at he
        exact ⟨fun _ => heT, fun _ => he⟩
      · simp [heT] at he
        exact ⟨fun hmem => (he hmem).elim,
          fun hmemT => False.elim (heT hmemT)⟩]
  exact E.measurableSet_biInter fun e _he => by
    by_cases heT : e ∈ T
    · simpa only [heT, if_true] using
        (measurableSet_mem e).preimage SimpleGraph.measurable_edgeSet
    · simpa only [heT, if_false] using
        ((measurableSet_mem e).preimage SimpleGraph.measurable_edgeSet).compl

lemma graphStarExactEvent_eq_graphEdgesExactFinsetEvent
    {V : Type*} {v : V} {S T : Finset V} (hvS : v ∉ S) :
    graphStarExactEvent v S T =
      graphEdgesExactFinsetEvent (graphStarEdgeFinset v S)
        (graphStarEdgeFinset v T) := by
  ext G
  simp [graphStarExactEvent, graphEdgesExactFinsetEvent,
    graphStarEdgeFinset, SimpleGraph.mem_edgeSet]
  constructor
  · intro h a haS
    have hmem : (∃ b ∈ T, b = a ∨ v = a ∧ b = v) ↔ a ∈ T := by
      constructor
      · rintro ⟨b, hbT, hba | ⟨hva, _hbv⟩⟩
        · simpa [hba] using hbT
        · exact False.elim (hvS (by simpa [hva] using haS))
      · intro haT
        exact ⟨a, haT, Or.inl rfl⟩
    exact (h a haS).trans hmem.symm
  · intro h a haS
    have hmem : (∃ b ∈ T, b = a ∨ v = a ∧ b = v) ↔ a ∈ T := by
      constructor
      · rintro ⟨b, hbT, hba | ⟨hva, _hbv⟩⟩
        · simpa [hba] using hbT
        · exact False.elim (hvS (by simpa [hva] using haS))
      · intro haT
        exact ⟨a, haT, Or.inl rfl⟩
    exact (h a haS).trans hmem

lemma binomialRandom_graphStarExactEvent_probability
    {V : Type*} [Countable V] [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {v : V} {S T : Finset V} (hvS : v ∉ S) (hT : T ⊆ S) :
    SimpleGraph.binomialRandom V p (graphStarExactEvent v S T) =
      (unitInterval.toNNReal p : ℝ≥0∞) ^ T.card *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^
          (S.card - T.card) := by
  rw [graphStarExactEvent_eq_graphEdgesExactFinsetEvent hvS]
  rw [SimpleGraph.binomialRandom_eq_map]
  rw [Measure.map_apply SimpleGraph.measurable_fromEdgeSet]
  · have hpre :
        SimpleGraph.fromEdgeSet ⁻¹'
            (graphEdgesExactFinsetEvent (graphStarEdgeFinset v S)
              (graphStarEdgeFinset v T)) =
          setBernoulliFinsetExactEvent (graphStarEdgeFinset v S)
            (graphStarEdgeFinset v T) := by
      ext s
      simp only [Set.mem_preimage, graphEdgesExactFinsetEvent,
        setBernoulliFinsetExactEvent, Set.mem_setOf_eq]
      constructor
      · intro hs e heE
        have hnotdiag : e ∈ Sym2.diagSetᶜ :=
          graphStarEdgeFinset_subset_diag_compl hvS (by simpa using heE)
        have hnotdiag' : ¬ e.IsDiag := by simpa [Sym2.mem_diagSet] using hnotdiag
        rw [SimpleGraph.edgeSet_fromEdgeSet] at hs
        have hiff := hs e heE
        simpa [hnotdiag'] using hiff
      · intro hs e heE
        have hnotdiag : e ∈ Sym2.diagSetᶜ :=
          graphStarEdgeFinset_subset_diag_compl hvS (by simpa using heE)
        have hnotdiag' : ¬ e.IsDiag := by simpa [Sym2.mem_diagSet] using hnotdiag
        rw [SimpleGraph.edgeSet_fromEdgeSet]
        simp [hnotdiag', hs e heE]
    rw [hpre]
    simpa [graphStarEdgeFinset] using (setBernoulliFinsetExactEvent_probability
      (u := Sym2.diagSetᶜ) (p := p)
      (E := graphStarEdgeFinset v S) (T := graphStarEdgeFinset v T)
      (graphStarEdgeFinset_subset_diag_compl hvS)
      (by simpa [graphStarEdgeFinset] using hT))
  · exact measurableSet_graphEdgesExactFinsetEvent _ _

lemma measurableSet_graphStarExactEvent
    {V : Type*} [DecidableEq (Sym2 V)] {v : V} {S T : Finset V}
    (hvS : v ∉ S) : MeasurableSet (graphStarExactEvent v S T) := by
  rw [graphStarExactEvent_eq_graphEdgesExactFinsetEvent hvS]
  exact measurableSet_graphEdgesExactFinsetEvent _ _

/-- Graphs in which `v` has exactly `k` neighbors in `S`. -/
def graphStarExactCardEvent {V : Type*} (v : V) (S : Finset V) (k : ℕ) :
    Set (SimpleGraph V) :=
  ⋃ T ∈ S.powersetCard k, graphStarExactEvent v S T

lemma measurableSet_graphStarExactCardEvent
    {V : Type*} [DecidableEq (Sym2 V)] {v : V} {S : Finset V}
    (hvS : v ∉ S) (k : ℕ) :
    MeasurableSet (graphStarExactCardEvent v S k) := by
  classical
  exact (S.powersetCard k).measurableSet_biUnion fun T _hT =>
    measurableSet_graphStarExactEvent hvS

lemma graphStarExactEvent_disjoint_of_ne
    {V : Type*} {v : V} {S T U : Finset V}
    (hT : T ⊆ S) (hU : U ⊆ S) (hne : T ≠ U) :
    Disjoint (graphStarExactEvent v S T) (graphStarExactEvent v S U) := by
  rw [Set.disjoint_left]
  intro G hGT hGU
  exact hne (by
    ext w
    by_cases hwS : w ∈ S
    · constructor
      · intro hwT
        exact (hGU w hwS).1 ((hGT w hwS).2 hwT)
      · intro hwU
        exact (hGT w hwS).1 ((hGU w hwS).2 hwU)
    · constructor
      · intro hwT
        exact False.elim (hwS (hT hwT))
      · intro hwU
        exact False.elim (hwS (hU hwU)))

lemma binomialRandom_graphStarExactCardEvent_probability_real
    {V : Type*} [Fintype V] [Countable V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) {v : V} {S : Finset V} (hvS : v ∉ S) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).real
        (graphStarExactCardEvent v S k) =
      (Nat.choose S.card k : ℝ) * (unitInterval.toNNReal p : ℝ) ^ k *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k) := by
  classical
  let C : Finset (Finset V) := S.powersetCard k
  let A : Finset V → Set (SimpleGraph V) :=
    fun T => graphStarExactEvent v S T
  have hpd : (↑C : Set (Finset V)).PairwiseDisjoint A := by
    intro T hTC U hUC hne
    exact graphStarExactEvent_disjoint_of_ne
      (Finset.mem_powersetCard.mp hTC).1
      (Finset.mem_powersetCard.mp hUC).1 hne
  have hmeas : ∀ T ∈ C, MeasurableSet (A T) := by
    intro T _hT
    exact measurableSet_graphStarExactEvent hvS
  have hUnionReal :
      (SimpleGraph.binomialRandom V p).real (⋃ T ∈ C, A T) =
        ∑ T ∈ C, (SimpleGraph.binomialRandom V p).real (A T) := by
    exact MeasureTheory.measureReal_biUnion_finset (μ := SimpleGraph.binomialRandom V p)
      hpd hmeas
  calc
    (SimpleGraph.binomialRandom V p).real
        (graphStarExactCardEvent v S k) =
      (SimpleGraph.binomialRandom V p).real (⋃ T ∈ C, A T) := by rfl
    _ = ∑ T ∈ C, (SimpleGraph.binomialRandom V p).real (A T) := hUnionReal
    _ = ∑ _T ∈ C,
        ((unitInterval.toNNReal p : ℝ) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k)) := by
      apply Finset.sum_congr rfl
      intro T hTC
      dsimp [A]
      rw [measureReal_def, binomialRandom_graphStarExactEvent_probability
        (p := p) hvS (Finset.mem_powersetCard.mp hTC).1]
      rw [(Finset.mem_powersetCard.mp hTC).2]
      simp
    _ = (C.card : ℝ) *
        ((unitInterval.toNNReal p : ℝ) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k)) := by
      simp
    _ = (Nat.choose S.card k : ℝ) *
        ((unitInterval.toNNReal p : ℝ) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k)) := by
      simp [C, Finset.card_powersetCard]
    _ = (Nat.choose S.card k : ℝ) * (unitInterval.toNNReal p : ℝ) ^ k *
        (unitInterval.toNNReal (unitInterval.symm p) : ℝ) ^ (S.card - k) := by
      ring

lemma binomialRandom_graphStarExactCardEvent_probability
    {V : Type*} [Fintype V] [Countable V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) {v : V} {S : Finset V} (hvS : v ∉ S) (k : ℕ) :
    SimpleGraph.binomialRandom V p (graphStarExactCardEvent v S k) =
      (Nat.choose S.card k : ℝ≥0∞) *
        (unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k) := by
  classical
  let C : Finset (Finset V) := S.powersetCard k
  let A : Finset V → Set (SimpleGraph V) :=
    fun T => graphStarExactEvent v S T
  have hpd : (↑C : Set (Finset V)).PairwiseDisjoint A := by
    intro T hTC U hUC hne
    exact graphStarExactEvent_disjoint_of_ne
      (Finset.mem_powersetCard.mp hTC).1
      (Finset.mem_powersetCard.mp hUC).1 hne
  have hmeas : ∀ T ∈ C, MeasurableSet (A T) := by
    intro T _hT
    exact measurableSet_graphStarExactEvent hvS
  calc
    SimpleGraph.binomialRandom V p (graphStarExactCardEvent v S k) =
        SimpleGraph.binomialRandom V p (⋃ T ∈ C, A T) := by rfl
    _ = ∑ T ∈ C, SimpleGraph.binomialRandom V p (A T) :=
      MeasureTheory.measure_biUnion_finset (μ := SimpleGraph.binomialRandom V p) hpd hmeas
    _ = ∑ _T ∈ C,
        ((unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k)) := by
      apply Finset.sum_congr rfl
      intro T hTC
      dsimp [A]
      rw [binomialRandom_graphStarExactEvent_probability
        (p := p) hvS (Finset.mem_powersetCard.mp hTC).1]
      rw [(Finset.mem_powersetCard.mp hTC).2]
    _ = (C.card : ℝ≥0∞) *
        ((unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k)) := by
      simp
    _ = (Nat.choose S.card k : ℝ≥0∞) *
        ((unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k)) := by
      simp [C, Finset.card_powersetCard]
    _ = (Nat.choose S.card k : ℝ≥0∞) *
        (unitInterval.toNNReal p : ℝ≥0∞) ^ k *
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) ^ (S.card - k) := by
      ring

/-- The `Set.ncard` of the neighbor set of `v`, hence zero when that set is infinite. -/
def graphDegree {V : Type*} (v : V) (G : SimpleGraph V) : ℕ :=
  (G.neighborSet v).ncard

/-- The degree of `v` written as a finite sum of adjacency indicators. -/
noncomputable def graphDegreeSum {V : Type*} [Fintype V] (v : V) (G : SimpleGraph V) : ℕ := by
  classical
  exact ∑ w : V, if G.Adj v w then 1 else 0

lemma graphDegreeSum_eq_graphDegree {V : Type*} [Fintype V]
    (v : V) (G : SimpleGraph V) :
    graphDegreeSum v G = graphDegree v G := by
  classical
  unfold graphDegreeSum graphDegree
  rw [Finset.sum_boole]
  simp only [SimpleGraph.neighborSet]
  rw [Set.ncard_eq_toFinset_card']
  simp

lemma measurable_graphDegreeSum {V : Type*} [Fintype V] (v : V) :
    Measurable (graphDegreeSum v) := by
  unfold graphDegreeSum
  refine Finset.measurable_fun_sum Finset.univ ?_
  intro w hw
  have hAdj : Measurable (fun G : SimpleGraph V => G.Adj v w) := by
    fun_prop
  have hset : MeasurableSet {G : SimpleGraph V | G.Adj v w} := by
    convert hAdj (measurableSet_singleton True) using 1
    ext G
    simp
  exact Measurable.ite hset measurable_const measurable_const

lemma graphStarExactCardEvent_eq_preimage_graphDegree
    {V : Type*} [Fintype V] [DecidableEq V] {v : V} (k : ℕ) :
    graphStarExactCardEvent v (Finset.univ.erase v) k =
      graphDegree v ⁻¹' ({k} : Set ℕ) := by
  classical
  ext G
  constructor
  · intro hG
    simp only [graphStarExactCardEvent, Set.mem_iUnion] at hG
    rcases hG with ⟨T, hTC, hGT⟩
    have hTsub : T ⊆ Finset.univ.erase v :=
      (Finset.mem_powersetCard.mp hTC).1
    have hTcard : T.card = k := (Finset.mem_powersetCard.mp hTC).2
    have hneighbors : G.neighborSet v = (T : Set V) := by
      ext w
      constructor
      · intro hw
        have hwS : w ∈ (Finset.univ.erase v : Set V) := by
          simp only [Finset.mem_coe, Finset.mem_erase, Finset.mem_univ]
          exact ⟨by
            intro hwv
            subst w
            simp at hw, trivial⟩
        exact (hGT w hwS).1 (by simpa using hw)
      · intro hwT
        have hwS : w ∈ (Finset.univ.erase v : Set V) := hTsub (by simpa using hwT)
        exact (by simpa using (hGT w hwS).2 (by simpa using hwT))
    change (G.neighborSet v).ncard = k
    rw [hneighbors, Set.ncard_coe_finset]
    exact hTcard
  · intro hG
    have hdeg : graphDegree v G = k := by simpa using hG
    let T : Finset V := (G.neighborSet v).toFinset
    have hTsub : T ⊆ Finset.univ.erase v := by
      intro w hw
      have hwN : w ∈ G.neighborSet v := by simpa [T] using hw
      have hwv : w ≠ v := by
        intro hwv
        subst w
        simp at hwN
      simp [hwv]
    have hTcard : T.card = k := by
      calc
        T.card = (G.neighborSet v).ncard := by
          simp [T, Set.ncard_eq_toFinset_card']
        _ = graphDegree v G := rfl
        _ = k := hdeg
    have hGT : G ∈ graphStarExactEvent v (Finset.univ.erase v) T := by
      intro w hwS
      constructor
      · intro hwAdj
        have hwN : w ∈ G.neighborSet v := by simpa using hwAdj
        simpa [T] using hwN
      · intro hwT
        have hwN : w ∈ G.neighborSet v := by simpa [T] using hwT
        simpa using hwN
    simp only [graphStarExactCardEvent, Set.mem_iUnion]
    exact ⟨T, Finset.mem_powersetCard.mpr ⟨hTsub, hTcard⟩, hGT⟩

lemma graphStarExactCardEvent_eq_preimage_graphDegreeSum
    {V : Type*} [Fintype V] [DecidableEq V] {v : V} (k : ℕ) :
    graphStarExactCardEvent v (Finset.univ.erase v) k =
      graphDegreeSum v ⁻¹' ({k} : Set ℕ) := by
  rw [graphStarExactCardEvent_eq_preimage_graphDegree k]
  ext G
  simp [graphDegreeSum_eq_graphDegree]

/-- The natural-valued pushforward of the binomial law with `n - 1` trials. -/
noncomputable def graphBinomialLaw (n : ℕ) (p : Set.Icc (0 : ℝ) 1) : Measure ℕ :=
  ((PMF.binomial (unitInterval.toNNReal p)
      (by change (p : ℝ) ≤ 1; exact p.2.2) (n - 1)).map
      (fun i : Fin (n - 1 + 1) => (i : ℕ))).toMeasure

lemma graphBinomialLaw_apply_of_lt (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (k : ℕ)
    (hk : k < n - 1 + 1) :
    graphBinomialLaw n p {k} =
      ↑((unitInterval.toNNReal p) ^ k *
        (1 - unitInterval.toNNReal p) ^ ((n - 1) - k) *
          ((n - 1).choose k : ℕ) : ℝ≥0∞) := by
  rw [graphBinomialLaw, PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rw [PMF.map_apply, tsum_fintype]
  simp only [PMF.binomial_apply]
  rw [Finset.sum_eq_single (⟨k, hk⟩ : Fin (n - 1 + 1))]
  · simp
  · intro b _hb hbk
    by_cases h : k = (b : ℕ)
    · exfalso
      apply hbk
      apply Fin.ext
      exact h.symm
    · simp [h]
  · simp

theorem graphDegreeSum_map_apply {n : ℕ} (p : Set.Icc (0 : ℝ) 1) (v : Fin n) (k : ℕ) :
    (SimpleGraph.binomialRandom (Fin n) p).map (graphDegreeSum v) {k} =
      graphBinomialLaw n p {k} := by
  rw [Measure.map_apply (measurable_graphDegreeSum v) (measurableSet_singleton k)]
  rw [← graphStarExactCardEvent_eq_preimage_graphDegreeSum k]
  rw [binomialRandom_graphStarExactCardEvent_probability
    (p := p) (v := v) (S := Finset.univ.erase v) (by simp) k]
  rw [graphBinomialLaw, PMF.toMeasure_apply_singleton _ k (measurableSet_singleton k)]
  rw [PMF.map_apply, tsum_fintype]
  by_cases hk : k < n - 1 + 1
  · rw [Finset.sum_eq_single (⟨k, hk⟩ : Fin (n - 1 + 1))]
    · have hq : 1 - unitInterval.toNNReal p =
          unitInterval.toNNReal (unitInterval.symm p) := by
        exact (eq_tsub_of_add_eq (unitInterval.toNNReal_symm_add_toNNReal p)).symm
      have hpNN : unitInterval.toNNReal p ≤ 1 := by
        change (p : ℝ) ≤ 1
        exact p.2.2
      have hqE : (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
          1 - (unitInterval.toNNReal p : ℝ≥0∞) := by
        calc
          (unitInterval.toNNReal (unitInterval.symm p) : ℝ≥0∞) =
              (1 - unitInterval.toNNReal p : ℝ≥0∞) :=
            congrArg (fun x : ℝ≥0 => (x : ℝ≥0∞)) hq.symm
          _ = 1 - (unitInterval.toNNReal p : ℝ≥0∞) := by
            rfl
      simp [PMF.binomial_apply, Finset.card_erase_of_mem, hqE]
      ring
    · intro b _hb hbk
      by_cases h : k = (b : ℕ)
      · exfalso
        apply hbk
        apply Fin.ext
        exact h.symm
      · simp [h]
    · simp
  · have hk' : n - 1 + 1 ≤ k := Nat.le_of_not_gt hk
    simp only [PMF.binomial_apply]
    have hlt : n - 1 < k := by omega
    have hne : ∀ b : Fin (n - 1 + 1), k ≠ (b : ℕ) := by
      intro b h
      omega
    simp [Finset.card_erase_of_mem, Nat.choose_eq_zero_of_lt hlt, hne]

theorem graphDegreeSum_hasLaw {n : ℕ} (p : Set.Icc (0 : ℝ) 1) (v : Fin n) :
    HasLaw (graphDegreeSum v) (graphBinomialLaw n p)
      (SimpleGraph.binomialRandom (Fin n) p) := by
  refine { aemeasurable := (measurable_graphDegreeSum v).aemeasurable, map_eq := ?_ }
  apply Measure.ext_of_singleton
  intro k
  exact graphDegreeSum_map_apply p v k

end NumStability.HDP.Scalar.IndependentSums.Chernoff
