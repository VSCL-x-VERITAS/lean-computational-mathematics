/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxDifferenceSplitting
import Mathlib.Algebra.Group.Pi.Basic

/-!
# LeVeque Chapter 4, equations (4.52) and (4.53)

For a general conservation law, the numerical interface flux can be
defined using the left physical flux and left-going fluctuation. The
right-state formula is equivalent when the fluctuations split the
physical-flux difference.
-/

namespace NumStability

/-- The numerical flux selected by the left-state formula (4.52). -/
def leveque04_generalFluctuationFlux
    {m : ℕ} (physical leftGoing : ℤ → (Fin m → ℝ))
    (i : ℤ) : Fin m → ℝ :=
  physical (i - 1) + leftGoing i

/-- Equation (4.52): left physical flux plus the left-going interface
fluctuation, for an arbitrary conservation-law flux field. -/
theorem leveque04_equation52
    {m : ℕ} (physical leftGoing : ℤ → (Fin m → ℝ)) (i : ℤ) :
    leveque04_generalFluctuationFlux physical leftGoing i =
      physical (i - 1) + leftGoing i := rfl

/-- Equation (4.53): under the flux-difference splitting (4.54), the
same selected face flux equals right physical flux minus its
right-going interface fluctuation. -/
theorem leveque04_equation53
    {m : ℕ} (physical leftGoing rightGoing : ℤ → (Fin m → ℝ))
    (hsplit : FluxDifferenceSplitting.IsSplit physical leftGoing rightGoing)
    (i : ℤ) :
    leveque04_generalFluctuationFlux physical leftGoing i =
      physical i - rightGoing i := by
  rw [leveque04_generalFluctuationFlux]
  exact (FluxDifferenceSplitting.faceFlux_eq_left
    physical leftGoing rightGoing hsplit i).symm

end NumStability
