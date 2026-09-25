/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.EigenmodeWaves
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Components of a pure left-going acoustic wave
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.61): the pressure and velocity components of a pure left-going
wave have the stated translated profile, with impedance `ρ₀ c₀`. -/
def leftAcousticComponentsTarget : Prop :=
  ∀ (q : ℝ → ℝ → (Fin 2 → ℝ)) (density soundSpeed : ℝ),
    0 < density → 0 < soundSpeed →
      IsPureEigenmodeWave q (-soundSpeed)
          (linearAcousticsLeftEigenvector density soundSpeed) →
        ∃ profile : ℝ → ℝ,
          ∀ x t,
            q x t (0 : Fin 2) =
                -acousticImpedance density soundSpeed *
                  profile (x + soundSpeed * t) ∧
              q x t (1 : Fin 2) = profile (x + soundSpeed * t)

end NumStability.Leveque02Tracer
