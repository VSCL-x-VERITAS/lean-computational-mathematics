/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Generic lower-case notation for the p-system

The coordinate named `x` is the Lagrangian mass coordinate when this system
models the gas in LeVeque (2.107)–(2.108). The same algebraic system is used
with signed states in other applications.
-/

namespace NumStability.Leveque02Tracer

/-- A classical pointwise solution of the generic two-equation `p`-system.
Explicit derivative witnesses exclude totalized `deriv` values at nonsmooth
states. -/
def IsGenericPSystemAt
    (specificVolume velocity : ℝ → ℝ → ℝ) (pressureLaw : ℝ → ℝ)
    (massCoordinate time : ℝ) : Prop :=
  ∃ volumeTime velocitySpace velocityTime pressureSpace : ℝ,
    HasDerivAt (fun τ => specificVolume massCoordinate τ) volumeTime time ∧
    HasDerivAt (fun x => velocity x time) velocitySpace massCoordinate ∧
    HasDerivAt (fun τ => velocity massCoordinate τ) velocityTime time ∧
    HasDerivAt (fun x => pressureLaw (specificVolume x time)) pressureSpace massCoordinate ∧
    volumeTime - velocitySpace = 0 ∧
    velocityTime + pressureSpace = 0

end NumStability.Leveque02Tracer
