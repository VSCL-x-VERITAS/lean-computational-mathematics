/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorIdentityTarget

/-! Source theorem for Bhatia, *Matrix Analysis* (1997), Chapter I.4,
printed page 15 (PDF page 27): the tensor product of the identity operator on
H with itself is the identity on H ⊗ H. The context is a finite-dimensional
complex inner-product space, with the same H in both tensor factors.
-/

namespace NumStability.Bhatia.Chapter01

/-- Tensoring the identity operator on a finite-dimensional complex
inner-product space with itself gives the identity on its tensor square. -/
theorem tensorIdentity : Targets.tensorIdentity := by
  intro H instNorm instInner instFinite
  exact TensorProduct.map_id

end NumStability.Bhatia.Chapter01
