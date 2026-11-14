/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.BilinearProductPointwiseTarget

set_option autoImplicit false

universe u

namespace NumStability.Bhatia.Chapter01

/-- The prescribed product obeys the two complete bilinear identities. -/
theorem fixedInnerProductBilinearFunctionPointwise :
    Targets.fixedInnerProductBilinearFunctionPointwise.{u} := by
  unfold Targets.fixedInnerProductBilinearFunctionPointwise
  intro H _ _ _ x y
  constructor
  · intro a b u v₁ v₂
    change inner ℂ x u * inner ℂ y (a • v₁ + b • v₂) =
      a * (inner ℂ x u * inner ℂ y v₁) + b * (inner ℂ x u * inner ℂ y v₂)
    rw [inner_add_right, inner_smul_right, inner_smul_right, mul_add,
      mul_left_comm (inner ℂ x u) a (inner ℂ y v₁),
      mul_left_comm (inner ℂ x u) b (inner ℂ y v₂)]
  · intro a b u₁ u₂ v
    change inner ℂ x (a • u₁ + b • u₂) * inner ℂ y v =
      a * (inner ℂ x u₁ * inner ℂ y v) + b * (inner ℂ x u₂ * inner ℂ y v)
    rw [inner_add_right, inner_smul_right, inner_smul_right, add_mul,
      mul_assoc a (inner ℂ x u₁) (inner ℂ y v),
      mul_assoc b (inner ℂ x u₂) (inner ℂ y v)]

end NumStability.Bhatia.Chapter01
