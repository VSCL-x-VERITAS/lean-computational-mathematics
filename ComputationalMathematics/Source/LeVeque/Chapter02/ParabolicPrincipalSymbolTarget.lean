/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ParabolicPrincipalSymbolModel
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# LeVeque Chapter 2: ParabolicPrincipalSymbolTarget

Target for the parabolic principal-symbol condition.
-/

namespace NumStability.Leveque02Tracer

/-- Forward parabolicity for positive variable diffusion. -/
def variableDiffusionParabolicTarget : Prop :=
  ∀ (β : ℝ → ℝ) (spaceDomain : Set ℝ),
    (∀ x ∈ spaceDomain, DifferentiableAt ℝ β x ∧ 0 < β x) →
    ∀ x ∈ spaceDomain,
      IsForwardParabolic
        (variableDiffusionOperator (β x) (deriv β x))

/-- Pointwise links between printed PDEs and operator residuals. -/
def sourceEquationLinksTarget : Prop :=
  (∀ (q : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ) (x t β qt qxx : ℝ),
    HasDerivAt (fun τ => q x τ) qt t →
    (∀ ξ, HasDerivAt (fun z => q z t) (gradient ξ) ξ) →
    HasDerivAt gradient qxx x →
    (deriv (fun τ => q x τ) t = β * deriv gradient x ↔
      residual (diffusionOperator β) qt 0 qxx = 0)) ∧
  (∀ (q : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ) (x t u β qt qxx : ℝ),
    HasDerivAt (fun τ => q x τ) qt t →
    (∀ ξ, HasDerivAt (fun z => q z t) (gradient ξ) ξ) →
    HasDerivAt gradient qxx x →
    (deriv (fun τ => q x τ) t + u * deriv (fun ξ => q ξ t) x =
        β * deriv gradient x ↔
      residual (advectionDiffusionOperator u β) qt (gradient x) qxx = 0)) ∧
  (∀ (q : ℝ → ℝ → ℝ) (β gradient : ℝ → ℝ) (x t qt qxx : ℝ),
    HasDerivAt (fun τ => q x τ) qt t →
    (∀ ξ, HasDerivAt (fun z => q z t) (gradient ξ) ξ) →
    DifferentiableAt ℝ β x →
    HasDerivAt gradient qxx x →
    (deriv (fun τ => q x τ) t =
        deriv (fun ξ => β ξ * gradient ξ) x ↔
      residual (variableDiffusionOperator (β x) (deriv β x))
        qt (gradient x) qxx = 0))

/-- Forward parabolicity of the diffusion and advection-diffusion models. -/
def diffusionAndAdvectionDiffusionParabolicTarget : Prop :=
  sourceEquationLinksTarget ∧ variableDiffusionParabolicTarget ∧
    ∀ (u β : ℝ), 0 < β →
      IsForwardParabolic (diffusionOperator β) ∧
        IsForwardParabolic (advectionDiffusionOperator u β)

end NumStability.Leveque02Tracer
