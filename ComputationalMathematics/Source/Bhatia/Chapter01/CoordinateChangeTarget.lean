/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.Matrix.ConjTranspose

/-!
# Orthonormal coordinates and their transition matrix

Proof-free statement contract for Bhatia, Matrix Analysis (1997), Chapter I.1,
printed page 3 (PDF page 15), including its local Indeed identities.
-/

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- Coordinates in an arbitrary orthonormal basis, unitarity for a second full
orthonormal basis, and both prescribed directions of coordinate transition. -/
def orthonormalCoordinateChange : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (E : OrthonormalBasis (Fin n) ℂ H),
      (∀ (k : ℕ) (X : Fin k → H),
        let C : Matrix (Fin n) (Fin k) ℂ := fun i j => inner ℂ (E i) (X j)
        (∀ (j : Fin k) (i : Fin n), E.repr (X j) i = C i j) ∧
        (∀ j : Fin k, X j = ∑ i : Fin n, C i j • E i)) ∧
      (∀ (X : OrthonormalBasis (Fin n) ℂ H),
        let C : Matrix (Fin n) (Fin n) ℂ := fun i j => inner ℂ (E i) (X j)
        let D : Matrix (Fin n) (Fin n) ℂ := fun i j => inner ℂ (X i) (E j)
        D = C.conjTranspose ∧
        C.conjTranspose * C = 1 ∧ C * C.conjTranspose = 1 ∧
        ∀ z : H,
          let a : Fin n → ℂ := fun i => E.repr z i
          let b : Fin n → ℂ := fun i => X.repr z i
          (∀ i : Fin n, a i = inner ℂ (E i) z) ∧
          (∀ j : Fin n, b j = inner ℂ (X j) z) ∧
          z = ∑ i : Fin n, a i • E i ∧
          z = ∑ j : Fin n, b j • X j ∧
          a = C.mulVec b ∧ b = D.mulVec a)

end NumStability.Bhatia.Chapter01.Targets
