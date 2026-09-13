/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.WithinDomains

/-!
# Classical fluid-density transport from initial data

The whole-line forward problem uses the source's arbitrary initial time.
The translated profile solves advection, and every continuously initialized,
jointly differentiable forward density satisfying actual constant-velocity
mass conservation agrees with that profile. No derivative at the initial
time or regularity outside the forward domain is required.
-/

namespace NumStability.Leveque02Tracer

/-- The initial density determines the classical constant-speed fluid model. -/
def classicalFluidCauchyTarget : Prop :=
  ∀ (initial : ℝ → ℝ) (velocity initialTime : ℝ),
    Differentiable ℝ initial →
    let solution : ℝ → ℝ → ℝ := fun x t => initial (x - velocity * (t - initialTime))
    ContinuousOn (Function.uncurry solution) (Set.prod Set.univ (Set.Ici initialTime)) ∧
    DifferentiableOn ℝ (Function.uncurry solution) (Set.prod Set.univ (Set.Ioi initialTime)) ∧
    (∀ x, solution x initialTime = initial x) ∧
    (∀ x t, initialTime < t → IsLinearAdvectionSolutionWithinAt solution velocity x t
      Set.univ (Set.Ioi initialTime)) ∧
    (∀ field : ℝ → ℝ → ℝ,
      ContinuousOn (Function.uncurry field) (Set.prod Set.univ (Set.Ici initialTime)) →
      DifferentiableOn ℝ (Function.uncurry field) (Set.prod Set.univ (Set.Ioi initialTime)) →
      (∀ x t, initialTime < t →
        IsConservationLawSolutionWithinAt field (fun density => velocity * density) x t
          Set.univ (Set.Ioi initialTime)) →
      (∀ x, field x initialTime = initial x) →
      ∀ x t, initialTime ≤ t → field x t = solution x t)

end NumStability.Leveque02Tracer
