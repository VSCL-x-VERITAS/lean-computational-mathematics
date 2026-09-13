/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import Mathlib.Analysis.Convex.Basic

/-!
# Translated-profile representation of classical advection solutions

This proof-free target for the converse following (2.13) retains the whole
spatial line and a connected time interval. The actual field derivative and
advection equation are premises; a translated profile is the conclusion.
Relative endpoint derivatives and normed vector values require independent
faithfulness review.
-/

namespace NumStability.Leveque02Tracer

/-- Every classical advection field on a time interval has a translated profile. -/
def advectionConverseTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (field : ℝ → ℝ → E) (velocity initialTime : ℝ) (timeDomain : Set ℝ),
    initialTime ∈ timeDomain →
    Convex ℝ timeDomain →
    UniqueDiffOn ℝ timeDomain →
    DifferentiableOn ℝ (Function.uncurry field) (Set.prod Set.univ timeDomain) →
    (∀ x t, t ∈ timeDomain →
      IsLinearAdvectionSolutionWithinAt field velocity x t Set.univ timeDomain) →
    ∃ profile : ℝ → E, ∀ x t, t ∈ timeDomain →
      field x t = profile (x - velocity * t)

end NumStability.Leveque02Tracer
