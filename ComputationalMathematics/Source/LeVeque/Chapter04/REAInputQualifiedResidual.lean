/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAGeneralPrescribedCertificate

/-!
# Input qualifications for a prescribed residual certificate

A qualification fixed from the method input can restrict the admissible path
carrier without changing its field, equation, defect, measurements or budgets.
The resulting certificate retains that qualification as an explicit conjunct.
There is no endpoint argument in the qualification.
-/

namespace NumStability.REA.InputQualifiedResidual

variable {m : ℕ} {problem : Leveque04ForwardIVP m}

/-- Restrict the existing path carrier by a condition on the input alone. -/
def presentation (P : ResidualPresentation problem) (Q : Input m → Prop) :
    ResidualPresentation problem where
  components := P.components
  components_pos := P.components_pos
  Path := fun i => Subtype (fun _ : P.Path i => Q i)
  Index := P.Index
  indexMeasurableSpace := P.indexMeasurableSpace
  field := fun i w => P.field i w.val
  same_initial := fun i w => P.same_initial i w.val
  defect := fun i w => P.defect i w.val
  field_determines_defect := fun i w v h => P.field_determines_defect i w.val v.val h
  same_equation_on_carrier := fun i w => P.same_equation_on_carrier i w.val

variable {P : ResidualPresentation problem} {J : Input m → Type}
  {E : (i : Input m) → J i → Type}
  [∀ i j, NormedAddCommGroup (E i j)] [∀ i j, NormedSpace ℝ (E i j)]

/-- Every original test, geometry and budget is retained literally. -/
def policy (M : ResidualPolicy P J E) (Q : Input m → Prop) :
    ResidualPolicy (presentation P Q) J E where
  tests_nonempty := M.tests_nonempty
  geometry := M.geometry
  budget := M.budget

/-- Input qualification adds exactly its stated conjunct to certification. -/
theorem certificate_iff (M : ResidualPolicy P J E) (Q : Input m → Prop)
    (i : Input m) (endpoint : Profile m) :
    ResidualCertificate (presentation P Q) (policy M Q) i endpoint ↔
      Q i ∧ ResidualCertificate P M i endpoint := by
  constructor
  · rintro ⟨⟨w, hQ⟩, hend, hbound⟩
    exact ⟨hQ, w, hend, hbound⟩
  · rintro ⟨hQ, w, hend, hbound⟩
    exact ⟨⟨w, hQ⟩, hend, hbound⟩

end NumStability.REA.InputQualifiedResidual
