/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.LinearOperators.NumericalRange.TriangleResolution
import ComputationalMathematics.Geometry.Complex.UnitCircleTriangle
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.PositiveResolution

/-!
# Contraction from a unit-circle triangle

Numerical-range containment in an arbitrary prescribed unit-circle triangle
implies pointwise contraction on finite-dimensional complex inner-product spaces.
-/

set_option autoImplicit false
universe u

namespace NumStability.ContractionAffineConstruction

variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]
  [FiniteDimensional ℂ H]

/-- Full numerical-range containment in an arbitrary prescribed unit-circle
triangle implies pointwise contraction. Repeated or collinear input vertices
and the zero-dimensional space require no additional assumptions. -/
theorem norm_apply_le_of_numericalRange_subset_unitCircle_triangle
    (z : Fin 3 → ℂ) (hz : ∀ j, ‖z j‖ = 1) (A : H →ₗ[ℂ] H)
    (hW : {v : ℂ | ∃ y : H, ‖y‖ = 1 ∧ v = inner ℂ y (A y)} ⊆
      convexHull ℝ (Set.range z)) (x : H) :
    ‖A x‖ ≤ ‖x‖ := by
  obtain ⟨w, hw, _hwi, hzw, hD⟩ := unit_triple_nondegenerate_completion z hz
  have hWw : {v : ℂ | ∃ y : H, ‖y‖ = 1 ∧ v = inner ℂ y (A y)} ⊆
      convexHull ℝ (Set.range w) := by
    intro v hv
    exact convexHull_mono hzw (hW hv)
  obtain ⟨P, hP, hsum, hA⟩ :=
    positive_resolution_of_triangle_of_area_ne_zero A w hD hWw
  exact NumStability.positiveResolution_norm_apply_le P w A hP hsum hA hw x

end NumStability.ContractionAffineConstruction
