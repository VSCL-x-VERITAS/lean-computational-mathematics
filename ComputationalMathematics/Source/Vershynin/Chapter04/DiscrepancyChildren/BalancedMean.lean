import ComputationalMathematics.HDP.Matrix.ReindexSpectral
import ComputationalMathematics.HDP.Graph.BalancedCommunityEquivalence
import ComputationalMathematics.HDP.Graph.CommunityZeroSumKernel
import ComputationalMathematics.Source.Vershynin.Chapter04.BalancedFinSBM
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.ActualSpectrum
import ComputationalMathematics.Source.Vershynin.Chapter04.Equation417LooplessFullCorrection.Q0FinIndexedGap

/-!
# Balanced displayed and loopless mean spectra

These source-model results support the separately specified analyst-derived
children of the printed stochastic-block claims.
-/

noncomputable section

set_option maxHeartbeats 1000000
set_option backward.isDefEq.respectTransparency false

open Matrix MeasureTheory
open NumStability.HDP.Graph

namespace NumStability.HDP.Contract.DiscrepancyChildren.BalancedMean

private theorem ordered_congr {n : ℕ} {A B : Matrix (Fin n) (Fin n) ℝ}
    (hA : A.IsHermitian) (hB : B.IsHermitian) (h : A = B) :
    NumStability.hermitianOrderedEigenvalue hA = NumStability.hermitianOrderedEigenvalue hB := by
  subst B
  rfl

/-- The displayed block-constant matrix, including its within-community diagonal. -/
def block {n : ℕ} (c : Fin n → Fin 2) (p q : ℝ) :
    Matrix (Fin n) (Fin n) ℝ := fun i j => if c i = c j then p else q

/-- A balanced labeling identifies both displayed and loopless matrices with their community-indexed forms. -/
theorem balanced_reindex {k : ℕ} (c : Fin (2*k) → Fin 2)
    (hc : ∀ b : Fin 2, Fintype.card {i // c i = b} = k) (p q : ℝ) :
    ∃ e : StochasticBlock.Vertex k ≃ Fin (2*k),
      (∀ v, c (e v) = v.1) ∧
      block c p q = Matrix.reindex e e (StochasticBlock.expectedAdjacency k p q) ∧
      FinStochasticBlock.expectedAdjacency c p q =
        Matrix.reindex e e (looplessExpectedAdjacency k p q) := by
  obtain ⟨d, hd⟩ := exists_balancedCommunityEquiv hc
  refine ⟨d.symm, ?_, ?_, ?_⟩
  · intro v
    simpa using (hd (d.symm v)).symm
  · ext i j
    simp [block, Matrix.reindex_apply, StochasticBlock.expectedAdjacency, hd]
  · ext i j
    simp [FinStochasticBlock.expectedAdjacency, Matrix.reindex_apply,
      looplessExpectedAdjacency, hd, d.injective.eq_iff]

private theorem mean_eq_block_sub {n : ℕ} (c : Fin n → Fin 2) (p q : ℝ) :
    FinStochasticBlock.expectedAdjacency c p q = block c p q - p • 1 := by
  ext i j
  by_cases h : i = j <;> simp [FinStochasticBlock.expectedAdjacency, block, h]

/-- The displayed block matrix is real Hermitian. -/
theorem block_hermitian {n : ℕ} (c : Fin n → Fin 2) (p q : ℝ) :
    (block c p q).IsHermitian := by
  ext i j
  simp [block, Matrix.conjTranspose_apply, eq_comm]

/-- The actual loopless mean matrix is real Hermitian. -/
theorem mean_hermitian {n : ℕ} (c : Fin n → Fin 2) (p q : ℝ) :
    (FinStochasticBlock.expectedAdjacency c p q).IsHermitian := by
  ext i j
  simp [FinStochasticBlock.expectedAdjacency, Matrix.conjTranspose_apply, eq_comm]

private theorem canonical_mean_ordered {k : ℕ} (hk : 0 < k)
    (θ : StochasticBlock.Parameters) (hpq : θ.q < θ.p) :
    let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
    NumStability.hermitianOrderedEigenvalue hD ⟨0, by omega⟩ =
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
    NumStability.hermitianOrderedEigenvalue hD ⟨1, by omega⟩ =
      (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∧
    ∀ j : Fin (2*k), 2 ≤ j.val → NumStability.hermitianOrderedEigenvalue hD j = -(θ.p : ℝ) := by
  classical
  dsimp only
  let hD := BalancedFinSBM.population_hermitian k θ.p θ.q
  let f := NumStability.hermitianOrderedEigenvalue hD
  let e0 : Fin (2*k) := ⟨0, by omega⟩
  let e1 : Fin (2*k) := ⟨1, by omega⟩
  have hkR : (0 : ℝ) < k := by exact_mod_cast hk
  have hpqR : (θ.q : ℝ) < θ.p := hpq
  have hqR : (0 : ℝ) ≤ θ.q := θ.q.coe_nonneg
  have hcases (i : Fin (2*k)) :
      f i = (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∨
      f i = (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∨ f i = -(θ.p : ℝ) := by
    apply BalancedFinSBM.population_eigenvalue_cases hk θ hpq
      (x := (NumStability.hermitianOrderedEigenbasis hD i).ofLp)
    · intro hz
      exact (NumStability.hermitianOrderedEigenbasis hD).orthonormal.ne_zero i
        ((WithLp.ofLp_injective 2) hz)
    · exact congrArg (WithLp.ofLp) (NumStability.hermitianOrderedEigenbasis_apply hD i)
  letI : NeZero (2*k) := ⟨by omega⟩
  have h0 : f e0 = (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p := by
    obtain ⟨i, hi⟩ := BalancedFinSBM.exists_orderedEigenvalue_eq_top hk θ hpq
    have hb : (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ≤ f e0 := by
      rw [← hi]
      exact NumStability.hermitianOrderedEigenvalue_antitone hD (Fin.zero_le i)
    rcases hcases e0 with h | h | h
    · exact h
    · have hnonneg := mul_nonneg hkR.le hqR
      nlinarith
    · nlinarith [mul_pos hkR (show (0 : ℝ) < (θ.p : ℝ) + θ.q by linarith)]
  have h1 : f e1 = (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p := by
    by_cases hq : θ.q = 0
    · have heq := ordinary_q0_fin_ordered_top_eq_second_candidate hk θ hpq hq
      change f e0 = f e1 at heq
      rw [← heq, h0]
      simp [hq]
    · exact BalancedFinSBM.orderedEigenvalue_one_eq_second hk θ (pos_iff_ne_zero.mpr hq) hpq
  refine ⟨h0, h1, ?_⟩
  have hdim : Module.finrank ℝ (Module.End.eigenspace
      (BalancedFinSBM.population k θ.p θ.q).mulVecLin (-(θ.p : ℝ))) = 2*k-2 := by
    rw [BalancedFinSBM.population, NumStability.HDP.Matrix.finrank_eigenspace_reindex,
      looplessExpectedAdjacency_eq_displayed_sub_diagonal]
    exact StochasticBlock.finrank_expectedAdjacency_sub_diagonal_eigenspace hk hqR hpqR
  have hcount : (Finset.univ.filter fun i => f i = -(θ.p : ℝ)).card = 2*k-2 := by
    rw [show (Finset.univ.filter fun i => f i = -(θ.p : ℝ)).card =
      Module.finrank ℝ (Module.End.eigenspace
        (BalancedFinSBM.population k θ.p θ.q).mulVecLin (-(θ.p : ℝ))) from ?_, hdim]
    exact (NumStability.card_filter_symmetric_eigenvalues_eq_finrank
      (Matrix.isHermitian_iff_isSymmetric.mp hD) finrank_euclideanSpace_fin _).trans
      (NumStability.finrank_eigenspace_toEuclideanLin_eq_mulVecLin _ _)
  have h0ne : f e0 ≠ -(θ.p : ℝ) := by
    rw [h0]; nlinarith [mul_pos hkR (show (0 : ℝ) < (θ.p : ℝ) + θ.q by linarith)]
  have h1ne : f e1 ≠ -(θ.p : ℝ) := by
    rw [h1]; nlinarith [mul_pos hkR (sub_pos.mpr hpqR)]
  have hsub : (Finset.univ.filter fun i => f i = -(θ.p : ℝ)) ⊆
      (Finset.univ.erase e0).erase e1 := by
    intro i hi
    have heq := (Finset.mem_filter.mp hi).2
    simp only [Finset.mem_erase, Finset.mem_univ, and_true]
    exact ⟨fun h => h1ne (h ▸ heq), fun h => h0ne (h ▸ heq)⟩
  have heq : (Finset.univ.filter fun i => f i = -(θ.p : ℝ)) =
      (Finset.univ.erase e0).erase e1 := by
    apply Finset.eq_of_subset_of_card_le hsub
    rw [hcount]
    simp [Finset.card_erase_of_mem, e0, e1]
    omega
  intro j hj
  have hjmem : j ∈ (Finset.univ.erase e0).erase e1 := by
    simp only [Finset.mem_erase, Finset.mem_univ, and_true]
    constructor
    · intro h; have hv : j.val = 1 := congrArg Fin.val h; omega
    · intro h; have hv : j.val = 0 := congrArg Fin.val h; omega
  rw [← heq] at hjmem
  exact (Finset.mem_filter.mp hjmem).2

/-- The complete decreasing loopless mean spectrum for every balanced labeling, including q = 0 and singleton communities. -/
theorem balanced_mean_ordered {k : ℕ} (hk : 0 < k) (θ : StochasticBlock.Parameters)
    (c : Fin (2*k) → Fin 2) (hc : ∀ b : Fin 2, Fintype.card {i // c i = b} = k)
    (hpq : θ.q < θ.p) :
    let hM := mean_hermitian c (θ.p : ℝ) (θ.q : ℝ)
    NumStability.hermitianOrderedEigenvalue hM ⟨0, by omega⟩ =
      (k : ℝ) * ((θ.p : ℝ) + θ.q) - θ.p ∧
    NumStability.hermitianOrderedEigenvalue hM ⟨1, by omega⟩ =
      (k : ℝ) * ((θ.p : ℝ) - θ.q) - θ.p ∧
    ∀ j : Fin (2*k), 2 ≤ j.val → NumStability.hermitianOrderedEigenvalue hM j = -(θ.p : ℝ) := by
  obtain ⟨e, he⟩ := exists_balancedCommunityIndexEquiv hc
  have hM : FinStochasticBlock.expectedAdjacency c θ.p θ.q =
      Matrix.reindex e.symm e.symm (BalancedFinSBM.population k θ.p θ.q) := by
    ext i j
    have hi : BalancedFinSBM.community k (e i) = c i := he i
    have hj : BalancedFinSBM.community k (e j) = c j := he j
    simp only [← BalancedFinSBM.expectedAdjacency_eq_population,
      Matrix.reindex_apply, Matrix.submatrix_apply, Equiv.symm_symm,
      FinStochasticBlock.expectedAdjacency, hi, hj, e.injective.eq_iff]
  have hR : (Matrix.reindex e.symm e.symm
      (BalancedFinSBM.population k θ.p θ.q)).IsHermitian := by
    rw [← hM]; exact mean_hermitian _ _ _
  have h := NumStability.HDP.Matrix.hermitianOrderedEigenvalue_reindex e.symm _ (BalancedFinSBM.population_hermitian k θ.p θ.q) hR
  have h' : NumStability.hermitianOrderedEigenvalue (mean_hermitian c θ.p θ.q) =
      NumStability.hermitianOrderedEigenvalue (BalancedFinSBM.population_hermitian k θ.p θ.q) := by
    exact (ordered_congr (mean_hermitian c θ.p θ.q) hR hM).trans h
  dsimp only
  rw [h']
  exact canonical_mean_ordered hk θ hpq

/-- Removing the displayed p-diagonal subtracts p from every ordered eigenvalue, with multiplicities preserved. -/
theorem block_mean_ordered_shift {n : ℕ} (c : Fin n → Fin 2) (p q : ℝ) :
    ∀ j : Fin n, NumStability.hermitianOrderedEigenvalue (mean_hermitian c p q) j =
      NumStability.hermitianOrderedEigenvalue (block_hermitian c p q) j - p := by
  let hM := mean_hermitian c p q
  let hB := block_hermitian c p q
  let b := NumStability.hermitianOrderedEigenbasis hM
  let f := NumStability.hermitianOrderedEigenvalue hM
  have hBM : block c p q = FinStochasticBlock.expectedAdjacency c p q + p • 1 := by
    rw [mean_eq_block_sub]; abel
  have h := NumStability.HDP.Matrix.antitone_eigenvalue_eq_ordered_of_eigenbasis hB
    (fun j => f j + p) b (fun i j hij => by
      have hh := NumStability.hermitianOrderedEigenvalue_antitone hM hij
      change f j + p ≤ f i + p
      change f j ≤ f i at hh
      linarith) (by
        intro j
        apply WithLp.ofLp_injective 2
        change (block c p q).mulVec (b j).ofLp = (f j + p) • (b j).ofLp
        have hm : (FinStochasticBlock.expectedAdjacency c p q).mulVec (b j).ofLp =
            f j • (b j).ofLp := congrArg WithLp.ofLp
              (NumStability.hermitianOrderedEigenbasis_apply hM j)
        rw [hBM, Matrix.add_mulVec, Matrix.smul_mulVec, Matrix.one_mulVec, hm, add_smul])
  intro j
  have hj := congrFun h j
  change f j + p = NumStability.hermitianOrderedEigenvalue hB j at hj
  change f j = NumStability.hermitianOrderedEigenvalue hB j - p
  linarith

end NumStability.HDP.Contract.DiscrepancyChildren.BalancedMean
