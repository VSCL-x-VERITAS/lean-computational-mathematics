/-
SPDX-License-Identifier: MIT
-/

/-
Scratch field-level target for LeVeque Chapter 2, C2.U.055, raw PDF pp. 66–67.
The printed case propagates in the x direction. The directional Maxwell symbol
allows the same plane-wave assertion in any spatial direction.
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPropagatingModeGeometryTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellFaradayModel
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDivergenceModel

/-!
# LeVeque Chapter 2: MaxwellPropagatingPlaneWaveTarget

Target for a propagating Maxwell plane-wave construction.
-/

namespace NumStability.Leveque02Tracer

/-- Phase of a planar travelling wave. -/
def maxwellWavePhase (direction position : MaxwellVector) (speed time : ℝ) : ℝ :=
  dotProduct direction position - speed * time

/-- A vector field with constant polarization and a differentiable scalar
profile travelling along `direction` with phase speed `speed`. -/
def maxwellDirectionalPlaneWave (profile : ℝ → ℝ)
    (direction vector : MaxwellVector) (speed : ℝ) : MaxwellField :=
  fun position time i =>
    profile (maxwellWavePhase direction position speed time) * vector i

/-- A nonstationary eigenpolarization of the physical six-state Maxwell symbol
generates a classical, source-free plane-wave solution of (2.115). At every
space-time point, both fields are transverse to the propagation direction and
    mutually orthogonal. The profile may have either polarization and any
    everywhere-differentiable shape. -/
def maxwellPropagatingPlaneWaveTarget : Prop :=
  ∀ (permittivity permeability : ℝ) (direction : MaxwellVector)
    (speed : ℝ) (state : MaxwellStateIndex → ℝ) (profile : ℝ → ℝ),
    0 < permittivity → 0 < permeability → speed ≠ 0 →
    Module.End.HasEigenvector
      (Matrix.toLin' (maxwellDirectionalMatrix permittivity permeability direction))
      speed state →
    (∀ s, HasDerivAt profile (deriv profile s) s) →
    let electric := maxwellDirectionalPlaneWave profile direction (state ∘ Sum.inl) speed
    let magnetic := maxwellDirectionalPlaneWave profile direction (state ∘ Sum.inr) speed
    (∀ position time component,
      maxwellTimePartial electric component position time -
        (1 / (permittivity * permeability)) *
          maxwellCurl magnetic position time component = 0) ∧
    (∀ position time component,
      maxwellTimePartial magnetic component position time +
        maxwellCurl electric position time component = 0) ∧
    (∀ position time,
      IsMaxwellDivergenceFreeAt electric position time ∧
      IsMaxwellDivergenceFreeAt magnetic position time) ∧
    (∀ position time,
      dotProduct direction (electric position time) = 0 ∧
      dotProduct direction (magnetic position time) = 0 ∧
      dotProduct (electric position time) (magnetic position time) = 0)

end NumStability.Leveque02Tracer
