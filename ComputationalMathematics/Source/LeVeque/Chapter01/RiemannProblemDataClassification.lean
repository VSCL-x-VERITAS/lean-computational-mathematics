/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.FirstOrderRiemann

/-!
# LeVeque Chapter 1: positive-dimensional Riemann problem data

Section 1.2.1, printed page 5 (raw PDF page 27), describes a hyperbolic equation
and two constant initial half-lines. The prose calls the data a jump while
(1.11) does not require distinct states or specify the value at the interface.

Under the user's goal to unblock the remaining rows, the coordinator selected
Q9: positive-dimensional first-order systems `q_t + A(x,t,q) q_x = g(x,t,q)`,
hyperbolic on their declared state domain, with equal side states included as
a degenerate case. This is a coordinator-selected convention, not a literal
detailed user answer or an explicit specification of the full class in the
book. The record is `unblock-nine-20260908/selected-interpretations.json` in
the session artifacts. The original source ambiguities remain disclosed.

The same principal matrix supplies the actual residual and spectral condition.
The interface value is free even in the equal-side case. This classifies
problem data without asserting solution existence, uniqueness or regularity.
Fresh independent auditing is required; compilation is not acceptance.
-/

namespace NumStability

open FirstOrderInitialValueProblem

/-- The selected first-order problem-data classification and its explicit
equal-state and distinct-jump constructor branches. -/
theorem leveque01_riemannProblemDataClassification {m : ℕ}
    (problem : FirstOrderInitialValueProblem (Fin (m + 1))) :
    (problem.IsRiemann ↔
      (∃ leftState rightState,
        problem.governing.IsHyperbolic ∧
        leftState ∈ problem.governing.admissibleStates ∧
        rightState ∈ problem.governing.admissibleStates ∧
        (∀ x, x < 0 → problem.initialState x = leftState) ∧
        (∀ x, 0 < x → problem.initialState x = rightState)) ∧
      (∀ x t state qt qx,
        problem.governing.residual x t state qt qx = 0 ↔
          qt + (problem.governing.principal x t state).mulVec qx =
            problem.governing.forcing x t state)) ∧
    (problem.IsJumpRiemann ↔
      ∃ leftState rightState,
        problem.IsRiemannWithStates leftState rightState ∧ leftState ≠ rightState) ∧
    (∀ (leftState origin rightState : Fin (m + 1) → ℝ),
      problem.governing.IsHyperbolic →
      leftState ∈ problem.governing.admissibleStates →
      rightState ∈ problem.governing.admissibleStates →
      (fromStates problem.governing leftState origin rightState).IsRiemannWithStates
          leftState rightState ∧
      (leftState = rightState →
        ¬ (fromStates problem.governing leftState origin rightState).IsJumpRiemann) ∧
      (leftState ≠ rightState →
        (fromStates problem.governing leftState origin rightState).IsJumpRiemann)) := by
  refine ⟨problem.isRiemann_characterization, Iff.rfl, ?_⟩
  intro leftState origin rightState hhyper hleft hright
  refine ⟨fromStates_isRiemannWithStates problem.governing hhyper _ _ _ hleft hright, ?_,
    fromStates_isJumpRiemann problem.governing hhyper _ _ _ hleft hright⟩
  intro hequal
  subst rightState
  exact fromEqualStates_not_isJumpRiemann problem.governing leftState origin

end NumStability
