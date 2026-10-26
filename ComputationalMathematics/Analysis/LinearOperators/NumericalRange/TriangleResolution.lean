/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.AffineQuadratic
import ComputationalMathematics.Analysis.Convex.Triangle.AffineCoordinates
import Mathlib.Analysis.InnerProductSpace.LinearMap
import Mathlib.Tactic.Abel

/-!
# Positive resolutions from triangle containment

Fixed coordinate operators resolve the identity and reconstruct a linear map
whose numerical range lies in a nondegenerate triangle.
-/
set_option autoImplicit false
open scoped BigOperators ComplexConjugate
universe u

namespace NumStability.ContractionAffineConstruction
noncomputable section
variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

theorem operator_eq_of_unit_quadratic (S T : H →ₗ[ℂ] H)
    (h : ∀ x : H, ‖x‖ = 1 → inner ℂ x (S x) = inner ℂ x (T x)) : S = T := by
  apply (ext_inner_map S T).mp
  intro x
  have he : inner ℂ x (S x) = inner ℂ x (T x) := by
    by_cases hx : x = 0
    · subst x
      simp
    · rw [linear_quadratic_normalization S x hx,
        linear_quadratic_normalization T x hx,
        h _ (complex_unit_normalization x hx)]
  calc
    inner ℂ (S x) x = conj (inner ℂ x (S x)) :=
      (inner_conj_symm (𝕜 := ℂ) (S x) x).symm
    _ = conj (inner ℂ x (T x)) := congrArg _ he
    _ = inner ℂ (T x) x := inner_conj_symm (𝕜 := ℂ) (T x) x

def triangleCoordinate (z : Fin 3 → ℂ) (j : Fin 3) (w : ℂ) : ℝ :=
  ![bary0 (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im w.re w.im,
    bary1 (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im w.re w.im,
    bary2 (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im w.re w.im] j

variable [FiniteDimensional ℂ H]

def triangleOperators (A : H →ₗ[ℂ] H) (z : Fin 3 → ℂ) : Fin 3 → (H →ₗ[ℂ] H) :=
  ![bary0Operator A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im,
    bary1Operator A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im,
    bary2Operator A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im]

theorem triangleOperators_quadratic_unit (A : H →ₗ[ℂ] H) (z : Fin 3 → ℂ)
    (j : Fin 3) (x : H) (hx : ‖x‖ = 1) :
    inner ℂ x (triangleOperators A z j x) = (triangleCoordinate z j (inner ℂ x (A x)) : ℂ) := by
  fin_cases j
  · simpa [triangleOperators, triangleCoordinate] using
      quadratic_bary0Operator_unit A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im x hx
  · simpa [triangleOperators, triangleCoordinate] using
      quadratic_bary1Operator_unit A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im x hx
  · simpa [triangleOperators, triangleCoordinate] using
      quadratic_bary2Operator_unit A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im x hx

theorem triangleCoordinate_nonneg (z : Fin 3 → ℂ)
    (hD : signedArea (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im ≠ 0)
    {w : ℂ} (hw : w ∈ convexHull ℝ (Set.range z)) (j : Fin 3) :
    0 ≤ triangleCoordinate z j w := by
  obtain ⟨h0, h1, h2⟩ := bary_nonneg_of_mem_triangle z hD hw
  fin_cases j
  · simpa [triangleCoordinate] using h0
  · simpa [triangleCoordinate] using h1
  · simpa [triangleCoordinate] using h2

theorem triangleOperators_sum (A : H →ₗ[ℂ] H) (z : Fin 3 → ℂ) :
    (∑ j, triangleOperators A z j) = LinearMap.id := by
  rw [Fin.sum_univ_three]
  change bary0Operator A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im +
    bary1Operator A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im +
    bary2Operator A (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im = LinearMap.id
  unfold bary0Operator
  abel

theorem triangleOperators_reconstruct (A : H →ₗ[ℂ] H) (z : Fin 3 → ℂ)
    (hD : signedArea (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im ≠ 0) :
    (∑ j, z j • triangleOperators A z j) = A := by
  apply operator_eq_of_unit_quadratic
  intro x hx
  have hc := bary_reconstruct (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im
    (inner ℂ x (A x)).re (inner ℂ x (A x)).im hD
  simp only [LinearMap.sum_apply, LinearMap.smul_apply, inner_sum, inner_smul_right]
  calc
    (∑ j, z j * inner ℂ x (triangleOperators A z j x)) =
        ∑ j, z j * (triangleCoordinate z j (inner ℂ x (A x)) : ℂ) := by
      apply Finset.sum_congr rfl
      intro j _
      rw [triangleOperators_quadratic_unit A z j x hx]
    _ = inner ℂ x (A x) := by
      rw [Fin.sum_univ_three]
      apply Complex.ext
      · simpa [triangleCoordinate, mul_comm] using hc.1
      · simpa [triangleCoordinate, mul_comm] using hc.2

/-- Fixed operators, rather than vector-dependent choices of barycentric weights,
give the positive resolution for the nondegenerate internal branch. -/
theorem positive_resolution_of_triangle_of_area_ne_zero
    (A : H →ₗ[ℂ] H) (z : Fin 3 → ℂ)
    (hD : signedArea (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im ≠ 0)
    (hW : {w : ℂ | ∃ x : H, ‖x‖ = 1 ∧ w = inner ℂ x (A x)} ⊆
      convexHull ℝ (Set.range z)) :
    ∃ P : Fin 3 → (H →ₗ[ℂ] H),
      (∀ j, (P j).IsPositive) ∧ (∑ j, P j) = LinearMap.id ∧ A = ∑ j, z j • P j := by
  refine ⟨triangleOperators A z, ?_, triangleOperators_sum A z,
    (triangleOperators_reconstruct A z hD).symm⟩
  intro j
  apply isPositive_of_unit_sphere
  intro x hx
  rw [triangleOperators_quadratic_unit A z j x hx]
  constructor
  · simp only [Complex.ofReal_re]
  · simp only [Complex.ofReal_re]
    exact triangleCoordinate_nonneg z hD (hW ⟨x, hx, rfl⟩) j

end
end NumStability.ContractionAffineConstruction
