/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDerivativeTarget

/-!
# LeVeque Chapter 2: material derivative along a characteristic

The source uses ordinary time and space derivatives. This contract takes the
scalar, whole-line instance of the material derivative, so its conclusion is
the actual observed rate along the curve.
-/

namespace NumStability.Leveque02Tracer

/-- Along a material curve `X' = u(X)`, the ordinary rate of a scalar field is
its time partial plus velocity times its space partial. -/
def materialDerivativeSourceTarget : Prop :=
  ∀ (q : ℝ → ℝ → ℝ) (velocity curve : ℝ → ℝ)
    (F : (ℝ × ℝ) →L[ℝ] ℝ) (qt qx : ℝ) (t : ℝ),
    HasFDerivAt (Function.uncurry q) F (curve t, t) →
    HasDerivAt (fun τ => q (curve t) τ) qt t →
    HasDerivAt (fun x => q x t) qx (curve t) →
    HasDerivAt curve (velocity (curve t)) t →
    HasDerivAt (fun τ => q (curve τ) τ)
      (qt + velocity (curve t) * qx) t

end NumStability.Leveque02Tracer
