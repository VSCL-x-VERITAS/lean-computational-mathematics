/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.ScalarUpwindFlux

/-!
# Upwind Flux Target

Equation (1.5) as an operation on its supplied real numerical inputs.
`normalFlux` is the prescribed integrated outward velocity in the application;
the two states are the values in the cell and its neighbour at the same time.
Geometric realization and guarantees of the full scheme are separate claims.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Equation (1.5) as an operation on its supplied real numerical inputs.
`normalFlux` is the prescribed integrated outward velocity in the application;
the two states are the values in the cell and its neighbour at the same time.
Geometric realization and guarantees of the full scheme are separate claims. -/
def upwindFluxTarget : Prop :=
  ∀ normalFlux localState neighbourState : ℝ,
    NumStability.FiniteVolume.scalarUpwindFlux normalFlux localState neighbourState =
      if 0 ≤ normalFlux then normalFlux * localState else normalFlux * neighbourState

end NumStability.Eymard.Chapter01
