/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.OpenClosureCover
import Mathlib.Topology.Constructions
import Mathlib.Topology.MetricSpace.Pseudo.Defs

/-!
# Mesh Definition Target

Section 2.2's mesh definition, with the exact union of cell closures.
Openness is the standard finite product topology on real coordinates. The
definition extends to arbitrary regions without asserting that a mesh exists.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Section 2.2's mesh definition, with the exact union of cell closures.
Openness is the standard finite product topology on real coordinates. The
definition extends to arbitrary regions without asserting that a mesh exists. -/
def meshDefinitionTarget : Prop :=
  ∀ (d : ℕ), (d = 1 ∨ d = 2 ∨ d = 3) →
    ∀ (Ω : Set (Fin d → ℝ)) (T : Set (Set (Fin d → ℝ))),
      NumStability.FiniteVolume.IsOpenClosureCover Ω T ↔
        ((∀ K ∈ T, IsOpen K ∧ K ⊆ Ω) ∧
          closure Ω = ⋃ K ∈ T, closure K)

end NumStability.Eymard.Chapter01
