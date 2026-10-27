/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REACertifiedCellAverage
import ComputationalMathematics.Source.LeVeque.Chapter04.REABoundedBilateralEvolution

/-!
# Selected closed-step REA evolution

The local profiles are the solutions selected by the ordered adjacent-cell
Riemann solver. Their physical faces are shifted by one index to match the
generic bilateral chain's state convention. Bounded separated fronts supply
the compatible finite windows used by that chain.
-/

namespace NumStability
open Set

/-- The actual certified adjacent-solver field, assembled for a closed step
under ordered bounded noninteracting fronts. -/
noncomputable def leveque04_reaCertifiedEvolution
    {m : ℕ} {Information : Type*}
    {law : OneDimensionalHyperbolicConservationLaw (Fin m)}
    (method : RectangleRiemannInterfaceFluxMethod law Information)
    (states : ℤ → Fin m → ℝ)
    (hdomain : ∀ j, method.domain (adjacentCellRiemannProblem law states j))
    (interface : ℤ → ℝ) (leftSpeed rightSpeed : ℤ → ℝ)
    (origin width bound step : ℝ)
    (hwidth : 0 < width) (hbound : 0 ≤ bound) (hstep : 0 ≤ step)
    (hspeeds : ∀ j, -bound ≤ leftSpeed j ∧
      leftSpeed j ≤ rightSpeed j ∧ rightSpeed j ≤ bound)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * step)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 step →
      x < origin + (j : ℝ) * width + leftSpeed j * time →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Icc 0 step →
      origin + (j : ℝ) * width + rightSpeed j * time < x →
        leveque04_reaCertifiedLocalField method states hdomain interface (j + 1) x time =
          states (j + 1)) :
    ℝ → ℝ → Fin m → ℝ :=
  leveque04_reaBoundedEvolution states
    (fun j => leveque04_reaCertifiedLocalField method states hdomain interface (j + 1))
    leftSpeed rightSpeed origin width bound step hwidth hbound hstep
    hspeeds hinteraction hleft hright

end NumStability
