/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation06

/-!
# LeVeque Chapter 1, acoustic eigenvalues

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25).
-/

namespace NumStability

/-- The acoustics matrix has the two nonzero eigenvectors displayed here,
with eigenvalues `-c` and `+c` for `c = sqrt (K / ρ)`.  Carrying an arbitrary
differentiable profile by either eigenvector gives a system solution
translated at that eigenvalue, making the source's wave-speed interpretation
explicit. -/
theorem leveque01_acousticsMatrixEigenvalues
    {bulkModulus density : ℝ}
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    let soundSpeed := Real.sqrt (bulkModulus / density)
    0 < soundSpeed ∧
      linearAcousticsLeftEigenvector density soundSpeed ≠ 0 ∧
      (linearAcousticsMatrix bulkModulus density).mulVec
          (linearAcousticsLeftEigenvector density soundSpeed) =
        (-soundSpeed) • linearAcousticsLeftEigenvector density soundSpeed ∧
      (∀ {profile : ℝ → ℝ} {profile' : ℝ} (x t : ℝ),
        HasDerivAt profile profile' (x - (-soundSpeed) * t) →
          IsConstantCoefficientLinearSystemSolutionAt
            (eigenmodeTravelingWave profile (-soundSpeed)
              (linearAcousticsLeftEigenvector density soundSpeed))
            (linearAcousticsMatrix bulkModulus density) x t) ∧
      linearAcousticsRightEigenvector density soundSpeed ≠ 0 ∧
      (linearAcousticsMatrix bulkModulus density).mulVec
          (linearAcousticsRightEigenvector density soundSpeed) =
        soundSpeed • linearAcousticsRightEigenvector density soundSpeed ∧
      ∀ {profile : ℝ → ℝ} {profile' : ℝ} (x t : ℝ),
        HasDerivAt profile profile' (x - soundSpeed * t) →
          IsConstantCoefficientLinearSystemSolutionAt
            (eigenmodeTravelingWave profile soundSpeed
              (linearAcousticsRightEigenvector density soundSpeed))
            (linearAcousticsMatrix bulkModulus density) x t := by
  dsimp only
  have hratioPos : 0 < bulkModulus / density :=
    div_pos hbulkModulus hdensity
  have hratio : 0 ≤ bulkModulus / density :=
    hratioPos.le
  have hmaterial : bulkModulus =
      density * (Real.sqrt (bulkModulus / density)) ^ 2 := by
    rw [Real.sq_sqrt hratio]
    field_simp [ne_of_gt hdensity]
  have hleft := linearAcousticsMatrix_mulVec_leftEigenvector
    bulkModulus density (Real.sqrt (bulkModulus / density))
    (ne_of_gt hdensity) hmaterial
  have hright := linearAcousticsMatrix_mulVec_rightEigenvector
    bulkModulus density (Real.sqrt (bulkModulus / density))
    (ne_of_gt hdensity) hmaterial
  refine ⟨Real.sqrt_pos.2 hratioPos, ?_, hleft, ?_, ?_, hright, ?_⟩
  · intro hzero
    have := congrFun hzero (1 : Fin 2)
    simp [linearAcousticsLeftEigenvector] at this
  · intro profile profile' x t hprofile
    exact eigenmodeTravelingWave_isConstantCoefficientSolutionAt
      (linearAcousticsMatrix bulkModulus density)
      (linearAcousticsLeftEigenvector density
        (Real.sqrt (bulkModulus / density))) x t hleft hprofile
  · intro hzero
    have := congrFun hzero (1 : Fin 2)
    simp [linearAcousticsRightEigenvector] at this
  · intro profile profile' x t hprofile
    exact eigenmodeTravelingWave_isConstantCoefficientSolutionAt
      (linearAcousticsMatrix bulkModulus density)
      (linearAcousticsRightEigenvector density
        (Real.sqrt (bulkModulus / density))) x t hright hprofile

end NumStability
