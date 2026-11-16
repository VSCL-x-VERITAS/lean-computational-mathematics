import ComputationalMathematics.Analysis.SingularValues.RealSVD
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core

/-! # Leverage sampling from leading left singular vectors

The first `k` vectors of a supplied, ordered SVD select a particular leading
subspace. The supplied SVD fixes the choice when singular values are repeated.
The remaining singular vectors are retained in the SVD certificate; no full
column rank assumption is imposed on the input matrix.
-/

namespace NumStability

open scoped BigOperators

/-- The first `k` columns of the chosen left singular family. -/
def leadingLeftSingularColumns {m r k : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m)) (hk : k ≤ r) :
    Matrix (Fin m) (Fin k) ℝ :=
  fun i j => u (Fin.castLE hk j) i

/-- The projector represented by the selected leading singular columns. -/
noncomputable def leadingLeftSingularProjector {m r k : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m)) (hk : k ≤ r) :
    Matrix (Fin m) (Fin m) ℝ :=
  leadingLeftSingularColumns u hk * (leadingLeftSingularColumns u hk).transpose

/-- Restricting an orthonormal singular family to its first columns preserves
orthonormality. -/
theorem hasOrthonormalColumns_leadingLeftSingularColumns {m r k : ℕ}
    (u : Fin r → EuclideanSpace ℝ (Fin m)) (hk : k ≤ r)
    (hu : Orthonormal ℝ u) :
    HasOrthonormalColumns (leadingLeftSingularColumns u hk) := by
  have hcoord : ∀ a b, (∑ i, u a i * u b i) = if a = b then 1 else 0 := by
    simpa [orthonormal_iff_ite, PiLp.inner_apply, real_inner_eq_re_inner,
      RCLike.inner_apply, mul_comm] using hu
  intro a b
  simpa only [leadingLeftSingularColumns, Fin.castLE_inj] using
    hcoord (Fin.castLE hk a) (Fin.castLE hk b)

/-- The leading columns of an actual ordered SVD are orthonormal. -/
theorem IsRealMatrixSVD.hasOrthonormalColumns_leadingLeftSingularColumns
    {m n r k : ℕ} {A : Matrix (Fin m) (Fin n) ℝ} {s : Fin n → ℝ}
    {u : Fin r → EuclideanSpace ℝ (Fin m)}
    {v : Fin r → EuclideanSpace ℝ (Fin n)}
    (h : IsRealMatrixSVD A r s u v) (hk : k ≤ r) :
    HasOrthonormalColumns (leadingLeftSingularColumns u hk) :=
  _root_.NumStability.hasOrthonormalColumns_leadingLeftSingularColumns u hk
    h.leftSingularVectors_orthonormal

end NumStability
