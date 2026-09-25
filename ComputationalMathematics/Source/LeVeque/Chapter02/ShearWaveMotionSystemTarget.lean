/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveKinematicsModel

/-!
# Proof-free target for LeVeque equation (2.98)

The shear stress remains independent of the constitutive law at this step.
The transverse Newton force balance is an explicit physical premise.
-/

namespace NumStability.Leveque02Tracer

/-- The two motion equations for one-dimensional plane S-waves. -/
def shearWaveMotionSystemTarget : Prop :=
  ∀ (W shearStress : ℝ → ℝ → ℝ)
      (density x t Wxt Wtx velocityTime stressSpace : ℝ),
    0 < density →
    (∃ δt : ℝ, 0 < δt ∧
      ∀ τ ∈ Set.Ioo (t - δt) (t + δt),
        DifferentiableAt ℝ (fun ξ => W ξ τ) x) →
    (∃ δx : ℝ, 0 < δx ∧
      ∀ ξ ∈ Set.Ioo (x - δx) (x + δx),
        DifferentiableAt ℝ (fun τ => W ξ τ) t) →
    (∃ δu : ℝ, 0 < δu ∧
      ∀ τ ∈ Set.Ioo (t - δu) (t + δu),
        DifferentiableAt ℝ (fun s => W x s) τ) →
    HasDerivAt (fun τ => deriv (fun ξ => W ξ τ) x) Wxt t →
    HasDerivAt (fun ξ => deriv (fun τ => W ξ τ) t) Wtx x →
    Wxt = Wtx →
    HasDerivAt (fun τ => shearWaveVelocity W x τ) velocityTime t →
    HasDerivAt (fun ξ => shearStress ξ t) stressSpace x →
    density * velocityTime = stressSpace →
      deriv (fun τ => shearWaveStrain W x τ) t -
        (1 / 2 : ℝ) * deriv (fun ξ => shearWaveVelocity W ξ t) x = 0 ∧
      density * deriv (fun τ => shearWaveVelocity W x τ) t -
        deriv (fun ξ => shearStress ξ t) x = 0

end NumStability.Leveque02Tracer
