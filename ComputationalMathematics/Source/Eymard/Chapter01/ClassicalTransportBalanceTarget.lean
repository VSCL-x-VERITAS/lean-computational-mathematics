/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ClassicalPlanarTransport

/-!
# Classical conditional interpretation of Example 1.1, equation (1.2)

This proposal follows the adopted specificity-20261026 statement. Both u and V
are jointly C1 on U times I, and the actual homogeneous PDE holds there. All
nondegenerate bounded convex polygons and all positive open time intervals are
quantified. No global mesh is needed for this one-cell identity. The original
spatial velocity is represented by constantTimeVelocity when selected.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume
open CoordinateBalance ClassicalPlanarTransport

/-- Proof-free source target. No integral identity, geometry foundation,
manufactured boundary trace or solution existence is among the inputs. -/
def classicalTransportBalanceTarget : Prop :=
  ∀ (K : Planar.Polygon) (U : Set (Point 2)) (I : Set ℝ)
      (u : Point 2 → ℝ → ℝ) (V : Point 2 → ℝ → Point 2),
    IsOpen U → closure K.region ⊆ U → IsPositiveOpenInterval I →
    C1On U I u V →
    LocalLawOn (U.prod I) u (flux V u) (fun _ _ => 0) →
    ∀ t ∈ I, BalanceAt K u V t

end NumStability.Eymard.Chapter01
