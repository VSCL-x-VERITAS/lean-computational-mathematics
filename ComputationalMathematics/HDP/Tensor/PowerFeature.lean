import ComputationalMathematics.HDP.Tensor.Finite
import Mathlib.Analysis.InnerProductSpace.PiL2

/-!
# Tensor-power feature maps

Rank-one tensor powers, viewed in their finite Euclidean coordinate spaces,
give concrete Hilbert-space feature maps for power kernels.
-/

noncomputable section

open scoped BigOperators InnerProductSpace

namespace NumStability.HDP.Tensor

/-- The finite-dimensional real Hilbert space of order-`k` tensor coordinates. -/
abbrev PowerFeatureSpace (n k : ℕ) :=
  EuclideanSpace ℝ (Fin k → Fin n)

/-- The order-`k` rank-one tensor power as a Hilbert-space feature vector. -/
def powerFeature {n : ℕ} (k : ℕ) (u : Fin n → ℝ) :
    PowerFeatureSpace n k :=
  WithLp.toLp 2 (power u k)

/-- Tensor-power features realize the `k`-th power of the Euclidean kernel. -/
theorem powerFeature_inner {n : ℕ} (k : ℕ) (u v : Fin n → ℝ) :
    ⟪powerFeature k u, powerFeature k v⟫_ℝ =
      (∑ i, u i * v i) ^ k := by
  rw [real_inner_comm]
  simp only [PiLp.inner_apply, powerFeature]
  exact inner_power_power u v k

end NumStability.HDP.Tensor
