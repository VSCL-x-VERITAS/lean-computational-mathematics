/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.GramSchmidtOrtho

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997), Chapter I.1,
printed pages 2–3 (PDF pages 14–15): the dependent-input Gram–Schmidt
construction and completion with the same upper triangular coefficients. -/

set_option autoImplicit false
open scoped BigOperators

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- One normalized modified Gram–Schmidt realization for a dependent tuple,
followed by every orthonormal completion that keeps its nonzero columns.
The normalization selects one witness of the source's construction. -/
def qrDependentConstruction : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X : Fin n → H), ¬ LinearIndependent ℂ X →
      let dependent : Fin n → Prop :=
        fun k => X k ∈ Submodule.span ℂ (X '' Set.Iio k)
      let residual : (Fin n → H) → Fin n → H :=
        fun Y k => X k -
          ∑ i ∈ Finset.Iio k, (inner ℂ (Y i) (X k)) • Y i
      ∃ (Q0 : Fin n → H) (R : Matrix (Fin n) (Fin n) ℂ),
        (∃ k : Fin n, Q0 k = 0) ∧
        (∀ k : Fin n,
          (Q0 k = 0 ↔ dependent k) ∧
          (¬ dependent k →
            residual Q0 k ≠ 0 ∧
              Q0 k = (‖residual Q0 k‖ : ℂ)⁻¹ • residual Q0 k)) ∧
        Orthonormal ℂ (fun i : {i : Fin n // Q0 i ≠ 0} => Q0 i.val) ∧
        (∀ k : Fin n,
          Submodule.span ℂ (Q0 '' Set.Iic k) =
            Submodule.span ℂ (X '' Set.Iic k)) ∧
        (∀ i j : Fin n, j < i → R i j = 0) ∧
        (∀ i : Fin n, Q0 i = 0 → ∀ j : Fin n, R i j = 0) ∧
        (∀ j : Fin n, X j = ∑ i : Fin n, (R i j) • Q0 i) ∧
        (∃ Q : Fin n → H,
          Orthonormal ℂ Q ∧
          (∀ i : Fin n, Q0 i ≠ 0 → Q i = Q0 i) ∧
          Submodule.span ℂ (Set.range Q) = ⊤ ∧
          (∀ j : Fin n, X j = ∑ i : Fin n, (R i j) • Q i)) ∧
        (∀ Q : Fin n → H,
          Orthonormal ℂ Q →
          (∀ i : Fin n, Q0 i ≠ 0 → Q i = Q0 i) →
          ∀ j : Fin n, X j = ∑ i : Fin n, (R i j) • Q i)

end NumStability.Bhatia.Chapter01.Targets
