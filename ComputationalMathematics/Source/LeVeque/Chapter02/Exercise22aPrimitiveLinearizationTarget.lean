/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target: linearizing the primitive gas equations

The pressure and velocity fields are perturbed about a constant state. Their
time and space derivatives are proportional to amplitude. The residuals below
are those of (2.122), with density and pressure slope recovered from pressure.
-/

namespace NumStability.Leveque02Tracer

/-- The first amplitude variation of the nonlinear pressure-velocity
residual is the convected acoustics system (2.48). -/
def exercise22aPrimitiveLinearizationTarget : Prop :=
  ∀ (pressureLaw densityFromPressure slopeFromPressure : ℝ → ℝ)
    (backgroundDensity backgroundVelocity pressureSlope : ℝ)
    (pressurePerturbation velocityPerturbation : ℝ → ℝ → ℝ)
    (x t pressureTime pressureSpace velocityTime velocitySpace : ℝ),
    0 < backgroundDensity →
    HasDerivAt pressureLaw pressureSlope backgroundDensity →
    (∀ r : ℝ, 0 < r →
      densityFromPressure (pressureLaw r) = r) →
    (∀ q : ℝ, 0 < densityFromPressure q →
      HasDerivAt pressureLaw (slopeFromPressure q)
        (densityFromPressure q)) →
    DifferentiableAt ℝ densityFromPressure (pressureLaw backgroundDensity) →
    DifferentiableAt ℝ slopeFromPressure (pressureLaw backgroundDensity) →
    HasDerivAt (pressurePerturbation x) pressureTime t →
    HasDerivAt (fun ξ => pressurePerturbation ξ t) pressureSpace x →
    HasDerivAt (velocityPerturbation x) velocityTime t →
    HasDerivAt (fun ξ => velocityPerturbation ξ t) velocitySpace x →
      let backgroundPressure := pressureLaw backgroundDensity
      let pressureAtAmplitude : ℝ → ℝ → ℝ → ℝ :=
        fun amplitude ξ τ => backgroundPressure +
          amplitude * pressurePerturbation ξ τ
      let velocityAtAmplitude : ℝ → ℝ → ℝ → ℝ :=
        fun amplitude ξ τ => backgroundVelocity +
          amplitude * velocityPerturbation ξ τ
      let pressureResidual : ℝ → ℝ := fun amplitude =>
        amplitude * pressureTime +
          velocityAtAmplitude amplitude x t *
            (amplitude * pressureSpace) +
          (densityFromPressure (pressureAtAmplitude amplitude x t) *
            slopeFromPressure (pressureAtAmplitude amplitude x t)) *
            (amplitude * velocitySpace)
      let velocityResidual : ℝ → ℝ := fun amplitude =>
        amplitude * velocityTime +
          (densityFromPressure (pressureAtAmplitude amplitude x t))⁻¹ *
            (amplitude * pressureSpace) +
          velocityAtAmplitude amplitude x t *
            (amplitude * velocitySpace)
      (∀ amplitude,
        HasDerivAt (pressureAtAmplitude amplitude x)
          (amplitude * pressureTime) t ∧
        HasDerivAt (fun ξ => pressureAtAmplitude amplitude ξ t)
          (amplitude * pressureSpace) x ∧
        HasDerivAt (velocityAtAmplitude amplitude x)
          (amplitude * velocityTime) t ∧
        HasDerivAt (fun ξ => velocityAtAmplitude amplitude ξ t)
          (amplitude * velocitySpace) x) ∧
      HasDerivAt pressureResidual
        (pressureTime + backgroundVelocity * pressureSpace +
          backgroundDensity * pressureSlope * velocitySpace) 0 ∧
      HasDerivAt velocityResidual
        (velocityTime + backgroundDensity⁻¹ * pressureSpace +
          backgroundVelocity * velocitySpace) 0 ∧
      ((HasDerivAt pressureResidual 0 0 ∧
          HasDerivAt velocityResidual 0 0) ↔
        pressureTime + backgroundVelocity * pressureSpace +
          backgroundDensity * pressureSlope * velocitySpace = 0 ∧
        backgroundDensity * velocityTime + pressureSpace +
          backgroundDensity * backgroundVelocity * velocitySpace = 0)

end NumStability.Leveque02Tracer
