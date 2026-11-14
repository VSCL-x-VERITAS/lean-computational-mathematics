/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Exercise I.2.7, printed page 7 (PDF19),
with complex finite-dimensional conventions PDF13 and unitary definition PDF16.
-/
import Mathlib.LinearAlgebra.Matrix.ConjTranspose
import Mathlib.Topology.Compactness.Compact
import Mathlib.Topology.Instances.Complex
import Mathlib.Topology.Instances.Matrix

set_option autoImplicit false

open scoped Matrix

namespace NumStability.Bhatia.Chapter01.Targets

/-- The full unitary subset is compact in the usual topology on complex square
matrices, for every finite size including the empty-matrix case. -/
def unitaryCompact : Prop :=
  ∀ n : ℕ,
    IsCompact {U : Matrix (Fin n) (Fin n) ℂ |
      Uᴴ * U = (1 : Matrix (Fin n) (Fin n) ℂ) ∧
      U * Uᴴ = (1 : Matrix (Fin n) (Fin n) ℂ)}

end NumStability.Bhatia.Chapter01.Targets
