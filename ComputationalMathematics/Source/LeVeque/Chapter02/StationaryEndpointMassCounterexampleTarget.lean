/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LagrangianMassLabelModel
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target: the stationary-endpoint mass discrepancy

The prose after (2.102) identifies a particle's label with the mass from the
*initial* reference position to its later position. A uniform translation
keeps the mass between particles constant while moving the reference particle.
-/

open MeasureTheory

namespace NumStability.Leveque02Tracer

/-- Unit density translated at unit speed satisfies material mass conservation,
but the mass measured from the fixed initial reference position is not the
particle label at positive time. -/
def stationaryEndpointMassCounterexampleTarget : Prop :=
  let density : ℝ → ℝ → ℝ := fun _ _ => 1
  let position : ℝ → ℝ → ℝ := fun label time => label + time
  let label := lagrangianMassLabel (fun _ => (1 : ℝ)) 0 1
  (∀ ξ : ℝ, position ξ 0 = ξ) ∧
  (∀ ξ time : ℝ, HasDerivAt (fun τ => position ξ τ) 1 time) ∧
  (∀ x time : ℝ, 0 < density x time) ∧
  (∀ left right time : ℝ,
    ∫ x in position left time..position right time, density x time = right - left) ∧
  label = 1 ∧
  (∫ x in (0 : ℝ)..position label 1, density x 1) = 2 ∧
  (∫ x in position 0 1..position label 1, density x 1) = label ∧
  (∫ x in (0 : ℝ)..position label 1, density x 1) ≠ label

end NumStability.Leveque02Tracer
