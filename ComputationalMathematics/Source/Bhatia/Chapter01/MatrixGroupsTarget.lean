/-
SPDX-License-Identifier: MIT
-/
import Mathlib.LinearAlgebra.Matrix.GeneralLinearGroup.Defs
import Mathlib.LinearAlgebra.UnitaryGroup
import Mathlib.Analysis.Complex.Basic

/-!
# Bhatia Chapter I: the general linear and unitary groups

Exercise I.2.7, printed page 7, says that the invertible and the unitary
`n × n` complex matrices form groups under matrix multiplication, called
`GL(n)` and `U(n)`. The target states the group laws for both sets with the
ordinary matrix product, identity and inverse, and identifies the two sets with
the library's general linear and unitary groups.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- For every size `n`, the invertible complex matrices and the unitary complex
matrices each contain the identity, are closed under matrix products and matrix
inverses, multiply associatively, and have the matrix inverse as a two-sided
inverse; they are the carriers of `GL (Fin n) ℂ` and `Matrix.unitaryGroup`. -/
def matrixGroupsUnderMultiplication : Prop :=
  ∀ n : ℕ,
    (let S : Set (Matrix (Fin n) (Fin n) ℂ) := {A | IsUnit A}
     (1 : Matrix (Fin n) (Fin n) ℂ) ∈ S ∧
     (∀ A ∈ S, ∀ B ∈ S, A * B ∈ S) ∧
     (∀ A ∈ S, ∀ B ∈ S, ∀ C ∈ S, A * B * C = A * (B * C)) ∧
     (∀ A ∈ S, A⁻¹ ∈ S ∧ A⁻¹ * A = 1 ∧ A * A⁻¹ = 1) ∧
     Set.range (fun g : GL (Fin n) ℂ => (g : Matrix (Fin n) (Fin n) ℂ)) = S) ∧
    (let U : Set (Matrix (Fin n) (Fin n) ℂ) :=
       {A | A * A.conjTranspose = 1 ∧ A.conjTranspose * A = 1}
     (1 : Matrix (Fin n) (Fin n) ℂ) ∈ U ∧
     (∀ A ∈ U, ∀ B ∈ U, A * B ∈ U) ∧
     (∀ A ∈ U, ∀ B ∈ U, ∀ C ∈ U, A * B * C = A * (B * C)) ∧
     (∀ A ∈ U, A⁻¹ ∈ U ∧ A⁻¹ * A = 1 ∧ A * A⁻¹ = 1) ∧
     (Matrix.unitaryGroup (Fin n) ℂ : Set (Matrix (Fin n) (Fin n) ℂ)) = U)

end NumStability.Bhatia.Chapter01.Targets
