/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.FluxVectorSplitting
import Mathlib.Algebra.Group.Pi.Basic
import Mathlib.Data.Real.Basic

/-!
# LeVeque Chapter 4, equations (4.54)–(4.55) and (4.57)–(4.58)

These source equations use a single reusable additive flux splitting. The
physical flux at each cell is the sum of its positive and negative parts.
-/

namespace NumStability

/-- Equation (4.57): positive flux from the left state plus negative flux
from the right state gives the numerical flux at their shared face. -/
theorem leveque04_equation57
    {m : ℕ} (positive negative : ℤ → (Fin m → ℝ)) (i : ℤ) :
    FluxVectorSplitting.faceFlux positive negative i =
      positive (i - 1) + negative i := rfl

/-- Equation (4.58): the directional fluctuations are differences of the
respective signed physical-flux parts across the face. -/
theorem leveque04_equation58
    {m : ℕ} (positive negative : ℤ → (Fin m → ℝ)) (i : ℤ) :
    FluxVectorSplitting.negativeFluctuation negative i =
        negative i - negative (i - 1) ∧
      FluxVectorSplitting.positiveFluctuation positive i =
        positive i - positive (i - 1) := ⟨rfl, rfl⟩

/-- Equation (4.54): subtracting physical fluxes gives the sum of the
negative and positive directional fluctuations at the shared face. -/
theorem leveque04_equation54
    {m : ℕ} (physical positive negative : ℤ → (Fin m → ℝ))
    (hsplit : ∀ i, physical i = positive i + negative i) (i : ℤ) :
    physical i - physical (i - 1) =
      FluxVectorSplitting.negativeFluctuation negative i +
        FluxVectorSplitting.positiveFluctuation positive i :=
  FluxVectorSplitting.physicalFlux_difference physical positive negative hsplit i

/-- Equation (4.55): the shared numerical flux can be computed from the
physical flux on either side by subtracting or adding the corresponding
outgoing fluctuation. -/
theorem leveque04_equation55
    {m : ℕ} (physical positive negative : ℤ → (Fin m → ℝ))
    (hsplit : ∀ i, physical i = positive i + negative i) (i : ℤ) :
    FluxVectorSplitting.faceFlux positive negative i =
        physical i - FluxVectorSplitting.positiveFluctuation positive i ∧
      FluxVectorSplitting.faceFlux positive negative i =
        physical (i - 1) + FluxVectorSplitting.negativeFluctuation negative i :=
  FluxVectorSplitting.faceFlux_eq_adjacent physical positive negative hsplit i

end NumStability
