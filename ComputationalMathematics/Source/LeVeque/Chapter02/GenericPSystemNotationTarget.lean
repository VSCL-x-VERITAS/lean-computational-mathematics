/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.GenericPSystemNotationModel

/-!
# Proof-free target for LeVeque equation (2.108)
-/

namespace NumStability.Leveque02Tracer

/-- The generic lower-case p-system predicate is exactly the printed pair of
classical partial-derivative equations in the Lagrangian mass coordinate. -/
def genericPSystemNotationTarget : Prop :=
  ∀ (specificVolume velocity : ℝ → ℝ → ℝ) (pressureLaw : ℝ → ℝ)
    (massCoordinate time : ℝ),
    IsGenericPSystemAt specificVolume velocity pressureLaw massCoordinate time ↔
      HasDerivAt (fun τ => specificVolume massCoordinate τ)
        (deriv (fun τ => specificVolume massCoordinate τ) time) time ∧
      HasDerivAt (fun x => velocity x time)
        (deriv (fun x => velocity x time) massCoordinate) massCoordinate ∧
      HasDerivAt (fun τ => velocity massCoordinate τ)
        (deriv (fun τ => velocity massCoordinate τ) time) time ∧
      HasDerivAt (fun x => pressureLaw (specificVolume x time))
        (deriv (fun x => pressureLaw (specificVolume x time)) massCoordinate)
        massCoordinate ∧
      (deriv (fun τ => specificVolume massCoordinate τ) time -
        deriv (fun x => velocity x time) massCoordinate = 0) ∧
      (deriv (fun τ => velocity massCoordinate τ) time +
        deriv (fun x => pressureLaw (specificVolume x time)) massCoordinate = 0)

end NumStability.Leveque02Tracer
