/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellConstantMedium
import Mathlib.Analysis.Matrix.Spectrum
import Mathlib.LinearAlgebra.CrossProduct

/-!
# Full three-dimensional Maxwell directional symbols

The state index has three electric and three magnetic coordinates. For a
direction `n`, `maxwellCrossMatrix n` represents `v ↦ n × v`.
-/

namespace NumStability.Leveque02Tracer

abbrev MaxwellStateIndex := Fin 3 ⊕ Fin 3

/-- Matrix of the cross product with a fixed spatial direction. -/
def maxwellCrossMatrix (direction : MaxwellVector) : Matrix (Fin 3) (Fin 3) ℝ :=
  !![0, -direction 2, direction 1;
     direction 2, 0, -direction 0;
     -direction 1, direction 0, 0]

/-- The six-state principal symbol of the printed constant-medium equations
`Eₜ - (1/(εμ)) curl B = 0`, `Bₜ + curl E = 0`. -/
noncomputable def maxwellDirectionalMatrix
    (permittivity permeability : ℝ) (direction : MaxwellVector) :
    Matrix MaxwellStateIndex MaxwellStateIndex ℝ :=
  Matrix.fromBlocks 0
    (-(1 / (permittivity * permeability)) • maxwellCrossMatrix direction)
    (maxwellCrossMatrix direction) 0

/-- Wave-speed scaling used to symmetrize the directional symbol. -/
noncomputable def maxwellDirectionalSpeed
    (permittivity permeability : ℝ) : ℝ :=
  Real.sqrt (1 / (permittivity * permeability))

/-- The symmetric six-state symbol after positive electric-field scaling. -/
noncomputable def maxwellNormalizedDirectionalMatrix
    (permittivity permeability : ℝ) (direction : MaxwellVector) :
    Matrix MaxwellStateIndex MaxwellStateIndex ℝ :=
  let speed := maxwellDirectionalSpeed permittivity permeability
  Matrix.fromBlocks 0 (-(speed • maxwellCrossMatrix direction))
    (speed • maxwellCrossMatrix direction) 0

end NumStability.Leveque02Tracer
