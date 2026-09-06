/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation01
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation05

/-!
# LeVeque Chapter 1, Equation (1.6)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 2 (raw PDF page 24), equations (1.5)--(1.6).
-/

namespace NumStability

/-- Equation (1.6): the pressure--velocity equations (1.5) are exactly the
constant-coefficient system with state `(p,u)` and matrix
`[[0,K],[1/ρ,0]]`. -/
theorem leveque01_equation06_acousticsMatrixForm
    (pressure velocity : ℝ → ℝ → ℝ)
    (bulkModulus density x t : ℝ) (_hdensity : density ≠ 0) :
    leveque01_equation01_constantLinearSystemAt
        (linearAcousticsState pressure velocity)
        (linearAcousticsMatrix bulkModulus density) x t ↔
      leveque01_equation05_linearAcousticsAt
        pressure velocity bulkModulus density x t :=
  linearAcoustics_matrixForm_iff
    pressure velocity bulkModulus density x t

end NumStability
