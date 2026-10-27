/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.MeasureTheory.Measure.Haar.InnerProductSpace
import Mathlib.MeasureTheory.Measure.Hausdorff
import Mathlib.MeasureTheory.Measure.Restrict
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# Euclidean integration measures in spatial dimensions one through three

The Hausdorff measure in the pinned library uses powers of diameter. We select the usual
Euclidean surface normalization, with factors 1, 1, pi/4 in ambient
dimensions 1, 2, 3. These are explicit convention factors. Agreement with induced
area on affine planes, and any parameterized area formula, require separate
support; neither is established by this definition. No normalized interpretation is assigned to
the total implementation outside these three dimensions.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.FiniteVolume.EuclideanMeasure

open MeasureTheory

/-- Canonical Lebesgue measure, normalized on orthonormal parallelepipeds. -/
def spatialVolume (d : ℕ) : Measure (EuclideanSpace ℝ (Fin d)) := volume

/-- Selected conventional Euclidean surface factors for ambient dimensions
1, 2, 3. This definition does not prove agreement with induced area. -/
def surfaceNormalization (d : ℕ) : ENNReal :=
  if d = 3 then ENNReal.ofReal (Real.pi / 4) else 1

/-- Diameter-defined Hausdorff measure with the explicit low-dimensional
Euclidean normalization. At d=1 this uses exponent zero, at d=2 exponent one,
and at d=3 exponent two. -/
def surfaceMeasure (d : ℕ) : Measure (EuclideanSpace ℝ (Fin d)) :=
  surfaceNormalization d •
    (Measure.hausdorffMeasure ((d : ℝ) - 1) : Measure (EuclideanSpace ℝ (Fin d)))

/-- The surface measure restricted to the actual boundary or interface set.
No geometric regularity or finiteness is implicit in this definition. -/
def boundaryMeasure {d : ℕ} (boundary : Set (EuclideanSpace ℝ (Fin d))) : Measure (EuclideanSpace ℝ (Fin d)) :=
  (surfaceMeasure d).restrict boundary

end NumStability.FiniteVolume.EuclideanMeasure
