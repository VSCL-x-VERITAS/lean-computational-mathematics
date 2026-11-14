/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.RowCol

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.1, printed page 2 (PDF page 14). Vectors are columns in the same
complex coordinate space. The inner product is scalar-valued; the outer
product is a square matrix with the adjoint on its second vector. -/

namespace NumStability.Bhatia.Chapter01.Targets

/-- The scalar and matrix products of two complex column vectors. -/
def outerProduct : Prop :=
  ∀ (n : ℕ) (u v : Fin n → ℂ),
    ((Matrix.replicateCol (Fin 1) u).conjTranspose *
        Matrix.replicateCol (Fin 1) v) 0 0 =
      dotProduct (fun i => star (u i)) v ∧
    Matrix.replicateCol (Fin 1) u *
        (Matrix.replicateCol (Fin 1) v).conjTranspose =
      Matrix.vecMulVec u (fun j => star (v j))

end NumStability.Bhatia.Chapter01.Targets
