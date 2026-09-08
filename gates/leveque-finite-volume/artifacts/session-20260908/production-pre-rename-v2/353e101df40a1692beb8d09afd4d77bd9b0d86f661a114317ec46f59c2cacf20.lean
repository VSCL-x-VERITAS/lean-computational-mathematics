/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Riemann

/-!
# LeVeque Chapter 1, Riemann initial-value configuration

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27).
-/

namespace NumStability

/-- Add the displayed two-state data to the selected hyperbolic evolution
equation. The equation is an independent predicate, so this definition retains
its solution convention and does not assert existence or choose a solver.
The same data construction is available for any equation predicate. -/
abbrev leveque01RiemannInitialConfiguration {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) : Prop :=
  IsRiemannInitialValueSolution evolutionEquation leftState rightState q

/-- A Riemann configuration is precisely the chosen equation together with
the left and right initial states. No origin value is prescribed. -/
theorem leveque01_riemannInitialConfiguration_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State) :
    leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q ↔
      evolutionEquation q ∧
        (∀ x, x < 0 → q x 0 = leftState) ∧
        (∀ x, 0 < x → q x 0 = rightState) :=
  isRiemannInitialValueSolution_iff evolutionEquation leftState rightState q

end NumStability
