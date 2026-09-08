/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation04
import Mathlib.Data.Real.Sqrt

/-!
# LeVeque Chapter 1, right acoustic mode on the positive-ratio domain

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), the connection between (1.5)--(1.6) and (1.4).
The real coordinate and partial-derivative context is on printed page 1.

This separate algebraic-domain statement uses exactly the positive-ratio
condition for `sqrt (K / ρ) > 0`. It asserts the characteristic equation for
the actual pressure and velocity of a given classical acoustic system. It
does not assert physical admissibility of negative material parameters.
-/

namespace NumStability

/-- The given acoustic system's right invariant `p + ρ c u`, with
`c = sqrt (K / ρ)`, obeys the positive-speed one-way equation whenever
`K / ρ > 0`. Nonzero density is supplied by the acoustic-system certificate. -/
theorem leveque01_acousticsRightMode_of_pos_ratio
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hratio : 0 < bulkModulus / density) :
    0 < Real.sqrt (bulkModulus / density) ∧
      ∀ x t,
        leveque01_equation04_oneWayWaveAt
          (linearAcousticsRightInvariant system.pressure system.velocity
            density (Real.sqrt (bulkModulus / density)))
          (Real.sqrt (bulkModulus / density)) x t := by
  have hmaterial : bulkModulus =
      density * (Real.sqrt (bulkModulus / density)) ^ 2 := by
    rw [Real.sq_sqrt hratio.le]
    field_simp [system.density_ne_zero]
  refine ⟨Real.sqrt_pos.2 hratio, ?_⟩
  intro x t
  exact linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
    system.pressure system.velocity bulkModulus density
    (Real.sqrt (bulkModulus / density)) x t system.density_ne_zero
    hmaterial (system.satisfies x t)

end NumStability

#check Real.sq_sqrt
#print axioms Real.sq_sqrt
#check Real.sqrt_pos
#print axioms Real.sqrt_pos
#check NumStability.linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
#print axioms NumStability.linearAcousticsRightInvariant_isLinearAdvectionSolutionAt
#check NumStability.leveque01_acousticsRightMode_of_pos_ratio
#print axioms NumStability.leveque01_acousticsRightMode_of_pos_ratio