/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticSpeedOrderConditionTarget
import Mathlib.Tactic

/-!
# Corrected P/S speed-order condition
-/

namespace NumStability.Leveque02Tracer

/-- The strict P-over-S speed order needs precisely the extra inequality
`λ+μ>0` within the positive-density, positive-modulus regime. -/
theorem elasticSpeedOrderCondition : elasticSpeedOrderConditionTarget := by
  intro lameLambda shearModulus density hdensity hshear hcompression
  change Real.sqrt (shearModulus / density) <
      Real.sqrt ((lameLambda + 2 * shearModulus) / density) ↔
        0 < lameLambda + shearModulus
  rw [Real.sqrt_lt_sqrt_iff (le_of_lt (div_pos hshear hdensity))]
  rw [div_lt_div_iff_of_pos_right hdensity]
  constructor <;> intro h <;> linarith

end NumStability.Leveque02Tracer
