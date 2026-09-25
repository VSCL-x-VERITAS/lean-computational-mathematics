/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Pure right-going acoustic waves
-/

namespace NumStability.Leveque02Tracer

/-- The right-going counterpart of the discussion after Equation (2.61):
a pure wave is a translated multiple of the right eigenvector, and its
pressure perturbation is impedance times its velocity perturbation. -/
def rightAcousticWaveTarget : Prop :=
  ∀ (q : ℝ → ℝ → (Fin 2 → ℝ)) (density soundSpeed : ℝ),
    0 < density → 0 < soundSpeed →
      (IsPureEigenmodeWave q soundSpeed
          (linearAcousticsRightEigenvector density soundSpeed) ↔
        ∃ profile : ℝ → ℝ,
          q = eigenmodeTravelingWave profile soundSpeed
            (linearAcousticsRightEigenvector density soundSpeed) ∧
          ∀ x t,
            q x t (0 : Fin 2) =
                acousticImpedance density soundSpeed *
                  profile (x - soundSpeed * t) ∧
              q x t (1 : Fin 2) = profile (x - soundSpeed * t) ∧
                q x t (0 : Fin 2) =
                  acousticImpedance density soundSpeed * q x t (1 : Fin 2))

end NumStability.Leveque02Tracer
