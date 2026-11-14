/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), I.5, printed 20 / PDF 32.
Proof-free source target; statement auditing and proof are separate.
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.InnerProductSpace.GramMatrix
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
Matrix.gram is the single actual entrywise Gram producer. The determinant below
is the determinant of that same matrix, with its complex value retained.
The coordinate clause uses the actual isometric coordinate representation of
every supplied orthonormal basis; it introduces no second Gram producer.
All finite tuple lengths are included. For k=0 the unique empty matrix has
its conventional determinant 1. This is an explicit boundary extension under
the campaign's all-finite-size convention; the source does not discuss k=0.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Gram determinant of the same canonical Gram matrix of the ordered tuple. -/
noncomputable def gramDeterminant {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (x : Fin k → H) : ℂ :=
  Matrix.det (Matrix.gram ℂ x)

/-- Both source definitions, together with the actual column-coordinate meaning
of XᴴX and the explicitly selected empty-tuple convention. -/
def gramDefinitionTarget : Prop :=
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (x : Fin k → H),
    (∀ i j : Fin k, (Matrix.gram ℂ x) i j = inner ℂ (x i) (x j)) ∧
    gramDeterminant k x = Matrix.det (Matrix.gram ℂ x) ∧
    (∀ (n : ℕ) (b : OrthonormalBasis (Fin n) ℂ H),
      let X : Matrix (Fin n) (Fin k) ℂ := fun i j => b.repr (x j) i
      Matrix.gram ℂ x = X.conjTranspose * X)) ∧
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (x : Fin 0 → H),
    gramDeterminant 0 x = 1)

end NumStability.Bhatia.Chapter01.Targets
