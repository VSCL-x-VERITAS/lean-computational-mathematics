/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData

/-!
# LeVeque Chapter 1, Equation (1.11)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 5 (raw PDF page 27), equation (1.11).  The displayed Riemann data
specifies `q_l` for `x < 0` and `q_r` for `x > 0`; it does not choose a value at
the jump point `x = 0`.
-/

namespace NumStability

/-- Equation (1.11) as a predicate on an `m`-component initial state.  There is
intentionally no condition at `x = 0`. -/
abbrev leveque01Equation11RiemannData {m : ℕ}
    (initialState : ℝ → (Fin m → ℝ))
    (leftState rightState : Fin m → ℝ) : Prop :=
  IsRiemannData initialState leftState rightState

/-- For every freely chosen value at the origin, the parameterized initial
state has the two branches printed in equation (1.11), and takes precisely that
chosen value at `x = 0`. -/
theorem leveque01_equation11_riemannData {m : ℕ}
    (leftState valueAtOrigin rightState : Fin m → ℝ) :
    leveque01Equation11RiemannData
        (riemannData leftState valueAtOrigin rightState)
        leftState rightState ∧
      riemannData leftState valueAtOrigin rightState 0 = valueAtOrigin := by
  exact ⟨riemannData_isRiemannData leftState valueAtOrigin rightState,
    riemannData_zero leftState valueAtOrigin rightState⟩

/-- Equation (1.11) permits exactly one free datum: the value at the origin. -/
theorem leveque01_equation11_characterization {m : ℕ}
    (initialState : ℝ → (Fin m → ℝ))
    (leftState rightState : Fin m → ℝ) :
    leveque01Equation11RiemannData initialState leftState rightState ↔
      ∃ valueAtOrigin,
        initialState = riemannData leftState valueAtOrigin rightState :=
  isRiemannData_iff_exists_valueAtOrigin initialState leftState rightState

end NumStability
