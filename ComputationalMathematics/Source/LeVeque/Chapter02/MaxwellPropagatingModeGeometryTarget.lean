/-
SPDX-License-Identifier: MIT
-/

/-
Scratch statement for LeVeque Chapter 2, C2.U.055 (raw PDF pages 66–67).
The printed discussion concerns one propagating electromagnetic plane wave.
This target allows both transverse polarizations and any spatial direction.
The nonzero eigenvalue excludes stationary longitudinal modes.
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicityTarget
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# LeVeque Chapter 2: MaxwellPropagatingModeGeometryTarget

Target for the geometry of propagating Maxwell modes.
-/

namespace NumStability.Leveque02Tracer

/-- Every nonstationary eigenmode of the full six-state directional Maxwell
symbol has electric and magnetic vectors transverse to its propagation
direction and orthogonal to each other. -/
def maxwellPropagatingModeGeometryTarget : Prop :=
  ∀ (permittivity permeability : ℝ) (direction : MaxwellVector)
    (speed : ℝ) (state : MaxwellStateIndex → ℝ),
    0 < permittivity → 0 < permeability → speed ≠ 0 →
    Module.End.HasEigenvector
      (Matrix.toLin' (maxwellDirectionalMatrix permittivity permeability direction))
      speed state →
    let electric : MaxwellVector := state ∘ Sum.inl
    let magnetic : MaxwellVector := state ∘ Sum.inr
    dotProduct direction electric = 0 ∧
      dotProduct direction magnetic = 0 ∧
      dotProduct electric magnetic = 0

end NumStability.Leveque02Tracer
