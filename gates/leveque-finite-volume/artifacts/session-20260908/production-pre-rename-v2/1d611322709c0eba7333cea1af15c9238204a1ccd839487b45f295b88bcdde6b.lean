/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.SelfSimilarity
import ComputationalMathematics.Source.LeVeque.Chapter01.RiemannInitialConfiguration

/-!
# LeVeque Chapter 1, the selected Riemann value on ray zero

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 11 (raw PDF page 33).
-/

namespace NumStability

/-- Ray-zero value for an independently selected Riemann similarity solution.
Its time-one profile determines the trace convention. -/
abbrev leveque01RiemannRayZeroValue {State : Type*}
    (q : ℝ → ℝ → State) : State :=
  similarityRayValue q 0

/-- The notation denotes the value on the entire positive-time ray x/t=0.
Initial data and the evolution equation are retained for the selected field;
uniqueness between different selected fields is not a premise or conclusion. -/
theorem leveque01_riemannRayZeroValue_iff {State : Type*}
    (evolutionEquation : (ℝ → ℝ → State) → Prop)
    (leftState rightState : State) (q : ℝ → ℝ → State)
    (_hriemann : leveque01RiemannInitialConfiguration evolutionEquation leftState rightState q)
    (hself : IsPositiveTimeSelfSimilar q) (value : State) :
    leveque01RiemannRayZeroValue q = value ↔ ∀ t, 0 < t → q 0 t = value := by
  simpa only [leveque01RiemannRayZeroValue, zero_mul] using hself.rayValue_iff 0 value

end NumStability
