/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.DirectSumTarget

/-!
# Bhatia's external direct sum

Source correspondence for *Matrix Analysis*, Section I.3, printed page 9:
the algebraic pair has coordinatewise operations, and the Hilbert direct sum
has the sum inner product. The actual `WithLp 2` construction includes zero
and unequal dimensional summands.
-/

set_option autoImplicit false
universe u v

namespace NumStability.Bhatia.Chapter01

/-- The concrete external direct sum and its Hilbert inner product. -/
theorem directSum : Targets.directSum.{u, v} := by
  constructor
  · intro U V _ _ _ _ _ _
    exact ⟨fun _ _ _ _ => rfl, fun _ _ _ => rfl⟩
  · intro H K _ _ _ _ _ _
    exact ⟨fun _ _ => rfl, fun _ _ => rfl, WithLp.prod_inner_apply⟩

end NumStability.Bhatia.Chapter01
