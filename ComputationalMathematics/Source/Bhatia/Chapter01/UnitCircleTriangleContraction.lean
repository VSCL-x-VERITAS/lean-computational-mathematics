/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.LinearOperators.NumericalRange.UnitCircleTriangleContraction
import ComputationalMathematics.Source.Bhatia.Chapter01.UnitCircleTriangleContractionTarget

/-!
# Bhatia Chapter I: unit-circle triangle contraction

The frozen source proposition follows from the reusable numerical-range
contraction theorem.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01

/-- The complete frozen contraction proposition, including degenerate input
triples and zero-dimensional complex inner-product spaces. -/
theorem unitCircleTriangleContraction_proof :
    Targets.unitCircleTriangleContraction.{u} := by
  unfold Targets.unitCircleTriangleContraction
  intro H _ _ _ z hz A
  change ({w : ℂ | ∃ x : H, ‖x‖ = 1 ∧ w = inner ℂ x (A x)} ⊆
    convexHull ℝ (Set.range z)) → ∀ x : H, ‖A x‖ ≤ ‖x‖
  intro hW x
  exact NumStability.ContractionAffineConstruction.norm_apply_le_of_numericalRange_subset_unitCircle_triangle
    z hz A hW x

end NumStability.Bhatia.Chapter01
