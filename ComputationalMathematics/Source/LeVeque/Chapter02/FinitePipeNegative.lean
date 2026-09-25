/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FinitePipeNegativeTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FinitePipePositive
import Mathlib.Tactic

/-!
# LeVeque Figure 2.1(b): right inflow for negative-speed advection
-/

namespace NumStability.Leveque02Tracer

/-- Reflecting space turns negative-speed advection into the proved positive
finite-pipe formula, so only right-inflow and initial traces enter the result. -/
theorem finitePipeNegative : finitePipeNegativeTarget := by
  intro left right speed initialTime field initial rightInflow x time
    hpipe hspeed hxleft hxright htime hchar hinflow hinitial
  have hmirror := finitePipePositive (-right) (-left) (-speed) initialTime
    (fun y s => field (-y) s) (fun y => initial (-y)) rightInflow (-x) time
    (by linarith) (by linarith) (by linarith) (by linarith) htime
    (Or.inl hchar)
    (by
      intro s hs
      simpa using hinflow s hs)
    (by
      intro y hyLeft hyRight
      exact hinitial (-y) (by linarith) (by linarith))
  constructor
  · intro hregion
    have hm : -x < -right + (-speed) * (time - initialTime) := by linarith
    have hvalue := hmirror.1 hm
    have hdiv : (-x - -right) / -speed = (x - right) / speed := by
      have hspeed0 : speed ≠ 0 := ne_of_lt hspeed
      field_simp
      ring
    simpa only [neg_neg, hdiv] using hvalue
  · intro hregion
    have hm : -right + (-speed) * (time - initialTime) < -x := by linarith
    have hvalue := hmirror.2 hm
    have harg : -(-x - -speed * (time - initialTime)) =
        x - speed * (time - initialTime) := by ring
    simpa only [neg_neg, harg] using hvalue

end NumStability.Leveque02Tracer
