/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.OperatorTerminologyTarget

/-!
# Bhatia Chapter I: Hermitian and skew-Hermitian operators

The defining equations in Section I.2, printed page 4, agree with the library
predicates on every finite-dimensional complex Hilbert space.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- Self-adjoint/Hermitian and skew-Hermitian mean the source adjoint equations. -/
theorem hermitianTerminology : Targets.hermitianTerminology.{u} := by
  intro H _ _ _ A
  constructor
  · rw [LinearMap.isSelfAdjoint_iff']
    exact eq_comm
  · rw [skewAdjoint.mem_iff, LinearMap.star_eq_adjoint]
    constructor <;> intro h <;>
      simpa only [neg_neg] using congrArg (fun T : H →ₗ[ℂ] H => -T) h.symm

end NumStability.Bhatia.Chapter01
