import ComputationalMathematics.HDP.Kernel.PositiveSemidefinite
import ComputationalMathematics.HDP.Tensor.PowerFeature

/-!
# Polynomial kernels

The inhomogeneous polynomial kernel is realized by adjoining one coordinate
and then taking a tensor-power feature.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Kernel

/-- The concrete Hilbert space for the degree-`k` polynomial kernel on
`Fin n → ℝ`. -/
abbrev PolynomialKernelFeatureSpace (n k : ℕ) :=
  NumStability.HDP.Tensor.PowerFeatureSpace (n + 1) k

/-- Adjoin `sqrt r` to the input vector and take its order-`k` tensor power. -/
def polynomialKernelFeature {n : ℕ} (r : ℝ) (k : ℕ) (u : Fin n → ℝ) :
    PolynomialKernelFeatureSpace n k :=
  NumStability.HDP.Tensor.powerFeature k (Fin.cons (Real.sqrt r) u)

theorem polynomialKernelFeature_inner {n : ℕ} (r : ℝ) (hr : 0 ≤ r)
    (k : ℕ) (u v : Fin n → ℝ) :
    ⟪polynomialKernelFeature r k u, polynomialKernelFeature r k v⟫_ℝ =
      ((∑ i, u i * v i) + r) ^ k := by
  change ⟪NumStability.HDP.Tensor.powerFeature k (Fin.cons (Real.sqrt r) u),
    NumStability.HDP.Tensor.powerFeature k (Fin.cons (Real.sqrt r) v)⟫_ℝ = _
  rw [NumStability.HDP.Tensor.powerFeature_inner, Fin.sum_univ_succ]
  simp only [Fin.cons_zero, Fin.cons_succ]
  rw [Real.mul_self_sqrt hr, add_comm]

/-- The inhomogeneous polynomial kernel is positive semidefinite for every
nonnegative offset. -/
theorem polynomialKernel_isPositiveSemidefinite {n : ℕ} (r : ℝ) (hr : 0 ≤ r)
    (k : ℕ) :
    IsPositiveSemidefinite
      (fun u v : Fin n → ℝ ↦ ((∑ i, u i * v i) + r) ^ k) := by
  apply IsRealFeatureMap.isPositiveSemidefinite
    (Φ := polynomialKernelFeature r k)
  intro u v
  exact polynomialKernelFeature_inner r hr k u v

end NumStability.HDP.Kernel
