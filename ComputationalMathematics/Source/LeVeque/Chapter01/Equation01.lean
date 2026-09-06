/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# LeVeque Chapter 1, Equation (1.1)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23), equation (1.1).
-/

namespace NumStability

/-- Equation (1.1): a real `m`-component field satisfies
`q_t + A q_x = 0` at `(x, t)` for a constant real `m`-by-`m` matrix `A`. -/
abbrev leveque01_equation01_constantLinearSystemAt
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ) : Prop :=
  IsConstantCoefficientLinearSystemSolutionAt q coefficient x t

/-- The pointwise predicate for equation (1.1), expanded into its time
derivative, space derivative, and zero-residual clauses. -/
theorem leveque01_equation01_constantLinearSystemAt_iff
    {m : ℕ} (q : ℝ → ℝ → (Fin m → ℝ))
    (coefficient : Matrix (Fin m) (Fin m) ℝ) (x t : ℝ) :
    leveque01_equation01_constantLinearSystemAt q coefficient x t ↔
      ∃ qt qx : Fin m → ℝ,
        HasDerivAt (fun τ => q x τ) qt t ∧
          HasDerivAt (fun ξ => q ξ t) qx x ∧
            qt + coefficient.mulVec qx = 0 :=
  Iff.rfl

/-- Equation (1.1): every proof-carrying constant-coefficient system asserts
the displayed PDE globally on `ℝ × ℝ`. This theorem is deliberately not a
definitional `P ↔ P`: its conclusion is the equation required of the system's
unknown state. -/
theorem leveque01_equation01_constantLinearSystem
    {m : ℕ} {coefficient : Matrix (Fin m) (Fin m) ℝ}
    (system : ConstantCoefficientLinearSystemSolution coefficient) :
    ∀ x t, ∃ qt qx : Fin m → ℝ,
      HasDerivAt (fun τ => system.state x τ) qt t ∧
        HasDerivAt (fun ξ => system.state ξ t) qx x ∧
          qt + coefficient.mulVec qx = 0 := by
  intro x t
  exact system.satisfies x t

end NumStability
