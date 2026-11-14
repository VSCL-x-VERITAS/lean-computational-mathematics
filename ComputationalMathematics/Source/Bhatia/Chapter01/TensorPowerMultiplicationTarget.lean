/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.Complex.Basic
import Mathlib.Analysis.InnerProductSpace.Defs
import Mathlib.LinearAlgebra.FiniteDimensional.Defs
import Mathlib.LinearAlgebra.PiTensorProduct

universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Bhatia, Matrix Analysis, I.4, tensor-power property 1 (printed p. 15).
The source direct k-fold quotient is represented by the finite family indexed
by `Fin k`; its prescribed action is `PiTensorProduct.map` on the constant
family of endomorphisms. Positive arity excludes an unasserted empty power.
This proposition states only multiplicativity, with `A.comp B` in that order.
-/
def tensorPowerMultiplication : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (k : ℕ), 0 < k →
    ∀ (A B : H →ₗ[ℂ] H),
      ((PiTensorProduct.map (fun _ : Fin k => A) :
          PiTensorProduct ℂ (fun _ : Fin k => H) →ₗ[ℂ]
            PiTensorProduct ℂ (fun _ : Fin k => H)).comp
        (PiTensorProduct.map (fun _ : Fin k => B))) =
      PiTensorProduct.map (fun _ : Fin k => A.comp B)

end NumStability.Bhatia.Chapter01.Targets
