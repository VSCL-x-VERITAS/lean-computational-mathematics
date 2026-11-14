/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.LinearAlgebra.FiniteDimensional.Basic
import Mathlib.LinearAlgebra.TensorProduct.Map

/-! Proof-free source target for Bhatia, *Matrix Analysis* (1997),
Chapter I.4, printed page 15: composition of tensor operators on H ⊗ H.
Operator multiplication is represented by linear-map composition. -/

namespace NumStability.Bhatia.Chapter01.Targets

/-- Composition of tensor operators equals the tensor of factorwise compositions. -/
def tensorMultiplication : Prop :=
  ∀ (H : Type) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
    [FiniteDimensional ℂ H] (A B C D : H →ₗ[ℂ] H),
    (TensorProduct.map A B).comp (TensorProduct.map C D) =
      TensorProduct.map (A.comp C) (B.comp D)

end NumStability.Bhatia.Chapter01.Targets
