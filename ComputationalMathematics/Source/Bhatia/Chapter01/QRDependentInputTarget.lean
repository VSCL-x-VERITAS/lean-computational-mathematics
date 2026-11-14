/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.GramSchmidtOrtho

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997), Chapter I.1,
printed pages 2–3 (PDF pages 14–15): the dependent-input Gram–Schmidt
construction and orthonormal completion with unchanged coefficients. -/

set_option autoImplicit false
open scoped BigOperators

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The dependent-input construction produces an intermediate tuple with zero
columns, an upper triangular coefficient matrix with matching zero rows, and
then an orthonormal completion that preserves the same factorization. -/
def qrDependentInput : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X : Fin n → H), ¬ LinearIndependent ℂ X →
      let dependent := fun j => X j ∈ Submodule.span ℂ (X '' Set.Iio j)
      ∃ (Q0 : Fin n → H) (R : Matrix (Fin n) (Fin n) ℂ),
        let residual := fun j =>
          X j - ∑ i ∈ Finset.Iio j, (inner ℂ (Q0 i) (X j)) • Q0 i
        let tupleMul := fun (Y : Fin n → H) => fun j => ∑ i, (R i j) • Y i
        (∀ j, (Q0 j = 0 ↔ dependent j) ∧
          (¬ dependent j → Q0 j = (‖residual j‖ : ℂ)⁻¹ • residual j)) ∧
        Orthonormal ℂ (fun i : {i : Fin n // Q0 i ≠ 0} => Q0 i.val) ∧
        (∃ i, Q0 i = 0) ∧
        (∀ i j, j < i → R i j = 0) ∧
        (∀ i, Q0 i = 0 → ∀ j, R i j = 0) ∧
        X = tupleMul Q0 ∧
        (∃ (Q : Fin n → H),
          Orthonormal ℂ Q ∧
          (∀ i, Q0 i ≠ 0 → Q i = Q0 i) ∧
          Submodule.span ℂ (Set.range Q) = ⊤ ∧
          X = tupleMul Q)

end NumStability.Bhatia.Chapter01.Targets
