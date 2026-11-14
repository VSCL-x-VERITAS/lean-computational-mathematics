/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.GramSchmidtOrtho

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.1, printed pages 2–3 (PDF pages 14–15): the prescribed dependent
Gram-Schmidt construction and orthonormal completion with unchanged coefficients. -/

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Modified Gram-Schmidt in an arbitrary finite-dimensional complex inner
product space, including its zero columns, zero coefficient rows, and completion. -/
def qrDependent : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H],
    let n := Module.finrank ℂ H
    ∀ (X : Fin n → H),
      let Q0 := InnerProductSpace.gramSchmidtNormed ℂ X
      let R : Matrix (Fin n) (Fin n) ℂ := fun i j => inner ℂ (Q0 i) (X j)
      let dependent := fun j => X j ∈ Submodule.span ℂ (X '' Set.Iio j)
      let residual := fun j => X j - ∑ i ∈ Finset.Iio j, (inner ℂ (Q0 i) (X j)) • Q0 i
      let tupleMul := fun (Y : Fin n → H) => fun j => ∑ i, (R i j) • Y i
      (∀ j, (Q0 j = 0 ↔ dependent j) ∧
        (¬ dependent j → Q0 j = (‖residual j‖ : ℂ)⁻¹ • residual j)) ∧
      Orthonormal ℂ (fun i : {i : Fin n // Q0 i ≠ 0} => Q0 i.val) ∧
      (∀ i j, j < i → R i j = 0) ∧
      (∀ i, Q0 i = 0 → ∀ j, R i j = 0) ∧
      X = tupleMul Q0 ∧
      (∃ (Q : Fin n → H),
        Orthonormal ℂ Q ∧
        (∀ i, Q0 i ≠ 0 → Q i = Q0 i) ∧
        Submodule.span ℂ (Set.range Q) = ⊤ ∧ X = tupleMul Q)

end NumStability.Bhatia.Chapter01.Targets
