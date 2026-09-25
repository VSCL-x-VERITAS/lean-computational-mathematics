/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveStressVelocityModel

/-!
# Proof-free target for LeVeque equation (2.95)

The constitutive law eliminates strain from the two longitudinal motion
equations. Newton's force balance is an explicit physical premise. The
neighborhoods make all displayed nested derivatives genuine classical ones.
-/

namespace NumStability.Leveque02Tracer

/-- The normal-stress and velocity field solves the constant-coefficient
matrix system in (2.95). -/
def pWaveStressVelocitySystemTarget : Prop :=
  ∀ (X : ℝ → ℝ → ℝ) (lameLambda shearModulus density x t
      Xxt Xtx velocityTime stressSpace : ℝ),
    0 < density →
    0 < lameLambda + 2 * shearModulus →
    (∃ δt : ℝ, 0 < δt ∧
      ∀ τ ∈ Set.Ioo (t - δt) (t + δt),
        DifferentiableAt ℝ (fun ξ => X ξ τ) x) →
    (∃ δx : ℝ, 0 < δx ∧
      ∀ ξ ∈ Set.Ioo (x - δx) (x + δx),
        DifferentiableAt ℝ (fun τ => X ξ τ) t) →
    (∃ δu : ℝ, 0 < δu ∧
      ∀ τ ∈ Set.Ioo (t - δu) (t + δu),
        DifferentiableAt ℝ (fun s => X x s) τ) →
    (∃ δε : ℝ, 0 < δε ∧
      ∀ ξ ∈ Set.Ioo (x - δε) (x + δε),
        DifferentiableAt ℝ (fun y => X y t) ξ) →
    HasDerivAt (fun τ => deriv (fun ξ => X ξ τ) x) Xxt t →
    HasDerivAt (fun ξ => deriv (fun τ => X ξ τ) t) Xtx x →
    Xxt = Xtx →
    HasDerivAt (fun τ => longitudinalMaterialVelocity X x τ) velocityTime t →
    HasDerivAt
      (fun ξ => planeNormalStress lameLambda shearModulus
        (longitudinalStrain X) ξ t) stressSpace x →
    density * velocityTime = stressSpace →
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (pWaveStressVelocityState X lameLambda shearModulus)
        (pWaveStressVelocityMatrix lameLambda shearModulus density) x t

end NumStability.Leveque02Tracer
