/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Scalar upwind flux

The normal flux and the two cell states are supplied real inputs. An application
must identify the normal flux with its prescribed outward velocity integral and
the states with the two incident cell values at the same time level.
-/

namespace NumStability.FiniteVolume

/-- Select the local state for outward flow and the neighbouring state for
inward flow. The zero normal flux belongs to the nonnegative branch. -/
noncomputable def scalarUpwindFlux (normalFlux localState neighbourState : ℝ) : ℝ :=
  if 0 ≤ normalFlux then normalFlux * localState else normalFlux * neighbourState

end NumStability.FiniteVolume
