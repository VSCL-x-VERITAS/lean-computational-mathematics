/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.PlanarUpwindFlux
import ComputationalMathematics.Source.Eymard.Chapter01.CellUnknownsTarget

/-!
# Upwind Conservation Target

Local conservation in Example 1.1, for the actual upwind flux (1.5).
The two cells share the same nondegenerate geometric face. Their normals are
the outward unit supporting normals supplied by the polygon mesh, and their
neighbours are the mesh's reciprocal neighbours. Both fluxes use the same
spatial C1 velocity, its constant-time lift, time level and unknown family.
The assertion covers every real family of states independently of (1.6).

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

noncomputable section

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume.Planar

/-- Local conservation in Example 1.1, for the actual upwind flux (1.5).
The two cells share the same nondegenerate geometric face. Their normals are
the outward unit supporting normals supplied by the polygon mesh, and their
neighbours are the mesh's reciprocal neighbours. Both fluxes use the same
spatial C1 velocity, its constant-time lift, time level and unknown family.
The assertion covers every real family of states independently of (1.6). -/
def upwindConservationTarget : Prop :=
  ∀ (Cell Face : Type) [DecidableEq Face]
    (M : Mesh Cell Face) (v : SpatialVelocity) (step : PositiveStep)
    (u : CellUnknowns Cell ℝ) (n : ℕ) (K L : Cell) (σ : Face),
      K ≠ L → σ ∈ M.faces K → σ ∈ M.faces L →
        upwindFlux M v step u n K σ = -upwindFlux M v step u n L σ

end NumStability.Eymard.Chapter01
