/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DisplacementGradientTarget

/-!
# LeVeque equation (2.85): planar displacement gradient
-/

namespace NumStability.Leveque02Tracer

/-- Differentiating current minus reference position gives the displayed
two-by-two displacement-gradient matrix. -/
theorem displacementGradientFormula : displacementGradientTarget := by
  intro X Y x y t hXx hXy hYx hYy
  have h11 : deriv (fun ξ => X ξ y t - ξ) x =
      deriv (fun ξ => X ξ y t) x - 1 := by
    simpa using (deriv_fun_sub hXx (differentiableAt_id : DifferentiableAt ℝ (fun ξ : ℝ => ξ) x))
  have h12 : deriv (fun η => X x η t - x) y =
      deriv (fun η => X x η t) y := by
    exact deriv_sub_const x
  have h21 : deriv (fun ξ => Y ξ y t - y) x =
      deriv (fun ξ => Y ξ y t) x := by
    exact deriv_sub_const y
  have h22 : deriv (fun η => Y x η t - η) y =
      deriv (fun η => Y x η t) y - 1 := by
    simpa using (deriv_fun_sub hYy (differentiableAt_id : DifferentiableAt ℝ (fun η : ℝ => η) y))
  simp [displacementGradient, materialDisplacement, currentMaterialLocation,
    h11, h12, h21, h22]

end NumStability.Leveque02Tracer
