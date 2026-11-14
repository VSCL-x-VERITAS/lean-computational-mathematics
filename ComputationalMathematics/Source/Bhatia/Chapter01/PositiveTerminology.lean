/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveDefinite
import ComputationalMathematics.Source.Bhatia.Chapter01.PositiveTerminologyTarget

/-!
# Positivity terminology and Hermitian order

Source correspondence for Bhatia, *Matrix Analysis* (1997), Chapter I.2,
printed page 4 (PDF page 16): positive semidefinite operators, strict positivity
in every supplied orthonormal basis, and the order of Hermitian operators.
All statements retain the supplied Hermitian qualifications and dimension zero.
-/

set_option autoImplicit false
open scoped ComplexOrder

namespace NumStability.Bhatia.Chapter01

/-- The prescribed positivity and order characterizations, with strict
positivity represented by the actual matrix predicate in every finite ONB. -/
theorem positiveTerminology : Targets.positiveTerminologyUsingPosDef := by
  refine ⟨?_, ?_⟩
  · intro H _ _ _ A hA
    have hSym : A.IsSymmetric := (LinearMap.eq_adjoint_iff A A).mp hA
    refine ⟨fun x => (hSym.coe_re_inner_self_apply x).symm, ?_,
      LinearMap.nonneg_iff_isPositive A, ?_⟩
    · constructor
      · intro h x
        exact h.re_inner_nonneg_right x
      · intro h
        refine ⟨hSym, ?_⟩
        intro x
        rw [hSym x x]
        exact h x
    · intro n E
      exact NumStability.posDef_toMatrix_iff_re_inner_pos E A hA
  · intro H _ _ _ A B _hA _hB
    exact LinearMap.le_def B A

end NumStability.Bhatia.Chapter01
