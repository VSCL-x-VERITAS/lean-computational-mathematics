/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.FiniteVolume.OpenClosureCover
import Mathlib.Algebra.Notation.Indicator
import Mathlib.Topology.Constructions
import Mathlib.Topology.MetricSpace.Pseudo.Defs

/-!
# Cell Indicators Target

Section 3's scalar cell indicator, restricted to any chosen ambient set.
The two cases define one actual indicator and assert no continuity, summed
reconstruction, test-space admissibility or PDE identity.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Section 3's scalar cell indicator, restricted to any chosen ambient set.
The two cases define one actual indicator and assert no continuity, summed
reconstruction, test-space admissibility or PDE identity. -/
def cellIndicatorsTarget : Prop :=
  ∀ (d : ℕ), (d = 1 ∨ d = 2 ∨ d = 3) →
    ∀ (Ω : Set (Fin d → ℝ)) (T : Set (Set (Fin d → ℝ))),
      NumStability.FiniteVolume.IsOpenClosureCover Ω T →
        ∀ (ambient : Set (Fin d → ℝ))
          (K : Set (Fin d → ℝ)), K ∈ T →
            ∀ x ∈ ambient,
              (x ∈ K → K.indicator (fun _ => (1 : ℝ)) x = 1) ∧
              (x ∉ K → K.indicator (fun _ => (1 : ℝ)) x = 0)

end NumStability.Eymard.Chapter01
