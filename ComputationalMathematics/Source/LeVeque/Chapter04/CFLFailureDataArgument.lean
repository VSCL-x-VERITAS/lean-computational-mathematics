/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.AdvectionRefinementCFLFailureData

/-!
# LeVeque Chapter 4: fixed initial data witnessing a missed characteristic foot

The initial-data argument on printed page 70 uses the recorded continuous-data,
fixed-observation pointwise convention. Two profiles are fixed before mesh
refinement; their numerical observations eventually agree while their exact
characteristic-foot values differ. Thus convergence cannot hold for every
continuous datum. This records the scalar argument and its stated convention.
-/

namespace NumStability

/-- The source initial-data argument under its recorded scalar interpretation. -/
def Leveque04CFLFailureDataArgumentTarget : Prop :=
  ∀ (update : ℕ → ℕ → (ℤ → ℝ) → ℤ → ℝ)
    (initialData : ℕ → (ℝ → ℝ) → ℤ → ℝ) (speed X T ratio : ℝ),
    0 < T → 0 < ratio → IsCenteredStencilUpdateFamily 1 update →
      IsLocalRefinementInitialization initialData X T ratio →
      T / ratio < |(X - speed * T) - X| →
      (∃ f g : ℝ → ℝ, Continuous f ∧ Continuous g ∧
        f (X - speed * T) ≠ g (X - speed * T) ∧
        (∀ᶠ n in Filter.atTop,
          centeredRefinementApproximation update initialData n f =
            centeredRefinementApproximation update initialData n g)) ∧
      ¬ IsAdvectionRefinementConvergent update initialData speed X T

/-- Two fixed continuous data separate exact transport from a missed read cone. -/
theorem leveque04_cflFailureDataArgument :
    Leveque04CFLFailureDataArgumentTarget :=
  advectionRefinement_missedFoot_pair_of_localInitialization

end NumStability
