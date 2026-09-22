/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsEigenvalues
import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsEigenvaluesTarget

/-!
# Eigenvalues of the stationary acoustic matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.54), packaged with Mathlib's standard eigenvalue predicate
from the compatible eigendata already formalized for Chapter 1. -/
theorem stationaryAcousticsEigenvalues :
    stationaryAcousticsEigenvaluesTarget := by
  intro bulkModulus density hbulkModulus hdensity
  have hacoustics :=
    NumStability.leveque01_acousticsMatrixEigenvalues hbulkModulus hdensity
  dsimp only at hacoustics ⊢
  rcases hacoustics with
    ⟨_, hleftNe, hleft, _, hrightNe, hright, _⟩
  constructor
  · apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    constructor
    · rw [Module.End.mem_eigenspace_iff, Matrix.toLin'_apply]
      exact hleft
    · exact hleftNe
  · apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    constructor
    · rw [Module.End.mem_eigenspace_iff, Matrix.toLin'_apply]
      exact hright
    · exact hrightNe

end NumStability.Leveque02Tracer
