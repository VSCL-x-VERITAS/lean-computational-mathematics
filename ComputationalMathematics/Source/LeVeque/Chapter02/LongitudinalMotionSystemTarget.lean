/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalMixedPartialsTarget

/-!
# Proof-free target for LeVeque equation (2.91)

The first P-wave motion equation follows from commuting mixed derivatives of
the material map. The second is Newton's force-balance law, supplied here as
an explicit physical premise with actual time and space derivatives. The
constitutive stress law of (2.89) is not yet substituted in this system.
-/

namespace NumStability.Leveque02Tracer

/-- The coupled kinematic and Newton equations for one-dimensional P-wave
motion, with genuine local derivatives and positive material density. -/
def longitudinalMotionSystemTarget : Prop :=
  ∀ (X stress : ℝ → ℝ → ℝ) (density x t Xxt Xtx velocityTime stressSpace : ℝ),
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
    HasDerivAt (fun τ => deriv (fun ξ => X ξ τ) x) Xxt t →
    HasDerivAt (fun ξ => deriv (fun τ => X ξ τ) t) Xtx x →
    Xxt = Xtx →
    HasDerivAt (fun τ => longitudinalMaterialVelocity X x τ) velocityTime t →
    HasDerivAt (fun ξ => stress ξ t) stressSpace x →
    density * velocityTime = stressSpace →
      deriv (fun τ => longitudinalStrain X x τ) t -
          deriv (fun ξ => longitudinalMaterialVelocity X ξ t) x = 0 ∧
        density * deriv (fun τ => longitudinalMaterialVelocity X x τ) t -
          deriv (fun ξ => stress ξ t) x = 0

end NumStability.Leveque02Tracer
