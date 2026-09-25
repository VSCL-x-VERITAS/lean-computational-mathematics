/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveStressVelocityModel

/-!
# Proof-free target for LeVeque equation (2.100)

The constitutive law eliminates shear strain. Transverse Newton balance is an
explicit premise; the four neighborhoods make the nested state derivatives
classical near the observation point.
-/

namespace NumStability.Leveque02Tracer

/-- The shear stress and vertical velocity field solves the printed system. -/
def shearWaveStressVelocitySystemTarget : Prop :=
  ∀ (W : ℝ → ℝ → ℝ) (shearModulus density x t
      Wxt Wtx velocityTime stressSpace : ℝ),
    0 < density →
    0 < shearModulus →
    (∃ δt : ℝ, 0 < δt ∧
      ∀ τ ∈ Set.Ioo (t - δt) (t + δt),
        DifferentiableAt ℝ (fun ξ => W ξ τ) x) →
    (∃ δx : ℝ, 0 < δx ∧
      ∀ ξ ∈ Set.Ioo (x - δx) (x + δx),
        DifferentiableAt ℝ (fun τ => W ξ τ) t) →
    (∃ δu : ℝ, 0 < δu ∧
      ∀ τ ∈ Set.Ioo (t - δu) (t + δu),
        DifferentiableAt ℝ (fun s => W x s) τ) →
    (∃ δε : ℝ, 0 < δε ∧
      ∀ ξ ∈ Set.Ioo (x - δε) (x + δε),
        DifferentiableAt ℝ (fun y => W y t) ξ) →
    HasDerivAt (fun τ => deriv (fun ξ => W ξ τ) x) Wxt t →
    HasDerivAt (fun ξ => deriv (fun τ => W ξ τ) t) Wtx x →
    Wxt = Wtx →
    HasDerivAt (fun τ => shearWaveVelocity W x τ) velocityTime t →
    HasDerivAt
      (fun ξ => planeShearStress shearModulus (shearWaveStrain W) ξ t)
      stressSpace x →
    density * velocityTime = stressSpace →
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (shearWaveStressVelocityState W shearModulus)
        (shearWaveStressVelocityMatrix shearModulus density) x t

end NumStability.Leveque02Tracer
