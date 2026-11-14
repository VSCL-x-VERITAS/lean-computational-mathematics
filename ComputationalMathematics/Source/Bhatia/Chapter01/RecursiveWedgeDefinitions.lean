/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorPowerClassPreservationTarget

/-!
Concrete iterated-binary realization of the positive-degree tensor quotient
used by the Bhatia, Matrix Analysis (1997), I.4-I.5 correspondence obligation.
The parameter r denotes degree r+1. No tensor carrier, product inner form,
pure-tensor map is supplied as an arbitrary input.
-/

set_option autoImplicit false
noncomputable section
universe u
open scoped TensorProduct BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

/-- The elementary tensor in the actual recursively constructed Hilbert power. -/
def recursiveTensor (H : Type u)
    [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] :
    (r : ℕ) → (Fin (r + 1) → H) → (tensorPowerFiniteHilbert H r).carrier
  | 0, x => x 0
  | r + 1, x =>
      TensorProduct.tmul ℂ (x 0) (recursiveTensor H r (fun i => x i.succ))

end NumStability.Bhatia.Chapter01.Targets
