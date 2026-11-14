/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Permanent

/-!
# Bhatia Chapter I: the permanent formula

Proof-free target for the unsigned permutation formula on printed page 17
(PDF page 29). Matrix size follows this chapter's all-finite-size convention;
the source does not separately discuss the empty matrix. The existing Mathlib
producer permutes rows, so equality with the displayed column-permutation
formula is an explicit correspondence obligation.
-/

set_option autoImplicit false

open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- The permanent agrees with Bhatia's unsigned column-permutation formula. -/
def permanentFormula : Prop :=
  ∀ n : ℕ, ∀ A : Matrix (Fin n) (Fin n) ℂ,
    Matrix.permanent A =
      ∑ σ : Equiv.Perm (Fin n), ∏ i : Fin n, A i (σ i)

end NumStability.Bhatia.Chapter01.Targets
