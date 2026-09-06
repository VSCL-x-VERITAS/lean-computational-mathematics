/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02
import ComputationalMathematics.Source.LeVeque.Chapter01.Hyperbolicity

/-!
# LeVeque Chapter 1, scalar hyperbolicity

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 1 (raw PDF page 23).  Every real scalar constant-coefficient
equation is hyperbolic, with the scalar coefficient itself as its eigenvalue.
-/

namespace NumStability

/-- Every real scalar constant-coefficient equation is hyperbolic.  Its
one-by-one coefficient matrix has eigenvalue `speed` and the standard basis as
a corresponding real eigenbasis. -/
theorem leveque01_scalarEquation_isHyperbolic (speed : ℝ) :
    leveque01IsHyperbolicMatrix
      (constantCoefficientScalarMatrix speed) := by
  refine ⟨fun _ => speed, Pi.basisFun ℝ (Fin 1), ?_⟩
  intro p
  funext i
  fin_cases p
  fin_cases i
  simp [constantCoefficientScalarMatrix, Matrix.mulVec, dotProduct,
    Pi.basisFun_apply]

end NumStability
