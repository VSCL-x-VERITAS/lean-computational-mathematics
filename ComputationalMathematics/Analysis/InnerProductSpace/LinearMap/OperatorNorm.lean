/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Analysis.Normed.Module.FiniteDimension
import Mathlib.Analysis.Normed.Operator.NormedSpace

/-!
# Operator norm in orthonormal coordinates

An operator and its matrix in supplied finite orthonormal bases have the same
Euclidean operator norm. The domain and codomain may differ, and empty bases
are included.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E F ι κ : Type*} [RCLike 𝕜]
variable [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]
variable [NormedAddCommGroup F] [InnerProductSpace 𝕜 F]
variable [Fintype ι] [DecidableEq ι] [Fintype κ]

/-- The Euclidean interpretation of an orthonormal-coordinate matrix acts by
transporting through the two basis isometries. -/
theorem toEuclideanLin_toMatrix_apply_repr
    (bE : OrthonormalBasis ι 𝕜 E) (bF : OrthonormalBasis κ 𝕜 F)
    (A : E →ₗ[𝕜] F) (x : E) :
    Matrix.toEuclideanLin (LinearMap.toMatrix bE.toBasis bF.toBasis A) (bE.repr x) =
      bF.repr (A x) := by
  apply WithLp.ofLp_injective
  change (LinearMap.toMatrix bE.toBasis bF.toBasis A).mulVec
    (WithLp.ofLp (bE.repr x)) = WithLp.ofLp (bF.repr (A x))
  have hE : WithLp.ofLp (bE.repr x) = (bE.toBasis.repr x : ι → 𝕜) := by
    funext i
    exact (bE.coe_toBasis_repr_apply x i).symm
  have hF : WithLp.ofLp (bF.repr (A x)) = (bF.toBasis.repr (A x) : κ → 𝕜) := by
    funext i
    exact (bF.coe_toBasis_repr_apply (A x) i).symm
  rw [hE, hF, LinearMap.toMatrix_mulVec_repr]

variable [FiniteDimensional 𝕜 E]

/-- The actual operator norm is unchanged on taking the matrix in any finite
orthonormal bases and interpreting it between Euclidean coordinate spaces. -/
theorem norm_toEuclideanLin_toMatrix
    (bE : OrthonormalBasis ι 𝕜 E) (bF : OrthonormalBasis κ 𝕜 F)
    (A : E →ₗ[𝕜] F) :
    ‖(Matrix.toEuclideanLin
      (LinearMap.toMatrix bE.toBasis bF.toBasis A)).toContinuousLinearMap‖ =
      ‖A.toContinuousLinearMap‖ := by
  have hmap : (Matrix.toEuclideanLin
      (LinearMap.toMatrix bE.toBasis bF.toBasis A)).toContinuousLinearMap =
      bF.repr.toLinearIsometry.toContinuousLinearMap.comp
        (A.toContinuousLinearMap.comp bE.repr.symm.toLinearIsometry.toContinuousLinearMap) := by
    apply ContinuousLinearMap.ext
    intro x
    simpa only [ContinuousLinearMap.comp_apply, LinearIsometry.coe_toContinuousLinearMap,
      LinearIsometryEquiv.coe_toLinearIsometry, LinearIsometryEquiv.apply_symm_apply] using
      toEuclideanLin_toMatrix_apply_repr bE bF A (bE.repr.symm x)
  rw [hmap, LinearIsometry.norm_toContinuousLinearMap_comp,
    ContinuousLinearMap.opNorm_comp_linearIsometryEquiv]

end NumStability
