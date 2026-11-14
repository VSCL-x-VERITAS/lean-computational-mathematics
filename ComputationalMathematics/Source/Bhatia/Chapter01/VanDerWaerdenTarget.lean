/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Convex.DoublyStochasticMatrix
import Mathlib.LinearAlgebra.Matrix.Permanent

/-!
# Bhatia, Chapter I: unrestricted permanent bound in the Notes

This file contains only a transparent proposition for independent source
review. It supplies no proof or statement-acceptance authorization.
-/

set_option autoImplicit false

namespace NumStability.Bhatia.Chapter01.Targets

/-- Notes and References, printed pages 26–27: the inequality from
Problem I.6.14(iii) for every doubly stochastic matrix. -/
def vanDerWaerden : Prop :=
  ∀ n : ℕ, 0 < n → ∀ A : Matrix (Fin n) (Fin n) ℝ,
    A ∈ doublyStochastic ℝ (Fin n) →
      (n.factorial : ℝ) / (n : ℝ) ^ n ≤ Matrix.permanent A

end NumStability.Bhatia.Chapter01.Targets
