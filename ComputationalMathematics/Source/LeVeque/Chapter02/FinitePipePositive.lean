/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FinitePipePositiveTarget
import Mathlib.Tactic

/-!
# LeVeque's positive-speed finite-pipe characteristic formula
-/

namespace NumStability.Leveque02Tracer

/-- Backward characteristics select the prescribed left-inflow or initial trace
in the two strict regions printed by LeVeque. -/
theorem finitePipePositive : finitePipePositiveTarget := by
  intro left right speed initialTime field initial inflow x time
    hpipe hspeed hxleft hxright htime hsolution hinflow hinitial
  have hsegment (s : ℝ) (hsinitial : initialTime ≤ s) (hst : s ≤ time)
      (hcorner : x ≠ left + speed * (time - initialTime))
      (hsourceLeft : left ≤ x - speed * (time - s))
      (hsourceRight : x - speed * (time - s) ≤ right) :
      field x time = field (x - speed * (time - s)) s := by
    rcases hsolution with hchar | ⟨hcont, hdiff, hpde⟩
    · exact hchar x time s hcorner (le_of_lt hxleft) (le_of_lt hxright)
        hsinitial hst hsourceLeft hsourceRight
    · exact positivePipeCharacteristicOfPDE field left right speed
        initialTime x time s hspeed hxright hsinitial hst hsourceLeft hcont hdiff hpde
  constructor
  · intro hregion
    let entryTime := time - (x - left) / speed
    have hentry : initialTime ≤ entryTime := by
      have hquot : (x - left) / speed < time - initialTime :=
        (div_lt_iff₀ hspeed).2 (by linarith)
      dsimp [entryTime]
      linarith
    have hentryTime : entryTime ≤ time := by
      dsimp [entryTime]
      exact sub_le_self _ (le_of_lt (div_pos (sub_pos.mpr hxleft) hspeed))
    have hback : x - speed * (time - entryTime) = left := by
      have hspeed0 : speed ≠ 0 := ne_of_gt hspeed
      dsimp [entryTime]
      field_simp
      ring
    have hvalue := hsegment entryTime hentry hentryTime (ne_of_lt hregion)
      (by rw [hback]) (by rw [hback]; exact le_of_lt hpipe)
    rw [hback, hinflow entryTime hentry] at hvalue
    exact hvalue
  · intro hregion
    let origin := x - speed * (time - initialTime)
    have horiginLeft : left < origin := by
      dsimp [origin]
      linarith
    have horiginRight : origin < right := by
      have hmove : 0 ≤ speed * (time - initialTime) :=
        mul_nonneg (le_of_lt hspeed) (sub_nonneg.mpr htime)
      dsimp [origin]
      linarith
    have hvalue := hsegment initialTime (le_refl _) htime (ne_of_gt hregion)
      (le_of_lt horiginLeft) (le_of_lt horiginRight)
    change field x time = field origin initialTime at hvalue
    rw [hinitial origin horiginLeft horiginRight] at hvalue
    exact hvalue

end NumStability.Leveque02Tracer
