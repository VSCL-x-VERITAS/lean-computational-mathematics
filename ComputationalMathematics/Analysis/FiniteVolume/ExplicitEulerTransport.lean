/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PolygonBoundaryIntegral
import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindFlux

/-! Conditional continuous-space explicit Euler specification. -/

set_option autoImplicit false
noncomputable section

namespace NumStability.FiniteVolume.Planar

open Set MeasureTheory

/-- Applicability of the actual volume and outward boundary integrals.
The supplied point functions provide their boundary values, including at level
zero. This contract does not infer a trace from a volume equivalence class. -/
def ExplicitEulerTransportInputs {Cell : Type} (cells : Cell → Polygon)
    (v : SpatialVelocity) (step : PositiveStep) (u : ℕ → Point → ℝ) : Prop :=
  ∀ K n,
    IntegrableOn (u n) (cells K).region volume ∧
      IntegrableOn
        (fun x => inner ℝ (constantTimeLift v x (timeLevel step n))
          (polygonBoundaryNormal (cells K) x) * u n x)
        (frontier (cells K).carrier) lengthMeasure

/-- The defining initialization and literal forward-difference equation.
This specifies a supplied sequence; it does not select or construct one. -/
def IsExplicitEulerTransportSequence {Cell : Type} (cells : Cell → Polygon)
    (v : SpatialVelocity) (initial : Point → ℝ) (step : PositiveStep)
    (u : ℕ → Point → ℝ) : Prop :=
  (∀ x, u 0 x = initial x) ∧
    ∀ n K,
      (1 / step.val) *
          (∫ x in (cells K).region, (u (n + 1) x - u n x) ∂volume) +
        (∫ x in frontier (cells K).carrier,
          inner ℝ (constantTimeLift v x (timeLevel step n))
            (polygonBoundaryNormal (cells K) x) * u n x ∂lengthMeasure) = 0

end NumStability.FiniteVolume.Planar
