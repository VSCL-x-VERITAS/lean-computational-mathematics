/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.TensorMultiplicationTarget

/-! Proof of the tensor multiplication identity from Bhatia, *Matrix Analysis*, Chapter I.4. -/

namespace NumStability.Bhatia.Chapter01

open NumStability.Bhatia.Chapter01.Targets

theorem tensorMultiplication : Targets.tensorMultiplication := by
  intro H _ _ _ A B C D
  exact (TensorProduct.map_comp A B C D).symm

end NumStability.Bhatia.Chapter01
