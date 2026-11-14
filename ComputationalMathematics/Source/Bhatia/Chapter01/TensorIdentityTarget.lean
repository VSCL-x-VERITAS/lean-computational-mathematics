/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.LinearAlgebra.TensorProduct.Map

/-! Source correspondence: proof-free target for Bhatia, Matrix Analysis (1997),
Chapter I.4, printed page 15. `tensorIdentity` states that the identity on H ⊗ H
is induced by the two identity operators on the same finite-dimensional complex
inner-product space H. The target uses Mathlib's algebraic tensor quotient. -/

namespace NumStability.Bhatia.Chapter01.Targets

/-- The identity assertion on the tensor product of the same Hilbert space. -/
def tensorIdentity : Prop :=
  ∀ (H : Type) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H],
    TensorProduct.map (LinearMap.id : H →ₗ[ℂ] H) (LinearMap.id : H →ₗ[ℂ] H) =
      (LinearMap.id : TensorProduct ℂ H H →ₗ[ℂ] TensorProduct ℂ H H)

end NumStability.Bhatia.Chapter01.Targets
