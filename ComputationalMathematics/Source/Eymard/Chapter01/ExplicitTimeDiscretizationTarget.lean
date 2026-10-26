/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ExplicitEulerTransport
import ComputationalMathematics.Source.Eymard.Chapter01.PrintedUpwindSchemeTarget

/-! Example 1.1, equation (1.3): a supplied-sequence interface definition. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01

open Set MeasureTheory
open NumStability.FiniteVolume.Planar

/-- Literal characterization with actual Lebesgue volume and H1 boundary
integrals. A chosen initial representative and the actual point sequence are
supplied. No boundary trace is inferred from the L∞ class. -/
def explicitTimeDiscretizationTarget : Prop :=
  ∀ (Cell Face : Type) [DecidableEq Face] (M : Mesh Cell Face)
      (v : SpatialVelocity) (datum : TransportInitialDatum)
      (step : PositiveStep) (u : ℕ → Point → ℝ),
    ExplicitEulerTransportInputs M.polygon v step u →
    (IsExplicitEulerTransportSequence M.polygon v datum.representative step u ↔
      (∀ x, u 0 x = datum.representative x) ∧
        ∀ n K,
          (1 / step.val) *
              (∫ x in (M.polygon K).region,
                (u (n + 1) x - u n x) ∂volume) +
            (∫ x in frontier (M.polygon K).carrier,
              inner ℝ
                (constantTimeLift v x
                  (NumStability.FiniteVolume.uniformTimeGrid step.val n))
                (polygonBoundaryNormal (M.polygon K) x) * u n x
              ∂(Measure.hausdorffMeasure 1)) = 0)

end NumStability.Eymard.Chapter01
