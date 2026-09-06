/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation06
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation08

/-!
# LeVeque Chapter 1, algebraic conservation form of linear acoustics

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 4 (raw PDF page 26).  This module records the exact algebraic
conservation form.  The nearby statement that pressure and velocity are only
approximately physical conserved quantities is an empirical modeling caveat,
not a theorem of this formal system.
-/

namespace NumStability

/-- Every pointwise solution of the linear-acoustics equations is a
conservation-law solution with flux `q ↦ A q` for the acoustics matrix. -/
theorem leveque01_acoustics_hasConservationForm
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) (hdensity : density ≠ 0)
    (hacoustics : leveque01_equation05_linearAcousticsAt
      pressure velocity bulkModulus density x t) :
    leveque01_equation08_conservationLawAt
      (linearAcousticsState pressure velocity)
      (constantLinearFlux (linearAcousticsMatrix bulkModulus density)) x t := by
  apply constantCoefficientLinearSystem_isConservationLaw
  exact (leveque01_equation06_acousticsMatrixForm
    pressure velocity bulkModulus density x t hdensity).2 hacoustics

end NumStability
