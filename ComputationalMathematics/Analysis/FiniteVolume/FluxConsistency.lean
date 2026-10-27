/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Scalar numerical-flux consistency

A two-state scalar numerical flux agrees with the physical flux on the
diagonal. This condition does not impose monotonicity or a mesh-dependent
stability condition.
-/

namespace NumStability.FiniteVolume

/-- Diagonal consistency of a two-state scalar numerical flux on all real states. -/
def IsScalarFluxConsistent (physicalFlux : ℝ → ℝ)
    (numericalFlux : ℝ → ℝ → ℝ) : Prop :=
  ∀ s : ℝ, numericalFlux s s = physicalFlux s

end NumStability.FiniteVolume
