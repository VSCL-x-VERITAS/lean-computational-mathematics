/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearPWaveStressModel

/-!
# Proof-free target for LeVeque equation (2.97)

The spatial stress derivative is the derivative of the full nonlinear
composition. Newton's force balance is an explicit physical premise.
-/

namespace NumStability.Leveque02Tracer

/-- The one-dimensional nonlinear P-wave strain/velocity equations. -/
def nonlinearPWaveSystemTarget : Prop :=
  ∀ (X : ℝ → ℝ → ℝ) (stressLaw : ℝ → ℝ)
      (density x t Xxt Xtx velocityTime stressSpace : ℝ),
    0 < density →
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
      (fun ξ => nonlinearPWaveStress stressLaw X ξ t) stressSpace x →
    density * velocityTime = stressSpace →
      deriv (fun τ => longitudinalStrain X x τ) t -
        deriv (fun ξ => longitudinalMaterialVelocity X ξ t) x = 0 ∧
      density * deriv (fun τ => longitudinalMaterialVelocity X x τ) t -
        deriv (fun ξ => nonlinearPWaveStress stressLaw X ξ t) x = 0

end NumStability.Leveque02Tracer
