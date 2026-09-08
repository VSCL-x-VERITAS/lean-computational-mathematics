/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann

/-!
# LeVeque Chapter 1: hyperbolic Riemann problem data

The governing object is a first-order equation with its actual principal matrix,
state domain and forcing. Its spectral condition concerns that same matrix.
Initial data are constant on each strict half-line, leaving the origin free.

The prose describes a jump while equation (1.11) does not require distinct
states. Both the broad two-state family and its distinct-jump subfamily are
displayed explicitly. This records the boundary without deciding which family
the source names a Riemann problem. No existence, uniqueness or solution
regularity theorem is asserted by this problem-data characterization.
-/

namespace NumStability

/-- Hyperbolic initial data, with the distinct-jump boundary made explicit. -/
theorem leveque01_riemannProblem_iff_hyperbolicInitialData
    {m : ℕ} (problem : FirstOrderInitialValueProblem (Fin m)) :
    (problem.IsRiemann ↔
      ∃ leftState rightState,
        (∀ x t state, state ∈ problem.governing.admissibleStates →
          ∃ (eigenvalues : Fin m → ℝ)
              (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
            ∀ p, (problem.governing.principal x t state).mulVec (eigenbasis p) =
              eigenvalues p • eigenbasis p) ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
    (problem.IsJumpRiemann ↔
      ∃ leftState rightState,
        problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState) :=
  ⟨problem.isRiemann_iff, Iff.rfl⟩

end NumStability
