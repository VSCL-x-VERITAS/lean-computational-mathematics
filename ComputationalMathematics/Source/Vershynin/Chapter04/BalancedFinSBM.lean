import ComputationalMathematics.HDP.Graph.FinStochasticBlockExpectedAdjacency
import ComputationalMathematics.HDP.Graph.StochasticBlockDecomposition
import ComputationalMathematics.Analysis.Eigenvalues.OrderedSpectrum
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.Contract

/-!
# Balanced stochastic-block population matrices on finite indices

Chapter 4 correspondence between the two-community vertex model and `Fin (2*k)`.
This module reindexes the loopless population matrix and its ordered spectrum;
the separately named correction preserves the printed diagonal discrepancy.
-/

noncomputable section

open Matrix

namespace NumStability.HDP.Contract.BalancedFinSBM

/-- Balanced-community vertices, indexed by a community and an offset. -/
abbrev Vertex (k : ℕ) := NumStability.HDP.Graph.StochasticBlock.Vertex k

/-- Identify balanced-community vertices with the flattened finite index. -/
def indexEquiv (k : ℕ) : Vertex k ≃ Fin (2 * k) := finProdFinEquiv

/-- The community label of a flattened vertex. -/
def community (k : ℕ) (i : Fin (2 * k)) : Fin 2 :=
  ((indexEquiv k).symm i).1

/-- The all-ones signal direction on flattened vertices. -/
def allOnes (k : ℕ) : Fin (2 * k) → ℝ :=
  NumStability.HDP.Graph.StochasticBlock.allOnes k ∘ (indexEquiv k).symm

/-- The signed community direction on flattened vertices. -/
def communitySign (k : ℕ) : Fin (2 * k) → ℝ :=
  NumStability.HDP.Graph.StochasticBlock.communitySign k ∘ (indexEquiv k).symm

/-- The loopless expected adjacency matrix on flattened vertices. -/
def population (k : ℕ) (p q : ℝ) : Matrix (Fin (2 * k)) (Fin (2 * k)) ℝ :=
  Matrix.reindex (indexEquiv k) (indexEquiv k) (looplessExpectedAdjacency k p q)

theorem population_hermitian (k : ℕ) (p q : ℝ) :
    (population k p q).IsHermitian := by
  ext i j
  simp [population, Matrix.reindex_apply, looplessExpectedAdjacency,
    Matrix.conjTranspose, eq_comm]

theorem expectedAdjacency_eq_population (k : ℕ) (p q : ℝ) :
    NumStability.HDP.Graph.FinStochasticBlock.expectedAdjacency
      (community k) p q = population k p q := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [NumStability.HDP.Graph.FinStochasticBlock.expectedAdjacency,
      population, Matrix.reindex_apply, looplessExpectedAdjacency,
      indexEquiv]
  · have hpre : (indexEquiv k).symm i ≠ (indexEquiv k).symm j := by
      intro h
      exact hij ((indexEquiv k).symm.injective h)
    simp [NumStability.HDP.Graph.FinStochasticBlock.expectedAdjacency,
      population, Matrix.reindex_apply, looplessExpectedAdjacency, community,
      hij, hpre]

theorem reindex_mulVec {k : ℕ} (A : Matrix (Vertex k) (Vertex k) ℝ)
    (x : Vertex k → ℝ) :
    (Matrix.reindex (indexEquiv k) (indexEquiv k) A).mulVec
        (x ∘ (indexEquiv k).symm) =
      (A.mulVec x) ∘ (indexEquiv k).symm := by
  rw [Matrix.reindex_apply, Matrix.submatrix_mulVec_equiv]
  simp [Function.comp_def]

theorem population_mulVec_allOnes {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (population k θ.p θ.q).mulVec (allOnes k) =
      (((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) • allOnes k) := by
  rw [population, allOnes, reindex_mulVec]
  rw [(hdp_04_equation_4_17_loopless_full_corrected hk θ hpq).2.1]
  rfl

theorem population_mulVec_communitySign {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    (population k θ.p θ.q).mulVec (communitySign k) =
      (((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) • communitySign k) := by
  rw [population, communitySign, reindex_mulVec]
  rw [(hdp_04_equation_4_17_loopless_full_corrected hk θ hpq).2.2.1]
  rfl

theorem exists_population_decomposition {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p)
    (x : Fin (2 * k) → ℝ) :
    ∃ a b : ℝ, ∃ y : Fin (2 * k) → ℝ,
      x = a • allOnes k + b • communitySign k + y ∧
      (∀ c : Fin 2, ∑ t : Fin k, y (indexEquiv k (c, t)) = 0) ∧
      (population k θ.p θ.q).mulVec y = (-(θ.p : ℝ)) • y := by
  obtain ⟨a, b, y, hxy, hy⟩ :=
    NumStability.HDP.Graph.StochasticBlock.exists_signal_complement_decomposition
      hk (x ∘ indexEquiv k)
  let y' : Fin (2 * k) → ℝ := y ∘ (indexEquiv k).symm
  refine ⟨a, b, y', ?_, ?_, ?_⟩
  · funext i
    have hi := congrFun hxy ((indexEquiv k).symm i)
    simpa [allOnes, communitySign, y', Function.comp_def] using hi
  · intro c
    simpa [y', Function.comp_def] using hy c
  · dsimp [y']
    rw [population, reindex_mulVec]
    rw [(hdp_04_equation_4_17_loopless_full_corrected hk θ hpq).2.2.2 y hy]
    rfl

theorem population_eigenvalue_cases {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p)
    {μ : ℝ} {x : Fin (2 * k) → ℝ} (hx : x ≠ 0)
    (heig : (population k θ.p θ.q).mulVec x = μ • x) :
    μ = (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∨
    μ = (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∨
    μ = -(θ.p : ℝ) := by
  let l1 : ℝ := (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p
  let l2 : ℝ := (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p
  let l3 : ℝ := -(θ.p : ℝ)
  obtain ⟨a, b, y, hxy, hy, hyEig⟩ :=
    exists_population_decomposition hk θ hpq x
  have heq := heig
  rw [hxy, Matrix.mulVec_add, Matrix.mulVec_add, Matrix.mulVec_smul,
    Matrix.mulVec_smul, population_mulVec_allOnes hk θ hpq,
    population_mulVec_communitySign hk θ hpq, hyEig] at heq
  have hsum0 := congrArg
    (fun z : Fin (2 * k) → ℝ => ∑ t : Fin k, z (indexEquiv k (0, t))) heq
  have hsum1 := congrArg
    (fun z : Fin (2 * k) → ℝ => ∑ t : Fin k, z (indexEquiv k (1, t))) heq
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    Finset.sum_add_distrib, ← Finset.mul_sum, hy 0, hy 1, mul_zero,
    allOnes, communitySign, Function.comp_apply, Equiv.symm_apply_apply,
    NumStability.HDP.Graph.StochasticBlock.allOnes, Function.const_apply,
    NumStability.HDP.Graph.StochasticBlock.communitySign,
    Fin.isValue, if_pos, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul] at hsum0 hsum1
  norm_num at hsum1
  have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hk)
  have he0 :
      (a * l1 + b * l2) * (k : ℝ) = μ * (a + b) * (k : ℝ) := by
    convert hsum0 using 1 <;> dsimp [l1, l2] <;> ring
  have he1 :
      (a * l1 - b * l2) * (k : ℝ) = μ * (a - b) * (k : ℝ) := by
    convert hsum1 using 1 <;> dsimp [l1, l2] <;> ring
  have he0' : a * l1 + b * l2 = μ * (a + b) :=
    mul_right_cancel₀ hkR he0
  have he1' : a * l1 - b * l2 = μ * (a - b) :=
    mul_right_cancel₀ hkR he1
  have haProd : a * (l1 - μ) = 0 := by
    nlinarith [he0', he1']
  have hbProd : b * (l2 - μ) = 0 := by
    nlinarith [he0', he1']
  by_cases h1 : μ = l1
  · exact Or.inl (by simpa [l1] using h1)
  by_cases h2 : μ = l2
  · exact Or.inr (Or.inl (by simpa [l2] using h2))
  by_cases h3 : μ = l3
  · exact Or.inr (Or.inr (by simpa [l3] using h3))
  have ha : a = 0 := by
    rcases mul_eq_zero.mp haProd with ha | hdiff
    · exact ha
    · exfalso
      apply h1
      linarith
  have hb : b = 0 := by
    rcases mul_eq_zero.mp hbProd with hb | hdiff
    · exact hb
    · exfalso
      apply h2
      linarith
  have hy0 : y = 0 := by
    rw [ha, hb] at heq
    simp only [zero_smul, zero_add] at heq
    apply funext
    intro i
    have hi := congrFun heq i
    simp only [Pi.smul_apply, smul_eq_mul] at hi
    have hprod : (l3 - μ) * y i = 0 := by
      dsimp [l3]
      nlinarith
    rcases mul_eq_zero.mp hprod with hdiff | hyi
    · exfalso
      apply h3
      linarith
    · exact hyi
  exfalso
  apply hx
  rw [hxy, ha, hb, hy0]
  simp

theorem population_second_eigenvector_eq_smul {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p)
    {x : Fin (2 * k) → ℝ}
    (heig : (population k θ.p θ.q).mulVec x =
      ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) • x) :
    ∃ b : ℝ, x = b • communitySign k := by
  let l1 : ℝ := (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p
  let l2 : ℝ := (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p
  let l3 : ℝ := -(θ.p : ℝ)
  obtain ⟨a, b, y, hxy, hy, hyEig⟩ :=
    exists_population_decomposition hk θ hpq x
  have heq := heig
  rw [hxy, Matrix.mulVec_add, Matrix.mulVec_add, Matrix.mulVec_smul,
    Matrix.mulVec_smul, population_mulVec_allOnes hk θ hpq,
    population_mulVec_communitySign hk θ hpq, hyEig] at heq
  have hsum0 := congrArg
    (fun z : Fin (2 * k) → ℝ => ∑ t : Fin k, z (indexEquiv k (0, t))) heq
  have hsum1 := congrArg
    (fun z : Fin (2 * k) → ℝ => ∑ t : Fin k, z (indexEquiv k (1, t))) heq
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    Finset.sum_add_distrib, ← Finset.mul_sum, hy 0, hy 1, mul_zero,
    allOnes, communitySign, Function.comp_apply, Equiv.symm_apply_apply,
    NumStability.HDP.Graph.StochasticBlock.allOnes, Function.const_apply,
    NumStability.HDP.Graph.StochasticBlock.communitySign,
    Fin.isValue, if_pos, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul] at hsum0 hsum1
  norm_num at hsum1
  have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hk)
  have he0 :
      (a * l1 + b * l2) * (k : ℝ) = l2 * (a + b) * (k : ℝ) := by
    convert hsum0 using 1 <;> dsimp [l1, l2] <;> ring
  have he1 :
      (a * l1 - b * l2) * (k : ℝ) = l2 * (a - b) * (k : ℝ) := by
    convert hsum1 using 1 <;> dsimp [l1, l2] <;> ring
  have he0' := mul_right_cancel₀ hkR he0
  have he1' := mul_right_cancel₀ hkR he1
  have haProd : a * (l1 - l2) = 0 := by
    nlinarith [he0', he1']
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hl12 : l1 - l2 ≠ 0 := by
    apply ne_of_gt
    calc
      0 < 2 * (k : ℝ) * (θ.q : ℝ) := by positivity
      _ = l1 - l2 := by dsimp [l1, l2]; ring
  have ha : a = 0 := (mul_eq_zero.mp haProd).resolve_right hl12
  have hy0 : y = 0 := by
    apply funext
    intro i
    have hi := congrFun heq i
    rw [ha] at hi
    simp only [zero_smul, zero_add, Pi.add_apply, Pi.smul_apply,
      smul_eq_mul] at hi
    have hprod : (l3 - l2) * y i = 0 := by
      dsimp [l2, l3]
      nlinarith
    have hl32 : l3 - l2 ≠ 0 := by
      have hdiff : 0 < (θ.p : ℝ) - θ.q := sub_pos.mpr hpqR
      have hpos : 0 < l2 - l3 := by
        calc
          0 < (k : ℝ) * ((θ.p : ℝ) - θ.q) := by positivity
          _ = l2 - l3 := by dsimp [l2, l3]; ring
      exact sub_ne_zero.mpr (by linarith)
    exact (mul_eq_zero.mp hprod).resolve_left hl32
  refine ⟨b, ?_⟩
  rw [hxy, ha, hy0]
  simp

theorem population_top_eigenvector_eq_smul {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) {x : Fin (2 * k) → ℝ}
    (heig : (population k θ.p θ.q).mulVec x =
      ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) • x) :
    ∃ a : ℝ, x = a • allOnes k := by
  let l1 : ℝ := (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p
  let l2 : ℝ := (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p
  let l3 : ℝ := -(θ.p : ℝ)
  obtain ⟨a, b, y, hxy, hy, hyEig⟩ :=
    exists_population_decomposition hk θ hpq x
  have heq := heig
  rw [hxy, Matrix.mulVec_add, Matrix.mulVec_add, Matrix.mulVec_smul,
    Matrix.mulVec_smul, population_mulVec_allOnes hk θ hpq,
    population_mulVec_communitySign hk θ hpq, hyEig] at heq
  have hsum0 := congrArg
    (fun z : Fin (2 * k) → ℝ => ∑ t : Fin k, z (indexEquiv k (0, t))) heq
  have hsum1 := congrArg
    (fun z : Fin (2 * k) → ℝ => ∑ t : Fin k, z (indexEquiv k (1, t))) heq
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    Finset.sum_add_distrib, ← Finset.mul_sum, hy 0, hy 1, mul_zero,
    allOnes, communitySign, Function.comp_apply, Equiv.symm_apply_apply,
    NumStability.HDP.Graph.StochasticBlock.allOnes, Function.const_apply,
    NumStability.HDP.Graph.StochasticBlock.communitySign,
    Fin.isValue, if_pos, Finset.sum_const, Finset.card_univ, Fintype.card_fin,
    nsmul_eq_mul] at hsum0 hsum1
  norm_num at hsum1
  have hkR : (k : ℝ) ≠ 0 := by exact_mod_cast (ne_of_gt hk)
  have he0 :
      (a * l1 + b * l2) * (k : ℝ) = l1 * (a + b) * (k : ℝ) := by
    convert hsum0 using 1 <;> dsimp [l1, l2] <;> ring
  have he1 :
      (a * l1 - b * l2) * (k : ℝ) = l1 * (a - b) * (k : ℝ) := by
    convert hsum1 using 1 <;> dsimp [l1, l2] <;> ring
  have he0' := mul_right_cancel₀ hkR he0
  have he1' := mul_right_cancel₀ hkR he1
  have hbProd : b * (l2 - l1) = 0 := by
    nlinarith [he0', he1']
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hl21 : l2 - l1 ≠ 0 := by
    have hpos : 0 < l1 - l2 := by
      calc
        0 < 2 * (k : ℝ) * (θ.q : ℝ) := by positivity
        _ = l1 - l2 := by dsimp [l1, l2]; ring
    exact sub_ne_zero.mpr (by linarith)
  have hb : b = 0 := (mul_eq_zero.mp hbProd).resolve_right hl21
  have hy0 : y = 0 := by
    apply funext
    intro i
    have hi := congrFun heq i
    rw [hb] at hi
    simp only [zero_smul, add_zero, Pi.add_apply, Pi.smul_apply,
      smul_eq_mul] at hi
    have hprod : (l3 - l1) * y i = 0 := by
      dsimp [l1, l3]
      nlinarith
    have hl31 : l3 - l1 ≠ 0 := by
      have hpos : 0 < l1 - l3 := by
        calc
          0 < (k : ℝ) * ((θ.p : ℝ) + θ.q) := by positivity
          _ = l1 - l3 := by dsimp [l1, l3]; ring
      exact sub_ne_zero.mpr (by linarith)
    exact (mul_eq_zero.mp hprod).resolve_left hl31
  refine ⟨a, ?_⟩
  rw [hxy, hb, hy0]
  simp

private theorem allOnes_ne_zero {k : ℕ} (hk : 0 < k) : allOnes k ≠ 0 := by
  intro h
  have hi := congrFun h (indexEquiv k (0, (⟨0, hk⟩ : Fin k)))
  simp [allOnes, NumStability.HDP.Graph.StochasticBlock.allOnes] at hi

private theorem communitySign_ne_zero {k : ℕ} (hk : 0 < k) :
    communitySign k ≠ 0 := by
  intro h
  have hi := congrFun h (indexEquiv k (0, (⟨0, hk⟩ : Fin k)))
  simp [communitySign,
    NumStability.HDP.Graph.StochasticBlock.communitySign] at hi

theorem exists_orderedEigenvalue_eq_top {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    ∃ i : Fin (2 * k),
      NumStability.hermitianOrderedEigenvalue
          (population_hermitian k θ.p θ.q) i =
        (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p := by
  let D := population k θ.p θ.q
  let hD := population_hermitian k θ.p θ.q
  letI : NeZero (2 * k) := ⟨by omega⟩
  let u : EuclideanSpace ℝ (Fin (2 * k)) :=
    (EuclideanSpace.equiv (Fin (2 * k)) ℝ).symm (allOnes k)
  have hu0 : u ≠ 0 := by
    intro hu
    apply allOnes_ne_zero hk
    simpa [u] using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) hu
  have huEig : D.toEuclideanLin u =
      ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) • u := by
    apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
    simpa [D, u] using population_mulVec_allOnes hk θ hpq
  have hval : Module.End.HasEigenvalue D.toEuclideanLin
      ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) := by
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨Module.End.mem_eigenspace_iff.mpr huEig, hu0⟩
  have hmem := hval.mem_spectrum
  rw [NumStability.spectrum_eq_range_hermitianOrderedEigenvalue hD] at hmem
  simpa [hD] using hmem

theorem exists_orderedEigenvalue_eq_second {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    ∃ i : Fin (2 * k),
      NumStability.hermitianOrderedEigenvalue
          (population_hermitian k θ.p θ.q) i =
        (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p := by
  let D := population k θ.p θ.q
  let hD := population_hermitian k θ.p θ.q
  let u : EuclideanSpace ℝ (Fin (2 * k)) :=
    (EuclideanSpace.equiv (Fin (2 * k)) ℝ).symm (communitySign k)
  have hu0 : u ≠ 0 := by
    intro hu
    apply communitySign_ne_zero hk
    simpa [u] using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) hu
  have huEig : D.toEuclideanLin u =
      ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) • u := by
    apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
    simpa [D, u] using population_mulVec_communitySign hk θ hpq
  have hval : Module.End.HasEigenvalue D.toEuclideanLin
      ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) := by
    apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    exact ⟨Module.End.mem_eigenspace_iff.mpr huEig, hu0⟩
  have hmem := hval.mem_spectrum
  rw [NumStability.spectrum_eq_range_hermitianOrderedEigenvalue hD] at hmem
  simpa [hD] using hmem

theorem orderedEigenvalue_zero_eq_top {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) :
    NumStability.hermitianOrderedEigenvalue
        (population_hermitian k θ.p θ.q) ⟨0, by omega⟩ =
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p := by
  let hD := population_hermitian k θ.p θ.q
  letI : NeZero (2 * k) := ⟨by omega⟩
  let e0 : Fin (2 * k) := ⟨0, by omega⟩
  obtain ⟨itop, hitop⟩ := exists_orderedEigenvalue_eq_top hk θ hpq
  have hb0 : NumStability.hermitianOrderedEigenbasis hD e0 ≠ 0 :=
    (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero e0
  have hb0raw :
      (NumStability.hermitianOrderedEigenbasis hD e0).ofLp ≠ 0 := by
    intro hraw
    apply hb0
    apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
    simpa using hraw
  have heig0 : (population k θ.p θ.q).mulVec
      (NumStability.hermitianOrderedEigenbasis hD e0) =
        NumStability.hermitianOrderedEigenvalue hD e0 •
          NumStability.hermitianOrderedEigenbasis hD e0 := by
    have h := NumStability.hermitianOrderedEigenbasis_apply hD e0
    simpa using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
  have hcases := population_eigenvalue_cases hk θ hpq hb0raw heig0
  have htop_le_zero :
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ≤
        NumStability.hermitianOrderedEigenvalue hD e0 := by
    rw [← hitop]
    exact NumStability.hermitianOrderedEigenvalue_antitone hD (Fin.zero_le itop)
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  rcases hcases with h0 | h0 | h0
  · simpa [hD, e0] using h0
  · exfalso
    rw [h0] at htop_le_zero
    have hkR : (0 : ℝ) < k := by exact_mod_cast hk
    nlinarith [mul_pos hkR hqR]
  · exfalso
    rw [h0] at htop_le_zero
    have hkR : (0 : ℝ) < k := by exact_mod_cast hk
    have hp : 0 < (θ.p : ℝ) := lt_trans hqR hpqR
    nlinarith [mul_pos hkR (add_pos hp hqR)]

theorem orderedEigenvalue_one_eq_second {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) :
    NumStability.hermitianOrderedEigenvalue
        (population_hermitian k θ.p θ.q) ⟨1, by omega⟩ =
      (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p := by
  let hD := population_hermitian k θ.p θ.q
  let e0 : Fin (2 * k) := ⟨0, by omega⟩
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  have hzero := orderedEigenvalue_zero_eq_top hk θ hq hpq
  have hb1 : NumStability.hermitianOrderedEigenbasis hD e1 ≠ 0 :=
    (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero e1
  have hb1raw :
      (NumStability.hermitianOrderedEigenbasis hD e1).ofLp ≠ 0 := by
    intro hraw
    apply hb1
    apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
    simpa using hraw
  have heig1 : (population k θ.p θ.q).mulVec
      (NumStability.hermitianOrderedEigenbasis hD e1) =
        NumStability.hermitianOrderedEigenvalue hD e1 •
          NumStability.hermitianOrderedEigenbasis hD e1 := by
    have h := NumStability.hermitianOrderedEigenbasis_apply hD e1
    simpa using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
  have hcases := population_eigenvalue_cases hk θ hpq hb1raw heig1
  have hnotTop : NumStability.hermitianOrderedEigenvalue hD e1 ≠
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p := by
    intro heqTop
    have heig0 : (population k θ.p θ.q).mulVec
        (NumStability.hermitianOrderedEigenbasis hD e0) =
          ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) •
            NumStability.hermitianOrderedEigenbasis hD e0 := by
      have h := NumStability.hermitianOrderedEigenbasis_apply hD e0
      simpa [hD, e0, hzero] using
        congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
    have heig1Top : (population k θ.p θ.q).mulVec
        (NumStability.hermitianOrderedEigenbasis hD e1) =
          ((k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p) •
            NumStability.hermitianOrderedEigenbasis hD e1 := by
      simpa [heqTop] using heig1
    obtain ⟨a0, ha0⟩ := population_top_eigenvector_eq_smul hk θ hq hpq heig0
    obtain ⟨a1, ha1⟩ := population_top_eigenvector_eq_smul hk θ hq hpq heig1Top
    let u : EuclideanSpace ℝ (Fin (2 * k)) :=
      (EuclideanSpace.equiv (Fin (2 * k)) ℝ).symm (allOnes k)
    have ha0E : NumStability.hermitianOrderedEigenbasis hD e0 = a0 • u := by
      apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
      simpa [u] using ha0
    have ha1E : NumStability.hermitianOrderedEigenbasis hD e1 = a1 • u := by
      apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
      simpa [u] using ha1
    have ha0nz : a0 ≠ 0 := by
      intro ha0z
      apply (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero e0
      rw [ha0E, ha0z, zero_smul]
    have ha1nz : a1 ≠ 0 := by
      intro ha1z
      apply (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero e1
      rw [ha1E, ha1z, zero_smul]
    have hu0 : u ≠ 0 := by
      intro hu
      apply allOnes_ne_zero hk
      simpa [u] using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) hu
    have horth := (NumStability.hermitianOrderedEigenbasis hD).orthonormal.inner_eq_zero
      (show e0 ≠ e1 by simp [e0, e1])
    rw [ha0E, ha1E, inner_smul_left, inner_smul_right] at horth
    exact (mul_ne_zero (mul_ne_zero ha0nz ha1nz)
      (inner_self_ne_zero.mpr hu0)) (by simpa [mul_assoc] using horth)
  rcases hcases with h1 | h1 | h1
  · exact (hnotTop h1).elim
  · simpa [hD, e1] using h1
  · exfalso
    obtain ⟨isecond, hisecond⟩ := exists_orderedEigenvalue_eq_second hk θ hpq
    have hisecond0 : isecond ≠ e0 := by
      intro hi
      subst isecond
      rw [hzero] at hisecond
      have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
      have hkR : (0 : ℝ) < k := by exact_mod_cast hk
      nlinarith [mul_pos hkR hqR]
    have hisecondVal : isecond.val ≠ 0 := by
      intro hval
      apply hisecond0
      apply Fin.ext
      simpa [e0] using hval
    have he1le : e1 ≤ isecond := by
      change 1 ≤ isecond.val
      omega
    have hsecond_le_one :=
      NumStability.hermitianOrderedEigenvalue_antitone hD he1le
    rw [hisecond, h1] at hsecond_le_one
    have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
    have hkR : (0 : ℝ) < k := by exact_mod_cast hk
    nlinarith [mul_pos hkR (sub_pos.mpr hpqR)]

theorem orderedEigenvalue_eq_second_iff {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) (j : Fin (2 * k)) :
    NumStability.hermitianOrderedEigenvalue
        (population_hermitian k θ.p θ.q) j =
        (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ↔
      j = ⟨1, by omega⟩ := by
  let hD := population_hermitian k θ.p θ.q
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  constructor
  · intro hjEig
    by_contra hje1
    have heigj : (population k θ.p θ.q).mulVec
        (NumStability.hermitianOrderedEigenbasis hD j) =
          ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
            NumStability.hermitianOrderedEigenbasis hD j := by
      have h := NumStability.hermitianOrderedEigenbasis_apply hD j
      simpa [hjEig] using
        congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
    have heig1 : (population k θ.p θ.q).mulVec
        (NumStability.hermitianOrderedEigenbasis hD e1) =
          ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
            NumStability.hermitianOrderedEigenbasis hD e1 := by
      have h := NumStability.hermitianOrderedEigenbasis_apply hD e1
      simpa [hD, e1, orderedEigenvalue_one_eq_second hk θ hq hpq] using
        congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
    obtain ⟨bj, hbj⟩ := population_second_eigenvector_eq_smul hk θ hq hpq heigj
    obtain ⟨b1, hb1⟩ := population_second_eigenvector_eq_smul hk θ hq hpq heig1
    let u : EuclideanSpace ℝ (Fin (2 * k)) :=
      (EuclideanSpace.equiv (Fin (2 * k)) ℝ).symm (communitySign k)
    have hbjE : NumStability.hermitianOrderedEigenbasis hD j = bj • u := by
      apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
      simpa [u] using hbj
    have hb1E : NumStability.hermitianOrderedEigenbasis hD e1 = b1 • u := by
      apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
      simpa [u] using hb1
    have hbjnz : bj ≠ 0 := by
      intro hbj0
      apply (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero j
      rw [hbjE, hbj0, zero_smul]
    have hb1nz : b1 ≠ 0 := by
      intro hb10
      apply (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero e1
      rw [hb1E, hb10, zero_smul]
    have hu0 : u ≠ 0 := by
      intro hu
      apply communitySign_ne_zero hk
      simpa [u] using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) hu
    have horth := (NumStability.hermitianOrderedEigenbasis hD).orthonormal.inner_eq_zero
      (show j ≠ e1 by simpa [e1] using hje1)
    rw [hbjE, hb1E, inner_smul_left, inner_smul_right] at horth
    exact (mul_ne_zero (mul_ne_zero hbjnz hb1nz)
      (inner_self_ne_zero.mpr hu0)) (by simpa [mul_assoc] using horth)
  · intro hj
    subst j
    simpa [e1] using orderedEigenvalue_one_eq_second hk θ hq hpq

theorem population_second_eigengap {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) :
    ∀ j : Fin (2 * k), j ≠ ⟨1, by omega⟩ →
      min (((θ.p : ℝ) - θ.q) / 2) θ.q * ((2 * k : ℕ) : ℝ) ≤
        |NumStability.hermitianOrderedEigenvalue
            (population_hermitian k θ.p θ.q) ⟨1, by omega⟩ -
          NumStability.hermitianOrderedEigenvalue
            (population_hermitian k θ.p θ.q) j| := by
  let hD := population_hermitian k θ.p θ.q
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  intro j hj
  have hbj : NumStability.hermitianOrderedEigenbasis hD j ≠ 0 :=
    (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero j
  have hbjraw : (NumStability.hermitianOrderedEigenbasis hD j).ofLp ≠ 0 := by
    intro hraw
    apply hbj
    apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
    simpa using hraw
  have heigj : (population k θ.p θ.q).mulVec
      (NumStability.hermitianOrderedEigenbasis hD j) =
        NumStability.hermitianOrderedEigenvalue hD j •
          NumStability.hermitianOrderedEigenbasis hD j := by
    have h := NumStability.hermitianOrderedEigenbasis_apply hD j
    simpa using congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
  have hcases := population_eigenvalue_cases hk θ hpq hbjraw heigj
  have hone := orderedEigenvalue_one_eq_second hk θ hq hpq
  have hn0 : (0 : ℝ) ≤ ((2 * k : ℕ) : ℝ) := by positivity
  have hpqR : (θ.q : ℝ) < θ.p := by exact_mod_cast hpq
  have hqR : (0 : ℝ) < θ.q := by exact_mod_cast hq
  have hkR : (0 : ℝ) < k := by exact_mod_cast hk
  rcases hcases with hjTop | hjSecond | hjBottom
  · rw [hone, hjTop]
    have hmin : min (((θ.p : ℝ) - θ.q) / 2) θ.q ≤ θ.q := min_le_right _ _
    have hmul := mul_le_mul_of_nonneg_right hmin hn0
    rw [abs_of_nonpos]
    · push_cast at hmul ⊢
      nlinarith
    · nlinarith [mul_pos hkR hqR]

  · exact (hj ((orderedEigenvalue_eq_second_iff hk θ hq hpq j).mp hjSecond)).elim
  · rw [hone, hjBottom]
    have hmin : min (((θ.p : ℝ) - θ.q) / 2) θ.q ≤
        ((θ.p : ℝ) - θ.q) / 2 := min_le_left _ _
    have hmul := mul_le_mul_of_nonneg_right hmin hn0
    rw [abs_of_nonneg]
    · push_cast at hmul ⊢
      nlinarith
    · nlinarith [mul_pos hkR (sub_pos.mpr hpqR)]


theorem population_second_eigenbasis_scaled_abs {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) :
    ∀ i : Fin (2 * k),
      |(Real.sqrt (2 * k : ℕ) •
        NumStability.hermitianOrderedEigenbasis
          (population_hermitian k θ.p θ.q) ⟨1, by omega⟩) i| = 1 := by
  let hD := population_hermitian k θ.p θ.q
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  have heig1 : (population k θ.p θ.q).mulVec
      (NumStability.hermitianOrderedEigenbasis hD e1) =
        ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
          NumStability.hermitianOrderedEigenbasis hD e1 := by
    have h := NumStability.hermitianOrderedEigenbasis_apply hD e1
    simpa [hD, e1, orderedEigenvalue_one_eq_second hk θ hq hpq] using
      congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
  obtain ⟨b, hb⟩ :=
    population_second_eigenvector_eq_smul hk θ hq hpq heig1
  let u : EuclideanSpace ℝ (Fin (2 * k)) :=
    (EuclideanSpace.equiv (Fin (2 * k)) ℝ).symm (communitySign k)
  have hbE : NumStability.hermitianOrderedEigenbasis hD e1 = b • u := by
    apply (EuclideanSpace.equiv (Fin (2 * k)) ℝ).injective
    simpa [u] using hb
  have huNormSq : ‖u‖ ^ 2 = ((2 * k : ℕ) : ℝ) := by
    rw [EuclideanSpace.norm_sq_eq]
    calc
      ∑ i : Fin (2 * k), ‖u.ofLp i‖ ^ 2 =
          ∑ _i : Fin (2 * k), (1 : ℝ) := by
            apply Finset.sum_congr rfl
            intro i _
            by_cases hc : ((indexEquiv k).symm i).1 = 0
            · simp [u, communitySign,
                NumStability.HDP.Graph.StochasticBlock.communitySign, hc]
            · simp [u, communitySign,
                NumStability.HDP.Graph.StochasticBlock.communitySign, hc]
      _ = ((2 * k : ℕ) : ℝ) := by simp
  have huNorm : ‖u‖ = Real.sqrt ((2 * k : ℕ) : ℝ) := by
    have hsqrt := Real.sq_sqrt (show (0 : ℝ) ≤ ((2 * k : ℕ) : ℝ) by positivity)
    nlinarith [norm_nonneg u, Real.sqrt_nonneg ((2 * k : ℕ) : ℝ)]
  have hbasisNorm :
      ‖NumStability.hermitianOrderedEigenbasis hD e1‖ = 1 :=
    (NumStability.hermitianOrderedEigenbasis hD).norm_eq_one e1
  have hcoef : |b| * Real.sqrt ((2 * k : ℕ) : ℝ) = 1 := by
    rw [hbE, norm_smul, Real.norm_eq_abs, huNorm] at hbasisNorm
    exact hbasisNorm
  intro i
  change |Real.sqrt ((2 * k : ℕ) : ℝ) *
      (NumStability.hermitianOrderedEigenbasis hD e1).ofLp i| = 1
  have hbi := congrFun hb i
  rw [hbi]
  simp only [Pi.smul_apply, smul_eq_mul, abs_mul]
  have habs : |communitySign k i| = 1 := by
    simpa [communitySign] using
      NumStability.HDP.Graph.StochasticBlock.abs_communitySign k
        ((indexEquiv k).symm i)
  rw [abs_of_nonneg (Real.sqrt_nonneg _), habs]
  nlinarith

/-- The normalized ordered second population eigenvector is the balanced
community-sign vector, up to the unavoidable global sign ambiguity of an
eigenbasis. -/
theorem exists_population_second_eigenbasis_sign {k : ℕ} (hk : 0 < k)
    (θ : NumStability.HDP.Graph.StochasticBlock.Parameters) (hq : 0 < θ.q)
    (hpq : θ.q < θ.p) :
    ∃ ρ : ℝ, (ρ = -1 ∨ ρ = 1) ∧
      Real.sqrt (2 * k : ℕ) •
          NumStability.hermitianOrderedEigenbasis
            (population_hermitian k θ.p θ.q) ⟨1, by omega⟩ =
        ρ • communitySign k := by
  let hD := population_hermitian k θ.p θ.q
  let e1 : Fin (2 * k) := ⟨1, by omega⟩
  have heig1 : (population k θ.p θ.q).mulVec
      (NumStability.hermitianOrderedEigenbasis hD e1) =
        ((k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p) •
          NumStability.hermitianOrderedEigenbasis hD e1 := by
    have h := NumStability.hermitianOrderedEigenbasis_apply hD e1
    simpa [hD, e1, orderedEigenvalue_one_eq_second hk θ hq hpq] using
      congrArg (EuclideanSpace.equiv (Fin (2 * k)) ℝ) h
  obtain ⟨b, hb⟩ :=
    population_second_eigenvector_eq_smul hk θ hq hpq heig1
  let ρ : ℝ := Real.sqrt (2 * k : ℕ) * b
  let i0 : Fin (2 * k) := indexEquiv k (0, ⟨0, hk⟩)
  have hi0 : communitySign k i0 = 1 := by
    simp [i0, communitySign,
      NumStability.HDP.Graph.StochasticBlock.communitySign]
  have habs := population_second_eigenbasis_scaled_abs hk θ hq hpq i0
  have hρabs : |ρ| = 1 := by
    change |Real.sqrt ((2 * k : ℕ) : ℝ) * b| = 1
    change |Real.sqrt ((2 * k : ℕ) : ℝ) *
      (NumStability.hermitianOrderedEigenbasis hD e1).ofLp i0| = 1 at habs
    rw [congrFun hb i0] at habs
    simp only [Pi.smul_apply, smul_eq_mul, hi0, mul_one] at habs
    simpa using habs
  have hρ : ρ = -1 ∨ ρ = 1 := by
    rcases (abs_eq (by norm_num : (0 : ℝ) ≤ 1)).mp hρabs with h | h
    · exact Or.inr h
    · exact Or.inl h
  refine ⟨ρ, hρ, ?_⟩
  funext i
  change Real.sqrt ((2 * k : ℕ) : ℝ) *
      (NumStability.hermitianOrderedEigenbasis hD e1).ofLp i =
    ρ * communitySign k i
  rw [congrFun hb i]
  simp [ρ, mul_assoc]

end NumStability.HDP.Contract.BalancedFinSBM
