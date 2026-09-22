/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileEigenvalueTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.TravelingProfileMatrixEquation

/-!
# Eigenvalue necessity for a nonconstant travelling profile
-/

namespace NumStability.Leveque02Tracer

/-- At every point where the travelling profile has nonzero derivative, its
speed is an eigenvalue and the derivative is a corresponding eigenvector.
The nonzero premise is essential: constant profiles solve the system for an
arbitrary speed. -/
theorem travelingProfileEigenvalue : travelingProfileEigenvalueTarget := by
  intro m hm coefficient profile profileDerivative speed x t hsmooth hprofile hsystem hne
  have hequation := travelingProfileMatrixEquation
    m hm coefficient profile profileDerivative speed x t hsmooth hprofile hsystem
  have heigenvector : Module.End.HasEigenvector
      (Matrix.toLin' coefficient) speed profileDerivative := by
    rw [Module.End.hasEigenvector_iff]
    constructor
    · rw [Module.End.mem_eigenspace_iff, Matrix.toLin'_apply]
      exact hequation
    · exact hne
  exact ⟨heigenvector,
    Module.End.hasEigenvalue_of_hasEigenvector heigenvector⟩

end NumStability.Leveque02Tracer
