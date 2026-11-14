/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.OperatorTerminologyTarget

/-!
# Bhatia Chapter I: unitary and normal operators

The defining equations in Section I.2, printed page 4, agree with the library
predicates on every finite-dimensional complex Hilbert space.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- Unitary operators satisfy both inverse equations; normal operators commute
with their adjoints, as in the source definitions. -/
theorem unitaryNormalTerminology : Targets.unitaryNormalTerminology.{u} := by
  intro H _ _ _ A
  constructor
  · rw [Unitary.mem_iff, LinearMap.star_eq_adjoint]
    simp only [Module.End.mul_eq_comp, Module.End.one_eq_id]
    exact and_comm
  · rw [isStarNormal_iff, commute_iff_eq, LinearMap.star_eq_adjoint]
    simp only [Module.End.mul_eq_comp]
    exact eq_comm

end NumStability.Bhatia.Chapter01
