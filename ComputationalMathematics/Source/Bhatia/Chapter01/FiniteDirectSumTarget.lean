/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# Bhatia Chapter I: finite external direct sums

Transparent source target for I.3.finite-sums, printed 11/PDF 23, with the
binary column construction on printed 9/PDF 21 as operative context.
Independent statement review and proof acceptance are separate obligations.
-/

set_option autoImplicit false
universe u
open scoped BigOperators
namespace NumStability.Bhatia.Chapter01.Targets

/-- The prescribed finite-column construction for more than two summands.
For `j : Fin k`, the coordinate `j` represents printed coordinate `j.val + 1`.
The algebraic carrier is the dependent column type. The Hilbert carrier is its
actual library L2 realization; `column` is the fixed coordinate-preserving
linear equivalence to those columns, not supplied realization data. Each
summand may have dimension zero. -/
def finiteDirectSum : Prop :=
  (∀ (k : ℕ), 2 < k →
    ∀ (V : Fin k → Type u)
      [∀ j, AddCommGroup (V j)] [∀ j, Module ℂ (V j)]
      [∀ j, FiniteDimensional ℂ (V j)],
      (∀ (x y : (j : Fin k) → V j) (j : Fin k),
        (x + y) j = x j + y j) ∧
      (∀ (a : ℂ) (x : (j : Fin k) → V j) (j : Fin k),
        (a • x) j = a • x j)) ∧
  (∀ (k : ℕ), 2 < k →
    ∀ (H : Fin k → Type u)
      [∀ j, NormedAddCommGroup (H j)] [∀ j, InnerProductSpace ℂ (H j)]
      [∀ j, FiniteDimensional ℂ (H j)],
      let column : PiLp 2 H ≃ₗ[ℂ] ((j : Fin k) → H j) :=
        WithLp.linearEquiv 2 ℂ ((j : Fin k) → H j)
      (∀ (x y : PiLp 2 H) (j : Fin k),
        column (x + y) j = column x j + column y j) ∧
      (∀ (a : ℂ) (x : PiLp 2 H) (j : Fin k),
        column (a • x) j = a • column x j) ∧
      (∀ (x y : PiLp 2 H),
        inner ℂ x y = ∑ j : Fin k, inner ℂ (column x j) (column y j)))

end NumStability.Bhatia.Chapter01.Targets
