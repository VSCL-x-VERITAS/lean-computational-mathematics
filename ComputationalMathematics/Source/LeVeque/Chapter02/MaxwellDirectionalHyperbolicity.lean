/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicityTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalSymmetrizer

/-!
# Hyperbolicity of the full constant-medium Maxwell system
-/

namespace NumStability.Leveque02Tracer

/-- The physical six-state directional symbol has a real eigenbasis in every
direction when both material coefficients are positive. -/
theorem maxwellDirectionalHyperbolicity :
    maxwellDirectionalHyperbolicityTarget := by
  intro permittivity permeability hpermittivity hpermeability direction
  let speed := maxwellDirectionalSpeed permittivity permeability
  have hspeed_pos : 0 < speed := by
    dsimp [speed, maxwellDirectionalSpeed]
    exact Real.sqrt_pos.2 (by positivity)
  have hspeed_ne : speed ≠ 0 := ne_of_gt hspeed_pos
  have hsymm :
      (maxwellNormalizedDirectionalMatrix
        permittivity permeability direction).IsSymm :=
    maxwellNormalizedDirectionalMatrix_symm
      permittivity permeability direction
  have hnormalized : NumStability.IsRealHyperbolicMatrix
      (maxwellNormalizedDirectionalMatrix
        permittivity permeability direction) :=
    NumStability.IsRealHyperbolicMatrix.of_symm hsymm
  have hphysical : NumStability.IsRealHyperbolicMatrix
      (maxwellDirectionalMatrix permittivity permeability direction) :=
    NumStability.IsRealHyperbolicMatrix.of_similar
      (T := maxwellElectricUnscale speed)
      (U := maxwellElectricScale speed)
      (maxwellElectricUnscale_mul_scale speed hspeed_ne)
      (maxwellElectricScale_mul_unscale speed hspeed_ne)
      (maxwellDirectionalMatrix_similarity
        permittivity permeability hpermittivity hpermeability direction)
      hnormalized
  refine ⟨hphysical, ?_⟩
  intro state component
  constructor
  · simp [maxwellDirectionalMatrix, Matrix.fromBlocks_mulVec,
      maxwellCrossMatrix_mulVec, Matrix.smul_mulVec]
  · simp [maxwellDirectionalMatrix, Matrix.fromBlocks_mulVec,
      maxwellCrossMatrix_mulVec, Matrix.smul_mulVec]

end NumStability.Leveque02Tracer
