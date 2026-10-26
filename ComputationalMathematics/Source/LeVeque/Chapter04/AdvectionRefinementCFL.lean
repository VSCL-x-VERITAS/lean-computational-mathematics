/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFL

/-!
# LeVeque Chapter 4: scalar three-point CFL necessity

Equation (4.16), with the local initial-data change argument on printed
pages 69–70. Continuous-data convergence at a single fixed observation is
a sufficient premise for necessity. Time-dependent updates and physically
local initial data include the source's finite-difference and finite-volume
conventions. This necessary condition makes no stability or sufficiency claim.
-/

namespace NumStability

/-- Proof-free scalar three-point refinement CFL contract for equation (4.16). -/
def Leveque04ThreePointRefinementCFLTarget : Prop :=
  ∀ (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (speed X T ratio : ℝ),
    0 < T → 0 < ratio → IsCenteredStencilUpdateFamily 1 update →
      IsLocalRefinementInitialization initialData X T ratio →
      IsAdvectionRefinementConvergent update initialData speed X T →
        |speed| * ratio ≤ 1

/-- Convergence of an actual three-point refinement requires Courant number at most one. -/
theorem leveque04_threePointRefinementCFL :
    Leveque04ThreePointRefinementCFLTarget := by
  intro update initialData speed X T ratio hT hratio hlocal hinitial hconverges
  simpa using advectionRefinement_courant_le_of_localInitialization
    update initialData 1 speed X T ratio hT hratio hlocal hinitial hconverges

end NumStability
