/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.EuclideanMeasures
import ComputationalMathematics.Source.Eymard.Chapter01.GeneralLawTarget

/-!
# Measure Conventions Target

Section 2 default for dx; explicitly stated exceptions remain local to
the later source passage making them.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open MeasureTheory

namespace Measures

/-- Section 2 default for dx; explicitly stated exceptions remain local to
the later source passage making them. -/
abbrev defaultDx := NumStability.FiniteVolume.EuclideanMeasure.spatialVolume

/-- The conventional physical Euclidean normalization selected for dgamma.
The source does not print the numeric factor pi/4. The explicit factors
select the usual normalized Euclidean Hausdorff convention; this definition
does not establish an induced-area identity. -/
abbrev defaultSurfaceHausdorff :=
  NumStability.FiniteVolume.EuclideanMeasure.surfaceMeasure

/-- Canonical boundary measure restricted to the supplied Euclidean boundary. -/
abbrev defaultDgamma {d : ℕ} (boundary : Set (EuclideanSpace ℝ (Fin d))) : Measure (EuclideanSpace ℝ (Fin d)) :=
  NumStability.FiniteVolume.EuclideanMeasure.boundaryMeasure boundary

end Measures

/-- PDF8/printed7, final convention sentence before Section 2.1.
This is a definitional correspondence for default notation in dimensions
1, 2, 3, with the explicitly recorded area-normalized reading of Hausdorff
measure. It asserts no divergence theorem, area formula, integral finiteness,
global counting-measure identity, or unconditional rule for later exceptions.
Time integration dt is outside this source convention. -/
def measureConventionsTarget : Prop :=
  (∀ d, IsSourceDimension d →
    Measures.defaultDx d = (volume : Measure (EuclideanSpace ℝ (Fin d))) ∧
      ∀ boundary : Set (EuclideanSpace ℝ (Fin d)),
        Measures.defaultDgamma boundary =
          (Measures.defaultSurfaceHausdorff d).restrict boundary) ∧
    Measures.defaultSurfaceHausdorff 1 =
      (Measure.hausdorffMeasure 0 : Measure (EuclideanSpace ℝ (Fin 1))) ∧
    Measures.defaultSurfaceHausdorff 2 =
      (Measure.hausdorffMeasure 1 : Measure (EuclideanSpace ℝ (Fin 2))) ∧
    Measures.defaultSurfaceHausdorff 3 =
      ENNReal.ofReal (Real.pi / 4) •
        (Measure.hausdorffMeasure 2 : Measure (EuclideanSpace ℝ (Fin 3)))

end NumStability.Eymard.Chapter01
