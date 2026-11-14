/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.Data.Matrix.Block

/-!
# Prescribed block conjugation

Proof-free source target proposal for Bhatia, Matrix Analysis (1997),
Exercise I.3.7, printed page 11 / PDF page 23.

The two-sided inverse identities express that the prescribed matrix `S` is
exactly the inverse of `T`. The third identity therefore expresses the printed
conjugation with the inverse on the left. All four block matrices are fixed
expressions in the supplied `A` and `B`.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed upper-unitriangular block matrix is invertible with its
explicit inverse, and conjugates the two displayed block matrices. -/
def prescribedBlockSimilarity : Prop :=
  ∀ (n : ℕ) (A B : Matrix (Fin n) (Fin n) ℂ),
    let T : Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
      Matrix.fromBlocks (1 : Matrix (Fin n) (Fin n) ℂ) A 0 1
    let S : Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
      Matrix.fromBlocks (1 : Matrix (Fin n) (Fin n) ℂ) (-A) 0 1
    let M : Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
      Matrix.fromBlocks (A * B) (0 : Matrix (Fin n) (Fin n) ℂ) B 0
    let N : Matrix (Fin n ⊕ Fin n) (Fin n ⊕ Fin n) ℂ :=
      Matrix.fromBlocks (0 : Matrix (Fin n) (Fin n) ℂ) 0 B (B * A)
    T * S = 1 ∧ S * T = 1 ∧ S * M * T = N

end NumStability.Bhatia.Chapter01.Targets
