/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Data.Real.Basic

/-!
# Capacity-weighted state and physical flux

Section 2.4 parameterizes a physical flux by a state variable, while capacity
times that variable is the conserved quantity. The pair below records those
two roles: its first coordinate is the conserved state and its second is the
flux evaluated at the original state. At a spatial point the capacity is a
time-independent material or geometric parameter. The coordinate definition
does not impose an evolution equation on arbitrary fields; that law is a
separate target. No inverse capacity is used.
-/

namespace NumStability.Leveque02Tracer

/-- Conserved-state and flux coordinates in the capacity model of Section 2.4. -/
noncomputable def capacityStateFlux (capacity state : ℝ) (flux : ℝ → ℝ) : ℝ × ℝ :=
  (capacity * state, flux state)

end NumStability.Leveque02Tracer
