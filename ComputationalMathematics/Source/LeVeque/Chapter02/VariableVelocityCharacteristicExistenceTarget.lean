/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.ODE.PicardLindelof

/-!
# Proof-free target for local variable-velocity characteristics

This target records the local existence content surrounding equation (2.17).
Continuous differentiability at the initial point is an explicit sufficient
hypothesis for the ODE existence assertion left implicit in the source.
-/

namespace NumStability.Leveque02Tracer

/-- A continuously differentiable spatial velocity admits a local
characteristic through any prescribed initial point. -/
def variableVelocityCharacteristicExistenceTarget : Prop :=
  ∀ (velocity : ℝ → ℝ) (initialPoint : ℝ),
    ContDiffAt ℝ 1 velocity initialPoint →
      ∃ curve : ℝ → ℝ, curve 0 = initialPoint ∧ ∃ ε : ℝ, 0 < ε ∧
        ∀ t ∈ Set.Ioo (-ε) ε, HasDerivAt curve (velocity (curve t)) t

end NumStability.Leveque02Tracer
