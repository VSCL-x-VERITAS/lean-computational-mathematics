/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Calculus.FirstOrderTaylor

/-!
# Half-time face state for the Richtmyer predictor

The scalar conservation law identifies the initial time derivative at a
fixed face with the negative spatial derivative of the physical flux.
A Lipschitz time derivative then gives the half-step Taylor estimate.
-/

namespace NumStability

/-- A face trace satisfying the conservation PDE at the initial time
has a quadratic half-step temporal Taylor error. -/
theorem leveque04_richtmyer_pdeFace_halfTimeTaylor
    (q : ℝ → ℝ → ℝ) (timeSlope : ℝ → ℝ)
    (face fluxSlope timeStep K : ℝ)
    (hK : 0 ≤ K)
    (htraceDeriv : ∀ τ, HasDerivAt (fun σ => q face σ) (timeSlope τ) τ)
    (htraceLip : ∀ τ σ,
      |timeSlope τ - timeSlope σ| ≤ K * |τ - σ|)
    (hpde : timeSlope 0 + fluxSlope = 0) :
    |q face (timeStep / 2) -
      (q face 0 - timeStep / 2 * fluxSlope)| ≤
        (K / 4) * timeStep ^ 2 := by
  have h := firstOrderTaylorError_le_of_lipschitzDeriv
    (fun τ => q face τ) timeSlope K 0 (timeStep / 2)
    hK htraceDeriv htraceLip
  have hslope : timeSlope 0 = -fluxSlope := by linarith
  rw [hslope] at h
  convert h using 1 <;> ring

end NumStability
