/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticPressureFromStressModel

/-!
# Proof-free target for LeVeque equation (2.96)
-/

namespace NumStability.Leveque02Tracer

/-- Pressure is negative normal stress at the same point, so positive
pressure perturbation corresponds to compressive negative stress. -/
def acousticPressureStressIdentificationTarget : Prop :=
  ∀ (normalStress : ℝ → ℝ → ℝ) (x t : ℝ),
    acousticPressureFromNormalStress normalStress x t = -normalStress x t ∧
      (0 < acousticPressureFromNormalStress normalStress x t ↔
        normalStress x t < 0)

end NumStability.Leveque02Tracer
