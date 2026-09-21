/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobianTarget
import Mathlib.Analysis.Calculus.FDeriv.Mul
import Mathlib.Analysis.Calculus.FDeriv.Prod

/-!
# The gas-flux Jacobian
-/

namespace NumStability.Leveque02Tracer

private theorem fluidStateFlux_hasFDerivAt
    (pressureLaw : ℝ → ℝ) (density velocity pressureSlope : ℝ)
    (hdensity : density ≠ 0) (hpressure : HasDerivAt pressureLaw pressureSlope density) :
    HasFDerivAt (fluidStateFlux pressureLaw)
      (LinearMap.toContinuousLinearMap
        (Matrix.toLin' (fluidFluxJacobian (fluidConservedState density velocity) pressureSlope)))
      (fluidConservedState density velocity) := by
  unfold fluidStateFlux
  rw [hasFDerivAt_pi']
  intro i
  fin_cases i
  · change HasFDerivAt (fun state : Fin 2 → ℝ => state 1) _ _
    convert hasFDerivAt_apply (𝕜 := ℝ) (1 : Fin 2)
      (fluidConservedState density velocity)
    ext v
    simp [fluidFluxJacobian, fluidConservedState, Matrix.toLin'_apply,
      Matrix.vecHead, Matrix.vecTail]
  · let state := fluidConservedState density velocity
    have h0 := hasFDerivAt_apply (𝕜 := ℝ) (0 : Fin 2) state
    have h1 := hasFDerivAt_apply (𝕜 := ℝ) (1 : Fin 2) state
    have hinv := (hasFDerivAt_inv' hdensity).comp state h0
    have hquot := (h1.mul h1).mul hinv
    have hp := hpressure.hasFDerivAt.comp state h0
    have hsum := hquot.add hp
    change HasFDerivAt
      (fun state : Fin 2 → ℝ => state 1 * state 1 / state 0 + pressureLaw (state 0)) _ state
    convert hsum using 1
    ext v
    simp [state, fluidFluxJacobian, fluidConservedState, Matrix.toLin'_apply,
      Matrix.vecHead, Matrix.vecTail, div_eq_mul_inv]
    field_simp [hdensity]
    ring

/-- Differentiating the gas flux gives equation (2.45). -/
theorem fluidJacobian : fluidJacobianTarget := by
  intro pressureLaw density velocity pressureSlope hdensity hpressure
  have hdensity_ne : density ≠ 0 := ne_of_gt hdensity
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [fluidFluxJacobian, fluidConservedState]
    all_goals
      field_simp [hdensity_ne]
  · let derivative : (Fin 2 → ℝ) →L[ℝ] (Fin 2 → ℝ) :=
      LinearMap.toContinuousLinearMap
        (Matrix.toLin' (fluidFluxJacobian (fluidConservedState density velocity) pressureSlope))
    refine ⟨derivative, ?_, ?_⟩
    · exact fluidStateFlux_hasFDerivAt pressureLaw density velocity pressureSlope
        hdensity_ne hpressure
    · simp [derivative]

end NumStability.Leveque02Tracer
