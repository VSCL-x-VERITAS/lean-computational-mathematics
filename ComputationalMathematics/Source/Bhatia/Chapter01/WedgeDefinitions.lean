/-
SPDX-License-Identifier: MIT
Bhatia, Matrix Analysis (1997), Chapter I.5.
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.InnerProductSpace.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.PiTensorProduct
import Mathlib.GroupTheory.Perm.Sign
import Mathlib.Analysis.SpecialFunctions.Sqrt

set_option autoImplicit false
universe u
open scoped BigOperators

namespace NumStability.Bhatia.Chapter01.Targets

noncomputable section

/-- The source normalization, interpreted as a complex scalar. -/
def wedgeCoefficient (k : ℕ) : ℂ :=
  (((Real.sqrt (Nat.factorial k : ℝ))⁻¹ : ℝ) : ℂ)

/-- The genuine k-ary normalized signed permutation sum in the tensor quotient.
The source's x_{σ(1)},…,x_{σ(k)} ordering becomes `x (σ i)` at slot i.
-/
def normalizedWedge {H : Type u} [NormedAddCommGroup H]
    [InnerProductSpace ℂ H] [FiniteDimensional ℂ H]
    (k : ℕ) (_hk : 0 < k) (x : Fin k → H) :
    PiTensorProduct ℂ (fun _ : Fin k => H) :=
  wedgeCoefficient k •
    ∑ σ : Equiv.Perm (Fin k),
      (((Equiv.Perm.sign σ : ℤ) : ℂ) •
        PiTensorProduct.tprod ℂ (fun i : Fin k => x (σ i)))


end

end NumStability.Bhatia.Chapter01.Targets
