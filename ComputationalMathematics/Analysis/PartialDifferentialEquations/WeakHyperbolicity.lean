/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.LinearAlgebra.Matrix.Charpoly.Eigs

/-!
# Weak hyperbolicity of real constant-coefficient systems

The complete characteristic polynomial must split over the real field,
counting multiplicity. Failure of a complete real eigenbasis distinguishes
this condition from real hyperbolicity. Repeated eigenvalues alone do not.
-/

namespace NumStability

/-- A real matrix is weakly hyperbolic when all characteristic roots are real
but it lacks a complete real eigenbasis. -/
def IsWeaklyHyperbolicMatrix {ι : Type*} [Fintype ι] [DecidableEq ι]
    (coefficient : Matrix ι ι ℝ) : Prop :=
  coefficient.charpoly.Splits ∧ ¬ IsRealHyperbolicMatrix coefficient

end NumStability
