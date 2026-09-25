/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalKinematicsModel

/-!
# Proof-free target for LeVeque equation (2.92)

The two mixed derivatives of material location are supplied as actual
pointwise derivative witnesses. Their equality is the analytic premise cited
by the source; mere existence of both mixed partials does not ensure it.
-/

namespace NumStability.Leveque02Tracer

/-- The two derivative identities in (2.92) and their equality under
commutation of the mixed partials. -/
def longitudinalMixedPartialsTarget : Prop :=
  ∀ (X : ℝ → ℝ → ℝ) (x t Xxt Xtx : ℝ),
    (∃ δt : ℝ, 0 < δt ∧
      ∀ τ ∈ Set.Ioo (t - δt) (t + δt),
        DifferentiableAt ℝ (fun ξ => X ξ τ) x) →
    (∃ δx : ℝ, 0 < δx ∧
      ∀ ξ ∈ Set.Ioo (x - δx) (x + δx),
        DifferentiableAt ℝ (fun τ => X ξ τ) t) →
    HasDerivAt (fun τ => deriv (fun ξ => X ξ τ) x) Xxt t →
    HasDerivAt (fun ξ => deriv (fun τ => X ξ τ) t) Xtx x →
    Xxt = Xtx →
      HasDerivAt (fun τ => longitudinalStrain X x τ) Xxt t ∧
      HasDerivAt (fun ξ => longitudinalMaterialVelocity X ξ t) Xtx x ∧
      deriv (fun τ => longitudinalStrain X x τ) t = Xxt ∧
      deriv (fun ξ => longitudinalMaterialVelocity X ξ t) x = Xtx ∧
      deriv (fun τ => longitudinalStrain X x τ) t =
        deriv (fun ξ => longitudinalMaterialVelocity X ξ t) x

end NumStability.Leveque02Tracer
