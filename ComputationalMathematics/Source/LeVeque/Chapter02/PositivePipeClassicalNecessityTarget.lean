/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FinitePipePositiveTarget
import Mathlib.Analysis.SpecialFunctions.SmoothTransition

/-! Positive-speed finite-pipe advection requires left inflow data. -/

namespace NumStability.Leveque02Tracer

/-- A smooth profile vanishing before a characteristic reaches the left side. -/
noncomputable def positivePipeIncomingProfile (z : ℝ) : ℝ :=
  expNegInvGlue (-z)

/-- Zero field with the same initial pipe trace as the incoming witness. -/
def positivePipeQuietField : ℝ → ℝ → ℝ :=
  Function.const ℝ (Function.const ℝ (0 : ℝ))

/-- Incoming characteristic field used to witness the missing inflow datum. -/
noncomputable def positivePipeIncomingField : ℝ → ℝ → ℝ :=
  NumStability.travelingWave positivePipeIncomingProfile 1

/-- The general pipe formula and a classical normalized witness that initial
data alone do not determine a positive-speed solution. -/
def positivePipeClassicalNecessityTarget : Prop :=
  finitePipePositiveTarget ∧
    ContDiff ℝ 1 (Function.uncurry positivePipeQuietField) ∧
    ContDiff ℝ 1 (Function.uncurry positivePipeIncomingField) ∧
    (∀ x t : ℝ, NumStability.IsLinearAdvectionSolutionAt positivePipeQuietField 1 x t) ∧
    (∀ x t : ℝ, NumStability.IsLinearAdvectionSolutionAt positivePipeIncomingField 1 x t) ∧
    (∀ x : ℝ, 0 < x → x < 1 → positivePipeQuietField x 0 =
      positivePipeIncomingField x 0) ∧
    positivePipeQuietField 0 0 = positivePipeIncomingField 0 0 ∧
    positivePipeQuietField 0 1 ≠ positivePipeIncomingField 0 1 ∧
    positivePipeQuietField (1 / 2) 1 ≠ positivePipeIncomingField (1 / 2) 1

end NumStability.Leveque02Tracer
