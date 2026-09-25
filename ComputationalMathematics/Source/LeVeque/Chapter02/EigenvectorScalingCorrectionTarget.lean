/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ConvectedAcousticsEigenvectorsTarget

/-!
# LeVeque Chapter 2: EigenvectorScalingCorrectionTarget

Target recording the zero-scaling exception for eigenvectors.
-/

namespace NumStability.Leveque02Tracer

/-- Multiplication by zero never yields a nonzero eigenvector, for any real matrix. -/
def zeroScalarEigenvectorFailureTarget : Prop :=
  ∀ (m : ℕ) (A : Matrix (Fin m) (Fin m) ℝ) (eigenvalue : ℝ)
    (v : Fin m → ℝ),
    ¬ Module.End.HasEigenvector (Matrix.toLin' A) eigenvalue ((0 : ℝ) • v)

/-- Every nonzero scalar multiple of a nonzero eigenvector remains an
eigenvector for the same eigenvalue. -/
def nonzeroScalarEigenvectorTarget : Prop :=
  ∀ (m : ℕ) (A : Matrix (Fin m) (Fin m) ℝ) (eigenvalue : ℝ)
    (v : Fin m → ℝ) (scalar : ℝ),
    Module.End.HasEigenvector (Matrix.toLin' A) eigenvalue v →
    scalar ≠ 0 →
    Module.End.HasEigenvector (Matrix.toLin' A) eigenvalue (scalar • v)

/-- In particular, each acoustic vector in (2.58) witnesses the zero-scalar
failure, while its nonzero multiples retain the corresponding eigenvalue. -/
def acousticEigenvectorScalingTarget : Prop :=
  ∀ (bulkModulus density backgroundVelocity : ℝ),
    0 < bulkModulus → 0 < density →
    let soundSpeed := Real.sqrt (bulkModulus / density)
    let A := convectedLinearAcousticsMatrix bulkModulus density backgroundVelocity
    let left := linearAcousticsLeftEigenvector density soundSpeed
    let right := linearAcousticsRightEigenvector density soundSpeed
    Module.End.HasEigenvector (Matrix.toLin' A)
        (backgroundVelocity - soundSpeed) left ∧
      ¬ Module.End.HasEigenvector (Matrix.toLin' A)
        (backgroundVelocity - soundSpeed) ((0 : ℝ) • left) ∧
      (∀ scalar : ℝ, scalar ≠ 0 →
        Module.End.HasEigenvector (Matrix.toLin' A)
          (backgroundVelocity - soundSpeed) (scalar • left)) ∧
      Module.End.HasEigenvector (Matrix.toLin' A)
        (backgroundVelocity + soundSpeed) right ∧
      ¬ Module.End.HasEigenvector (Matrix.toLin' A)
        (backgroundVelocity + soundSpeed) ((0 : ℝ) • right) ∧
      (∀ scalar : ℝ, scalar ≠ 0 →
        Module.End.HasEigenvector (Matrix.toLin' A)
          (backgroundVelocity + soundSpeed) (scalar • right))

end NumStability.Leveque02Tracer
