import Mathlib.Data.Finset.Max
import Mathlib.Data.Matrix.Basic
import Mathlib.Data.Real.Basic

/-!
# Quadratic optimization over sign vectors

This file provides the finite integer-optimization object used by the
Grothendieck and maximum-cut applications.
-/

namespace NumStability.HDP.Optimization

open scoped BigOperators

/-- A two-valued sign. -/
inductive Sign
  | neg
  | pos
  deriving DecidableEq

instance : Fintype Sign :=
  ⟨{Sign.neg, Sign.pos}, fun x ↦ by cases x <;> simp⟩

instance : Nonempty Sign := ⟨Sign.pos⟩

/-- The real value represented by a sign. -/
def Sign.value : Sign → ℝ
  | .neg => -1
  | .pos => 1

@[simp] theorem Sign.value_neg : Sign.neg.value = (-1 : ℝ) := rfl
@[simp] theorem Sign.value_pos : Sign.pos.value = (1 : ℝ) := rfl

/-- A sign vector with `n` coordinates. -/
abbrev SignVector (n : ℕ) := Fin n → Sign

/-- The quadratic objective `∑ i, j, Aᵢⱼ xᵢ xⱼ` at a sign vector. -/
def signQuadraticValue {n : ℕ} (A : Matrix (Fin n) (Fin n) ℝ)
    (x : SignVector n) : ℝ :=
  ∑ i, ∑ j, A i j * (x i).value * (x j).value

/-- The maximum quadratic objective over all sign vectors. -/
noncomputable def signQuadraticMaximum {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  Finset.univ.sup' Finset.univ_nonempty (signQuadraticValue A)

theorem signQuadraticValue_le_maximum {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) (x : SignVector n) :
    signQuadraticValue A x ≤ signQuadraticMaximum A := by
  simpa [signQuadraticMaximum] using
    (Finset.le_sup' (signQuadraticValue A) (Finset.mem_univ x))

theorem exists_signQuadraticValue_eq_maximum {n : ℕ}
    (A : Matrix (Fin n) (Fin n) ℝ) :
    ∃ x : SignVector n, signQuadraticValue A x = signQuadraticMaximum A := by
  obtain ⟨x, _, hx⟩ :=
    Finset.exists_mem_eq_sup' (s := (Finset.univ : Finset (SignVector n)))
      Finset.univ_nonempty (signQuadraticValue A)
  exact ⟨x, hx.symm⟩

end NumStability.HDP.Optimization
