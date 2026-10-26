/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.FluxVectorSplitting
import ComputationalMathematics.Source.LeVeque.Chapter04.FluxDifferenceSplitting

/-!
# LeVeque Chapter 4: flux-vector splitting induces flux-difference splitting

The directional differences in (4.58) satisfy the flux-jump identity
(4.54). The numerical flux recovered through (4.55) is the original
flux-vector split (4.57), including for a nonlinear physical flux whose
values have a positive/negative splitting at each cell state.
-/

namespace NumStability

/-- The induced directional fluctuations split the physical-flux jump
and reproduce exactly the split numerical face flux. -/
theorem leveque04_vectorDifferenceEquivalence
    {m : ℕ} (physical positive negative : ℤ → (Fin m → ℝ))
    (hsplit : ∀ i, physical i = positive i + negative i) :
    FluxDifferenceSplitting.IsSplit physical
        (FluxVectorSplitting.negativeFluctuation negative)
        (FluxVectorSplitting.positiveFluctuation positive) ∧
      ∀ i, FluxDifferenceSplitting.faceFlux physical
          (FluxVectorSplitting.positiveFluctuation positive) i =
        FluxVectorSplitting.faceFlux positive negative i := by
  constructor
  · intro i
    exact leveque04_equation54 physical positive negative hsplit i
  · intro i
    exact (leveque04_equation55 physical positive negative hsplit i).1.symm

end NumStability
