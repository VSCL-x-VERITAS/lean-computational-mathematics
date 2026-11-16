import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LowRankApproximation.ColumnSketches.Core
import ComputationalMathematics.Analysis.MatrixNorms.UnitarilyInvariant

/-!
# Sharp contraction bounds for orthogonal projector complements

These generic deterministic results support projector error estimates. They do
not by themselves assert the source equation (9), whose sketch, rank and norm
family hypotheses remain separate obligations.
-/

namespace NumStability

open scoped BigOperators

/-- The complement of a symmetric real matrix is symmetric. -/
theorem matSub_id_symmetric {m : ℕ} (P : Fin m → Fin m → ℝ)
    (hSym : IsSymmetricFiniteMatrix P) :
    IsSymmetricFiniteMatrix (matSub_id m P) := by
  intro i j
  simp only [matSub_id, idMatrix]
  rw [hSym i j]
  congr 1
  simp [eq_comm]

/-- The complement of an idempotent real matrix is idempotent. -/
theorem matSub_id_idempotent {m : ℕ} (P : Fin m → Fin m → ℝ)
    (hIdem : ∀ i j, preconditionRows P P i j = P i j) :
    ∀ i j, preconditionRows (matSub_id m P) (matSub_id m P) i j =
      matSub_id m P i j := by
  intro i j
  have hexpand :
      preconditionRows (matSub_id m P) (matSub_id m P) i j =
        idMatrix m i j - P i j - P i j + preconditionRows P P i j := by
    unfold preconditionRows matSub_id
    simp_rw [sub_mul, mul_sub, Finset.sum_sub_distrib]
    simp [idMatrix, Finset.sum_ite_eq, Finset.sum_ite_eq', Finset.mem_univ]
    ring
  rw [hexpand, hIdem i j]
  simp only [matSub_id]
  ring

/-- Complement row multiplication is the displayed projection residual. -/
theorem preconditionRows_matSub_id {m n : ℕ}
    (P : Fin m → Fin m → ℝ) (A : Fin m → Fin n → ℝ) :
    preconditionRows (matSub_id m P) A =
      fun i j => A i j - preconditionRows P A i j := by
  funext i j
  simp [preconditionRows, matSub_id, sub_mul, Finset.sum_sub_distrib,
    idMatrix, Finset.sum_ite_eq, Finset.mem_univ]

/-- Sharp Frobenius contraction for the complement of an orthogonal projector. -/
theorem frobNormRect_projection_residual_le_of_symmetric_idempotent {m n : ℕ}
    (P : Fin m → Fin m → ℝ) (A : Fin m → Fin n → ℝ)
    (hSym : IsSymmetricFiniteMatrix P)
    (hIdem : ∀ i j, preconditionRows P P i j = P i j) :
    frobNormRect (fun i j => A i j - preconditionRows P A i j) ≤
      frobNormRect A := by
  rw [← preconditionRows_matSub_id P A]
  exact frobNormRect_preconditionRows_le_of_symmetric_idempotent
    (matSub_id m P) A (matSub_id_symmetric P hSym)
    (matSub_id_idempotent P hIdem)

/-- Orthogonal projection minimizes the Frobenius residual among reproduced
matrices. This form requires neither a rank assumption nor a sketch parameter. -/
theorem frobNormSqRect_projection_residual_le_residual_of_reproduced
    {m n : ℕ} (P : Fin m → Fin m → ℝ)
    (A H : Fin m → Fin n → ℝ) (hSym : IsSymmetricFiniteMatrix P)
    (hIdem : ∀ i j, preconditionRows P P i j = P i j)
    (hH : ∀ i j, preconditionRows P H i j = H i j) :
    frobNormSqRect (fun i j => A i j - preconditionRows P A i j) ≤
      frobNormSqRect (fun i j => A i j - H i j) := by
  have hIdemFinite : ∀ i j, finiteMatMul P P i j = P i j := hIdem
  unfold frobNormSqRect
  rw [Finset.sum_comm]
  rw [Finset.sum_comm (f := fun i j => (A i j - H i j) ^ 2)]
  apply Finset.sum_le_sum
  intro j _
  have hcol :=
    finiteVecNorm2Sq_projection_residual_le_residual_to_range_of_symmetric_idempotent
      P hSym hIdemFinite (fun i => A i j) (fun i => H i j)
  have hrepr : finiteMatVec P (fun i => H i j) = fun i => H i j := by
    funext i
    exact hH i j
  rw [hrepr] at hcol
  exact hcol

/-- Norm form of Frobenius best approximation by an orthogonal projector. -/
theorem frobNormRect_projection_residual_le_residual_of_reproduced
    {m n : ℕ} (P : Fin m → Fin m → ℝ)
    (A H : Fin m → Fin n → ℝ) (hSym : IsSymmetricFiniteMatrix P)
    (hIdem : ∀ i j, preconditionRows P P i j = P i j)
    (hH : ∀ i j, preconditionRows P H i j = H i j) :
    frobNormRect (fun i j => A i j - preconditionRows P A i j) ≤
      frobNormRect (fun i j => A i j - H i j) := by
  exact Real.sqrt_le_sqrt
    (frobNormSqRect_projection_residual_le_residual_of_reproduced P A H hSym hIdem hH)

/-- A column-sketch orthogonal projector has no Frobenius loss against any
candidate head that factors through its sketch columns. -/
theorem frobNormRect_columnSketch_projection_residual_le_residual_of_headFactorization
    {m n r : ℕ} (A : Fin m → Fin n → ℝ)
    (Z : Fin n → Fin r → ℝ) (C : Fin r → Fin m → ℝ)
    (H : Fin m → Fin n → ℝ)
    (hC : ColumnSketchOrthogonalProjectorCertificate A Z C)
    (hH : ColumnSketchHeadFactorization A Z H) :
    frobNormRect (fun i j =>
      A i j - preconditionRows (columnSketchLeftMultiplier A Z C) A i j) ≤
      frobNormRect (fun i j => A i j - H i j) := by
  exact frobNormRect_projection_residual_le_residual_of_reproduced
    (columnSketchLeftMultiplier A Z C) A H hC.symmetric
    (columnSketchLeftMultiplier_idempotent_of_generalizedInverse A Z C
      hC.generalizedInverse)
    (preconditionRows_reproduces_head_of_columnSketchHeadFactorization A Z
      (columnSketchLeftMultiplier A Z C) H hC.generalizedInverse.reproducesSketch hH)

/-- A real orthogonal projector has complexified spectral norm at most one,
including in dimension zero and for the zero projector. -/
theorem complexMatrixOp2_realRectToCMatrix_le_one_of_symmetric_idempotent {m : ℕ}
    (P : Fin m → Fin m → ℝ) (hSym : IsSymmetricFiniteMatrix P)
    (hIdem : ∀ i j, preconditionRows P P i j = P i j) :
    complexMatrixOp2 (realRectToCMatrix P) ≤ 1 := by
  have hGram : rectMatMul (finiteTranspose P) P = P := by
    funext i j
    change (∑ k : Fin m, P k i * P k j) = P i j
    simp_rw [hSym _ i]
    exact hIdem i j
  have hsquare :=
    complexMatrixOp2_realRectToCMatrix_finiteTranspose_mul_self_eq_sq P
  rw [hGram] at hsquare
  nlinarith [sq_nonneg (complexMatrixOp2 (realRectToCMatrix P) - 1)]

/-- The complement of a real orthogonal projector has spectral norm at most one. -/
theorem complexMatrixOp2_realRectToCMatrix_matSub_id_le_one_of_symmetric_idempotent
    {m : ℕ} (P : Fin m → Fin m → ℝ) (hSym : IsSymmetricFiniteMatrix P)
    (hIdem : ∀ i j, preconditionRows P P i j = P i j) :
    complexMatrixOp2 (realRectToCMatrix (matSub_id m P)) ≤ 1 :=
  complexMatrixOp2_realRectToCMatrix_le_one_of_symmetric_idempotent
    (matSub_id m P) (matSub_id_symmetric P hSym) (matSub_id_idempotent P hIdem)

/-- The complement of a certified column-sketch projector is a spectral
contraction. The certificate supplies symmetry and idempotence explicitly. -/
theorem complexMatrixOp2_columnSketch_projector_complement_le_one
    {m n r : ℕ} (A : Fin m → Fin n → ℝ)
    (Z : Fin n → Fin r → ℝ) (C : Fin r → Fin m → ℝ)
    (hC : ColumnSketchOrthogonalProjectorCertificate A Z C) :
    complexMatrixOp2 (realRectToCMatrix
      (matSub_id m (columnSketchLeftMultiplier A Z C))) ≤ 1 :=
  complexMatrixOp2_realRectToCMatrix_matSub_id_le_one_of_symmetric_idempotent
    (columnSketchLeftMultiplier A Z C) hC.symmetric
    (columnSketchLeftMultiplier_idempotent_of_generalizedInverse A Z C
      hC.generalizedInverse)

end NumStability
