/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Quadratic forms in orthonormal coordinates

The matrix of a linear map in any supplied finite orthonormal basis preserves
its quadratic inner-product expression in the corresponding ordinary coordinates.
The empty basis is included.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 H ι : Type*} [RCLike 𝕜] [NormedAddCommGroup H] [InnerProductSpace 𝕜 H]
variable [Fintype ι] [DecidableEq ι]

/-- The conjugated coordinate vector paired with the matrix-vector product
equals the original quadratic inner product. -/
theorem star_dotProduct_toMatrix_mulVec_eq_inner
    (b : OrthonormalBasis ι 𝕜 H) (A : H →ₗ[𝕜] H) (x : H) :
    dotProduct (star (b.toBasis.equivFun x))
      ((LinearMap.toMatrix b.toBasis b.toBasis A).mulVec (b.toBasis.equivFun x)) =
        inner 𝕜 x (A x) := by
  simp only [Module.Basis.equivFun_apply]
  rw [LinearMap.toMatrix_mulVec_repr]
  have hcoords (y : H) : (b.toBasis.repr y : ι → 𝕜) = WithLp.ofLp (b.repr y) := by
    funext i
    exact b.coe_toBasis_repr_apply y i
  rw [hcoords x, hcoords (A x), dotProduct_comm,
    ← EuclideanSpace.inner_eq_star_dotProduct]
  exact b.repr.inner_map_map x (A x)

end NumStability
