/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Topology.Instances.Matrix
import Mathlib.LinearAlgebra.Matrix.Charpoly.Basic
import Mathlib.Analysis.Complex.Basic

/-!
# Bhatia Chapter I: matrices with distinct eigenvalues are dense

Exercise I.2.5, printed page 7. A complex `n × n` matrix has `n` distinct
eigenvalues when its characteristic polynomial is `∏ᵢ (X - bᵢ)` for an injective
tuple `b`, i.e. its `n` characteristic roots, counted with multiplicity, are
pairwise distinct. The ambient topology is the library's topology on
`Matrix (Fin n) (Fin n) ℂ`, the product topology of the entries.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- For every size `n`, the complex matrices with `n` distinct eigenvalues are
dense in all complex `n × n` matrices. -/
def distinctEigenvalueMatricesDense : Prop :=
  ∀ n : ℕ,
    Dense {A : Matrix (Fin n) (Fin n) ℂ |
      ∃ b : Fin n → ℂ, Function.Injective b ∧
        A.charpoly = ∏ i : Fin n, (Polynomial.X - Polynomial.C (b i))}

end NumStability.Bhatia.Chapter01.Targets
