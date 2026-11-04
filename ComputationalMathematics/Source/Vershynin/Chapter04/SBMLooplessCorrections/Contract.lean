import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417.Contract
import ComputationalMathematics.Source.Vershynin.Chapter04.ExpectedAdjacencyN4.Contract

/-!
# Vershynin Chapter 4, loopless SBM corrections

Separately named corrected results and formal obstruction witnesses for the
conflict between the loopless adjacency matrix imported from Definition 3.6.2
and the `p`-filled diagonal matrix displayed in Section 4.5.2.
-/

namespace NumStability.HDP.Contract

open Matrix MeasureTheory
open scoped Matrix.Norms.L2Operator

private abbrev SBMVertex (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Vertex k

private abbrev SBMEdge (k : ℕ) :=
  NumStability.HDP.Graph.StochasticBlock.Edge k

/-- Corrected Section 4.5.2 decomposition: the loopless block matrix is the
entrywise expectation, and every sample is that signal plus its residual. -/
theorem hdp_04_expected_adjacency_decomposition_corrected {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j : NumStability.HDP.Graph.StochasticBlock.Vertex k,
      ∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
        looplessExpectedAdjacency k θ.p θ.q i j) ∧
      (∀ ω : NumStability.HDP.Graph.StochasticBlock.Edge k → Bool,
        looplessExpectedAdjacency k θ.p θ.q +
            looplessResidual (stochasticBlockAdjacency ω) θ.p θ.q =
          stochasticBlockAdjacency ω) := by
  have h := hdp_04_expected_adjacency_decomposition hk θ hpq
  exact ⟨h.2.1, h.2.2.2.2.2⟩

/-- Formal obstruction to the printed Section 4.5.2 identity `D = E A`:
the imported loopless expectation has diagonal zero, while the displayed block
matrix has the strictly positive diagonal `p`. -/
theorem hdp_04_expected_adjacency_decomposition_counterexample {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    ∀ i : NumStability.HDP.Graph.StochasticBlock.Vertex k,
      looplessExpectedAdjacency k θ.p θ.q i i = 0 ∧
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
        k θ.p θ.q i i = θ.p ∧
      looplessExpectedAdjacency k θ.p θ.q i i ≠
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
          k θ.p θ.q i i := by
  have h := hdp_04_expected_adjacency_decomposition hk θ hpq
  intro i
  exact ⟨(h.2.2.2.1 i).1, (h.2.2.2.1 i).2, h.2.2.2.2.1 i⟩

/-- Corrected four-vertex expectation: its diagonal is zero, its distinct
within-community entries are `p`, and its cross-community entries are `q`. -/
theorem hdp_04_expected_adjacency_n4_corrected
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j : NumStability.HDP.Graph.StochasticBlock.Vertex 2,
      ∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure 2 θ =
        looplessExpectedAdjacency 2 θ.p θ.q i j) ∧
    (∀ c a : Fin 2,
      looplessExpectedAdjacency 2 θ.p θ.q (c, a) (c, a) = 0) ∧
    (∀ (c : Fin 2) (a b : Fin 2), a ≠ b →
      looplessExpectedAdjacency 2 θ.p θ.q (c, a) (c, b) = θ.p) ∧
    (∀ a b : Fin 2,
      looplessExpectedAdjacency 2 θ.p θ.q (0, a) (1, b) = θ.q) ∧
    (∀ a b : Fin 2,
      looplessExpectedAdjacency 2 θ.p θ.q (1, a) (0, b) = θ.q) := by
  have h := hdp_04_expected_adjacency_decomposition_corrected (k := 2) (by omega) θ hpq
  refine ⟨h.1, ?_, ?_, ?_, ?_⟩
  · simp [looplessExpectedAdjacency]
  · intro c a b hab
    simp [looplessExpectedAdjacency, hab]
  · simp [looplessExpectedAdjacency]
  · simp [looplessExpectedAdjacency]

/-- Formal obstruction for the printed `n = 4` display: all four printed
diagonal entries are `p`, whereas the true loopless expectation has diagonal
zero. -/
theorem hdp_04_expected_adjacency_n4_counterexample
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    ∀ i : NumStability.HDP.Graph.StochasticBlock.Vertex 2,
      looplessExpectedAdjacency 2 θ.p θ.q i i = 0 ∧
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
        2 θ.p θ.q i i = θ.p ∧
      looplessExpectedAdjacency 2 θ.p θ.q i i ≠
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
          2 θ.p θ.q i i := by
  exact hdp_04_expected_adjacency_decomposition_counterexample (k := 2) (by omega) θ hpq

theorem looplessExpectedAdjacency_eq_displayed_sub_diagonal
    (k : ℕ) (p q : ℝ) :
    looplessExpectedAdjacency k p q =
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency k p q -
        p • (1 : Matrix (NumStability.HDP.Graph.StochasticBlock.Vertex k)
          (NumStability.HDP.Graph.StochasticBlock.Vertex k) ℝ) := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [looplessExpectedAdjacency,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency]
  · simp [looplessExpectedAdjacency,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency, hij]

/-- Corrected Equation (4.17) for the actual loopless expectation. Removing
the printed diagonal `p I` shifts both displayed eigenvalues by `-p` while
preserving the two eigenvectors. -/
theorem hdp_04_equation_4_17_corrected {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.allOnes k) =
      (((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) •
        NumStability.HDP.Graph.StochasticBlock.allOnes k) ∧
    (looplessExpectedAdjacency k θ.p θ.q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
      (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
        NumStability.HDP.Graph.StochasticBlock.communitySign k) := by
  have _ := hk
  have _ := hpq
  rw [looplessExpectedAdjacency_eq_displayed_sub_diagonal]
  constructor
  · rw [Matrix.sub_mulVec,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_allOnes]
    simp [Matrix.smul_mulVec]
    module
  · rw [Matrix.sub_mulVec,
      NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_communitySign]
    simp [Matrix.smul_mulVec]
    module

/-- Formal obstruction for interpreting printed Equation (4.17) as an
eigenvalue statement about `E A`: its matrix differs from the true loopless
expectation on every diagonal entry. -/
theorem hdp_04_equation_4_17_counterexample {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    ∀ i : NumStability.HDP.Graph.StochasticBlock.Vertex k,
      looplessExpectedAdjacency k θ.p θ.q i i ≠
        NumStability.HDP.Graph.StochasticBlock.expectedAdjacency
          k θ.p θ.q i i := by
  have h := hdp_04_equation_4_17 hk θ hpq
  exact h.2.1

/-- Corrected Exercise 4.5.2: the true loopless expectation has the same two
signal directions as the displayed matrix, but both eigenvalues are shifted
by `-p`.  In particular, the displayed rank-two conclusion cannot be retained
without additional parameter restrictions. -/
theorem hdp_04_exercise_4_5_2_corrected {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (∀ i j : NumStability.HDP.Graph.StochasticBlock.Vertex k,
      ∫ ω, stochasticBlockAdjacency ω i j
          ∂NumStability.HDP.Graph.StochasticBlock.graphMeasure k θ =
        looplessExpectedAdjacency k θ.p θ.q i j) ∧
      (looplessExpectedAdjacency k θ.p θ.q).mulVec
          (NumStability.HDP.Graph.StochasticBlock.allOnes k) =
        (((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) •
          NumStability.HDP.Graph.StochasticBlock.allOnes k) ∧
      (looplessExpectedAdjacency k θ.p θ.q).mulVec
          (NumStability.HDP.Graph.StochasticBlock.communitySign k) =
        (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
          NumStability.HDP.Graph.StochasticBlock.communitySign k) := by
  exact ⟨(hdp_04_expected_adjacency_decomposition_corrected hk θ hpq).1,
    hdp_04_equation_4_17_corrected hk θ hpq⟩

/-- A concrete obstruction to Exercise 4.5.2's printed rank-two conclusion:
with one vertex in each community and no cross-community edges, the true
loopless expectation is the zero matrix, hence has rank zero. -/
theorem hdp_04_exercise_4_5_2_counterexample :
    let θ : NumStability.HDP.Graph.StochasticBlock.Parameters :=
      { p := 1, q := 0, hp := by norm_num, hq := by norm_num }
    (looplessExpectedAdjacency 1 θ.p θ.q).rank = 0 ∧
      (looplessExpectedAdjacency 1 θ.p θ.q).rank ≠ 2 := by
  dsimp
  have hzero : looplessExpectedAdjacency 1 (1 : ℝ) 0 = 0 := by
    ext i j
    by_cases hij : i = j
    · simp [looplessExpectedAdjacency, hij]
    · have hcomm : i.1 ≠ j.1 := by
        intro h
        apply hij
        apply Prod.ext h
        exact Subsingleton.elim _ _
      simp [looplessExpectedAdjacency, hij, hcomm]
  rw [hzero]
  simp

private theorem looplessExpectedAdjacency_mulVec_allOnes
    (k : ℕ) (p q : ℝ) :
    (looplessExpectedAdjacency k p q).mulVec
        (NumStability.HDP.Graph.StochasticBlock.allOnes k) =
      (((k : ℝ) * (p + q) - p) •
        NumStability.HDP.Graph.StochasticBlock.allOnes k) := by
  rw [looplessExpectedAdjacency_eq_displayed_sub_diagonal,
    Matrix.sub_mulVec,
    NumStability.HDP.Graph.StochasticBlock.expectedAdjacency_mulVec_allOnes]
  simp [Matrix.smul_mulVec]
  module

private theorem looplessExpectedAdjacency_entry_nonneg
    (k : ℕ) {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    (i j : SBMVertex k) :
    0 ≤ looplessExpectedAdjacency k p q i j := by
  by_cases hij : i = j
  · simp [looplessExpectedAdjacency, hij]
  · by_cases hcomm : i.1 = j.1
    · simp [looplessExpectedAdjacency, hij, hcomm, hp]
    · simp [looplessExpectedAdjacency, hij, hcomm, hq]

private theorem normalizedLooplessExpectedAdjacency_mem_doublyStochastic
    {k : ℕ} {p q : ℝ} (hp : 0 ≤ p) (hq : 0 ≤ q)
    (hlam : 0 < (k : ℝ) * (p + q) - p) :
    (((((k : ℝ) * (p + q) - p)⁻¹) • looplessExpectedAdjacency k p q :
      Matrix (SBMVertex k) (SBMVertex k) ℝ) ∈
        doublyStochastic ℝ (SBMVertex k)) := by
  let lam : ℝ := (k : ℝ) * (p + q) - p
  have hrow (i : SBMVertex k) :
      ∑ j, looplessExpectedAdjacency k p q i j = lam := by
    have hi := congrFun (looplessExpectedAdjacency_mulVec_allOnes k p q) i
    simpa [Matrix.mulVec, dotProduct,
      NumStability.HDP.Graph.StochasticBlock.allOnes, lam] using hi
  rw [mem_doublyStochastic_iff_sum]
  constructor
  · intro i j
    simp only [Matrix.smul_apply, smul_eq_mul]
    exact mul_nonneg (inv_nonneg.mpr hlam.le)
      (looplessExpectedAdjacency_entry_nonneg k hp hq i j)
  constructor
  · intro i
    simp only [Matrix.smul_apply, smul_eq_mul, ← Finset.mul_sum, hrow]
    exact inv_mul_cancel₀ hlam.ne'
  · intro j
    calc
      ∑ i, lam⁻¹ * looplessExpectedAdjacency k p q i j =
          ∑ i, lam⁻¹ * looplessExpectedAdjacency k p q j i := by
            apply Finset.sum_congr rfl
            intro i _
            simp only [looplessExpectedAdjacency]
            by_cases hij : i = j
            · subst j; rfl
            · have hji : j ≠ i := Ne.symm hij
              simp [hij, hji, eq_comm]
      _ = lam⁻¹ * ∑ i, looplessExpectedAdjacency k p q j i := by
        rw [Finset.mul_sum]
      _ = 1 := by rw [hrow]; exact inv_mul_cancel₀ hlam.ne'

/-- Exact operator norm of the true loopless expectation.  The diagonal
correction changes the printed leading eigenvalue by `-p`. -/
theorem norm_looplessExpectedAdjacency {k : ℕ} (hk : 0 < k)
    {p q : ℝ} (hq : 0 ≤ q) (hpq : q < p) :
    ‖looplessExpectedAdjacency k p q‖ = (k : ℝ) * (p + q) - p := by
  let lam : ℝ := (k : ℝ) * (p + q) - p
  have hp : 0 ≤ p := (lt_of_le_of_lt hq hpq).le
  let i₀ : SBMVertex k := ((0 : Fin 2), ⟨0, hk⟩)
  have hrow : ∑ j, looplessExpectedAdjacency k p q i₀ j = lam := by
    have hi := congrFun (looplessExpectedAdjacency_mulVec_allOnes k p q) i₀
    simpa [Matrix.mulVec, dotProduct,
      NumStability.HDP.Graph.StochasticBlock.allOnes, lam] using hi
  have hlam0 : 0 ≤ lam := by
    rw [← hrow]
    exact Finset.sum_nonneg fun j _ ↦
      looplessExpectedAdjacency_entry_nonneg k hp hq i₀ j
  by_cases hlam : lam = 0
  · have hzero : looplessExpectedAdjacency k p q = 0 := by
      ext i j
      change looplessExpectedAdjacency k p q i j = (0 : ℝ)
      have hrowsum : ∑ t, looplessExpectedAdjacency k p q i t = 0 := by
        have hi := congrFun (looplessExpectedAdjacency_mulVec_allOnes k p q) i
        simpa [Matrix.mulVec, dotProduct,
          NumStability.HDP.Graph.StochasticBlock.allOnes, lam, hlam] using hi
      apply le_antisymm
      · rw [← hrowsum]
        exact Finset.single_le_sum
          (fun t _ ↦ looplessExpectedAdjacency_entry_nonneg k hp hq i t)
          (Finset.mem_univ j)
      · exact looplessExpectedAdjacency_entry_nonneg k hp hq i j
    rw [hzero, norm_zero]
    change 0 = lam
    exact hlam.symm
  · have hlampos : 0 < lam := lt_of_le_of_ne hlam0 (Ne.symm hlam)
    let N : Matrix (SBMVertex k) (SBMVertex k) ℝ :=
      lam⁻¹ • looplessExpectedAdjacency k p q
    letI : Nonempty (SBMVertex k) := ⟨i₀⟩
    have hN : N ∈ doublyStochastic ℝ (SBMVertex k) := by
      simpa [N, lam] using
        normalizedLooplessExpectedAdjacency_mem_doublyStochastic hp hq hlampos
    have hNnorm : ‖N‖ = 1 :=
      NumStability.HDP.Graph.StochasticBlock.l2_opNorm_eq_one_of_mem_doublyStochastic
        N hN
    have hrecover : looplessExpectedAdjacency k p q = lam • N := by
      dsimp [N]
      rw [smul_smul, mul_inv_cancel₀ hlam, one_smul]
    rw [hrecover, norm_smul, hNnorm, mul_one, Real.norm_eq_abs,
      abs_of_pos hlampos]

/-- Corrected stochastic-block signal norm: the true loopless expectation
has norm `k(p+q)-p`, and its normalized value differs from the displayed
matrix by the explicit diagonal correction.  Community membership is encoded
by signs, while all signal coefficients have equal magnitude. -/
theorem hdp_04_sbm_signal_norm_corrected {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    ‖looplessExpectedAdjacency k θ.p θ.q‖ =
        (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
      ‖looplessExpectedAdjacency k θ.p θ.q‖ /
          ((2 * k : ℕ) : ℝ) =
        ((θ.p : ℝ) + θ.q) / 2 - θ.p / ((2 * k : ℕ) : ℝ) ∧
      (∀ i : NumStability.HDP.Graph.StochasticBlock.Vertex k,
        (0 < NumStability.HDP.Graph.StochasticBlock.communitySign k i ↔ i.1 = 0) ∧
        |NumStability.HDP.Graph.StochasticBlock.communitySign k i| = 1) := by
  have hnorm :
      ‖looplessExpectedAdjacency k (θ.p : ℝ) (θ.q : ℝ)‖ =
        (k : ℝ) * ((θ.p : ℝ) + (θ.q : ℝ)) - (θ.p : ℝ) :=
    norm_looplessExpectedAdjacency hk (p := (θ.p : ℝ)) (q := (θ.q : ℝ))
      θ.q.coe_nonneg hpq
  refine ⟨hnorm, ?_, ?_⟩
  · rw [hnorm]
    have hkR : (0 : ℝ) < k := by exact_mod_cast hk
    push_cast
    field_simp
  · intro i
    exact ⟨
      NumStability.HDP.Graph.StochasticBlock.communitySign_pos_iff k i,
      NumStability.HDP.Graph.StochasticBlock.abs_communitySign k i⟩

/-- Concrete failure of the printed signal-norm formula when it is read as a
statement about the inherited loopless graph: for one vertex per community,
`p=1`, and `q=0`, the true expectation is zero while the displayed matrix has
norm one. -/
theorem hdp_04_sbm_signal_norm_counterexample :
    ‖looplessExpectedAdjacency 1 (1 : ℝ) 0‖ = 0 ∧
      ‖NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 1 (1 : ℝ) 0‖ = 1 ∧
      ‖looplessExpectedAdjacency 1 (1 : ℝ) 0‖ ≠
        ‖NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 1 (1 : ℝ) 0‖ := by
  have hloop := norm_looplessExpectedAdjacency (k := 1) (by omega)
    (q := 0) (p := 1) (by norm_num) (by norm_num)
  have hdisplay :=
    NumStability.HDP.Graph.StochasticBlock.norm_expectedAdjacency (k := 1)
      (by omega) (q := 0) (p := 1) (by norm_num) (by norm_num)
  have hloop' : ‖looplessExpectedAdjacency 1 (1 : ℝ) 0‖ = 0 := by
    norm_num at hloop
    exact hloop
  have hdisplay' :
      ‖NumStability.HDP.Graph.StochasticBlock.expectedAdjacency 1 (1 : ℝ) 0‖ = 1 := by
    norm_num at hdisplay
    exact hdisplay
  exact ⟨hloop', hdisplay', by rw [hloop', hdisplay']; norm_num⟩

end NumStability.HDP.Contract
