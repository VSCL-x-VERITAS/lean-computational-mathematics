import Mathlib.Algebra.BigOperators.Group.Finset.Basic
import Mathlib.Data.Real.Basic
import Mathlib.Data.Bool.Basic
import ComputationalMathematics.HDP.Probability.FiniteSignProducts
import Mathlib.Tactic.Linarith

/-!
Uncompiled ordinary algebra contract. This finite-product statement selects no
probability law or source interpretation. The existing paired-sign inequality
is the intended producer; no replacement proof of that producer is requested.
-/

set_option autoImplicit false

open scoped BigOperators

universe u

/-- Weak coordinatewise modes maximize the sum of the complementary products. -/
def ModalAlgebraClosedTarget : Prop :=
  ∀ (ι : Type u) (I : Finset ι) (p : ι → ℝ) (s d : ι → Bool),
    (∀ i ∈ I, 0 ≤ p i ∧ p i ≤ 1) →
    (∀ i ∈ I, if d i then 1 - p i ≤ p i else p i ≤ 1 - p i) →
    (∏ i ∈ I, if s i then p i else 1 - p i) +
        (∏ i ∈ I, if s i then 1 - p i else p i) ≤
      (∏ i ∈ I, if d i then p i else 1 - p i) +
        (∏ i ∈ I, if d i then 1 - p i else p i)
