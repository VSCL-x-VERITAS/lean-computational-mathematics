/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.AcousticsEigenvalues
import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsEigenvaluesTarget

/-!
# Eigenvalues of the convected acoustic matrix
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.57), using the source-independent velocity-shift eigendata and
the already integrated nonzero acoustic eigenvectors. -/
theorem convectedAcousticsEigenvalues :
    convectedAcousticsEigenvaluesTarget := by
  intro bulkModulus density backgroundVelocity hbulkModulus hdensity
  dsimp only
  let soundSpeed := Real.sqrt (bulkModulus / density)
  have hratioPos : 0 < bulkModulus / density :=
    div_pos hbulkModulus hdensity
  have hmaterial : bulkModulus = density * soundSpeed ^ 2 := by
    dsimp [soundSpeed]
    rw [Real.sq_sqrt hratioPos.le]
    field_simp [ne_of_gt hdensity]
  have hacoustics :=
    NumStability.leveque01_acousticsMatrixEigenvalues hbulkModulus hdensity
  dsimp only at hacoustics
  rcases hacoustics with
    ⟨_, hleftNe, _, _, hrightNe, _, _⟩
  constructor
  · apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    constructor
    · rw [Module.End.mem_eigenspace_iff, Matrix.toLin'_apply]
      exact convectedLinearAcousticsMatrix_mulVec_leftEigenvector
        bulkModulus density soundSpeed backgroundVelocity
        (ne_of_gt hdensity) hmaterial
    · exact hleftNe
  · apply Module.End.hasEigenvalue_of_hasEigenvector
    rw [Module.End.hasEigenvector_iff]
    constructor
    · rw [Module.End.mem_eigenspace_iff, Matrix.toLin'_apply]
      exact convectedLinearAcousticsMatrix_mulVec_rightEigenvector
        bulkModulus density soundSpeed backgroundVelocity
        (ne_of_gt hdensity) hmaterial
    · exact hrightNe

end NumStability.Leveque02Tracer
