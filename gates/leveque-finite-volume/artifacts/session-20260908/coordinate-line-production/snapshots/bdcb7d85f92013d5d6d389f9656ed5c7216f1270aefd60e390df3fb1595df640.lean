/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CoordinateLineBalance
import ComputationalMathematics.Analysis.PartialDifferentialEquations.OperatorSplitting

/-!
# Successive conservative coordinate-line updates

The existing ordered operator sweep executes the supplied direction-duration
list. Each normal-flux rule reads its actual intermediate numerical state.
The two-stage mass identity retains both directional transfers; it does not
assert commutation, a high-resolution property, or a physical geometry.
-/

open scoped BigOperators

namespace NumStability.CoordinateLineBalance

variable {D E : Type*} [DecidableEq D] [AddCommGroup E] [Module ℝ E]

/-- Execute the conservative directional operators in the supplied order.
Each rule is reevaluated on its actual intermediate state. -/
noncomputable def sweep (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (stages : List (D × ℝ)) (state : (D → ℤ) → E) : (D → ℤ) → E :=
  orderedOperatorSweep (stages.map fun stage => advance volume rule stage.1 stage.2) state

/-- The remaining stages receive the state produced by the first directional update. -/
theorem sweep_cons (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d : D) (dt : ℝ) (stages : List (D × ℝ)) (state : (D → ℤ) → E) :
    sweep volume rule ((d, dt) :: stages) state =
      sweep volume rule stages (advance volume rule d dt state) := rfl

/-- The existing ordered sweep really feeds the first update into the second. -/
theorem sweep_two (volume : (D → ℤ) → ℝ)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → E) :
    sweep volume rule [(d, dt), (e, ds)] state =
      advance volume rule e ds (advance volume rule d dt state) :=
  orderedOperatorSweep_two _ _ _

/-- Successive directional mass changes use their respective current numerical states. -/
theorem sweep_two_mass_balance (volume : (D → ℤ) → ℝ)
    (hvolume : ∀ cell, 0 < volume cell)
    (rule : D → (D → ℤ) → ℝ → (ℤ → E) → E)
    (d e : D) (dt ds : ℝ) (state : (D → ℤ) → E) (cell : D → ℤ) :
    volume cell • sweep volume rule [(d, dt), (e, ds)] state cell =
      volume cell • state cell - dt • netOutwardFlux rule d dt state cell -
        ds • netOutwardFlux rule e ds (advance volume rule d dt state) cell := by
  rw [sweep_two, advance_mass_balance volume hvolume, advance_mass_balance volume hvolume]

end NumStability.CoordinateLineBalance
