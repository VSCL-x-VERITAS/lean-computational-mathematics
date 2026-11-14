/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Orthonormal
import Mathlib.LinearAlgebra.Dimension.Finrank
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.LinearIndependent.Defs
import Mathlib.LinearAlgebra.Span.Defs

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.1, printed page 2 (PDF page 14): Gram-Schmidt prefix-span claim. -/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Bhatia I.1, PDF14 printed page 2: an independent tuple of length
`dim ℂ H` has an orthonormal tuple preserving each initial linear span.
The ambient complex inner product space is arbitrary. -/
def gramSchmidt : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X : Fin n → H), LinearIndependent ℂ X →
      ∃ (Q : Fin n → H),
        Orthonormal ℂ Q ∧
          ∀ (k : ℕ), 1 ≤ k → k ≤ n →
            Submodule.span ℂ {x : H | ∃ i : Fin n, i.val < k ∧ X i = x} =
              Submodule.span ℂ {x : H | ∃ i : Fin n, i.val < k ∧ Q i = x}

end NumStability.Bhatia.Chapter01.Targets
