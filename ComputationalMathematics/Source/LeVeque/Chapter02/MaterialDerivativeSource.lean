/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDerivative
import ComputationalMathematics.Source.LeVeque.Chapter02.MaterialDerivativeSourceTarget

/-!
# LeVeque's scalar material derivative on the real line
-/

namespace NumStability.Leveque02Tracer

/-- The source's ordinary-derivative identity follows from the reusable
material-derivative chain rule on the whole real line. -/
theorem materialDerivativeSource : materialDerivativeSourceTarget := by
  intro q velocity curve F qt qx t hF ht hx hcurve
  have hresult : HasDerivWithinAt (fun τ => q (curve τ) τ)
      (qt + velocity (curve t) • qx) Set.univ t := by
    exact materialDerivative (E := ℝ) q velocity curve F qt qx t
      Set.univ Set.univ Set.univ
      (by simp) (by simp) (by simp)
      (by simp)
      (by simpa only [Set.univ_prod_univ, hasFDerivWithinAt_univ] using hF)
      ht.hasDerivWithinAt hx.hasDerivWithinAt hcurve.hasDerivWithinAt
  simpa only [hasDerivWithinAt_univ, smul_eq_mul] using hresult

end NumStability.Leveque02Tracer
