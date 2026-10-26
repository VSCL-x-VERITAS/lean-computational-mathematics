/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Contraction from a unit-circle triangle

Proof-free source target proposal for Bhatia, Matrix Analysis (1997),
Problem I.6.17(ii), printed page 25 / PDF page 37.

The conclusion is the pointwise form of the operator-norm bound `‖A‖ ≤ 1`.
Every linear map on a finite-dimensional complex normed space has its canonical
continuous realization `LinearMap.toContinuousLinearMap A`, with the same
underlying function. Mathlib's `ContinuousLinearMap.opNorm_le_iff` at bound `1`
identifies that norm bound with `∀ x, ‖A x‖ ≤ ‖x‖`. This representation also
retains the zero-dimensional case without selecting a unit vector.

The positive resolution and positive block in the printed argument are proof
steps, rather than premises of this containment-to-contraction assertion.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Containment of the full numerical range in a prescribed unit-circle
triangle implies the non-strict operator contraction bound. -/
def unitCircleTriangleContraction : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (z : Fin 3 → ℂ),
    (∀ j : Fin 3, ‖z j‖ = 1) →
    ∀ A : H →ₗ[ℂ] H,
      let W : Set ℂ :=
        {w : ℂ | ∃ x : H, ‖x‖ = 1 ∧ w = inner ℂ x (A x)}
      (W ⊆ convexHull ℝ (Set.range z)) →
        ∀ x : H, ‖A x‖ ≤ ‖x‖

end NumStability.Bhatia.Chapter01.Targets
