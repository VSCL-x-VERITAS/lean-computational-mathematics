/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.PWaveCoefficientModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneNormalStressModel

/-!
# Proof-free target for LeVeque equation (2.93)

This target eliminates normal stress from the two motion equations using the
constant-modulus constitutive law. Newton's force balance is an explicit
physical premise. Every component derivative is an actual local derivative.
-/

namespace NumStability.Leveque02Tracer

/-- The longitudinal strain-velocity field solves the constant-coefficient
matrix system in (2.93) after substitution of the normal-stress law. -/
def pWaveMatrixSystemTarget : Prop :=
  ∀ (X : ℝ → ℝ → ℝ) (lameLambda shearModulus density x t
      Xxt Xtx strainSpace velocityTime stressSpace : ℝ),
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
    HasDerivAt (fun ξ => longitudinalStrain X ξ t) strainSpace x →
    HasDerivAt (fun τ => longitudinalMaterialVelocity X x τ) velocityTime t →
    HasDerivAt
      (fun ξ => planeNormalStress lameLambda shearModulus
        (longitudinalStrain X) ξ t) stressSpace x →
    density * velocityTime = stressSpace →
      NumStability.IsConstantCoefficientLinearSystemSolutionAt
        (pWaveStrainVelocityState X)
        (pWaveCoefficientMatrix lameLambda shearModulus density) x t

end NumStability.Leveque02Tracer
