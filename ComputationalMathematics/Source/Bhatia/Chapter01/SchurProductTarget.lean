/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Hadamard

/-! Proof-free target for Bhatia, Matrix Analysis (1997),
Problem I.6.13 definition, printed page 23 (PDF page 35).
The source-facing proof is a separate acceptance obligation. -/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- The Schur/Hadamard product is the entrywise product for every pair of
same-size square complex matrices, including the empty size. -/
def schurProduct : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ) (i j : Fin n),
    Matrix.hadamard A B i j = A i j * B i j

end NumStability.Bhatia.Chapter01.Targets
