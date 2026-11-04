/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredWholeLineL2Instability

/-!
# Proof-free target for centered-method instability in the physical two-norm

The scalar-advection realization follows the centered method (4.19) and its
explicitly referenced Exercise 8.1. The fixed positive time/space ratio satisfies
the scalar CFL constraint. At each positive mesh index, the actual bounded
centered operator acts on bilateral square-summable data; its coordinate formula
is the existing conservative centered-flux update.

Only failure of a uniform all-data bound through one fixed physical time is
selected. The initial datum may depend on the mesh. No fixed-datum nonconvergence,
universal nonlinear/system claim, exact growth formula, mesh-limit lemma or
zero-speed identity is an additional primary conclusion.
-/

namespace NumStability

noncomputable section

/-- The centered method fails uniform all-data fixed-time physical two-norm
stability even at a fixed nonzero CFL-satisfying Courant number. -/
def leveque04_centeredWholeLineL2Instability_target : Prop :=
  ∀ (speed ratio finalTime : ℝ),
    speed ≠ 0 → 0 < ratio → |speed * ratio| ≤ 1 → 0 < finalTime →
    ¬ ∃ bound : ℝ, 0 ≤ bound ∧ ∃ start : ℕ,
      ∀ N : ℕ, start ≤ N → 0 < N →
        let timeStep := finalTime / (N : ℝ)
        let width := finalTime / (ratio * (N : ℝ))
        ∀ n : ℕ, n ≤ N → ∀ u : lp (fun _ : ℤ => ℝ) 2,
          Real.sqrt width *
              ‖(leveque04_centeredWholeLineL2Step
                (speed * timeStep / width))^[n] u‖ ≤
            bound * (Real.sqrt width * ‖u‖)

end

end NumStability
