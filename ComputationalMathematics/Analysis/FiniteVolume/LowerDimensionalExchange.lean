/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.OpenClosureCover
import Mathlib.Analysis.InnerProductSpace.PiL2
import Mathlib.Topology.MetricSpace.HausdorffDimension

/-!
# Lower Dimensional Exchange

A requirement on a supplied scalar numerical exchange family, indexed by
every natural time index and every ordered pair of actual regions. No assertion
that an arbitrary numerical approximation satisfies this requirement is made.
The dimension is Mathlib's Euclidean Hausdorff dimension in `ℝ≥0∞`.
In dimension one the strict hypothesis is false even for an empty interface.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.FiniteVolume

/-- A requirement on a supplied scalar numerical exchange family, indexed by
every natural time index and every ordered pair of actual regions. No assertion
that an arbitrary numerical approximation satisfies this requirement is made.
The dimension is Mathlib's Euclidean Hausdorff dimension in `ℝ≥0∞`.
In dimension one the strict hypothesis is false even for an empty interface. -/
def IsZeroOnLowerDimensionalInterfaces {d : ℕ}
    (regions : Set (Set (EuclideanSpace ℝ (Fin d))))
    (exchange : ℕ → ↥regions → ↥regions → ℝ) : Prop :=
  ∀ (n : ℕ) (K L : ↥regions),
    dimH (closure K.val ∩ closure L.val) < ((d - 1 : ℕ) : ENNReal) →
      exchange n K L = 0

end NumStability.FiniteVolume
