/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellPlaneWaveMatrixModel

/-!
# Proof-free target for LeVeque equation (2.118)
-/

namespace NumStability.Leveque02Tracer

/-- The printed matrix has the stated four entries and acts on the spatial
derivative of the ordered state `(E²,B³)` as required by equation (2.117). -/
def maxwellPlaneWaveMatrixTarget : Prop :=
  ∀ (permittivity permeability : ℝ),
    permittivity ≠ 0 → permeability ≠ 0 →
    (maxwellPlaneWaveCoefficient permittivity permeability =
        !![0, 1 / (permittivity * permeability); 1, 0] ∧
      (∀ spatialDerivative : Fin 2 → ℝ,
        (maxwellPlaneWaveCoefficient permittivity permeability).mulVec spatialDerivative =
          ![(1 / (permittivity * permeability)) * spatialDerivative 1,
            spatialDerivative 0]))

end NumStability.Leveque02Tracer
