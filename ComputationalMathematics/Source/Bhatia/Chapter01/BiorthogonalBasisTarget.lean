/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.LinearIndependent.Defs

/-! Proof-free targets for the two parts of Bhatia, *Matrix Analysis* (1997),
Exercise I.1.1, printed page 2 (PDF page 14). The vectors range over the
given finite-dimensional complex Hilbert space. -/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Every independent tuple has a biorthogonal tuple in the same Hilbert space. -/
def biorthogonalExists : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ) (X : Fin k → H),
    LinearIndependent ℂ X →
      ∃ Y : Fin k → H, ∀ i j : Fin k,
        inner ℂ (Y i) (X j) = (if i = j then 1 else 0 : ℂ)

/-- Biorthogonal tuples are unique when the independent tuple has full dimension. -/
def biorthogonalUnique : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (X : Fin (Module.finrank ℂ H) → H),
    LinearIndependent ℂ X →
      ∀ Y Z : Fin (Module.finrank ℂ H) → H,
        (∀ i j, inner ℂ (Y i) (X j) = (if i = j then 1 else 0 : ℂ)) →
        (∀ i j, inner ℂ (Z i) (X j) = (if i = j then 1 else 0 : ℂ)) →
        Y = Z

end NumStability.Bhatia.Chapter01.Targets
