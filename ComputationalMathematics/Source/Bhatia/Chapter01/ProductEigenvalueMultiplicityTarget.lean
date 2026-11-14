/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic

/-!
First target proposal for Bhatia, Exercise I.3.7, printed 11 (PDF 23).
The full-multiplicity interpretation is retained from the reconciled source
contract; the bare printed wording and that interpretation remain separately
recorded for independent statement review. This file contains only the target.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Bhatia.Chapter01.Targets

/-- The two square products have the same characteristic polynomial, retaining
all complex eigenvalues with algebraic multiplicity, including zero. -/
def productEigenvalueMultiplicity : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ),
    Matrix.charpoly (A * B) = Matrix.charpoly (B * A)

end NumStability.Bhatia.Chapter01.Targets
