/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.GramSchmidt.Normalization

/-!
# Diagonal coefficients in a completed Gram–Schmidt basis

For a family whose length equals the ambient dimension, the coefficient of
an input vector along its own completed Gram–Schmidt basis vector is the
nonnegative real norm of its unnormalized residual, embedded in the scalar
field. This also holds at a zero residual: the completed vector is orthogonal
to every input, and its diagonal coefficient is zero.

No independence or positive-dimension hypothesis is required.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E ι : Type*} [RCLike 𝕜] [NormedAddCommGroup E]
variable [InnerProductSpace 𝕜 E] [FiniteDimensional 𝕜 E]
variable [LinearOrder ι] [LocallyFiniteOrderBot ι] [WellFoundedLT ι] [Fintype ι]

/-- The completed basis has the residual norm as its diagonal input
coefficient, including at dependent inputs where that residual vanishes. -/
theorem inner_gramSchmidtOrthonormalBasis_input
    (hdim : Module.finrank 𝕜 E = Fintype.card ι) (f : ι → E) (i : ι) :
    inner 𝕜 (InnerProductSpace.gramSchmidtOrthonormalBasis hdim f i) (f i) =
      (‖InnerProductSpace.gramSchmidt 𝕜 f i‖ : 𝕜) := by
  by_cases hi : InnerProductSpace.gramSchmidtNormed 𝕜 f i = 0
  · have hraw := (gramSchmidtNormed_eq_zero_iff f i).mp hi
    rw [InnerProductSpace.inner_gramSchmidtOrthonormalBasis_eq_zero hdim hi i,
      hraw, norm_zero, RCLike.ofReal_zero]
  · rw [InnerProductSpace.gramSchmidtOrthonormalBasis_apply hdim hi]
    exact inner_gramSchmidtNormed_input f i

end NumStability
