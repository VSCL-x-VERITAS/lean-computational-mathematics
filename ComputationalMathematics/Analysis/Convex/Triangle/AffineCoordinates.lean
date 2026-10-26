/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.Convex.Triangle.Coordinates
import Mathlib.Analysis.Convex.Hull
import Mathlib.LinearAlgebra.Complex.Module
import Mathlib.Tactic.FinCases
import Mathlib.Tactic.NormNum

/-!
# Affine views of triangle coordinates

Scalar barycentric coordinates bundled as real affine maps, and their
nonnegativity on a nondegenerate closed triangle.
-/
set_option autoImplicit false

namespace NumStability.ContractionAffineConstruction
noncomputable section

def realAffine (c a b : ℝ) : ℂ →ᵃ[ℝ] ℝ :=
  AffineMap.const ℝ ℂ c + a • Complex.reLm.toAffineMap + b • Complex.imLm.toAffineMap

theorem realAffine_apply (c a b : ℝ) (w : ℂ) :
    realAffine c a b w = c + a * w.re + b * w.im := rfl

def bary1Affine (x0 y0 x1 y1 x2 y2 : ℝ) : ℂ →ᵃ[ℝ] ℝ where
  toFun w := bary1 x0 y0 x1 y1 x2 y2 w.re w.im
  linear :=
    ((y2 - y0) / signedArea x0 y0 x1 y1 x2 y2) • Complex.reLm -
      ((x2 - x0) / signedArea x0 y0 x1 y1 x2 y2) • Complex.imLm
  map_vadd' p v := by
    change bary1 x0 y0 x1 y1 x2 y2 (v + p).re (v + p).im =
      (((y2 - y0) / signedArea x0 y0 x1 y1 x2 y2) * v.re -
        ((x2 - x0) / signedArea x0 y0 x1 y1 x2 y2) * v.im) +
      bary1 x0 y0 x1 y1 x2 y2 p.re p.im
    simp only [bary1, Complex.add_re, Complex.add_im]
    ring

def bary2Affine (x0 y0 x1 y1 x2 y2 : ℝ) : ℂ →ᵃ[ℝ] ℝ where
  toFun w := bary2 x0 y0 x1 y1 x2 y2 w.re w.im
  linear :=
    ((x1 - x0) / signedArea x0 y0 x1 y1 x2 y2) • Complex.imLm -
      ((y1 - y0) / signedArea x0 y0 x1 y1 x2 y2) • Complex.reLm
  map_vadd' p v := by
    change bary2 x0 y0 x1 y1 x2 y2 (v + p).re (v + p).im =
      (((x1 - x0) / signedArea x0 y0 x1 y1 x2 y2) * v.im -
        ((y1 - y0) / signedArea x0 y0 x1 y1 x2 y2) * v.re) +
      bary2 x0 y0 x1 y1 x2 y2 p.re p.im
    simp only [bary2, Complex.add_re, Complex.add_im]
    ring

def bary0Affine (x0 y0 x1 y1 x2 y2 : ℝ) : ℂ →ᵃ[ℝ] ℝ where
  toFun w := bary0 x0 y0 x1 y1 x2 y2 w.re w.im
  linear :=
    -(bary1Affine x0 y0 x1 y1 x2 y2).linear -
      (bary2Affine x0 y0 x1 y1 x2 y2).linear
  map_vadd' p v := by
    have h1 := (bary1Affine x0 y0 x1 y1 x2 y2).map_vadd p v
    have h2 := (bary2Affine x0 y0 x1 y1 x2 y2).map_vadd p v
    change bary1 x0 y0 x1 y1 x2 y2 (v + p).re (v + p).im =
      (bary1Affine x0 y0 x1 y1 x2 y2).linear v +
        bary1 x0 y0 x1 y1 x2 y2 p.re p.im at h1
    change bary2 x0 y0 x1 y1 x2 y2 (v + p).re (v + p).im =
      (bary2Affine x0 y0 x1 y1 x2 y2).linear v +
        bary2 x0 y0 x1 y1 x2 y2 p.re p.im at h2
    change 1 - bary1 x0 y0 x1 y1 x2 y2 (v + p).re (v + p).im -
        bary2 x0 y0 x1 y1 x2 y2 (v + p).re (v + p).im =
      (-(bary1Affine x0 y0 x1 y1 x2 y2).linear v -
          (bary2Affine x0 y0 x1 y1 x2 y2).linear v) +
        (1 - bary1 x0 y0 x1 y1 x2 y2 p.re p.im -
          bary2 x0 y0 x1 y1 x2 y2 p.re p.im)
    rw [h1, h2]
    ring

theorem bary1Affine_apply (x0 y0 x1 y1 x2 y2 : ℝ) (w : ℂ) :
    bary1Affine x0 y0 x1 y1 x2 y2 w = bary1 x0 y0 x1 y1 x2 y2 w.re w.im := rfl

theorem bary2Affine_apply (x0 y0 x1 y1 x2 y2 : ℝ) (w : ℂ) :
    bary2Affine x0 y0 x1 y1 x2 y2 w = bary2 x0 y0 x1 y1 x2 y2 w.re w.im := rfl

theorem bary0Affine_apply (x0 y0 x1 y1 x2 y2 : ℝ) (w : ℂ) :
    bary0Affine x0 y0 x1 y1 x2 y2 w = bary0 x0 y0 x1 y1 x2 y2 w.re w.im := rfl

theorem affine_nonneg_of_mem_triangle
    (f : ℂ →ᵃ[ℝ] ℝ) (z : Fin 3 → ℂ) (hf : ∀ j, 0 ≤ f (z j))
    {w : ℂ} (hw : w ∈ convexHull ℝ (Set.range z)) : 0 ≤ f w := by
  have hs : Set.range z ⊆ f ⁻¹' Set.Ici 0 := by
    rintro _ ⟨j, rfl⟩
    exact hf j
  exact (convexHull_min hs ((convex_Ici (0 : ℝ)).affine_preimage f)) hw

/-- The prescribed coordinates are nonnegative on the entire closed triangle.
The signed-area hypothesis is confined to this nondegenerate internal branch. -/
theorem bary_nonneg_of_mem_triangle (z : Fin 3 → ℂ)
    (hD : signedArea (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im ≠ 0)
    {w : ℂ} (hw : w ∈ convexHull ℝ (Set.range z)) :
    0 ≤ bary0 (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im w.re w.im ∧
    0 ≤ bary1 (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im w.re w.im ∧
    0 ≤ bary2 (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im w.re w.im := by
  have h0 := bary_of_affine_combination
    (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im 1 0 0 hD (by norm_num)
  have h1 := bary_of_affine_combination
    (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im 0 1 0 hD (by norm_num)
  have h2 := bary_of_affine_combination
    (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im 0 0 1 hD (by norm_num)
  simp only [one_mul, zero_mul, add_zero, zero_add] at h0 h1 h2
  have hf0 : ∀ j : Fin 3,
      0 ≤ bary0Affine (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im (z j) := by
    intro j
    rw [bary0Affine_apply]
    fin_cases j <;> simp [h0.1, h1.1, h2.1]
  have hf1 : ∀ j : Fin 3,
      0 ≤ bary1Affine (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im (z j) := by
    intro j
    rw [bary1Affine_apply]
    fin_cases j <;> simp [h0.2.1, h1.2.1, h2.2.1]
  have hf2 : ∀ j : Fin 3,
      0 ≤ bary2Affine (z 0).re (z 0).im (z 1).re (z 1).im (z 2).re (z 2).im (z j) := by
    intro j
    rw [bary2Affine_apply]
    fin_cases j <;> simp [h0.2.2, h1.2.2, h2.2.2]
  exact ⟨by simpa only [bary0Affine_apply] using affine_nonneg_of_mem_triangle _ z hf0 hw,
    by simpa only [bary1Affine_apply] using affine_nonneg_of_mem_triangle _ z hf1 hw,
    by simpa only [bary2Affine_apply] using affine_nonneg_of_mem_triangle _ z hf2 hw⟩

end
end NumStability.ContractionAffineConstruction
