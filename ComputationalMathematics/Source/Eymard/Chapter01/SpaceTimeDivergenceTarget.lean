/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.Eymard.Chapter01.GeneralLawTarget

/-!
# Space Time Divergence Target

Section 2.1's space-time rewriting, using spatial coordinates first and
time last. The field is exactly `(F,q)` and the right-hand side is unchanged.
Applicability uses the same scalar partials as (2.1); joint differentiability,
an integral theorem and existence of a PDE solution are not required.
The displayed divergence identity is required where the actual partials exist;
no PDE meaning is assigned to totalized derivative values outside that guard.

Source-faithfulness and proof status are recorded in `docs/formalization/eymard-chapter-01.md`.
-/

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

open NumStability.FiniteVolume.CoordinateBalance

/-- Section 2.1's space-time rewriting, using spatial coordinates first and
time last. The field is exactly `(F,q)` and the right-hand side is unchanged.
Applicability uses the same scalar partials as (2.1); joint differentiability,
an integral theorem and existence of a PDE solution are not required.
The displayed divergence identity is required where the actual partials exist;
no PDE meaning is assigned to totalized derivative values outside that guard. -/
def spaceTimeDivergenceTarget : Prop :=
  ∀ d, IsSourceDimension d → ∀ (R : Set (Point d × ℝ))
    (q : Point d → ℝ → ℝ) (F : Point d → ℝ → Point d) (f : Point d → ℝ → ℝ),
    (∀ x t, (x, t) ∈ R →
      (PartialsExistAt q F x t ↔
        SpaceTimePartialsExistAt (spaceTimeFlux q F) (pack x t)) ∧
      (PartialsExistAt q F x t →
        spaceTimeDivergence (spaceTimeFlux q F) (pack x t) =
          timePartial q x t + divergence F x t)) ∧
    (LocalLawOn R q F f ↔
      ∀ z, (spacePart z, timePart z) ∈ R →
        SpaceTimePartialsExistAt (spaceTimeFlux q F) z ∧
        spaceTimeDivergence (spaceTimeFlux q F) z = f (spacePart z) (timePart z))

end NumStability.Eymard.Chapter01
