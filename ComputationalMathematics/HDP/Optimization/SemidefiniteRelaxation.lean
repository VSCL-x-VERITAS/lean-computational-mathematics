import ComputationalMathematics.HDP.Optimization.VectorQuadratic
import Mathlib.Analysis.InnerProductSpace.GramMatrix
import Mathlib.Analysis.Matrix.Order

/-!
# Gram-matrix form of the unit-vector quadratic relaxation

This file records both directions of the finite-dimensional Gram/positive-
semidefinite correspondence used to express the vector relaxation as an SDP.
-/

namespace NumStability.HDP.Optimization

open scoped BigOperators InnerProductSpace

/-- The Gram matrix of a family of Euclidean unit vectors. -/
noncomputable def unitVectorGram {n : ℕ} (X : UnitVectorFamily n) :
    Matrix (Fin n) (Fin n) ℝ :=
  Matrix.gram ℝ (fun i ↦ (X i : EuclideanSpace ℝ (Fin n)))

/-- Feasibility for the correlation-matrix SDP: positive semidefinite with
unit diagonal. -/
def IsCorrelationMatrix {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  M.PosSemidef ∧ ∀ i, M i i = 1

/-- The SDP objective `∑ i, j, Aᵢⱼ Mᵢⱼ`. -/
def semidefiniteQuadraticValue {n : ℕ} (A M : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  ∑ i, ∑ j, A i j * M i j

theorem unitVectorGram_posSemidef {n : ℕ} (X : UnitVectorFamily n) :
    (unitVectorGram X).PosSemidef := by
  exact Matrix.posSemidef_gram ℝ _

theorem unitVectorGram_diagonal {n : ℕ} (X : UnitVectorFamily n) (i : Fin n) :
    unitVectorGram X i i = 1 := by
  simp [unitVectorGram]

theorem unitVectorGram_isCorrelationMatrix {n : ℕ} (X : UnitVectorFamily n) :
    IsCorrelationMatrix (unitVectorGram X) :=
  ⟨unitVectorGram_posSemidef X, unitVectorGram_diagonal X⟩

theorem semidefiniteQuadraticValue_unitVectorGram {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (X : UnitVectorFamily n) :
    semidefiniteQuadraticValue A (unitVectorGram X) = vectorQuadraticValue A X :=
  rfl

/-- Every real positive-semidefinite matrix with unit diagonal is the Gram
matrix of unit vectors in the matching Euclidean dimension, including the
empty family in dimension zero. -/
theorem exists_unitVectorFamily_gram_eq {n : ℕ}
    {M : Matrix (Fin n) (Fin n) ℝ} (hM : IsCorrelationMatrix M) :
    ∃ X : UnitVectorFamily n, unitVectorGram X = M := by
  classical
  cases n with
  | zero =>
      let X : UnitVectorFamily 0 := fun i ↦ Fin.elim0 i
      refine ⟨X, ?_⟩
      ext i
      exact Fin.elim0 i
  | succ n =>
      obtain ⟨B, hB⟩ :=
        Matrix.posSemidef_iff_eq_conjTranspose_mul_self.mp hM.1
      let v : Fin (n + 1) → EuclideanSpace ℝ (Fin (n + 1)) :=
        fun i ↦ WithLp.toLp 2 (fun k ↦ B k i)
      have hgram : Matrix.gram ℝ v = M := by
        rw [hB]
        ext i j
        simp [Matrix.gram_apply, v, PiLp.inner_apply, Matrix.mul_apply]
        apply Finset.sum_congr rfl
        intro k _
        exact RCLike.inner_apply' (B k i) (B k j)
      have hvnorm : ∀ i, ‖v i‖ = 1 := by
        intro i
        have hsquare : ‖v i‖ ^ 2 = 1 := by
          rw [← real_inner_self_eq_norm_sq, ← Matrix.gram_apply, hgram, hM.2 i]
        nlinarith [norm_nonneg (v i)]
      let X : UnitVectorFamily (n + 1) := fun i ↦
        ⟨v i, by simpa using hvnorm i⟩
      refine ⟨X, ?_⟩
      simpa [unitVectorGram, X] using hgram

theorem semidefiniteQuadraticValue_le_vectorMaximum {n : ℕ} [Nonempty (Fin n)]
    (A M : Matrix (Fin n) (Fin n) ℝ) (hM : IsCorrelationMatrix M) :
    semidefiniteQuadraticValue A M ≤ vectorQuadraticMaximum A := by
  obtain ⟨X, hX⟩ := exists_unitVectorFamily_gram_eq hM
  rw [← hX, semidefiniteQuadraticValue_unitVectorGram]
  exact vectorQuadraticValue_le_maximum A X

/-- The SDP optimum, identified with the equivalent unit-vector optimum. -/
noncomputable def semidefiniteQuadraticMaximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  vectorQuadraticMaximum A

theorem exists_semidefiniteQuadraticValue_eq_maximum {n : ℕ} [Nonempty (Fin n)]
    (A : Matrix (Fin n) (Fin n) ℝ) :
    ∃ M : Matrix (Fin n) (Fin n) ℝ,
      IsCorrelationMatrix M ∧
      semidefiniteQuadraticValue A M = semidefiniteQuadraticMaximum A := by
  obtain ⟨X, hX⟩ := exists_vectorQuadraticValue_eq_maximum A
  refine ⟨unitVectorGram X, unitVectorGram_isCorrelationMatrix X, ?_⟩
  simpa [semidefiniteQuadraticMaximum, semidefiniteQuadraticValue_unitVectorGram] using hX

end NumStability.HDP.Optimization
