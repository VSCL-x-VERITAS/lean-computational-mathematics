import ComputationalMathematics.HDP.Optimization.GrothendieckHilbert
import ComputationalMathematics.HDP.Optimization.SemidefiniteRelaxation
import Mathlib.Data.Matrix.Block

/-!
# Bipartite Grothendieck optimization as a semidefinite program

This module supplies the block-matrix and Gram-matrix correspondence from
Exercise 3.5.7.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Optimization

variable {m n : ℕ}

/-- The symmetric block matrix with off-diagonal blocks `A` and `Aᵀ`. -/
def bipartiteBlockMatrix (A : Matrix (Fin m) (Fin n) ℝ) :
    Matrix (Sum (Fin m) (Fin n)) (Sum (Fin m) (Fin n)) ℝ :=
  Matrix.fromBlocks 0 A A.transpose 0

/-- Positive-semidefinite matrices with unit diagonal on an arbitrary finite
index type. -/
def IsCorrelationMatrixOn {ι : Type*} [Fintype ι]
    (M : Matrix ι ι ℝ) : Prop :=
  M.PosSemidef ∧ ∀ i, M i i = 1

/-- The Gram matrix obtained by concatenating the two unit-vector families. -/
def bipartiteUnitGram {E : Type*} [NormedAddCommGroup E]
    [InnerProductSpace ℝ E] (X : Fin m → E) (Y : Fin n → E) :
    Matrix (Sum (Fin m) (Fin n)) (Sum (Fin m) (Fin n)) ℝ :=
  Matrix.gram ℝ (Sum.elim X Y)

/-- The block SDP objective, including the source's factor `1/2`. -/
def bipartiteSemidefiniteValue (A : Matrix (Fin m) (Fin n) ℝ)
    (M : Matrix (Sum (Fin m) (Fin n)) (Sum (Fin m) (Fin n)) ℝ) : ℝ :=
  (2 : ℝ)⁻¹ * ∑ p, ∑ q, bipartiteBlockMatrix A p q * M p q

theorem bipartiteUnitGram_isCorrelationMatrixOn
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (X : Fin m → E) (Y : Fin n → E)
    (hX : ∀ i, ‖X i‖ = 1) (hY : ∀ j, ‖Y j‖ = 1) :
    IsCorrelationMatrixOn (bipartiteUnitGram X Y) := by
  constructor
  · exact Matrix.posSemidef_gram ℝ _
  · intro p
    rcases p with i | j
    · simp [bipartiteUnitGram, Matrix.gram_apply, hX i]
    · simp [bipartiteUnitGram, Matrix.gram_apply, hY j]

/-- On a concatenated Gram matrix, the factor-half block objective equals the
original bipartite vector objective. -/
theorem bipartiteSemidefiniteValue_unitGram
    {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℝ E]
    (A : Matrix (Fin m) (Fin n) ℝ) (X : Fin m → E) (Y : Fin n → E) :
    bipartiteSemidefiniteValue A (bipartiteUnitGram X Y) =
      innerBilinearValue A X Y := by
  simp only [bipartiteSemidefiniteValue, bipartiteBlockMatrix,
    bipartiteUnitGram, Fintype.sum_sum_type, Matrix.fromBlocks_apply₁₁,
    Matrix.fromBlocks_apply₁₂, Matrix.fromBlocks_apply₂₁,
    Matrix.fromBlocks_apply₂₂, Matrix.zero_apply, Matrix.transpose_apply,
    Matrix.gram_apply, Sum.elim_inl, Sum.elim_inr, zero_mul,
    Finset.sum_const_zero, zero_add]
  unfold innerBilinearValue
  rw [Finset.sum_comm]
  simp_rw [real_inner_comm]
  norm_num
  ring

/-- Every feasible block SDP matrix is a Gram matrix of two unit-vector
families in the Euclidean space indexed by the combined row and column set. -/
theorem exists_bipartite_unit_families_gram_eq
    {M : Matrix (Sum (Fin m) (Fin n)) (Sum (Fin m) (Fin n)) ℝ}
    (hM : IsCorrelationMatrixOn M) :
    ∃ X : Fin m → EuclideanSpace ℝ (Sum (Fin m) (Fin n)),
      ∃ Y : Fin n → EuclideanSpace ℝ (Sum (Fin m) (Fin n)),
        (∀ i, ‖X i‖ = 1) ∧ (∀ j, ‖Y j‖ = 1) ∧
          bipartiteUnitGram X Y = M := by
  classical
  obtain ⟨B, hB⟩ := Matrix.posSemidef_iff_eq_conjTranspose_mul_self.mp hM.1
  let v : Sum (Fin m) (Fin n) →
      EuclideanSpace ℝ (Sum (Fin m) (Fin n)) :=
    fun i => WithLp.toLp 2 (fun k => B k i)
  have hgram : Matrix.gram ℝ v = M := by
    rw [hB]
    ext i j
    simp [Matrix.gram_apply, v, PiLp.inner_apply, Matrix.mul_apply]
    congr 1
    · apply Finset.sum_congr rfl
      intro k _hk
      exact RCLike.inner_apply' (B (Sum.inl k) i) (B (Sum.inl k) j)
    · apply Finset.sum_congr rfl
      intro k _hk
      exact RCLike.inner_apply' (B (Sum.inr k) i) (B (Sum.inr k) j)
  have hvnorm : ∀ i, ‖v i‖ = 1 := by
    intro i
    have hsquare : ‖v i‖ ^ 2 = 1 := by
      rw [← real_inner_self_eq_norm_sq, ← Matrix.gram_apply, hgram, hM.2 i]
    nlinarith [norm_nonneg (v i)]
  refine ⟨fun i => v (Sum.inl i), fun j => v (Sum.inr j),
    fun i => hvnorm (Sum.inl i), fun j => hvnorm (Sum.inr j), ?_⟩
  have hvsplit : Sum.elim (fun i => v (Sum.inl i))
      (fun j => v (Sum.inr j)) = v := by
    funext p
    cases p <;> rfl
  rw [bipartiteUnitGram, hvsplit]
  exact hgram

end NumStability.HDP.Optimization
