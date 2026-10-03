import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Convex.Birkhoff
import Mathlib.Data.Prod.Lex
import Mathlib.LinearAlgebra.Matrix.ToLin
import Mathlib.LinearAlgebra.Matrix.Rank
import Mathlib.LinearAlgebra.LinearIndependent.Lemmas
import Mathlib.Probability.ProductMeasure
import Mathlib.Probability.ProbabilityMassFunction.Constructions

/-!
# Balanced two-community stochastic block signal

The deterministic expected-adjacency matrix for two communities of equal
size, together with its two distinguished eigenvectors and the signal/noise
decomposition of an observed matrix.
-/

noncomputable section

open Matrix
open scoped NNReal ENNReal
open scoped Matrix.Norms.L2Operator

namespace NumStability.HDP.Graph.StochasticBlock

open MeasureTheory

/-- Vertices are indexed by a community label and an offset within that
community. -/
abbrev Vertex (k : ℕ) := Fin 2 × Fin k

/-- Canonical representatives of unordered pairs of distinct vertices.  The
lexicographic order is total, unlike the componentwise product order on
`Vertex k`, so every distinct pair has exactly one orientation here. -/
abbrev Edge (k : ℕ) :=
  {e : Vertex k × Vertex k // toLex e.1 < toLex e.2}

/-- Admissible within- and cross-community edge probabilities. -/
structure Parameters where
  /-- The within-community edge probability. -/
  p : ℝ≥0
  /-- The cross-community edge probability. -/
  q : ℝ≥0
  hp : p ≤ 1
  hq : q ≤ 1

/-- Probability assigned to an unordered vertex pair. -/
def edgeProbability {k : ℕ} (θ : Parameters) (e : Edge k) : ℝ≥0 :=
  if e.1.1.1 = e.1.2.1 then θ.p else θ.q

theorem edgeProbability_le_one {k : ℕ} (θ : Parameters) (e : Edge k) :
    edgeProbability θ e ≤ 1 := by
  by_cases h : e.1.1.1 = e.1.2.1 <;> simp [edgeProbability, h, θ.hp, θ.hq]

/-- The balanced two-community stochastic block law: independent Bernoulli
outcomes for every unordered pair of distinct vertices. -/
def graphMeasure (k : ℕ) (θ : Parameters) : Measure (Edge k → Bool) :=
  Measure.pi fun e : Edge k ↦
    (PMF.bernoulli (edgeProbability θ e) (edgeProbability_le_one θ e)).toMeasure

/-- Exact probabilities of finite edge configurations. This states the joint
Bernoulli law directly, including the probability-one empty configuration. -/
theorem graphMeasure_finite_configuration (k : ℕ) (θ : Parameters)
    (S : Finset (Edge k)) (v : Edge k → Bool) :
    graphMeasure k θ {x | ∀ e ∈ S, x e = v e} =
      ∏ e ∈ S, if v e then (edgeProbability θ e : ℝ≥0∞)
        else ((1 - edgeProbability θ e : ℝ≥0) : ℝ≥0∞) := by
  classical
  have hset : {x : Edge k → Bool | ∀ e ∈ S, x e = v e} =
      Set.pi Set.univ (fun e ↦ if e ∈ S then {v e} else Set.univ) := by
    ext x
    constructor
    · intro hx e _
      by_cases he : e ∈ S
      · simpa only [if_pos he, Set.mem_singleton_iff] using hx e he
      · simp only [if_neg he, Set.mem_univ]
    · intro hx e he
      have h := hx e (Set.mem_univ e)
      simpa only [if_pos he, Set.mem_singleton_iff] using h
  have hmass (e : Edge k) :
      (PMF.bernoulli (edgeProbability θ e) (edgeProbability_le_one θ e)).toMeasure
          {v e} =
        if v e then (edgeProbability θ e : ℝ≥0∞)
          else ((1 - edgeProbability θ e : ℝ≥0) : ℝ≥0∞) := by
    rw [PMF.toMeasure_apply_singleton _ _ (measurableSet_singleton _)]
    cases v e <;> simp [PMF.bernoulli_apply]
  rw [hset, graphMeasure, Measure.pi_pi]
  simpa only [apply_ite, hmass, measure_univ] using
    (Finset.prod_ite_mem_eq S fun e ↦
      if v e then (edgeProbability θ e : ℝ≥0∞)
        else ((1 - edgeProbability θ e : ℝ≥0) : ℝ≥0∞))

/-- When the two probabilities agree, every edge-coordinate law is the same
Bernoulli law, i.e. the Erdős--Rényi special case. -/
theorem graphMeasure_eq_erdosRenyi_of_p_eq_q (k : ℕ) (θ : Parameters)
    (hpq : θ.p = θ.q) :
    graphMeasure k θ = Measure.pi (fun _ : Edge k ↦
      (PMF.bernoulli θ.p θ.hp).toMeasure) := by
  unfold graphMeasure edgeProbability
  congr 2
  funext e
  by_cases h : e.1.1.1 = e.1.2.1 <;> simp [h, hpq]

/-- Expected adjacency: `p` within a community and `q` across communities. -/
def expectedAdjacency (k : ℕ) (p q : ℝ) : Matrix (Vertex k) (Vertex k) ℝ :=
  fun i j ↦ if i.1 = j.1 then p else q

/-- The all-ones signal direction. -/
def allOnes (k : ℕ) : Vertex k → ℝ := Function.const (Vertex k) 1

/-- The signed community direction, positive on community zero and negative
on community one. -/
def communitySign (k : ℕ) : Vertex k → ℝ :=
  fun i ↦ if i.1 = 0 then 1 else -1

private theorem finTwo_eq_zero_or_one (i : Fin 2) : i = 0 ∨ i = 1 := by
  rcases Nat.le_one_iff_eq_zero_or_eq_one.mp (Nat.le_of_lt_succ i.isLt) with h | h
  · exact Or.inl (Fin.ext h)
  · exact Or.inr (Fin.ext h)

/-- The all-ones vector has eigenvalue `k(p+q)`. -/
theorem expectedAdjacency_mulVec_allOnes (k : ℕ) (p q : ℝ) :
    (expectedAdjacency k p q).mulVec (allOnes k) =
      (k * (p + q)) • allOnes k := by
  funext i
  simp only [Matrix.mulVec, dotProduct, expectedAdjacency, allOnes,
    Function.const_apply, mul_one, Pi.smul_apply, smul_eq_mul]
  rw [Fintype.sum_prod_type, Fin.sum_univ_two]
  rcases finTwo_eq_zero_or_one i.1 with hi | hi
  · simp [hi, mul_add]
  · simp [hi, mul_add, add_comm]

/-- The signed community vector has eigenvalue `k(p-q)`. -/
theorem expectedAdjacency_mulVec_communitySign (k : ℕ) (p q : ℝ) :
    (expectedAdjacency k p q).mulVec (communitySign k) =
      (k * (p - q)) • communitySign k := by
  funext i
  simp only [Matrix.mulVec, dotProduct, expectedAdjacency, communitySign,
    Pi.smul_apply, smul_eq_mul]
  rw [Fintype.sum_prod_type, Fin.sum_univ_two]
  rcases finTwo_eq_zero_or_one i.1 with hi | hi
  · simp [hi]
    ring
  · simp [hi]
    ring

/-- Two-column signal basis used to factor the expected adjacency. -/
def signalBasis (k : ℕ) : Matrix (Vertex k) (Fin 2) ℝ :=
  fun i t ↦ if t = 0 then allOnes k i else communitySign k i

/-- Coefficient matrix in the two-dimensional signal factorization. -/
def signalCoefficients (k : ℕ) (p q : ℝ) : Matrix (Fin 2) (Vertex k) ℝ :=
  fun t j ↦ if t = 0 then (p + q) / 2 else (p - q) / 2 * communitySign k j

theorem expectedAdjacency_eq_signalBasis_mul (k : ℕ) (p q : ℝ) :
    expectedAdjacency k p q = signalBasis k * signalCoefficients k p q := by
  ext i j
  rw [Matrix.mul_apply, Fin.sum_univ_two]
  rcases finTwo_eq_zero_or_one i.1 with hi | hi <;>
    rcases finTwo_eq_zero_or_one j.1 with hj | hj <;>
    simp [expectedAdjacency, signalBasis, signalCoefficients, allOnes, communitySign, hi, hj] <;>
    ring

private theorem allOnes_ne_zero {k : ℕ} (hk : 0 < k) : allOnes k ≠ 0 := by
  intro h
  have hi := congrFun h ((0 : Fin 2), (⟨0, hk⟩ : Fin k))
  simp [allOnes] at hi

/-- For a nonempty community, the all-ones and signed-community directions
are linearly independent. -/
theorem linearIndependent_allOnes_communitySign {k : ℕ} (hk : 0 < k) :
    LinearIndependent ℝ ![allOnes k, communitySign k] := by
  rw [LinearIndependent.pair_iff' (allOnes_ne_zero hk)]
  intro a ha
  have h0 := congrFun ha ((0 : Fin 2), (⟨0, hk⟩ : Fin k))
  have h1 := congrFun ha ((1 : Fin 2), (⟨0, hk⟩ : Fin k))
  simp [allOnes, communitySign] at h0 h1
  linarith

/-- Under the chapter's nondegenerate probability assumptions, the expected
adjacency matrix has rank exactly two. -/
theorem expectedAdjacency_rank_eq_two {k : ℕ} (hk : 0 < k)
    {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    (expectedAdjacency k p q).rank = 2 := by
  have hp : 0 < p := lt_of_le_of_lt hq hpq
  have hLam1 : (k : ℝ) * (p + q) ≠ 0 := by positivity
  have hLam2 : (k : ℝ) * (p - q) ≠ 0 := by
    have : 0 < p - q := sub_pos.mpr hpq
    positivity
  have hupper : (expectedAdjacency k p q).rank ≤ 2 := by
    rw [expectedAdjacency_eq_signalBasis_mul]
    exact (Matrix.rank_mul_le_left (signalBasis k) (signalCoefficients k p q)).trans
      (by simpa using Matrix.rank_le_card_width (signalBasis k))
  have hone_mem : allOnes k ∈ LinearMap.range (expectedAdjacency k p q).mulVecLin := by
    refine ⟨((k : ℝ) * (p + q))⁻¹ • allOnes k, ?_⟩
    rw [LinearMap.map_smul, Matrix.mulVecLin_apply,
      expectedAdjacency_mulVec_allOnes]
    rw [← SemigroupAction.mul_smul, inv_mul_cancel₀ hLam1, one_smul]
  have hsign_mem : communitySign k ∈
      LinearMap.range (expectedAdjacency k p q).mulVecLin := by
    refine ⟨((k : ℝ) * (p - q))⁻¹ • communitySign k, ?_⟩
    rw [LinearMap.map_smul, Matrix.mulVecLin_apply,
      expectedAdjacency_mulVec_communitySign]
    rw [← SemigroupAction.mul_smul, inv_mul_cancel₀ hLam2, one_smul]
  have hspan : Submodule.span ℝ (Set.range ![allOnes k, communitySign k]) ≤
      LinearMap.range (expectedAdjacency k p q).mulVecLin := by
    rw [Submodule.span_le]
    intro v hv
    obtain ⟨i, rfl⟩ := hv
    rcases finTwo_eq_zero_or_one i with rfl | rfl
    · simpa using hone_mem
    · simpa using hsign_mem
  have hlower : 2 ≤ (expectedAdjacency k p q).rank := by
    rw [Matrix.rank]
    calc
      2 = Module.finrank ℝ (Submodule.span ℝ
          (Set.range ![allOnes k, communitySign k])) := by
        symm
        simpa using finrank_span_eq_card (linearIndependent_allOnes_communitySign hk)
      _ ≤ Module.finrank ℝ
          (LinearMap.range (expectedAdjacency k p q).mulVecLin) :=
        Submodule.finrank_mono hspan
  omega

/-- Noise is the observed adjacency minus its expectation. -/
def residual {k : ℕ} (A : Matrix (Vertex k) (Vertex k) ℝ) (p q : ℝ) :
    Matrix (Vertex k) (Vertex k) ℝ :=
  A - expectedAdjacency k p q

theorem expectedAdjacency_add_residual {k : ℕ}
    (A : Matrix (Vertex k) (Vertex k) ℝ) (p q : ℝ) :
    expectedAdjacency k p q + residual A p q = A := by
  ext i j
  simp [residual]

/-- A doubly stochastic real matrix over a nonempty finite index type has
Euclidean operator norm exactly one.  Birkhoff's theorem gives the upper
bound, while the constant-one vector gives the matching lower bound. -/
theorem l2_opNorm_eq_one_of_mem_doublyStochastic
    {n : Type*} [Fintype n] [DecidableEq n] [Nonempty n]
    (M : Matrix n n ℝ) (hM : M ∈ doublyStochastic ℝ n) :
    ‖M‖ = 1 := by
  apply le_antisymm
  · exact Matrix.l2_opNorm_le_one_of_mem_doublyStochastic hM
  · let x : EuclideanSpace ℝ n := (EuclideanSpace.equiv n ℝ).symm 1
    have hx : 0 < ‖x‖ := by
      rw [norm_pos_iff]
      intro hx0
      have hone : (1 : n → ℝ) = 0 := by
        simpa [x] using congrArg (EuclideanSpace.equiv n ℝ) hx0
      obtain ⟨i⟩ := inferInstanceAs (Nonempty n)
      have hbad := congrFun hone i
      norm_num at hbad
    have hbound := Matrix.l2_opNorm_mulVec M x
    have hMx : (EuclideanSpace.equiv n ℝ).symm (M *ᵥ x) = x := by
      apply (EuclideanSpace.equiv n ℝ).injective
      simpa [x] using mulVec_one_of_mem_doublyStochastic hM
    rw [hMx] at hbound
    nlinarith [norm_nonneg M]

/-- After division by its positive row sum, the expected adjacency matrix is
doubly stochastic. -/
theorem normalizedExpectedAdjacency_mem_doublyStochastic
    {k : ℕ} (hk : 0 < k) {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    (((((k : ℝ) * (p + q))⁻¹) • expectedAdjacency k p q :
      Matrix (Vertex k) (Vertex k) ℝ) ∈
        doublyStochastic ℝ (Vertex k)) := by
  have hp : 0 < p := lt_of_le_of_lt hq hpq
  have hpqpos : 0 < p + q := by positivity
  have hqppos : 0 < q + p := by positivity
  rw [mem_doublyStochastic_iff_sum]
  constructor
  · intro i j
    simp only [smul_apply, smul_eq_mul, expectedAdjacency]
    split <;> positivity
  constructor
  · intro i
    simp only [smul_apply, smul_eq_mul, expectedAdjacency]
    rw [Fintype.sum_prod_type, Fin.sum_univ_two]
    rcases finTwo_eq_zero_or_one i.1 with hi | hi
    · simp [hi]
      field_simp [ne_of_gt hpqpos]
    · simp [hi]
      field_simp [ne_of_gt hqppos]
      ring
  · intro j
    simp only [smul_apply, smul_eq_mul, expectedAdjacency]
    rw [Fintype.sum_prod_type, Fin.sum_univ_two]
    rcases finTwo_eq_zero_or_one j.1 with hj | hj
    · simp [hj]
      field_simp [ne_of_gt hpqpos]
    · simp [hj]
      field_simp [ne_of_gt hqppos]
      ring

/-- The expected adjacency signal has Euclidean operator norm equal to its
top eigenvalue `k(p+q)`. -/
theorem norm_expectedAdjacency {k : ℕ} (hk : 0 < k)
    {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    ‖expectedAdjacency k p q‖ = (k : ℝ) * (p + q) := by
  let lam : ℝ := (k : ℝ) * (p + q)
  let N : Matrix (Vertex k) (Vertex k) ℝ :=
    lam⁻¹ • expectedAdjacency k p q
  have hlam : 0 < lam := by
    dsimp [lam]
    have hp : 0 < p := lt_of_le_of_lt hq hpq
    positivity
  have hN : N ∈ doublyStochastic ℝ (Vertex k) := by
    simpa [N, lam] using
      normalizedExpectedAdjacency_mem_doublyStochastic hk hq hpq
  letI : Nonempty (Vertex k) :=
    ⟨((0 : Fin 2), (⟨0, hk⟩ : Fin k))⟩
  have hNnorm : ‖N‖ = 1 :=
    l2_opNorm_eq_one_of_mem_doublyStochastic N hN
  have hrecover : expectedAdjacency k p q = lam • N := by
    dsimp [N]
    rw [smul_smul, mul_inv_cancel₀ hlam.ne', one_smul]
  rw [hrecover, norm_smul, hNnorm, mul_one, Real.norm_eq_abs,
    abs_of_pos hlam]

/-- Community coefficients have equal magnitude. -/
theorem abs_communitySign (k : ℕ) (i : Vertex k) :
    |communitySign k i| = 1 := by
  by_cases h : i.1 = 0 <;> simp [communitySign, h]

/-- The sign of the community vector exactly identifies community zero. -/
theorem communitySign_pos_iff (k : ℕ) (i : Vertex k) :
    0 < communitySign k i ↔ i.1 = 0 := by
  by_cases h : i.1 = 0 <;> simp [communitySign, h]

end NumStability.HDP.Graph.StochasticBlock
