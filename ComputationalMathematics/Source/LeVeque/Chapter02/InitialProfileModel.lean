/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Initial data on the infinite spatial line

LeVeque (2.15) prescribes the tracer profile at a fixed initial time.
`HasInitialProfile` expresses that condition as equality of functions of
position. Values at other times do not enter the condition. The evolution
equation and the later translated-solution assertion are separate obligations.
-/

namespace NumStability.Leveque02Tracer

/-- The scalar field has the prescribed spatial profile at the initial time. -/
def HasInitialProfile (field : ℝ → ℝ → ℝ) (initial : ℝ → ℝ) (initialTime : ℝ) : Prop :=
  (fun x => field x initialTime) = initial

end NumStability.Leveque02Tracer
