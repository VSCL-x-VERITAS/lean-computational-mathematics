/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Data.Fin.VecNotation

/-!
# Spatial and temporal components for the charge-free Maxwell equation

Fields are three-component functions of position and time. Spatial partials
vary one coordinate at a time, keeping the other two and time fixed.
-/

namespace NumStability.Leveque02Tracer

/-- A three-component spatial vector. -/
abbrev MaxwellVector := Fin 3 → ℝ

/-- A time-dependent three-component spatial field. -/
abbrev MaxwellField := MaxwellVector → ℝ → MaxwellVector

/-- The ordinary time derivative of one field component. -/
noncomputable def maxwellTimePartial
    (field : MaxwellField) (component : Fin 3)
    (position : MaxwellVector) (time : ℝ) : ℝ :=
  deriv (fun τ => field position τ component) time

/-- The ordinary spatial derivative of one field component in one coordinate. -/
noncomputable def maxwellSpatialPartial
    (field : MaxwellField) (component direction : Fin 3)
    (position : MaxwellVector) (time : ℝ) : ℝ :=
  deriv (fun s => field (Function.update position direction s) time component)
    (position direction)

/-- Cartesian curl of a three-component field, with the standard right-hand
orientation. -/
noncomputable def maxwellCurl
    (field : MaxwellField) (position : MaxwellVector) (time : ℝ) : MaxwellVector :=
  ![maxwellSpatialPartial field 2 1 position time -
      maxwellSpatialPartial field 1 2 position time,
    maxwellSpatialPartial field 0 2 position time -
      maxwellSpatialPartial field 2 0 position time,
    maxwellSpatialPartial field 1 0 position time -
      maxwellSpatialPartial field 0 1 position time]

/-- Exactly the six component-direction pairs used by the Cartesian curl. -/
def MaxwellCurlUses (component direction : Fin 3) : Prop :=
  (component = 2 ∧ direction = 1) ∨
  (component = 1 ∧ direction = 2) ∨
  (component = 0 ∧ direction = 2) ∨
  (component = 2 ∧ direction = 0) ∨
  (component = 1 ∧ direction = 0) ∨
  (component = 0 ∧ direction = 1)

/-- Charge/current-free Ampère evolution at a space-time point:
`Dₜ - ∇ × H = 0`. -/
def IsMaxwellAmpereAt
    (electricDisplacement magneticField : MaxwellField)
    (position : MaxwellVector) (time : ℝ) : Prop :=
  (∀ component,
      HasDerivAt (fun τ => electricDisplacement position τ component)
        (maxwellTimePartial electricDisplacement component position time) time) ∧
  (∀ component direction, MaxwellCurlUses component direction →
      HasDerivAt
        (fun s => magneticField (Function.update position direction s) time component)
        (maxwellSpatialPartial magneticField component direction position time)
        (position direction)) ∧
  (fun i => maxwellTimePartial electricDisplacement i position time) =
    maxwellCurl magneticField position time

end NumStability.Leveque02Tracer
