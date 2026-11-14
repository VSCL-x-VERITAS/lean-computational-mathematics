/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.Matrix.Defs
import Mathlib.Logic.ExistsUnique

open scoped BigOperators

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.1, printed page 2 (PDF page 14): positive-diagonal QR uniqueness claim. -/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Bhatia I.1, PDF14 printed page 2: every independent dimension-length
tuple in an arbitrary finite complex inner product space has a unique QR pair
when the scalar factor is upper triangular with strictly positive real diagonal.
Tuple multiplication is stated pointwise as finite scalar synthesis in `H`. -/
def qrIndependent : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X : Fin n → H), LinearIndependent ℂ X →
      ∃! (qr : (Fin n → H) × Matrix (Fin n) (Fin n) ℂ),
        Orthonormal ℂ qr.1 ∧
          (∀ j : Fin n, X j = ∑ i : Fin n, qr.2 i j • qr.1 i) ∧
          (∀ i j : Fin n, j < i → qr.2 i j = 0) ∧
          (∀ j : Fin n, ∃ d : ℝ, 0 < d ∧ qr.2 j j = (d : ℂ))

end NumStability.Bhatia.Chapter01.Targets
