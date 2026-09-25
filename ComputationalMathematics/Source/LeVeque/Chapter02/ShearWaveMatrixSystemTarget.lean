/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneShearStressModel
import ComputationalMathematics.Source.LeVeque.Chapter02.ShearWaveCoefficientModel

/-!
# Proof-free target for LeVeque equation (2.99)

This eliminates shear stress from the S-wave motion equations by the
constant-modulus constitutive law. Newton's balance remains a physical premise.
-/

namespace NumStability.Leveque02Tracer

/-- The shear strain-velocity field solves the printed matrix system. -/
def shearWaveMatrixSystemTarget : Prop :=
  ∀ (W : ℝ → ℝ → ℝ) (shearModulus density x t
      Wxt Wtx strainSpace velocityTime stressSpace : ℝ),
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
    HasDerivAt (fun ξ => shearWaveStrain W ξ t) strainSpace x →
    HasDerivAt (fun τ => shearWaveVelocity W x τ) velocityTime t →
    HasDerivAt
      (fun ξ => planeShearStress shearModulus (shearWaveStrain W) ξ t)
      stressSpace x →
    density * velocityTime = stressSpace →
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (shearWaveStrainVelocityState W)
        (shearWaveCoefficientMatrix shearModulus density) x t

end NumStability.Leveque02Tracer
