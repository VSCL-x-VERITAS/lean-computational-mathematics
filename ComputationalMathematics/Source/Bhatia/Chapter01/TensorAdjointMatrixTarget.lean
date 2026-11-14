/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Kronecker

/-! Proposed matrix coordinates for Bhatia, Chapter I.4, printed page 15.
Source correspondence requires a separate independent review of the fixed
orthonormal bases, product basis, and same-space quantification.
-/

namespace NumStability.Bhatia.Chapter01.Targets

/-- The proposed closed coordinate proposition, including dimension zero. -/
def tensorAdjointInCoordinates : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ),
    (Matrix.kronecker A B).conjTranspose =
      Matrix.kronecker A.conjTranspose B.conjTranspose

end NumStability.Bhatia.Chapter01.Targets
