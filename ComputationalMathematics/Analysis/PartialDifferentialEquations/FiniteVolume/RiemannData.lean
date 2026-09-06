/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# One-dimensional Riemann data

Source-independent definitions for piecewise constant initial data with one
jump at the origin.  The predicate intentionally imposes no condition at the
origin, and `riemannData` exposes that free value as an explicit parameter.
-/

namespace NumStability

/-- A field has left state `leftState` on `x < 0` and right state `rightState`
on `x > 0`.  Its value at `x = 0` is deliberately unspecified. -/
def IsRiemannData
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) : Prop :=
  (∀ x : ℝ, x < 0 → data x = leftState) ∧
    (∀ x : ℝ, 0 < x → data x = rightState)

/-- Riemann data with an explicit, freely chosen value at the jump point. -/
noncomputable def riemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    ℝ → State :=
  fun x =>
    if x < 0 then leftState
    else if 0 < x then rightState
    else valueAtOrigin

/-- The parameterized construction satisfies the Riemann-data predicate. -/
theorem riemannData_isRiemannData
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    IsRiemannData
      (riemannData leftState valueAtOrigin rightState)
      leftState rightState := by
  constructor
  · intro x hx
    simp [riemannData, hx]
  · intro x hx
    have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
    simp [riemannData, hx, hnotLeft]

/-- The value of `riemannData` at the jump is exactly its free parameter. -/
@[simp]
theorem riemannData_zero
    {State : Type*} (leftState valueAtOrigin rightState : State) :
    riemannData leftState valueAtOrigin rightState 0 = valueAtOrigin := by
  simp [riemannData]

/-- The Riemann-data predicate characterizes exactly the functions obtained by
choosing an arbitrary value at the origin. -/
theorem isRiemannData_iff_exists_valueAtOrigin
    {State : Type*} (data : ℝ → State)
    (leftState rightState : State) :
    IsRiemannData data leftState rightState ↔
      ∃ valueAtOrigin,
        data = riemannData leftState valueAtOrigin rightState := by
  constructor
  · rintro ⟨hleft, hright⟩
    refine ⟨data 0, funext ?_⟩
    intro x
    rcases lt_trichotomy x 0 with hx | hx | hx
    · simpa [riemannData, hx] using hleft x hx
    · subst x
      simp
    · have hnotLeft : ¬ x < 0 := not_lt_of_ge (le_of_lt hx)
      simpa [riemannData, hx, hnotLeft] using hright x hx
  · rintro ⟨valueAtOrigin, rfl⟩
    exact riemannData_isRiemannData leftState valueAtOrigin rightState

end NumStability
