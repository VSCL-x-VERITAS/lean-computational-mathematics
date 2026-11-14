/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Topology.Instances.Matrix
import Mathlib.Analysis.Complex.Basic

/-!
# Bhatia Chapter I: topology of the invertible and unitary matrices

Exercise I.2.7, printed page 7: the invertible matrices form a dense open subset
of all `n × n` matrices, and the unitary matrices form a compact subset. The
ambient topology is the library's topology on `Matrix (Fin n) (Fin n) ℂ`, the
product topology of the entries, which is the usual finite-dimensional topology.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- For every size `n`, the invertible complex `n × n` matrices form a dense
open subset of all complex `n × n` matrices. -/
def invertibleMatricesDenseOpen : Prop :=
  ∀ n : ℕ,
    Dense {A : Matrix (Fin n) (Fin n) ℂ | IsUnit A} ∧
    IsOpen {A : Matrix (Fin n) (Fin n) ℂ | IsUnit A}

/-- For every size `n`, the unitary complex `n × n` matrices, those with
`A Aᴴ = 1` and `Aᴴ A = 1`, form a compact subset of all complex `n × n`
matrices. -/
def unitaryMatricesCompact : Prop :=
  ∀ n : ℕ,
    IsCompact {A : Matrix (Fin n) (Fin n) ℂ |
      A * A.conjTranspose = 1 ∧ A.conjTranspose * A = 1}

end NumStability.Bhatia.Chapter01.Targets
