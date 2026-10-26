/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.RectangleClassicalBalance
import ComputationalMathematics.Source.Eymard.Chapter01.DiffusionTargets

/-!
# Classical rectangular realization of Eymard equation (1.8)

The adopted specificity-20261026 claim supplies an ambient C2 neighbourhood of
the closed cell and f = -Delta u there. The conclusion is the exact sum of four
integrated outward physical edge fluxes. Cells meeting the unit-square boundary
remain included: the neighbourhood is not required to lie in the unit square.
-/

set_option autoImplicit false
noncomputable section

namespace NumStability.Eymard.Chapter01

open Set MeasureTheory
open scoped BigOperators
open NumStability.FiniteVolume
open NumStability.FiniteVolume.Planar
open NumStability.FiniteVolume.RectangleClassicalBalance

/-- The owner-adopted classical conditional claim. No Gauss identity,
integrability proposition or desired balance is supplied as an assumption. The
boundary value u=0 from the surrounding problem is unused in this local identity. -/
def classicalDiffusionBalanceTarget : Prop :=
  ∀ (K : Rectangle2) (U : Set Point) (u f : Point → ℝ),
    K.region ⊆ diffusionUnitSquare → closure K.region ⊆ U →
    ClassicalPoissonOn U u f →
      (∑ s : RectangleSide2, ∫ x in K.side s,
        inner ℝ (negativeGradient u x) (outwardNormal K s)
          ∂(EuclideanMeasure.surfaceMeasure 2)) =
        ∫ x in K.region, f x ∂(EuclideanMeasure.spatialVolume 2)

end NumStability.Eymard.Chapter01
