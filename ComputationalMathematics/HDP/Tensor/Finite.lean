import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Algebra.BigOperators.Ring.Finset
import Mathlib.Data.Fintype.Pi
import Mathlib.Data.Real.Basic

/-!
# Finite real tensors

Reusable array-level foundations for finite tensors.  A tensor with axis sizes
`n : Fin k → ℕ` is a real-valued function on the corresponding product of
finite index types, and its canonical inner product is the entrywise sum of
products.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Tensor

/-- The multi-index type for a finite tensor with the prescribed axis sizes. -/
abbrev MultiIndex {k : ℕ} (n : Fin k → ℕ) := ∀ j, Fin (n j)

/-- A finite real tensor, represented as a multidimensional array. -/
abbrev FiniteTensor {k : ℕ} (n : Fin k → ℕ) := MultiIndex n → ℝ

/-- The canonical entrywise inner product of finite real tensors. -/
def inner {k : ℕ} {n : Fin k → ℕ}
    (A B : FiniteTensor n) : ℝ :=
  ∑ i, A i * B i

theorem inner_eq_sum {k : ℕ} {n : Fin k → ℕ}
    (A B : FiniteTensor n) :
    inner A B = ∑ i, A i * B i := rfl

/-- The rank-one tensor formed from a possibly different vector on each axis. -/
def ofFactors {k : ℕ} {n : Fin k → ℕ}
    (u : ∀ j, Fin (n j) → ℝ) : FiniteTensor n :=
  fun i ↦ ∏ j, u j (i j)

/-- The entries of a rank-one tensor are products of the corresponding factor
coordinates. -/
theorem ofFactors_apply {k : ℕ} {n : Fin k → ℕ}
    (u : ∀ j, Fin (n j) → ℝ) (i : MultiIndex n) :
    ofFactors u i = ∏ j, u j (i j) := rfl

/-- The `k`-fold rank-one tensor power of a finite real vector. -/
def power {n : ℕ} (u : Fin n → ℝ) (k : ℕ) :
    FiniteTensor (fun _ : Fin k ↦ n) :=
  ofFactors (fun _ ↦ u)

/-- The canonical tensor inner product of two rank-one powers is the
corresponding vector dot product raised to the tensor order. -/
theorem inner_power_power {n : ℕ} (u v : Fin n → ℝ) (k : ℕ) :
    inner (power u k) (power v k) =
      (∑ i, u i * v i) ^ k := by
  unfold inner power
  rw [Fintype.sum_pow]
  apply Finset.sum_congr rfl
  intro i _
  exact (Finset.prod_mul_distrib (f := fun j ↦ u (i j))
    (g := fun j ↦ v (i j))).symm

end NumStability.HDP.Tensor
