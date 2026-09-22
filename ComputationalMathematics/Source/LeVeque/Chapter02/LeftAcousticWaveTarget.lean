/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves

/-!
# Target for the general form of a pure left-going acoustic wave
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.60): pure left-going sound waves are exactly translated scalar
profiles multiplying the left acoustic eigenvector; wherever the scalar
profile is differentiable, the vector-profile derivative remains in that
eigendirection. -/
def leftAcousticWaveTarget : Prop :=
  ∀ (q : ℝ → ℝ → (Fin 2 → ℝ)) (density soundSpeed : ℝ),
    0 < density → 0 < soundSpeed →
    (IsPureEigenmodeWave q (-soundSpeed)
        (linearAcousticsLeftEigenvector density soundSpeed) ↔
      ∃ profile : ℝ → ℝ,
        q = eigenmodeTravelingWave profile (-soundSpeed)
          (linearAcousticsLeftEigenvector density soundSpeed) ∧
        (∀ x t,
          q x t = profile (x + soundSpeed * t) •
            linearAcousticsLeftEigenvector density soundSpeed) ∧
        ∀ ξ profile', HasDerivAt profile profile' ξ →
          HasDerivAt
            (fun z => profile z •
              linearAcousticsLeftEigenvector density soundSpeed)
            (profile' • linearAcousticsLeftEigenvector density soundSpeed) ξ)

end NumStability.Leveque02Tracer
