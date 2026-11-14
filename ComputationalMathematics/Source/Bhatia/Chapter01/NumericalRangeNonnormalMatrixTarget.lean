/-
SPDX-License-Identifier: MIT
-/
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.Complex.Basic

/-!
# Bhatia Chapter I: a nonnormal matrix with a large numerical range

Exercise I.2.9(i), printed page 8: for nonnormal matrices, `W(A)` may be bigger
than the convex hull of the eigenvalues. For a complex `n × n` matrix `A`, `ℂⁿ`
carries the inner product `⟨u, v⟩ = u* v` (printed page 1), so
`W(A) = {x* A x : x* x = 1}`. Eigenvalues are scalars `λ` with `A v = λ v` for
some `v ≠ 0`, normal means `A A* = A* A`, and the convex hull is the real convex
hull in `ℂ`.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- Some nonnormal complex square matrix has a numerical range strictly bigger
than the convex hull of its eigenvalues. -/
def numericalRangeNonnormalMatrixStrict : Prop :=
  ∃ (n : ℕ) (A : Matrix (Fin n) (Fin n) ℂ),
    A * A.conjTranspose ≠ A.conjTranspose * A ∧
      convexHull ℝ {lam : ℂ | ∃ v : Fin n → ℂ, v ≠ 0 ∧ A.mulVec v = lam • v} ⊂
        {z : ℂ | ∃ x : Fin n → ℂ, star x ⬝ᵥ x = 1 ∧ z = star x ⬝ᵥ A.mulVec x}

end NumStability.Bhatia.Chapter01.Targets
