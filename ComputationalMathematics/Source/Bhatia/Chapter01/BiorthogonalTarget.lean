/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.Matrix.ConjTranspose

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Bhatia I.1, PDF14 printed2: the defining biorthogonality condition for
an independent tuple in an arbitrary finite complex Hilbert space, followed
by its literal conjugate-transpose realization for standard complex columns.
The pointwise condition is the source definition of “Y biorthogonal to X”. -/
def biorthogonal : Prop :=
  (∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (k : ℕ) (X : Fin k → H),
    LinearIndependent ℂ X → ∀ (Y : Fin k → H),
      ((∀ i j : Fin k, inner ℂ (Y i) (X j) =
          (if i = j then 1 else 0 : ℂ)) ↔
        Matrix.of (fun i j : Fin k => inner ℂ (Y i) (X j)) =
          (1 : Matrix (Fin k) (Fin k) ℂ))) ∧
  (∀ (n k : ℕ) (X Y : Fin k → EuclideanSpace ℂ (Fin n)),
    LinearIndependent ℂ X →
      Matrix.of (fun i j : Fin k => inner ℂ (Y i) (X j)) =
        (Matrix.of (fun r i => Y i r)).conjTranspose *
          Matrix.of (fun r j => X j r))

end NumStability.Bhatia.Chapter01.Targets
