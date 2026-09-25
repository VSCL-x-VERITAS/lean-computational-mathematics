/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.EigenvectorScalingCorrectionTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsEigenvectors

/-!
# LeVeque Chapter 2: EigenvectorScalingCorrection

Proof that nonzero scaling preserves an acoustic eigenvector.
-/

namespace NumStability.Leveque02Tracer

theorem zeroScalarEigenvectorFailure : zeroScalarEigenvectorFailureTarget := by
  intro m A eigenvalue v hzero
  exact (Module.End.hasEigenvector_iff.mp hzero).2 (zero_smul ℝ v)

theorem nonzeroScalarEigenvector : nonzeroScalarEigenvectorTarget := by
  intro m A eigenvalue v scalar hv hscalar
  rw [Module.End.hasEigenvector_iff] at hv ⊢
  constructor
  · rw [Module.End.mem_eigenspace_iff] at hv ⊢
    rw [map_smul, hv.1, smul_comm]
  · exact smul_ne_zero hscalar hv.2

theorem acousticEigenvectorScaling : acousticEigenvectorScalingTarget := by
  intro bulkModulus density backgroundVelocity hbulk hdensity
  dsimp only
  obtain ⟨hleft, hright⟩ :=
    convectedAcousticsEigenvectors bulkModulus density backgroundVelocity
      hbulk hdensity
  refine ⟨hleft, ?_, ?_, hright, ?_, ?_⟩
  · exact zeroScalarEigenvectorFailure _ _ _ _
  · intro scalar hscalar
    exact nonzeroScalarEigenvector _ _ _ _ scalar hleft hscalar
  · exact zeroScalarEigenvectorFailure _ _ _ _
  · intro scalar hscalar
    exact nonzeroScalarEigenvector _ _ _ _ scalar hright hscalar

end NumStability.Leveque02Tracer
