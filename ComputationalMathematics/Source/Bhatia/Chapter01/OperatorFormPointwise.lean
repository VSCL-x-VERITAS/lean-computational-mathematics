/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Source.Bhatia.Chapter01.OperatorFormPointwiseTarget

set_option autoImplicit false

universe u v

namespace NumStability.Bhatia.Chapter01

/-- The prescribed inner-product function of every complex-linear operator
satisfies the two complete sesquilinear identities of the frozen target. -/
theorem operatorSesquilinearFunctionPointwise_proof :
    Targets.operatorSesquilinearFunctionPointwise.{u, v} := by
  unfold Targets.operatorSesquilinearFunctionPointwise
  intro H K _ _ _ _ _ _ A
  constructor
  · intro a b u v₁ v₂
    change inner ℂ u (A (a • v₁ + b • v₂)) =
      a * inner ℂ u (A v₁) + b * inner ℂ u (A v₂)
    simp only [A.map_add, A.map_smul, inner_add_right, inner_smul_right]
  · intro a b u₁ u₂ v
    change inner ℂ (a • u₁ + b • u₂) (A v) =
      star a * inner ℂ u₁ (A v) + star b * inner ℂ u₂ (A v)
    simp only [inner_add_left, inner_smul_left, starRingEnd_apply]

end NumStability.Bhatia.Chapter01
