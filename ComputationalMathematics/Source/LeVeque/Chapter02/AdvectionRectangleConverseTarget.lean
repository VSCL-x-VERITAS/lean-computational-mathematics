/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.WithinDomains
import Mathlib.Analysis.Convex.Basic

/-!
# Advection profiles on spatial and temporal intervals

This proof-free converse target permits both finite pipes and the whole line.
Convex coordinate domains keep each characteristic's intersection connected.
The actual joint derivative and advection witnesses precede the conclusion
that one profile represents every point of the solution domain.
-/

namespace NumStability.Leveque02Tracer

/-- An advection solution on a rectangle is represented by a characteristic profile. -/
def advectionRectangleConverseTarget : Prop :=
  ∀ (E : Type) [NormedAddCommGroup E] [NormedSpace ℝ E]
      (field : ℝ → ℝ → E) (velocity : ℝ) (spaceDomain timeDomain : Set ℝ),
    Convex ℝ spaceDomain → Convex ℝ timeDomain →
    UniqueDiffOn ℝ spaceDomain → UniqueDiffOn ℝ timeDomain →
    DifferentiableOn ℝ (Function.uncurry field) (Set.prod spaceDomain timeDomain) →
    (∀ x ∈ spaceDomain, ∀ t ∈ timeDomain,
      IsLinearAdvectionSolutionWithinAt field velocity x t spaceDomain timeDomain) →
    ∃ profile : ℝ → E, ∀ x ∈ spaceDomain, ∀ t ∈ timeDomain,
      field x t = profile (x - velocity * t)

end NumStability.Leveque02Tracer
