/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.ElementaryFunctionPointwiseTarget

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01

/-- The defining fixed-pair characterization on the source bilinear domain. -/
theorem elementaryFunctionPointwiseCharacterization :
    Targets.elementaryFunctionPointwiseCharacterization.{u} := by
  unfold Targets.elementaryFunctionPointwiseCharacterization
  intro H _ _ _ F hF
  unfold Targets.sourceElementaryFunction
  exact and_iff_right hF

end NumStability.Bhatia.Chapter01
