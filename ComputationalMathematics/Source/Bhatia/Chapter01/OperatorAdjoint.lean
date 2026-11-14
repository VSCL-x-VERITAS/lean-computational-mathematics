/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.OperatorMatricesTarget

/-!
# Bhatia Chapter I: the adjoint identity and uniqueness

Section I.2, printed page 4, specifies the adjoint of every linear map between
finite-dimensional complex Hilbert spaces by its inner-product identity.
-/

set_option autoImplicit false
universe u v

namespace NumStability.Bhatia.Chapter01

/-- The prescribed adjoint satisfies the source identity and is uniquely
determined by it. -/
theorem operatorAdjoint : Targets.operatorAdjoint.{u, v} := by
  intro H K _ _ _ _ _ _ A
  constructor
  · intro x z
    exact (LinearMap.adjoint_inner_left A x z).symm
  · intro B hB
    apply (LinearMap.eq_adjoint_iff B A).2
    intro z x
    exact (hB x z).symm

end NumStability.Bhatia.Chapter01
