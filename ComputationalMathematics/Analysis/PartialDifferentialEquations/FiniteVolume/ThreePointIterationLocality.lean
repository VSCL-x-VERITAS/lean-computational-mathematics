/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import Mathlib.Logic.Function.Iterate
import Mathlib.Data.Int.Cast.Basic
import Lean.Elab.Tactic.Omega
import Mathlib.Order.Interval.Set.Basic

/-!
# Finite dependence of three-point iterations

Equality of initial arrays on the closed integer radius-n window forces
equality after n steps at its center. The update can be nonlinear; it only
needs to read the center and its two neighboring cells.
-/

open Set
namespace NumStability

/-- An actual three-point update reads only the radius-n initial window after
n iterations. No linearity, monotonicity or stability assumption is needed. -/
theorem iterate_eq_of_threePoint_locality {E : Type*}
    (update : (ℤ → E) → ℤ → E)
    (hlocal : ∀ (left right : ℤ → E) (i : ℤ),
      left (i - 1) = right (i - 1) → left i = right i →
      left (i + 1) = right (i + 1) → update left i = update right i)
    (left right : ℤ → E) (steps : ℕ) (i : ℤ)
    (hagree : ∀ j ∈ Icc (i - (steps : ℤ)) (i + (steps : ℤ)), left j = right j) :
    (update^[steps] left) i = (update^[steps] right) i := by
  apply iterate_eq_of_centeredStencil_locality update 1
  · intro a b k hk
    apply hlocal
    · exact hk (k-1) (by constructor <;> omega)
    · exact hk k (by constructor <;> omega)
    · exact hk (k+1) (by constructor <;> omega)
  · simpa using hagree

end NumStability
