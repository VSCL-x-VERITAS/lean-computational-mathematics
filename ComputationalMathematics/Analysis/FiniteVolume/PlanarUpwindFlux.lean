/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import ComputationalMathematics.Analysis.FiniteVolume.ScalarUpwindFlux
import ComputationalMathematics.Analysis.FiniteVolume.UniformTimeGrid
import Mathlib.Analysis.Calculus.ContDiff.Defs
import Mathlib.MeasureTheory.Integral.Bochner.Set

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume.Planar

open MeasureTheory

/-- A spatial C1 velocity on the Euclidean plane. -/
structure SpatialVelocity where
  toFun : Point → Point
  regularity : ContDiff ℝ 1 toFun

/-- The constant-in-time lift of a spatial velocity. -/
def constantTimeLift (v : SpatialVelocity) (x : Point) (_t : ℝ) : Point :=
  v.toFun x

abbrev PositiveStep := {k : ℝ // 0 < k}

/-- Use the existing zero-based constant-step time grid. -/
def timeLevel (step : PositiveStep) (n : ℕ) : ℝ :=
  NumStability.FiniteVolume.uniformTimeGrid step.val n

/-- Actual signed normal-velocity integral on the canonical shared Planar.Segment.
Its carrier and Point type are the same producers used by rectangular diffusion.
This local operation needs no global mesh. An outward interpretation requires
`IsOutwardNormal` for the supplied segment and normal. -/
def integratedNormalVelocity (v : SpatialVelocity) (step : PositiveStep)
    (n : ℕ) (σ : Segment) (normal : Point) : ℝ :=
  ∫ x in σ.carrier,
    inner ℝ (constantTimeLift v x (timeLevel step n)) normal ∂lengthMeasure

/-- The existing scalar upwind operation, supplied with the actual geometric
coefficient and the incident cell states at the same time level. -/
def upwindFlux {Cell Face : Type} [DecidableEq Face]
    (M : Mesh Cell Face) (v : SpatialVelocity) (step : PositiveStep)
    (u : ℕ → Cell → ℝ) (n : ℕ) (K : Cell) (σ : Face) : ℝ :=
  NumStability.FiniteVolume.scalarUpwindFlux
    (integratedNormalVelocity v step n (M.segment σ) (M.normal K σ))
    (u n K) (u n (M.neighbour K σ))

end NumStability.FiniteVolume.Planar
