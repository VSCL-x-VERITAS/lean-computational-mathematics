/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PositivePipeClassicalNecessityTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FinitePipePositive
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: PositivePipeClassicalNecessity

A classical finite-pipe inflow example and its necessity result.
-/

namespace NumStability.Leveque02Tracer

theorem positivePipeClassicalNecessity : positivePipeClassicalNecessityTarget := by
  have hprofile : Differentiable ℝ positivePipeIncomingProfile := by
    unfold positivePipeIncomingProfile
    exact ((expNegInvGlue.contDiff (n := 1)).differentiable (by norm_num)).comp
      differentiable_neg
  have hquiet : ContDiff ℝ 1 (Function.uncurry positivePipeQuietField) := by
    unfold positivePipeQuietField
    fun_prop
  have hincoming : ContDiff ℝ 1 (Function.uncurry positivePipeIncomingField) := by
    unfold positivePipeIncomingField positivePipeIncomingProfile NumStability.travelingWave
    fun_prop
  refine ⟨finitePipePositive, hquiet, hincoming, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro x t
    exact ⟨0, 0, by simpa [positivePipeQuietField] using
      (hasDerivAt_const t (0 : ℝ)),
      by simpa [positivePipeQuietField] using (hasDerivAt_const x (0 : ℝ)), by simp⟩
  · intro x t
    exact NumStability.travelingWave_isLinearAdvectionSolutionAt 1 x t
      (hprofile (x - 1 * t)).hasDerivAt
  · intro x hx _
    simp only [positivePipeQuietField, positivePipeIncomingField,
      NumStability.travelingWave, positivePipeIncomingProfile]
    simp [expNegInvGlue.zero_of_nonpos (show -x ≤ 0 by linarith)]
  · simp [positivePipeQuietField, positivePipeIncomingField,
      NumStability.travelingWave, positivePipeIncomingProfile]
  · change (0 : ℝ) ≠ expNegInvGlue (-(0 - 1 * 1))
    have hpos : 0 < expNegInvGlue 1 := expNegInvGlue.pos_of_pos (by norm_num)
    norm_num
    exact ne_of_lt hpos
  · change (0 : ℝ) ≠ expNegInvGlue (-(1 / 2 - 1 * 1))
    have hpos : 0 < expNegInvGlue (1 / 2) :=
      expNegInvGlue.pos_of_pos (by norm_num)
    norm_num
    exact ne_of_lt hpos

end NumStability.Leveque02Tracer
