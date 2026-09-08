/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.SecondOrder.Classification
import Mathlib.Data.Real.Sqrt

/-!
# LeVeque Chapter 1, second-order wave classification

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25), the classification following equation (1.7).
Positive bulk modulus and density give a positive sound speed.
-/

namespace NumStability

/-- The positive-material sound speed in (1.7) gives the hyperbolic
second-order principal part asserted immediately after that equation. -/
theorem leveque01_equation07_secondOrderHyperbolic
    (bulkModulus density : ℝ)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density) :
    (wavePrincipalPart (Real.sqrt (bulkModulus / density))).IsHyperbolic :=
  wavePrincipalPart_isHyperbolic _ (Real.sqrt_pos.2 (div_pos hbulkModulus hdensity))


end NumStability
