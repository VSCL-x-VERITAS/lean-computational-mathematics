import ComputationalMathematics.HDP.Tensor.Finite
import Mathlib.LinearAlgebra.Matrix.Trace

/-!
# Low-order finite tensors

Scalars, vectors, and matrices as order-zero, order-one, and order-two finite
tensors, together with the matrix trace formula for the tensor inner product.
-/

noncomputable section

open scoped BigOperators Matrix

namespace NumStability.HDP.Tensor

/-- A scalar as an order-zero tensor. -/
def scalarTensor (a : ℝ) : FiniteTensor (fun _ : Fin 0 => 0) :=
  fun _ => a

/-- The unique multi-index of an order-zero tensor. -/
def emptyIndex : MultiIndex (fun _ : Fin 0 => 0) :=
  fun j => Fin.elim0 j

theorem scalarTensor_bijective : Function.Bijective scalarTensor := by
  constructor
  · intro a b h
    exact congr_fun h emptyIndex
  · intro A
    refine ⟨A emptyIndex, ?_⟩
    funext i
    exact congrArg A (Subsingleton.elim emptyIndex i)

/-- The constant multi-index associated to a vector coordinate. -/
def singletonIndex {n : ℕ} (i : Fin n) :
    MultiIndex (fun _ : Fin 1 => n) :=
  fun _ => i

/-- A vector as an order-one tensor. -/
def vectorTensor {n : ℕ} (u : Fin n → ℝ) :
    FiniteTensor (fun _ : Fin 1 => n) :=
  fun i => u (i 0)

theorem vectorTensor_bijective {n : ℕ} :
    Function.Bijective (vectorTensor (n := n)) := by
  constructor
  · intro u v h
    funext i
    exact congr_fun h (singletonIndex i)
  · intro A
    refine ⟨fun i => A (singletonIndex i), ?_⟩
    funext i
    change A (singletonIndex (i 0)) = A i
    congr 1
    funext j
    fin_cases j
    rfl

/-- The two-axis shape associated to an `m` by `n` matrix. -/
def matrixShape (m n : ℕ) : Fin 2 → ℕ :=
  Fin.cases m (fun _ : Fin 1 => n)

/-- A pair of row and column indices as an order-two multi-index. -/
def pairIndex {m n : ℕ} (i : Fin m) (j : Fin n) :
    MultiIndex (matrixShape m n) :=
  fun k => Fin.cases i (fun _ : Fin 1 => j) k

/-- Order-two multi-indices are precisely row-column index pairs. -/
def matrixIndexEquiv {m n : ℕ} :
    MultiIndex (matrixShape m n) ≃ Fin m × Fin n where
  toFun ij := (ij 0, ij 1)
  invFun ij := pairIndex ij.1 ij.2
  left_inv ij := by
    funext j
    fin_cases j
    · rfl
    · change ij 1 = ij 1
      rfl
  right_inv ij := by
    rcases ij with ⟨i, j⟩
    rfl

/-- A matrix as an order-two tensor. -/
def matrixTensor {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ) :
    FiniteTensor (matrixShape m n) :=
  fun ij => A (ij 0) (ij 1)

theorem matrixTensor_bijective {m n : ℕ} :
    Function.Bijective (matrixTensor (m := m) (n := n)) := by
  constructor
  · intro A B h
    ext i j
    exact congr_fun h (pairIndex i j)
  · intro T
    refine ⟨fun i j => T (pairIndex i j), ?_⟩
    funext ij
    change T (pairIndex (ij 0) (ij 1)) = T ij
    congr 1
    funext j
    fin_cases j
    · rfl
    · change ij 1 = ij 1
      rfl

theorem trace_transpose_mul_eq_sum {m n : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) :
    Matrix.trace (A.transpose * B) =
      ∑ i, ∑ j, A i j * B i j := by
  simp only [Matrix.trace, Matrix.diag_apply, Matrix.mul_apply,
    Matrix.transpose_apply]
  exact Finset.sum_comm

theorem inner_matrixTensor_eq_sum {m n : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) :
    inner (matrixTensor A) (matrixTensor B) =
      ∑ i, ∑ j, A i j * B i j := by
  unfold inner
  calc
    ∑ ij, matrixTensor A ij * matrixTensor B ij =
        ∑ ij : Fin m × Fin n, A ij.1 ij.2 * B ij.1 ij.2 := by
      apply Fintype.sum_equiv matrixIndexEquiv
      intro ij
      rfl
    _ = ∑ i, ∑ j, A i j * B i j :=
      Fintype.sum_prod_type _

/-- On matrices, the finite-tensor inner product is `tr(Aᵀ B)`. -/
theorem inner_matrixTensor_eq_trace {m n : ℕ}
    (A B : Matrix (Fin m) (Fin n) ℝ) :
    inner (matrixTensor A) (matrixTensor B) =
      Matrix.trace (A.transpose * B) := by
  rw [inner_matrixTensor_eq_sum, trace_transpose_mul_eq_sum]

end NumStability.HDP.Tensor
