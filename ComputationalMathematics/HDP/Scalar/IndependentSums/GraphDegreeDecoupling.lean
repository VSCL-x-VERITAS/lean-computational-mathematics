import ComputationalMathematics.HDP.Scalar.IndependentSums.GraphDegreeLaw
import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic
import Mathlib.Data.Nat.Choose.Bounds
import Mathlib.Probability.Independence.InfinitePi

/-!
# Restricted degrees in binomial random graphs

This module starts the decoupling infrastructure for sparse random-graph lower
bounds.  A vertex is tested only against a prescribed finite set of possible
neighbors.  Its restricted degree has the canonical binomial law with one
trial per vertex in that set.
-/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped BigOperators ENNReal NNReal Topology

namespace NumStability.HDP.Scalar.IndependentSums.Chernoff

/-- Independence is preserved when a flat independent family is grouped into
disjoint dependent-product blocks. -/
lemma iIndepFun_group_sigma
    {I Ω : Type*} {J : I → Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    {X : (i : I) → (j : J i) → Ω → Prop}
    (hX : ∀ i j, Measurable (X i j))
    (hflat : iIndepFun (fun p : (i : I) × J i ↦ X p.1 p.2) μ) :
    iIndepFun (fun i ω j ↦ X i j ω) μ := by
  have hrow (i : I) : iIndepFun (X i) μ := by
    exact hflat.precomp (g := fun j ↦ ⟨i, j⟩) (by
      intro j k hjk
      simpa using hjk)
  have : ∀ i j, IsProbabilityMeasure (μ.map (X i j)) :=
    fun i j ↦ Measure.isProbabilityMeasure_map (hX i j).aemeasurable
  rw [iIndepFun_iff_map_fun_eq_infinitePi_map (by fun_prop)]
  have hcurry :
      (fun ω i j ↦ X i j ω) =
        (MeasurableEquiv.piCurry (fun i j ↦ Prop)) ∘
          (fun ω (p : (i : I) × J i) ↦ X p.1 p.2 ω) := by
    funext ω i j
    rfl
  rw [hcurry, ← Measure.map_map (by fun_prop) (by fun_prop)]
  rw [(iIndepFun_iff_map_fun_eq_infinitePi_map (by
    intro p
    exact hX p.1 p.2)).1 hflat]
  rw [Measure.infinitePi_map_piCurry
    (X := fun _ _ ↦ Prop) (μ := fun i j ↦ μ.map (X i j))]
  congrm Measure.infinitePi fun i ↦ ?_
  exact ((iIndepFun_iff_map_fun_eq_infinitePi_map (hX i)).1 (hrow i)).symm

/-- Pulling a measurable family back along a measurable random element turns
independence under the pushforward law into independence on the original
space. -/
lemma iIndepFun_map_iff
    {I Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
    {μ : Measure Ω} {F : Ω → Ω'} {X : I → Ω' → Prop}
    (hF : Measurable F) (hX : ∀ i, Measurable (X i)) :
    iIndepFun X (μ.map F) ↔ iIndepFun (fun i ↦ X i ∘ F) μ := by
  rw [iIndepFun_iff_measure_inter_preimage_eq_mul,
    iIndepFun_iff_measure_inter_preimage_eq_mul]
  constructor
  · intro h S sets hsets
    have hInter : MeasurableSet (⋂ i ∈ S, X i ⁻¹' sets i) :=
      S.measurableSet_biInter fun i hi ↦ (hsets i hi).preimage (hX i)
    calc
      μ (⋂ i ∈ S, (X i ∘ F) ⁻¹' sets i) =
          μ (F ⁻¹' (⋂ i ∈ S, X i ⁻¹' sets i)) := by
        congr 1
        ext ω
        simp [Function.comp_def]
      _ = (μ.map F) (⋂ i ∈ S, X i ⁻¹' sets i) :=
        (Measure.map_apply hF hInter).symm
      _ = ∏ i ∈ S, (μ.map F) (X i ⁻¹' sets i) := h S hsets
      _ = ∏ i ∈ S, μ (F ⁻¹' (X i ⁻¹' sets i)) := by
        apply Finset.prod_congr rfl
        intro i hi
        rw [Measure.map_apply hF ((hsets i hi).preimage (hX i))]
      _ = ∏ i ∈ S, μ ((X i ∘ F) ⁻¹' sets i) := by
        congr 1
  · intro h S sets hsets
    have hInter : MeasurableSet (⋂ i ∈ S, X i ⁻¹' sets i) :=
      S.measurableSet_biInter fun i hi ↦ (hsets i hi).preimage (hX i)
    calc
      (μ.map F) (⋂ i ∈ S, X i ⁻¹' sets i) =
          μ (F ⁻¹' (⋂ i ∈ S, X i ⁻¹' sets i)) :=
        Measure.map_apply hF hInter
      _ = μ (⋂ i ∈ S, (X i ∘ F) ⁻¹' sets i) := by
        congr 1
        ext ω
        simp [Function.comp_def]
      _ = ∏ i ∈ S, μ ((X i ∘ F) ⁻¹' sets i) := h S hsets
      _ = ∏ i ∈ S, (μ.map F) (X i ⁻¹' sets i) := by
        apply Finset.prod_congr rfl
        intro i hi
        rw [Measure.map_apply hF ((hsets i hi).preimage (hX i))]
        rfl

/-- Membership of each coordinate is a mutually independent family under a
set-Bernoulli product law. -/
lemma iIndepFun_setBernoulli_mem {I : Type*} (u : Set I)
    (p : Set.Icc (0 : ℝ) 1) :
    iIndepFun (fun i (s : Set I) ↦ i ∈ s) (setBer(u, p)) := by
  rw [ProbabilityTheory.setBernoulli_eq_map]
  apply (iIndepFun_map_iff (F := fun q : I → Prop ↦ {i | q i})
    (by fun_prop) (by intro i; fun_prop)).2
  simpa [Function.comp_def] using
    (iIndepFun_infinitePi
      (P := fun i : I ↦
        unitInterval.toNNReal p • Measure.dirac (i ∈ u) +
          unitInterval.toNNReal (unitInterval.symm p) • Measure.dirac False)
      (X := fun _ (q : Prop) ↦ q) (by intro i; fun_prop))

/-- Edge-membership coordinates are mutually independent under Mathlib's
binomial random-graph law. -/
lemma iIndepFun_binomialRandom_edgeMem {V : Type*} [Countable V]
    (p : Set.Icc (0 : ℝ) 1) :
    iIndepFun (fun e : Sym2 V ↦ fun G : SimpleGraph V ↦ e ∈ G.edgeSet)
      (SimpleGraph.binomialRandom V p) := by
  rw [SimpleGraph.binomialRandom_eq_map]
  apply (iIndepFun_map_iff (F := SimpleGraph.fromEdgeSet)
    SimpleGraph.measurable_fromEdgeSet (by intro e; fun_prop)).2
  have hmem := iIndepFun_setBernoulli_mem (I := Sym2 V) (u := Sym2.diagSetᶜ) p
  have hcomp := hmem.comp
    (fun e (q : Prop) ↦ q ∧ ¬ e.IsDiag) (by intro e; fun_prop)
  simpa [Function.comp_def, SimpleGraph.edgeSet_fromEdgeSet] using hcomp

lemma graphCrossEdge_injective {V : Type*} [DecidableEq V]
    {A B : Finset V} (hAB : Disjoint A B) :
    Function.Injective
      (fun q : (↑A × ↑B) ↦ s(q.1.1, q.2.1)) := by
  intro q r hqr
  rcases Sym2.eq_iff.mp hqr with h | h
  · apply Prod.ext
    · exact Subtype.ext h.1
    · exact Subtype.ext h.2
  · exfalso
    have hqB : q.1.1 ∈ B := by
      rw [h.1]
      exact r.2.2
    exact (Finset.disjoint_left.mp hAB q.1.2 hqB).elim

/-- If the centers `A` and possible neighbors `B` are disjoint, the adjacency
indicator vectors from each center into `B` are mutually independent. -/
lemma iIndepFun_graphCrossAdjacency_of_disjoint
    {V : Type*} [Countable V] [DecidableEq V]
    (p : Set.Icc (0 : ℝ) 1) {A B : Finset V} (hAB : Disjoint A B) :
    iIndepFun
      (fun a : ↑A ↦ fun G : SimpleGraph V ↦ fun b : ↑B ↦ G.Adj a.1 b.1)
      (SimpleGraph.binomialRandom V p) := by
  apply iIndepFun_group_sigma (by intro a b; fun_prop)
  have hflat := (iIndepFun_binomialRandom_edgeMem p).precomp
    (graphCrossEdge_injective hAB)
  have hflat' := hflat.precomp (Equiv.sigmaEquivProd ↑A ↑B).injective
  simpa [SimpleGraph.mem_edgeSet] using hflat'

/-- The number of neighbors of `v` belonging to the finite vertex set `S`. -/
noncomputable def graphRestrictedDegree {V : Type*}
    (v : V) (S : Finset V) (G : SimpleGraph V) : ℕ := by
  classical
  exact ∑ w ∈ S, if G.Adj v w then 1 else 0

/-- The first half of `Fin n`, used as independent degree-test centers. -/
def graphDegreeTestCenters (n : ℕ) : Finset (Fin n) :=
  Finset.univ.filter fun v => v.val < n / 2

/-- The complementary half of `Fin n`, used as possible neighbors of the
degree-test centers. -/
def graphDegreeTestNeighbors (n : ℕ) : Finset (Fin n) :=
  Finset.univ.filter fun v => ¬ v.val < n / 2

@[simp] lemma card_graphDegreeTestCenters (n : ℕ) :
    (graphDegreeTestCenters n).card = n / 2 := by
  rw [graphDegreeTestCenters, Fin.card_filter_val_lt]
  exact min_eq_right (Nat.div_le_self n 2)

@[simp] lemma card_graphDegreeTestNeighbors (n : ℕ) :
    (graphDegreeTestNeighbors n).card = n - n / 2 := by
  have hsum := Finset.card_filter_add_card_filter_not
    (s := (Finset.univ : Finset (Fin n))) (fun v => v.val < n / 2)
  have hsum' : (graphDegreeTestCenters n).card +
      (graphDegreeTestNeighbors n).card = n := by
    simpa [graphDegreeTestCenters, graphDegreeTestNeighbors] using hsum
  rw [card_graphDegreeTestCenters] at hsum'
  omega

lemma graphDegreeTestCenters_disjoint_graphDegreeTestNeighbors (n : ℕ) :
    Disjoint (graphDegreeTestCenters n) (graphDegreeTestNeighbors n) := by
  rw [Finset.disjoint_left]
  simp [graphDegreeTestCenters, graphDegreeTestNeighbors]

/-- A restricted degree never exceeds the full degree. -/
lemma graphRestrictedDegree_le_graphDegreeSum
    {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) (v : V) (S : Finset V) :
    graphRestrictedDegree v S G ≤ graphDegreeSum v G := by
  classical
  rw [graphRestrictedDegree, graphDegreeSum]
  exact Finset.sum_le_sum_of_subset (Finset.subset_univ S)

/-- If `v` lies in `A` and there are no edges from `v` to another member of
`A`, then counting neighbors in the complement of `A` gives its full degree. -/
lemma graphRestrictedDegree_compl_eq_graphDegreeSum_of_no_internal
    {V : Type*} [Fintype V] [DecidableEq V]
    (G : SimpleGraph V) {A : Finset V} {v : V}
    (hno : ∀ w ∈ A, ¬ G.Adj v w) :
    graphRestrictedDegree v (Finset.univ \ A) G = graphDegreeSum v G := by
  classical
  unfold graphRestrictedDegree graphDegreeSum
  rw [Finset.sum_subset (Finset.sdiff_subset)]
  intro w hwU hwNot
  have hwA : w ∈ A := by
    by_contra hwA
    exact hwNot (by simp [hwA])
  simp [hno w hwA]

/-- A single adjacency event has probability at most the edge parameter.  The
diagonal case is empty; off the diagonal its probability is exactly `p`. -/
lemma binomialRandom_graphAdjEvent_real_le
    {V : Type*} [Countable V] [DecidableEq V] [DecidableEq (Sym2 V)]
    (p : Set.Icc (0 : ℝ) 1) (v w : V) :
    (SimpleGraph.binomialRandom V p).real {G | G.Adj v w} ≤ (p : ℝ) := by
  classical
  by_cases hvw : v = w
  · subst w
    simp
    exact p.2.1
  · have hevent : {G : SimpleGraph V | G.Adj v w} =
        graphStarExactEvent v {w} {w} := by
      ext G
      simp [graphStarExactEvent]
    rw [hevent, Measure.real_def,
      binomialRandom_graphStarExactEvent_probability p (by simp [hvw]) (by simp)]
    simp

/-- A union bound for the event that the induced graph on `A` contains an
edge.  Ordered pairs deliberately overcount, which keeps the bound elementary. -/
theorem binomialRandom_exists_internalAdj_probability_le
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1) (A : Finset V) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, ∃ b : ↑A, G.Adj a.1 b.1} ≤
      (A.card : ℝ) ^ 2 * (p : ℝ) := by
  classical
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  let Bad : ↑A → ↑A → Set (SimpleGraph V) :=
    fun a b ↦ {G | G.Adj a.1 b.1}
  have hevent : {G : SimpleGraph V | ∃ a : ↑A, ∃ b : ↑A,
      G.Adj a.1 b.1} = ⋃ a, ⋃ b, Bad a b := by
    ext G
    simp [Bad]
  rw [hevent]
  calc
    P.real (⋃ a, ⋃ b, Bad a b) ≤
        ∑ a, P.real (⋃ b, Bad a b) :=
      measureReal_iUnion_fintype_le (fun a ↦ ⋃ b, Bad a b)
    _ ≤ ∑ a, ∑ b, P.real (Bad a b) := by
      exact Finset.sum_le_sum fun a _ha ↦
        measureReal_iUnion_fintype_le (Bad a)
    _ ≤ ∑ _a : ↑A, ∑ _b : ↑A, (p : ℝ) := by
      exact Finset.sum_le_sum fun a _ha ↦
        Finset.sum_le_sum fun b _hb ↦ by
          simpa [P, Bad] using binomialRandom_graphAdjEvent_real_le p a.1 b.1
    _ = (A.card : ℝ) ^ 2 * (p : ℝ) := by
      simp
      ring

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

/-- Restricted degrees from disjoint centers into one complementary vertex
set form a mutually independent family. -/
theorem iIndepFun_graphRestrictedDegree_of_disjoint
    {V : Type*} [Countable V] [DecidableEq V]
    (p : Set.Icc (0 : ℝ) 1) {A B : Finset V} (hAB : Disjoint A B) :
    iIndepFun (fun a : ↑A ↦ graphRestrictedDegree a.1 B)
      (SimpleGraph.binomialRandom V p) := by
  classical
  have hcross := iIndepFun_graphCrossAdjacency_of_disjoint p hAB
  have hsum := hcross.comp
    (fun _ f ↦ ∑ b : ↑B, if f b then 1 else 0) (by intro a; fun_prop)
  apply hsum.congr
  intro a
  filter_upwards with G
  change (∑ b : ↑B, if G.Adj a.1 b.1 then 1 else 0) =
    graphRestrictedDegree a.1 B G
  unfold graphRestrictedDegree
  exact (Finset.sum_subtype B (fun _ ↦ Iff.rfl)
    (fun w ↦ if G.Adj a.1 w then 1 else 0)).symm

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

lemma graphRestrictedBinomialLaw_eq_graphBinomialLaw
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) :
    graphRestrictedBinomialLaw S p = graphBinomialLaw (S.card + 1) p := by
  simp [graphRestrictedBinomialLaw, graphBinomialLaw,
    LimitTheorems.binomialNatPMF]

lemma graphRestrictedBinomialLaw_real_singleton_of_le
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) (k : ℕ) (hk : k ≤ S.card) :
    (graphRestrictedBinomialLaw S p).real {k} =
      (Nat.choose S.card k : ℝ) * (unitInterval.toNNReal p : ℝ) ^ k *
        (1 - (unitInterval.toNNReal p : ℝ)) ^ (S.card - k) := by
  rw [graphRestrictedBinomialLaw_eq_graphBinomialLaw, Measure.real_def,
    graphBinomialLaw_apply_of_lt]
  · have hp1 : (unitInterval.toNNReal p : ℝ≥0∞) ≤ 1 := by
      exact_mod_cast p.2.2
    rw [ENNReal.toReal_mul, ENNReal.toReal_mul, ENNReal.toReal_pow,
      ENNReal.toReal_pow, ENNReal.toReal_sub_of_le hp1 (by simp),
      ENNReal.toReal_natCast]
    simp
    ring
  · omega

/-- A convenient lower bound for a binomial coefficient.  The ratio form is
chosen so it combines directly with the success-probability power in a
binomial point mass. -/
lemma choose_cast_ge_sub_ratio_pow (m k : ℕ) :
    (((m + 1 - k : ℕ) : ℝ) / (k : ℝ)) ^ k ≤ (Nat.choose m k : ℝ) := by
  rw [div_pow]
  calc
    ((m + 1 - k : ℕ) : ℝ) ^ k / (k : ℝ) ^ k ≤
        ((m + 1 - k : ℕ) : ℝ) ^ k / (k.factorial : ℝ) := by
      apply div_le_div_of_nonneg_left (by positivity) (by positivity)
      exact_mod_cast Nat.factorial_le_pow k
    _ ≤ (Nat.choose m k : ℝ) := Nat.pow_le_choose k m

/-- Lower-bound a restricted-degree point mass by replacing the binomial
coefficient with its elementary ratio bound. -/
lemma graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) (k : ℕ) (hk : k ≤ S.card) :
    ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        (1 - (unitInterval.toNNReal p : ℝ)) ^ (S.card - k) ≤
      (graphRestrictedBinomialLaw S p).real {k} := by
  rw [graphRestrictedBinomialLaw_real_singleton_of_le S p k hk]
  have hchoose : (((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) ^ k ≤
      (Nat.choose S.card k : ℝ) := choose_cast_ge_sub_ratio_pow S.card k
  have hp0 : 0 ≤ (unitInterval.toNNReal p : ℝ) := by positivity
  have hq0 : 0 ≤ 1 - (unitInterval.toNNReal p : ℝ) := by
    change 0 ≤ 1 - (p : ℝ)
    linarith [p.2.2]
  rw [mul_pow]
  exact mul_le_mul_of_nonneg_right
    (mul_le_mul_of_nonneg_right hchoose (pow_nonneg hp0 k))
    (pow_nonneg hq0 (S.card - k))

/-- On the interval `[0, 1/2]`, the logarithm of a Bernoulli failure
probability is bounded below by the first-order estimate `-2p`. -/
lemma log_one_sub_ge_neg_two_mul {p : ℝ} (hp0 : 0 ≤ p) (hp : p ≤ 1 / 2) :
    -(2 * p) ≤ Real.log (1 - p) := by
  have h1p : 0 < 1 - p := by linarith
  have h := Real.log_le_sub_one_of_pos (inv_pos.mpr h1p)
  rw [Real.log_inv] at h
  have hinv : (1 - p)⁻¹ - 1 = p / (1 - p) := by
    field_simp
    ring
  rw [hinv] at h
  have hfrac : p / (1 - p) ≤ 2 * p := by
    rw [div_le_iff₀ h1p]
    nlinarith
  linarith

/-- The Bernoulli failure power is bounded below by an exponential when the
success probability is at most one half. -/
lemma exp_neg_two_mul_le_one_sub_pow {p : ℝ} (hp0 : 0 ≤ p) (hp : p ≤ 1 / 2)
    (m : ℕ) :
    Real.exp (-(2 * (m : ℝ) * p)) ≤ (1 - p) ^ m := by
  have h1p : 0 < 1 - p := by linarith
  have hlog : -(2 * p) ≤ Real.log (1 - p) :=
    log_one_sub_ge_neg_two_mul hp0 hp
  calc
    Real.exp (-(2 * (m : ℝ) * p)) =
        Real.exp ((m : ℝ) * (-(2 * p))) := by ring_nf
    _ ≤ Real.exp ((m : ℝ) * Real.log (1 - p)) := by
      apply Real.exp_le_exp.mpr
      exact mul_le_mul_of_nonneg_left hlog (by positivity)
    _ = Real.exp (Real.log ((1 - p) ^ m)) := by rw [Real.log_pow]
    _ = (1 - p) ^ m := Real.exp_log (pow_pos h1p m)

/-- If an integer scale is little-oh of `log n`, then a fixed exponential
penalty in that scale is eventually dominated by the size of half of `Fin n`.
The numerical constants are tailored to the sparse-graph point-mass bound. -/
lemma eventually_log_ten_le_half_card_mul_exp_of_log_ratio_tendsto_zero
    (k : ℕ → ℕ)
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
        Real.exp (-((k n : ℝ) * (Real.log 40 + 1 / 4))) := by
  let C : ℝ := Real.log 40 + 1 / 4
  have hlog40 : 0 < Real.log 40 := Real.log_pos (by norm_num)
  have hC : 0 < C := by dsimp [C]; positivity
  let ε : ℝ := 1 / (2 * C)
  have hε : 0 < ε := by dsimp [ε]; positivity
  rcases (Metric.tendsto_atTop.mp hsmall) ε hε with ⟨N, hN⟩
  refine Filter.eventually_atTop.2 ⟨max N 400, ?_⟩
  intro n hn
  have hnN : N ≤ n := (le_max_left N 400).trans hn
  have hn400 : 400 ≤ n := (le_max_right N 400).trans hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hn1 : 1 < (n : ℝ) := by exact_mod_cast (show 1 < n by omega)
  have hlogn : 0 < Real.log (n : ℝ) := Real.log_pos hn1
  have hratio0 : 0 ≤ (k n : ℝ) / Real.log (n : ℝ) :=
    div_nonneg (by positivity) hlogn.le
  have hdist := hN n hnN
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hratio0] at hdist
  rw [div_lt_iff₀ hlogn] at hdist
  have hscaled := mul_lt_mul_of_pos_right hdist hC
  have heq : ε * Real.log (n : ℝ) * C = Real.log (n : ℝ) / 2 := by
    dsimp [ε]
    field_simp
  rw [heq] at hscaled
  have hlog400 : Real.log ((20 : ℝ) ^ 2) ≤ Real.log (n : ℝ) := by
    apply Real.strictMonoOn_log.monotoneOn
    · norm_num
    · exact hnpos
    · norm_num at hn400 ⊢
      exact hn400
  have hlog20 : Real.log 20 ≤ Real.log (n : ℝ) / 2 := by
    rw [Real.log_pow] at hlog400
    norm_num at hlog400 ⊢
    linarith
  have hbudget : (k n : ℝ) * C ≤ Real.log (n : ℝ) - Real.log 20 := by
    linarith
  have hexp : 20 / (n : ℝ) ≤ Real.exp (-((k n : ℝ) * C)) := by
    calc
      20 / (n : ℝ) = Real.exp (Real.log 20) / Real.exp (Real.log (n : ℝ)) := by
        rw [Real.exp_log (by norm_num), Real.exp_log hnpos]
      _ = Real.exp (Real.log 20 - Real.log (n : ℝ)) := (Real.exp_sub _ _).symm
      _ ≤ Real.exp (-((k n : ℝ) * C)) := by
        apply Real.exp_le_exp.mpr
        linarith
  have hhalf : (n : ℝ) - 1 ≤ 2 * ((n / 2 : ℕ) : ℝ) := by
    rw [← Nat.cast_one, ← Nat.cast_sub (show 1 ≤ n by omega)]
    exact_mod_cast (show n - 1 ≤ 2 * (n / 2) by omega)
  have hfactor : (9 : ℝ) ≤ ((n / 2 : ℕ) : ℝ) * (20 / (n : ℝ)) := by
    have hn10 : (10 : ℝ) ≤ (n : ℝ) := by exact_mod_cast (show 10 ≤ n by omega)
    rw [show ((n / 2 : ℕ) : ℝ) * (20 / (n : ℝ)) =
      (((n / 2 : ℕ) : ℝ) * 20) / (n : ℝ) by ring, le_div_iff₀ hnpos]
    nlinarith
  have hlog10 : Real.log (10 : ℝ) ≤ 9 := by
    nlinarith [Real.log_le_sub_one_of_pos (show (0 : ℝ) < 10 by norm_num)]
  calc
    Real.log 10 ≤ 9 := hlog10
    _ ≤ ((n / 2 : ℕ) : ℝ) * (20 / (n : ℝ)) := hfactor
    _ ≤ ((n / 2 : ℕ) : ℝ) * Real.exp (-((k n : ℝ) * C)) :=
      mul_le_mul_of_nonneg_left hexp (by positivity)
    _ = ((n / 2 : ℕ) : ℝ) *
        Real.exp (-((k n : ℝ) * (Real.log 40 + 1 / 4))) := by rfl

/-- The finite arithmetic linking the expected-degree identity to the
balanced point-mass estimate. -/
lemma balanced_ratio_mass_bound_of_degree_relation
    (n k : ℕ) (p : Set.Icc (0 : ℝ) 1)
    (hn : 10 ≤ n) (hkpos : 0 < k) (hksmall : 4 * k ≤ n)
    (hrel : (k : ℝ) = 10 * ((n - 1 : ℕ) : ℝ) * (p : ℝ))
    (hlog : Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
      Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4)))) :
    k ≤ n - n / 2 ∧ (p : ℝ) ≤ 1 / 2 ∧
      Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
        ((((((n - n / 2 : ℕ) + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
            (unitInterval.toNNReal p : ℝ)) ^ k *
          Real.exp (-(2 * ((n - n / 2 : ℕ) : ℝ) * (p : ℝ)))) := by
  have hn1 : 1 ≤ n := by omega
  have hkB : k ≤ n - n / 2 := by omega
  have h4k : (4 : ℝ) * (k : ℝ) ≤ (n : ℝ) := by exact_mod_cast hksmall
  have hnR : (10 : ℝ) ≤ (n : ℝ) := by exact_mod_cast hn
  have h20 : (n : ℝ) ≤ 20 * ((n - 1 : ℕ) : ℝ) := by
    rw [Nat.cast_sub hn1]
    norm_num
    nlinarith
  let B : ℕ := n - n / 2
  let q : ℝ := p
  have hq : q = (p : ℝ) := rfl
  have hnsubpos : (0 : ℝ) < ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast (show 0 < n - 1 by omega)
  have hden : 0 < 10 * ((n - 1 : ℕ) : ℝ) := by positivity
  have hpform : q = (k : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
    rw [eq_div_iff (ne_of_gt hden)]
    rw [hq]
    nlinarith [hrel]
  have hp : (p : ℝ) ≤ 1 / 2 := by
    rw [← hq, hpform, div_le_iff₀ hden]
    nlinarith
  refine ⟨hkB, hp, ?_⟩
  have hnumNat : n ≤ 4 * (B + 1 - k) := by
    dsimp [B]
    omega
  have hnum : (n : ℝ) ≤ 4 * ((B + 1 - k : ℕ) : ℝ) := by
    exact_mod_cast hnumNat
  have hnsub_le : ((n - 1 : ℕ) : ℝ) ≤ (n : ℝ) := by
    exact_mod_cast Nat.sub_le n 1
  have hbase : (1 : ℝ) / 40 ≤
      (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q := by
    have hkR : (0 : ℝ) < (k : ℝ) := by positivity
    rw [hpform]
    have heq : (((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
        ((k : ℝ) / (10 * ((n - 1 : ℕ) : ℝ))) =
        ((B + 1 - k : ℕ) : ℝ) / (10 * ((n - 1 : ℕ) : ℝ)) := by
      field_simp
    rw [heq, le_div_iff₀ hden]
    nlinarith
  have hcoefNat : 4 * B ≤ 5 * (n - 1) := by
    dsimp [B]
    omega
  have hcoef : (4 : ℝ) * (B : ℝ) ≤ 5 * ((n - 1 : ℕ) : ℝ) := by
    exact_mod_cast hcoefNat
  have hcoefq := mul_le_mul_of_nonneg_right hcoef p.2.1
  have hexponent : 2 * (B : ℝ) * q ≤ (k : ℝ) / 4 := by
    rw [hq]
    nlinarith [hrel]
  have hbasePow : ((1 : ℝ) / 40) ^ k ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k :=
    pow_le_pow_left₀ (by norm_num) hbase k
  have hexp : Real.exp (-((k : ℝ) / 4)) ≤
      Real.exp (-(2 * (B : ℝ) * q)) := by
    apply Real.exp_le_exp.mpr
    exact neg_le_neg hexponent
  have hlower : Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4))) ≤
      ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
        Real.exp (-(2 * (B : ℝ) * q)) := by
    have hpowid : ((1 : ℝ) / 40) ^ k =
        Real.exp (-((k : ℝ) * Real.log 40)) := by
      calc
        ((1 : ℝ) / 40) ^ k =
            (Real.exp (Real.log ((1 : ℝ) / 40))) ^ k := by
              rw [Real.exp_log (by norm_num)]
        _ = Real.exp ((k : ℝ) * Real.log ((1 : ℝ) / 40)) :=
          (Real.exp_nat_mul _ k).symm
        _ = Real.exp (-((k : ℝ) * Real.log 40)) := by
          rw [show (1 : ℝ) / 40 = (40 : ℝ)⁻¹ by ring, Real.log_inv]
          ring_nf
    calc
      Real.exp (-((k : ℝ) * (Real.log 40 + 1 / 4))) =
          ((1 : ℝ) / 40) ^ k * Real.exp (-((k : ℝ) / 4)) := by
        rw [hpowid, ← Real.exp_add]
        congr 1
        ring
      _ ≤ ((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
          Real.exp (-(2 * (B : ℝ) * q)) :=
        mul_le_mul hbasePow hexp (Real.exp_nonneg _)
          (pow_nonneg ((by norm_num : (0 : ℝ) ≤ 1 / 40).trans hbase) k)
  change Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
    (((((B + 1 - k : ℕ) : ℝ) / (k : ℝ)) * q) ^ k *
      Real.exp (-(2 * (B : ℝ) * q)))
  exact hlog.trans (mul_le_mul_of_nonneg_left hlower (by positivity))

/-- An integer sequence that is little-oh of `log n` is eventually at most
one quarter of `n`. -/
lemma eventually_four_mul_le_of_log_ratio_tendsto_zero
    (k : ℕ → ℕ)
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop, 4 * k n ≤ n := by
  have hlogdiv : Filter.Tendsto
      (fun n : ℕ => Real.log (n : ℝ) / (n : ℝ)) Filter.atTop (nhds 0) := by
    have h := Real.isLittleO_log_id_atTop.comp_tendsto
      (tendsto_natCast_atTop_atTop : Filter.Tendsto
        (fun n : ℕ => (n : ℝ)) Filter.atTop Filter.atTop)
    simpa [Function.comp_def] using h.tendsto_div_nhds_zero
  have hprod := hsmall.mul hlogdiv
  have hkn : Filter.Tendsto
      (fun n : ℕ => (k n : ℝ) / (n : ℝ)) Filter.atTop (nhds 0) := by
    have heq : (fun n : ℕ =>
        (k n : ℝ) / Real.log (n : ℝ) * (Real.log (n : ℝ) / (n : ℝ))) =ᶠ[Filter.atTop]
        (fun n : ℕ => (k n : ℝ) / (n : ℝ)) := by
      filter_upwards [Filter.eventually_atTop.2 ⟨2, fun n hn => hn⟩] with n hn
      have hn0 : (n : ℝ) ≠ 0 := by positivity
      have hlog0 : Real.log (n : ℝ) ≠ 0 := ne_of_gt <|
        Real.log_pos (by exact_mod_cast (show 1 < n by omega))
      field_simp
    simpa using hprod.congr' heq
  rcases (Metric.tendsto_atTop.mp hkn) ((1 : ℝ) / 5) (by norm_num) with ⟨N, hN⟩
  refine Filter.eventually_atTop.2 ⟨max N 2, ?_⟩
  intro n hn
  have hnN : N ≤ n := (le_max_left N 2).trans hn
  have hn2 : 2 ≤ n := (le_max_right N 2).trans hn
  have hnpos : 0 < (n : ℝ) := by positivity
  have hratio0 : 0 ≤ (k n : ℝ) / (n : ℝ) := by positivity
  have hdist := hN n hnN
  rw [Real.dist_eq, sub_zero, abs_of_nonneg hratio0, div_lt_iff₀ hnpos] at hdist
  have hcast : (4 : ℝ) * (k n : ℝ) ≤ (n : ℝ) := by nlinarith
  exact_mod_cast hcast

/-- An explicit exponential lower bound for a restricted binomial point mass.
This is the finite analytic estimate used by the sparse-graph specialization. -/
lemma graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow_mul_exp
    (S : Finset V) (p : Set.Icc (0 : ℝ) 1) (k : ℕ) (hk : k ≤ S.card)
    (hp : (p : ℝ) ≤ 1 / 2) :
    ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (S.card : ℝ) * (p : ℝ))) ≤
      (graphRestrictedBinomialLaw S p).real {k} := by
  let x : ℝ := unitInterval.toNNReal p
  have hx : x = (p : ℝ) := rfl
  have hx0 : 0 ≤ x := by positivity
  have hpow : Real.exp (-(2 * ((S.card - k : ℕ) : ℝ) * x)) ≤
      (1 - x) ^ (S.card - k) := by
    exact exp_neg_two_mul_le_one_sub_pow hx0 (by simpa [hx] using hp) _
  have hexp : Real.exp (-(2 * (S.card : ℝ) * (p : ℝ))) ≤
      Real.exp (-(2 * ((S.card - k : ℕ) : ℝ) * x)) := by
    apply Real.exp_le_exp.mpr
    rw [hx]
    have hcast : ((S.card - k : ℕ) : ℝ) ≤ (S.card : ℝ) := by
      exact_mod_cast Nat.sub_le S.card k
    nlinarith [p.1]
  calc
    ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (S.card : ℝ) * (p : ℝ))) ≤
        ((((S.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
            (1 - (unitInterval.toNNReal p : ℝ)) ^ (S.card - k) := by
      apply mul_le_mul_of_nonneg_left (hexp.trans (by simpa [x] using hpow))
      positivity
    _ ≤ (graphRestrictedBinomialLaw S p).real {k} :=
      graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow S p k hk

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

/-- The exact decoupling package used in sparse random-graph lower bounds:
centers in `A`, counted only against the disjoint set `B`, have mutually
independent `Binomial(|B|, p)` restricted degrees. -/
theorem graphRestrictedDegrees_independent_binomial
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) :
    iIndepFun (fun a : ↑A ↦ graphRestrictedDegree a.1 B)
        (SimpleGraph.binomialRandom V p) ∧
      ∀ a : ↑A,
        HasLaw (graphRestrictedDegree a.1 B) (graphRestrictedBinomialLaw B p)
          (SimpleGraph.binomialRandom V p) := by
  refine ⟨iIndepFun_graphRestrictedDegree_of_disjoint p hAB, ?_⟩
  intro a
  exact graphRestrictedDegree_hasLaw p
    (Finset.disjoint_left.mp hAB a.2)

/-- Exact maximum-tail probability for the decoupled restricted degrees.  It
turns the graph event into the complement of a power of one binomial lower
tail. -/
theorem binomialRandom_exists_restrictedDegree_ge_probability
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} =
      1 - (graphRestrictedBinomialLaw B p).real {j | j < k} ^ A.card := by
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  change P.real {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} = _
  let Low : Set (SimpleGraph V) :=
    {G | ∀ a : ↑A, graphRestrictedDegree a.1 B G < k}
  have hpack := graphRestrictedDegrees_independent_binomial p hAB
  have hLowEq : Low =
      ⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' {j | j < k} := by
    ext G
    simp [Low]
  have hLowMeas : MeasurableSet Low := by
    rw [hLowEq]
    exact MeasurableSet.iInter fun a ↦
      (measurableSet_Iio.preimage (measurable_graphRestrictedDegree a.1 B))
  have hprod :
      P (⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' {j | j < k}) =
        ∏ a : ↑A, P (graphRestrictedDegree a.1 B ⁻¹' {j | j < k}) := by
    simpa [P] using hpack.1.measure_inter_preimage_eq_mul
      Finset.univ (sets := fun _ : ↑A ↦ {j : ℕ | j < k})
        (fun _ _ ↦ measurableSet_Iio)
  have hsingle (a : ↑A) :
      P.real (graphRestrictedDegree a.1 B ⁻¹' {j | j < k}) =
        (graphRestrictedBinomialLaw B p).real {j | j < k} := by
    dsimp [P]
    rw [Measure.real_def, Measure.real_def]
    change ((SimpleGraph.binomialRandom V p)
      (graphRestrictedDegree a.1 B ⁻¹' Set.Iio k)).toReal =
        ((graphRestrictedBinomialLaw B p) (Set.Iio k)).toReal
    have hmap := Measure.map_apply_of_aemeasurable
      (hpack.2 a).aemeasurable (measurableSet_Iio : MeasurableSet {j : ℕ | j < k})
    rw [← hmap, (hpack.2 a).map_eq]
  have hLowReal :
      P.real Low =
        (graphRestrictedBinomialLaw B p).real {j | j < k} ^ A.card := by
    rw [Measure.real_def, hLowEq, hprod, ENNReal.toReal_prod]
    simp_rw [← Measure.real_def, hsingle]
    simp
  have hHighEq :
      {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} = Lowᶜ := by
    ext G
    simp [Low, not_lt]
  rw [hHighEq, measureReal_compl hLowMeas, hLowReal]
  simp

/-- Exact point-mass occurrence probability for the decoupled restricted
degrees.  This is the equality-event counterpart of
`binomialRandom_exists_restrictedDegree_ge_probability`. -/
theorem binomialRandom_exists_restrictedDegree_eq_probability
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} =
      1 - (1 - (graphRestrictedBinomialLaw B p).real {k}) ^ A.card := by
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  let ν : Measure ℕ := graphRestrictedBinomialLaw B p
  haveI : IsProbabilityMeasure ν := by
    dsimp [ν, graphRestrictedBinomialLaw]
    infer_instance
  change P.real {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} = _
  let Avoid : Set (SimpleGraph V) :=
    {G | ∀ a : ↑A, graphRestrictedDegree a.1 B G ≠ k}
  have hpack := graphRestrictedDegrees_independent_binomial p hAB
  have hAvoidEq : Avoid =
      ⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ := by
    ext G
    simp [Avoid]
  have hAvoidMeas : MeasurableSet Avoid := by
    rw [hAvoidEq]
    exact MeasurableSet.iInter fun a ↦
      (measurableSet_singleton k).compl.preimage
        (measurable_graphRestrictedDegree a.1 B)
  have hprod :
      P (⋂ a : ↑A, graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
        ∏ a : ↑A, P (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) := by
    simpa [P] using hpack.1.measure_inter_preimage_eq_mul
      Finset.univ (sets := fun _ : ↑A ↦ ({k} : Set ℕ)ᶜ)
        (fun _ _ ↦ (measurableSet_singleton k).compl)
  have hsingle (a : ↑A) :
      P.real (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
        1 - ν.real {k} := by
    have hmap := Measure.map_apply_of_aemeasurable
      (hpack.2 a).aemeasurable ((measurableSet_singleton k).compl)
    have heq :
        P (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
          ν (({k} : Set ℕ)ᶜ) := by
      rw [← hmap, (hpack.2 a).map_eq]
    have hrealeq :
        P.real (graphRestrictedDegree a.1 B ⁻¹' ({k} : Set ℕ)ᶜ) =
          ν.real (({k} : Set ℕ)ᶜ) := by
      simpa only [Measure.real_def] using congrArg ENNReal.toReal heq
    rw [hrealeq, measureReal_compl (measurableSet_singleton k)]
    simp
  have hAvoidReal :
      P.real Avoid = (1 - ν.real {k}) ^ A.card := by
    rw [Measure.real_def, hAvoidEq, hprod, ENNReal.toReal_prod]
    simp_rw [← Measure.real_def, hsingle]
    simp
  have hHitEq :
      {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} = Avoidᶜ := by
    ext G
    simp [Avoid]
  rw [hHitEq, measureReal_compl hAvoidMeas, hAvoidReal]
  simp [ν]

lemma one_sub_pow_le_exp_neg_nat_mul {r : ℝ} (hr1 : r ≤ 1)
    (m : ℕ) :
    (1 - r) ^ m ≤ Real.exp (-((m : ℝ) * r)) := by
  calc
    (1 - r) ^ m ≤ Real.exp (-r) ^ m :=
      pow_le_pow_left₀ (sub_nonneg.mpr hr1) (Real.one_sub_le_exp_neg r) m
    _ = Real.exp ((m : ℝ) * (-r)) := (Real.exp_nat_mul (-r) m).symm
    _ = Real.exp (-((m : ℝ) * r)) := by ring_nf

/-- If the expected number of exact restricted-degree hits dominates
`log 20`, then an exact hit occurs with probability at least `0.95`. -/
theorem binomialRandom_exists_restrictedDegree_eq_probability_ge_nineteen_twentieths
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ)
    (hmass : Real.log 20 ≤ (A.card : ℝ) *
      (graphRestrictedBinomialLaw B p).real {k}) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k} ≥
      (19 : ℝ) / 20 := by
  let ν : Measure ℕ := graphRestrictedBinomialLaw B p
  haveI : IsProbabilityMeasure ν := by
    dsimp [ν, graphRestrictedBinomialLaw]
    infer_instance
  let r : ℝ := ν.real {k}
  have hr1 : r ≤ 1 := by
    simpa [r] using measureReal_le_one (μ := ν) (s := ({k} : Set ℕ))
  have hpow : (1 - r) ^ A.card ≤ (1 : ℝ) / 20 := by
    calc
      (1 - r) ^ A.card ≤ Real.exp (-((A.card : ℝ) * r)) :=
        one_sub_pow_le_exp_neg_nat_mul hr1 A.card
      _ ≤ Real.exp (-Real.log 20) := by
        apply Real.exp_le_exp.mpr
        exact neg_le_neg (by simpa [r, ν] using hmass)
      _ = (1 : ℝ) / 20 := by
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0 : ℝ) < 20)]
        norm_num
  rw [binomialRandom_exists_restrictedDegree_eq_probability p hAB k]
  change (19 : ℝ) / 20 ≤ 1 - (1 - r) ^ A.card
  linarith

/-- Exact restricted-degree occurrence transfers to exact full degree when
internal edges among the test centers have probability at most `0.05`. -/
theorem binomialRandom_exists_degree_eq_probability_ge_nine_tenths
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    (A : Finset V) (k : ℕ)
    (hmass : Real.log 20 ≤ (A.card : ℝ) *
      (graphRestrictedBinomialLaw (Finset.univ \ A) p).real {k})
    (hinternal : (A.card : ℝ) ^ 2 * (p : ℝ) ≤ (1 : ℝ) / 20) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, graphDegreeSum v G = k} ≥ (9 : ℝ) / 10 := by
  classical
  let P : Measure (SimpleGraph V) := SimpleGraph.binomialRandom V p
  let B : Finset V := Finset.univ \ A
  let Hit : Set (SimpleGraph V) :=
    {G | ∃ a : ↑A, graphRestrictedDegree a.1 B G = k}
  let Bad : Set (SimpleGraph V) :=
    {G | ∃ a : ↑A, ∃ b : ↑A, G.Adj a.1 b.1}
  let Full : Set (SimpleGraph V) := {G | ∃ v : V, graphDegreeSum v G = k}
  have hAB : Disjoint A B := by
    rw [Finset.disjoint_left]
    simp [B]
  have hHit : (19 : ℝ) / 20 ≤ P.real Hit := by
    simpa [P, B, Hit] using
      binomialRandom_exists_restrictedDegree_eq_probability_ge_nineteen_twentieths
        p hAB k hmass
  have hBad : P.real Bad ≤ (1 : ℝ) / 20 := by
    have hBad' : P.real Bad ≤ (A.card : ℝ) ^ 2 * (p : ℝ) := by
      simpa [P, Bad] using
        (binomialRandom_exists_internalAdj_probability_le p A)
    exact hBad'.trans hinternal
  have hsubset : Hit \ Bad ⊆ Full := by
    intro G hG
    rcases hG.1 with ⟨a, ha⟩
    refine ⟨a.1, ?_⟩
    have hno : ∀ w ∈ A, ¬ G.Adj a.1 w := by
      intro w hw hadj
      exact hG.2 ⟨a, ⟨w, hw⟩, hadj⟩
    have heq := graphRestrictedDegree_compl_eq_graphDegreeSum_of_no_internal
      G (A := A) (v := a.1) hno
    exact heq.symm.trans ha
  have hdiff : P.real Hit - P.real Bad ≤ P.real (Hit \ Bad) :=
    le_measureReal_diff
  have hmono : P.real (Hit \ Bad) ≤ P.real Full :=
    measureReal_mono hsubset
  change (9 : ℝ) / 10 ≤ P.real Full
  linarith

/-- A finite point-mass criterion ensuring that one of the independent
restricted degrees reaches `k` with probability at least `0.9`. -/
theorem binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ)
    (hmass : Real.log 10 ≤ (A.card : ℝ) *
      (graphRestrictedBinomialLaw B p).real {k}) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} ≥
      (9 : ℝ) / 10 := by
  let ν : Measure ℕ := graphRestrictedBinomialLaw B p
  let q : ℝ := ν.real {j | j < k}
  let r : ℝ := ν.real {k}
  haveI : IsProbabilityMeasure ν := by
    dsimp [ν, graphRestrictedBinomialLaw]
    infer_instance
  have hdisj : Disjoint ({j : ℕ | j < k} : Set ℕ) {k} := by
    rw [Set.disjoint_left]
    intro j hj hk
    simp only [Set.mem_setOf_eq] at hj
    simp only [Set.mem_singleton_iff] at hk
    omega
  have hadd :
      ν.real (({j : ℕ | j < k} : Set ℕ) ∪ {k}) = q + r := by
    simpa [q, r] using
      (measureReal_union (μ := ν) hdisj (measurableSet_singleton k)
        (measure_ne_top _ _) (measure_ne_top _ _))
  have hunion : ν.real (({j : ℕ | j < k} : Set ℕ) ∪ {k}) ≤ 1 := by
    calc
      ν.real (({j : ℕ | j < k} : Set ℕ) ∪ {k}) ≤ ν.real Set.univ :=
        measureReal_mono (by intro j hj; trivial)
      _ = 1 := by simp
  have hq_le : q ≤ 1 - r := by linarith [hadd.symm.trans_le hunion]
  have hq0 : 0 ≤ q := measureReal_nonneg
  have hr1 : r ≤ 1 := by
    have := measureReal_le_one (μ := ν) (s := ({k} : Set ℕ))
    simpa [r] using this
  have hpow : q ^ A.card ≤ (1 : ℝ) / 10 := by
    calc
      q ^ A.card ≤ (1 - r) ^ A.card :=
        pow_le_pow_left₀ hq0 hq_le A.card
      _ ≤ Real.exp (-((A.card : ℝ) * r)) :=
        one_sub_pow_le_exp_neg_nat_mul hr1 A.card
      _ ≤ Real.exp (-Real.log 10) := by
        apply Real.exp_le_exp.mpr
        exact neg_le_neg (by simpa [r, ν] using hmass)
      _ = (1 : ℝ) / 10 := by
        rw [Real.exp_neg, Real.exp_log (by norm_num : (0 : ℝ) < 10)]
        norm_num
  rw [binomialRandom_exists_restrictedDegree_ge_probability p hAB k]
  change (9 : ℝ) / 10 ≤ 1 - q ^ A.card
  linarith

/-- A fully explicit finite criterion for the decoupled maximum to reach `k`
with probability at least `0.9`. -/
theorem binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths_of_ratio_pow
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) (hk : k ≤ B.card)
    (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 10 ≤ (A.card : ℝ) *
      (((((B.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (B.card : ℝ) * (p : ℝ))))) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} ≥
      (9 : ℝ) / 10 := by
  apply binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths
    p hAB k
  exact hmass.trans (mul_le_mul_of_nonneg_left
    (graphRestrictedBinomialLaw_real_singleton_ge_ratio_pow_mul_exp B p k hk hp)
    (by positivity))

/-- Transfer the explicit restricted-degree lower bound to the full maximum
degree of the graph. -/
theorem binomialRandom_exists_degree_ge_probability_ge_nine_tenths_of_ratio_pow
    {V : Type*} [Fintype V] [Countable V] [DecidableEq V]
    [DecidableEq (Sym2 V)] (p : Set.Icc (0 : ℝ) 1)
    {A B : Finset V} (hAB : Disjoint A B) (k : ℕ) (hk : k ≤ B.card)
    (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 10 ≤ (A.card : ℝ) *
      (((((B.card + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * (B.card : ℝ) * (p : ℝ))))) :
    (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, k ≤ graphDegreeSum v G} ≥
      (9 : ℝ) / 10 := by
  have hrestricted :=
    binomialRandom_exists_restrictedDegree_ge_probability_ge_nine_tenths_of_ratio_pow
      p hAB k hk hp hmass
  have hmono : (SimpleGraph.binomialRandom V p).real
      {G | ∃ a : ↑A, k ≤ graphRestrictedDegree a.1 B G} ≤
      (SimpleGraph.binomialRandom V p).real
        {G | ∃ v : V, k ≤ graphDegreeSum v G} := by
    apply measureReal_mono
    intro G hG
    rcases hG with ⟨a, ha⟩
    exact ⟨a.1, ha.trans (graphRestrictedDegree_le_graphDegreeSum G a.1 B)⟩
    exact measure_ne_top _ _
  exact hrestricted.trans hmono

/-- The explicit finite lower bound specialized to the canonical balanced
split of `Fin n`. -/
theorem binomialRandom_exists_degree_ge_probability_ge_nine_tenths_balanced
    (n : ℕ) (p : Set.Icc (0 : ℝ) 1) (k : ℕ)
    (hk : k ≤ n - n / 2) (hp : (p : ℝ) ≤ 1 / 2)
    (hmass : Real.log 10 ≤ ((n / 2 : ℕ) : ℝ) *
      ((((((n - n / 2 : ℕ) + 1 - k : ℕ) : ℝ) / (k : ℝ)) *
          (unitInterval.toNNReal p : ℝ)) ^ k *
        Real.exp (-(2 * ((n - n / 2 : ℕ) : ℝ) * (p : ℝ))))) :
    (SimpleGraph.binomialRandom (Fin n) p).real
        {G | ∃ v : Fin n, k ≤ graphDegreeSum v G} ≥
      (9 : ℝ) / 10 := by
  apply binomialRandom_exists_degree_ge_probability_ge_nine_tenths_of_ratio_pow
    p (graphDegreeTestCenters_disjoint_graphDegreeTestNeighbors n) k
  · simpa using hk
  · exact hp
  · simpa using hmass

/-- In the sparse regime, if the integer threshold is ten times the expected
degree and is little-oh of `log n`, then a vertex reaches that threshold with
probability at least `0.9` for all sufficiently large `n`. -/
theorem erdosRenyiSparseExistsDegreeTenExpectedEventually
    (p : ℕ → Set.Icc (0 : ℝ) 1) (k : ℕ → ℕ)
    (hrel : ∀ n, (k n : ℝ) =
      10 * ((n - 1 : ℕ) : ℝ) * (p n : ℝ))
    (hsmall : Filter.Tendsto
      (fun n => (k n : ℝ) / Real.log (n : ℝ)) Filter.atTop (nhds 0)) :
    ∀ᶠ n in Filter.atTop,
      (SimpleGraph.binomialRandom (Fin n) (p n)).real
        {G | ∃ v : Fin n, k n ≤ graphDegreeSum v G} ≥
      (9 : ℝ) / 10 := by
  filter_upwards
    [eventually_log_ten_le_half_card_mul_exp_of_log_ratio_tendsto_zero k hsmall,
      eventually_four_mul_le_of_log_ratio_tendsto_zero k hsmall,
      Filter.eventually_atTop.2 ⟨400, fun n hn => hn⟩] with n hlog h4 hn
  by_cases hk0 : k n = 0
  · have hevent : {G : SimpleGraph (Fin n) |
        ∃ v : Fin n, k n ≤ graphDegreeSum v G} = Set.univ := by
      ext G
      simp only [Set.mem_setOf_eq, Set.mem_univ, iff_true]
      exact ⟨⟨0, by omega⟩, by simp [hk0]⟩
    rw [hevent]
    simp
    norm_num
  · have harith := balanced_ratio_mass_bound_of_degree_relation n (k n) (p n)
      (by omega) (Nat.pos_of_ne_zero hk0) h4 (hrel n) hlog
    exact binomialRandom_exists_degree_ge_probability_ge_nine_tenths_balanced
      n (p n) (k n) harith.1 harith.2.1 harith.2.2

end NumStability.HDP.Scalar.IndependentSums.Chernoff
