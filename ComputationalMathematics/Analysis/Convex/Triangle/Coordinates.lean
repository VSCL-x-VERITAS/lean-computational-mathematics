/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Data.Real.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# Scalar coordinates of a real triangle

Determinant-based signed area and total barycentric coordinates, with
reconstruction identities for nondegenerate triangles.
-/

set_option autoImplicit false

namespace NumStability.ContractionAffineConstruction

noncomputable section

/-- Signed twice-area; its sign is unrestricted. -/
def signedArea (x0 y0 x1 y1 x2 y2 : ℝ) : ℝ :=
  Matrix.det !![x1 - x0, y1 - y0; x2 - x0, y2 - y0]

/-- Scalar expansion of the canonical two-displacement determinant. -/
theorem signedArea_eq (x0 y0 x1 y1 x2 y2 : ℝ) :
    signedArea x0 y0 x1 y1 x2 y2 =
      (x1 - x0) * (y2 - y0) - (y1 - y0) * (x2 - x0) := by
  unfold signedArea
  exact Matrix.det_fin_two_of (x1 - x0) (y1 - y0) (x2 - x0) (y2 - y0)

def bary1 (x0 y0 x1 y1 x2 y2 wx wy : ℝ) : ℝ :=
  ((wx - x0) * (y2 - y0) - (wy - y0) * (x2 - x0)) /
    signedArea x0 y0 x1 y1 x2 y2

def bary2 (x0 y0 x1 y1 x2 y2 wx wy : ℝ) : ℝ :=
  ((x1 - x0) * (wy - y0) - (y1 - y0) * (wx - x0)) /
    signedArea x0 y0 x1 y1 x2 y2

def bary0 (x0 y0 x1 y1 x2 y2 wx wy : ℝ) : ℝ :=
  1 - bary1 x0 y0 x1 y1 x2 y2 wx wy -
    bary2 x0 y0 x1 y1 x2 y2 wx wy

theorem bary_sum (x0 y0 x1 y1 x2 y2 wx wy : ℝ) :
    bary0 x0 y0 x1 y1 x2 y2 wx wy +
      bary1 x0 y0 x1 y1 x2 y2 wx wy +
      bary2 x0 y0 x1 y1 x2 y2 wx wy = 1 := by
  unfold bary0
  ring

/-- Exact reconstruction for either orientation of a nondegenerate triangle. -/
theorem bary_reconstruct (x0 y0 x1 y1 x2 y2 wx wy : ℝ)
    (hD : signedArea x0 y0 x1 y1 x2 y2 ≠ 0) :
    (bary0 x0 y0 x1 y1 x2 y2 wx wy * x0 +
      bary1 x0 y0 x1 y1 x2 y2 wx wy * x1 +
      bary2 x0 y0 x1 y1 x2 y2 wx wy * x2 = wx) ∧
    (bary0 x0 y0 x1 y1 x2 y2 wx wy * y0 +
      bary1 x0 y0 x1 y1 x2 y2 wx wy * y1 +
      bary2 x0 y0 x1 y1 x2 y2 wx wy * y2 = wy) := by
  have hb1 : bary1 x0 y0 x1 y1 x2 y2 wx wy *
      signedArea x0 y0 x1 y1 x2 y2 =
      (wx - x0) * (y2 - y0) - (wy - y0) * (x2 - x0) :=
    div_mul_cancel₀ _ hD
  have hb2 : bary2 x0 y0 x1 y1 x2 y2 wx wy *
      signedArea x0 y0 x1 y1 x2 y2 =
      (x1 - x0) * (wy - y0) - (y1 - y0) * (wx - x0) :=
    div_mul_cancel₀ _ hD
  constructor
  · apply mul_right_cancel₀ hD
    dsimp only [bary0]
    calc
      _ = x0 * signedArea x0 y0 x1 y1 x2 y2 +
          (x1 - x0) * (bary1 x0 y0 x1 y1 x2 y2 wx wy *
            signedArea x0 y0 x1 y1 x2 y2) +
          (x2 - x0) * (bary2 x0 y0 x1 y1 x2 y2 wx wy *
            signedArea x0 y0 x1 y1 x2 y2) := by ring
      _ = _ := by rw [hb1, hb2]; simp only [signedArea_eq]; ring
  · apply mul_right_cancel₀ hD
    dsimp only [bary0]
    calc
      _ = y0 * signedArea x0 y0 x1 y1 x2 y2 +
          (y1 - y0) * (bary1 x0 y0 x1 y1 x2 y2 wx wy *
            signedArea x0 y0 x1 y1 x2 y2) +
          (y2 - y0) * (bary2 x0 y0 x1 y1 x2 y2 wx wy *
            signedArea x0 y0 x1 y1 x2 y2) := by ring
      _ = _ := by rw [hb1, hb2]; simp only [signedArea_eq]; ring

/-- Fixed affine coordinates recover any three-point affine weights.
Nonnegativity, when supplied by convex-hull membership, follows immediately;
no vector-dependent choice is used to define any operator. -/
theorem bary_of_affine_combination (x0 y0 x1 y1 x2 y2 t0 t1 t2 : ℝ)
    (hD : signedArea x0 y0 x1 y1 x2 y2 ≠ 0)
    (hsum : t0 + t1 + t2 = 1) :
    (bary0 x0 y0 x1 y1 x2 y2
      (t0 * x0 + t1 * x1 + t2 * x2)
      (t0 * y0 + t1 * y1 + t2 * y2) = t0) ∧
    (bary1 x0 y0 x1 y1 x2 y2
      (t0 * x0 + t1 * x1 + t2 * x2)
      (t0 * y0 + t1 * y1 + t2 * y2) = t1) ∧
    (bary2 x0 y0 x1 y1 x2 y2
      (t0 * x0 + t1 * x1 + t2 * x2)
      (t0 * y0 + t1 * y1 + t2 * y2) = t2) := by
  have ht0 : t0 = 1 - t1 - t2 := by linarith
  have h1 : bary1 x0 y0 x1 y1 x2 y2
      (t0 * x0 + t1 * x1 + t2 * x2)
      (t0 * y0 + t1 * y1 + t2 * y2) = t1 := by
    unfold bary1
    apply (div_eq_iff hD).2
    rw [ht0]
    simp only [signedArea_eq]
    ring
  have h2 : bary2 x0 y0 x1 y1 x2 y2
      (t0 * x0 + t1 * x1 + t2 * x2)
      (t0 * y0 + t1 * y1 + t2 * y2) = t2 := by
    unfold bary2
    apply (div_eq_iff hD).2
    rw [ht0]
    simp only [signedArea_eq]
    ring
  refine ⟨?_, h1, h2⟩
  unfold bary0
  rw [h1, h2, ht0]

end
end NumStability.ContractionAffineConstruction
