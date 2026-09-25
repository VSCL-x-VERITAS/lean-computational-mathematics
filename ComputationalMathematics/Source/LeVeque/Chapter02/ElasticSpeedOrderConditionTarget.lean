/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticWaveSpeedsModel

/-!
# Corrected material condition for P- and S-wave speed order
-/

namespace NumStability.Leveque02Tracer

/-- With positive density and real positive wave moduli, S-waves are slower
than P-waves exactly when the additional Lamé sum `λ+μ` is positive. -/
def elasticSpeedOrderConditionTarget : Prop :=
  ∀ (lameLambda shearModulus density : ℝ),
    0 < density → 0 < shearModulus →
    0 < lameLambda + 2 * shearModulus →
      (shearWaveSpeed shearModulus density <
        compressionalWaveSpeed lameLambda shearModulus density ↔
          0 < lameLambda + shearModulus)

end NumStability.Leveque02Tracer
