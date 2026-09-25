/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PrintedSpeedOrderCounterexampleTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.ElasticSpeedOrderCondition
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: counterexample to unconditional P/S speed order
-/

namespace NumStability.Leveque02Tracer

/-- The book's displayed positive material conditions permit a slower P-wave. -/
theorem printedSpeedOrderCounterexample : printedSpeedOrderCounterexampleTarget := by
  dsimp [printedSpeedOrderCounterexampleTarget,
    compressionalWaveSpeed, shearWaveSpeed]
  refine ⟨by norm_num, by norm_num, by norm_num, ?_⟩
  have hspeed : Real.sqrt (1 / 2 : ℝ) < Real.sqrt 1 :=
    Real.sqrt_lt_sqrt (by norm_num) (by norm_num)
  convert hspeed using 1 <;> norm_num

end NumStability.Leveque02Tracer
