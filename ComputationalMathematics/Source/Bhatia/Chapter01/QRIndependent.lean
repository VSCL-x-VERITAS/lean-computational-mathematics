/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.QR.Decomposition
import ComputationalMathematics.Source.Bhatia.Chapter01.QRIndependentTarget

/-!
# Positive-diagonal QR factorization

Source correspondence for Bhatia, *Matrix Analysis* (1997), Chapter I.1,
printed page 2 (PDF page 14): a linearly independent dimension-length tuple
has a unique orthonormal/upper-triangular factorization whose diagonal
entries are strictly positive real numbers.
-/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01

/-- Bhatia's positive-diagonal QR existence and uniqueness statement,
including dimension zero. -/
theorem qrIndependent : Targets.qrIndependent.{u} := by
  intro H _ _ _
  dsimp only
  intro X hX
  exact NumStability.existsUnique_qr_of_linearIndependent X hX

end NumStability.Bhatia.Chapter01
