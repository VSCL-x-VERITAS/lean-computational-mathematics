/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarGeometry
import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindFlux
import ComputationalMathematics.Source.Eymard.Chapter01.CellUnknownsTarget
import Mathlib.MeasureTheory.Function.LpSpace.Basic

/-!
# Printed Upwind Scheme Target

An actual L∞ class and a supplied representative of that class.
No continuity or boundary trace is imposed on the representative.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open MeasureTheory
open NumStability.FiniteVolume.Planar
open scoped BigOperators

/-- An actual L∞ class and a supplied representative of that class.
No continuity or boundary trace is imposed on the representative. -/
structure TransportInitialDatum where
  /-- Essentially bounded initial datum represented as an L-infinity equivalence class. -/
  equivalenceClass : Lp (α := Point) ℝ ⊤ volume
  /-- Chosen pointwise representative of the initial datum. -/
  representative : Point → ℝ
  memLp : MemLp representative ⊤ volume
  sameClass : representative =ᵐ[volume] (equivalenceClass : Point → ℝ)

/-- Literal equations (1.6) on a supplied family.
All cell vertices, face segments and velocity points use canonical Planar geometry. The initial cell value is
the printed volume integral, with no division by cell area. The flux uses the
same-time local and neighbouring states and the actual face integral. -/
def IsPrintedUpwindScheme {Cell Face : Type} [DecidableEq Face]
    (M : Mesh Cell Face) (v : SpatialVelocity) (datum : TransportInitialDatum)
    (step : PositiveStep) (u : CellUnknowns Cell ℝ) : Prop :=
  (∀ K, u 0 K = ∫ x in (M.polygon K).region, datum.representative x) ∧
    ∀ K n,
      (cellArea M K / step.val) * (u (n + 1) K - u n K) +
        ∑ σ ∈ M.faces K, upwindFlux M v step u n K σ = 0

/-- The supplied-family scheme definition with its physical coefficient exposed.
For the declared L∞ datum and bounded polygon cells, per-cell integrability
is a separate derivable support fact, rather than an extra hypothesis on
this characterization. No solution family is constructed. -/
def printedUpwindSchemeTarget : Prop :=
  ∀ (Cell Face : Type) [DecidableEq Face]
    (M : Mesh Cell Face) (v : SpatialVelocity) (datum : TransportInitialDatum)
    (step : PositiveStep) (u : CellUnknowns Cell ℝ),
    (IsPrintedUpwindScheme M v datum step u ↔
      (∀ K, u 0 K = ∫ x in (M.polygon K).region, datum.representative x) ∧
        ∀ K n,
          ((volume (M.polygon K).region).toReal / step.val) *
              (u (n + 1) K - u n K) +
            ∑ σ ∈ M.faces K,
              NumStability.FiniteVolume.scalarUpwindFlux
                (∫ x in (M.segment σ).carrier,
                  inner ℝ
                    (constantTimeLift v x
                      (NumStability.FiniteVolume.uniformTimeGrid step.val n))
                    (M.normal K σ) ∂(Measure.hausdorffMeasure 1))
                (u n K) (u n (M.neighbour K σ)) = 0)

end NumStability.Eymard.Chapter01
