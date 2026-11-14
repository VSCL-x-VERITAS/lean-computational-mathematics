/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.LinearMap
import Mathlib.LinearAlgebra.Trace
import Mathlib.LinearAlgebra.FiniteDimensional.Defs

/-!
# Numerical-range values as rank-one traces

Proof-free source target for the first displayed equality in Bhatia,
Matrix Analysis (1997), Problem I.6.2, printed page 20 / PDF page 32.
The rank-one endomorphism and basis-independent trace are Mathlib's objects.
-/

set_option autoImplicit false
noncomputable section
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- The quadratic value and rank-one trace agree at every unit vector,
and their full unit-indexed value sets agree. -/
def numericalRangeTraceRepresentationTarget : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (A : H →ₗ[ℂ] H),
    (∀ x : H, ‖x‖ = 1 →
      inner ℂ x (A x) =
        LinearMap.trace ℂ H
          (A.comp (InnerProductSpace.rankOne ℂ x x).toLinearMap)) ∧
    ({z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z = inner ℂ x (A x)} =
      {z : ℂ | ∃ x : H, ‖x‖ = 1 ∧ z =
        LinearMap.trace ℂ H
          (A.comp (InnerProductSpace.rankOne ℂ x x).toLinearMap)})

end NumStability.Bhatia.Chapter01.Targets
