/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ParabolicPrincipalSymbolTarget
import Mathlib.Tactic

/-!
# LeVeque Chapter 2: ParabolicPrincipalSymbol

Proof of positivity of the diffusion principal symbol.
-/

namespace NumStability.Leveque02Tracer

theorem principalSymbol_eq (op : OneSpaceEvolutionOperator) (τ ξ : ℝ) :
    principalSymbol op τ ξ =
      (op.diffusivity * ξ ^ 2 : ℝ) + Complex.I * (τ : ℂ) := by
  rw [principalSymbol, Complex.mk_eq_add_mul_I, mul_comm (τ : ℂ) Complex.I]

/-- Forward parabolicity requires positive spatial principal part and a
nonzero weighted principal symbol away from zero frequency. -/
theorem diffusion_residual_iff (qt qxx β : ℝ) :
    residual (diffusionOperator β) qt 0 qxx = 0 ↔ qt = β * qxx := by
  simp [residual, diffusionOperator, sub_eq_zero]

theorem advectionDiffusion_residual_iff (qt qx qxx u β : ℝ) :
    residual (advectionDiffusionOperator u β) qt qx qxx = 0 ↔
      qt + u * qx = β * qxx := by
  simp [residual, advectionDiffusionOperator, sub_eq_zero]

theorem variableDiffusion_residual_iff (qt qx qxx β β' : ℝ) :
    residual (variableDiffusionOperator β β') qt qx qxx = 0 ↔
      qt = β' * qx + β * qxx := by
  simp only [residual, variableDiffusionOperator]
  constructor <;> intro h <;> linarith

/-- Under the local derivatives used in the printed equations, the constant
advection-diffusion PDE (2.23) is exactly the zero-residual equation. -/
theorem advectionDiffusion_sourceEquation_iff
    (q : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ) (x t u β qt qxx : ℝ)
    (hqt : HasDerivAt (fun τ => q x τ) qt t)
    (hgradient : ∀ ξ, HasDerivAt (fun z => q z t) (gradient ξ) ξ)
    (hqxx : HasDerivAt gradient qxx x) :
    deriv (fun τ => q x τ) t + u * deriv (fun ξ => q ξ t) x =
        β * deriv gradient x ↔
      residual (advectionDiffusionOperator u β) qt (gradient x) qxx = 0 := by
  rw [hqt.deriv, (hgradient x).deriv, hqxx.deriv]
  exact (advectionDiffusion_residual_iff qt (gradient x) qxx u β).symm

/-- Under actual local derivatives, the constant diffusion PDE (2.21) is
exactly the zero-residual equation. -/
theorem diffusion_sourceEquation_iff
    (q : ℝ → ℝ → ℝ) (gradient : ℝ → ℝ) (x t β qt qxx : ℝ)
    (hqt : HasDerivAt (fun τ => q x τ) qt t)
    (hqxx : HasDerivAt gradient qxx x) :
    deriv (fun τ => q x τ) t = β * deriv gradient x ↔
      residual (diffusionOperator β) qt 0 qxx = 0 := by
  rw [hqt.deriv, hqxx.deriv]
  exact (diffusion_residual_iff qt qxx β).symm

/-- If diffusivity and the spatial gradient are differentiable at `x`,
the divergence-form diffusion PDE (2.22) has the pointwise operator record
with drift `-β'(x)` and diffusion `β(x)`. -/
theorem variableDiffusion_sourceEquation_iff
    (q : ℝ → ℝ → ℝ) (β gradient : ℝ → ℝ) (x t qt qxx : ℝ)
    (hqt : HasDerivAt (fun τ => q x τ) qt t)
    (hβ : DifferentiableAt ℝ β x)
    (hqxx : HasDerivAt gradient qxx x) :
    deriv (fun τ => q x τ) t =
        deriv (fun ξ => β ξ * gradient ξ) x ↔
      residual (variableDiffusionOperator (β x) (deriv β x))
        qt (gradient x) qxx = 0 := by
  have hprod : HasDerivAt (fun ξ => β ξ * gradient ξ)
      (deriv β x * gradient x + β x * qxx) x :=
    hβ.hasDerivAt.mul hqxx
  rw [hqt.deriv, hprod.deriv]
  exact (variableDiffusion_residual_iff qt (gradient x) qxx (β x) (deriv β x)).symm

theorem forwardParabolic_of_positive_diffusivity
    (op : OneSpaceEvolutionOperator) (hβ : 0 < op.diffusivity) :
    IsForwardParabolic op := by
  constructor
  · intro ξ hξ
    exact mul_pos hβ (sq_pos_of_ne_zero hξ)
  · intro τ ξ hfreq hsymbol
    rcases hfreq with hτ | hξ
    · by_cases hx : ξ = 0
      · have him : τ = 0 := by
          simpa [principalSymbol, hx] using congrArg Complex.im hsymbol
        exact hτ him
      · have hre : op.diffusivity * ξ ^ 2 = 0 := by
          simpa [principalSymbol] using congrArg Complex.re hsymbol
        exact (ne_of_gt (mul_pos hβ (sq_pos_of_ne_zero hx))) hre
    · have hre : op.diffusivity * ξ ^ 2 = 0 := by
        simpa [principalSymbol] using congrArg Complex.re hsymbol
      exact (ne_of_gt (mul_pos hβ (sq_pos_of_ne_zero hξ))) hre

theorem diffusion_isForwardParabolic (β : ℝ) (hβ : 0 < β) :
    IsForwardParabolic (diffusionOperator β) := by
  exact forwardParabolic_of_positive_diffusivity _ hβ

theorem advectionDiffusion_isForwardParabolic (u β : ℝ) (hβ : 0 < β) :
    IsForwardParabolic (advectionDiffusionOperator u β) := by
  exact forwardParabolic_of_positive_diffusivity _ hβ

/-- Equation (2.22) is forward parabolic at every point of a spatial domain
where its variable diffusivity is positive and differentiable. Positivity is
pointwise; no uniform lower bound is claimed. -/
theorem variableDiffusionParabolic : variableDiffusionParabolicTarget := by
  intro β spaceDomain hβ x hx
  exact forwardParabolic_of_positive_diffusivity _ (hβ x hx).2

/-- The three printed differential expressions correspond to the actual
coefficient records when the indicated classical derivatives exist. -/
theorem sourceEquationLinks : sourceEquationLinksTarget := by
  refine ⟨?_, ?_, ?_⟩
  · intro q gradient x t β qt qxx hqt hqx hqxx
    exact diffusion_sourceEquation_iff q gradient x t β qt qxx hqt hqxx
  · intro q gradient x t u β qt qxx hqt hqx hqxx
    exact advectionDiffusion_sourceEquation_iff q gradient x t u β qt qxx hqt hqx hqxx
  · intro q β gradient x t qt qxx hqt hqx hβ hqxx
    exact variableDiffusion_sourceEquation_iff q β gradient x t qt qxx hqt hβ hqxx

/-- Source-row scratch target for positive one-space diffusion coefficients,
including pointwise variable diffusivity and all three equation links. -/
theorem diffusionAndAdvectionDiffusionParabolic :
    diffusionAndAdvectionDiffusionParabolicTarget := by
  refine ⟨sourceEquationLinks, variableDiffusionParabolic, ?_⟩
  intro u β hβ
  exact ⟨diffusion_isForwardParabolic β hβ,
    advectionDiffusion_isForwardParabolic u β hβ⟩

end NumStability.Leveque02Tracer
