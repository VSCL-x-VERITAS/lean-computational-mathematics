/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DiffusiveFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.MaterialDerivative

/-!
# LeVeque Chapter 2, printed page 20: the material derivative and diffusion

The page finishes the variable-coefficient discussion and opens Section 2.2.

Equation (2.18) follows a density along a characteristic of a
variable-coefficient flow. Equation (2.19) is the nonconservative form, whose
solutions are constant along the same curves. Equation (2.20) is Fick's law, a
flux of a new kind, and (2.21) is the diffusion equation it produces.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.MaterialDerivative`
and
`ComputationalMathematics.Analysis.PartialDifferentialEquations.DiffusiveFlux`.
-/

namespace NumStability

/-- Equation (2.18): along a characteristic the total derivative of the density
reduces to minus the velocity's spreading rate times the density.

The printed calculation is a chain of four expressions and the three equalities
between them are the three conjuncts. The first is the chain rule with the
curve's velocity replaced by the fluid velocity, which is what being a
characteristic means. The second passes from the advective term to the
conservative one and is where the term `u'(x) q` appears. The third applies
(2.16) and leaves the printed right-hand side. -/
theorem leveque02_equation18_characteristicDecay
    {q qt qx Fx : ℝ → ℝ → ℝ} {u u' : ℝ → ℝ} {X : ℝ → ℝ} {t : ℝ}
    (hX : IsCharacteristicCurve u X)
    (hq : DifferentiableAt ℝ (Function.uncurry q) (X t, t))
    (hqt : ∀ x s, HasDerivAt (fun τ => q x τ) (qt x s) s)
    (hqx : ∀ x s, HasDerivAt (fun ξ => q ξ s) (qx x s) x)
    (hu : ∀ x, HasDerivAt u (u' x) x)
    (hFx : ∀ x s, HasDerivAt (fun y => u y * q y s) (Fx x s) x)
    (hlaw : ∀ x s, qt x s + Fx x s = 0) :
    HasDerivAt (fun τ => q (X τ) τ)
        (qt (X t) t + u (X t) * qx (X t) t) t ∧
      qt (X t) t + u (X t) * qx (X t) t
        = qt (X t) t + Fx (X t) t - u' (X t) * q (X t) t ∧
      qt (X t) t + u (X t) * qx (X t) t = -(u' (X t) * q (X t) t) :=
  characteristic_materialDerivative_of_conservationLaw hX hq hqt hqx hu hFx hlaw

/-- The material derivative.

The source calls `∂_t + u ∂_x` the material derivative because it "represents
differentiation along the characteristic curve, and hence computes the rate of
change observed by a material particle moving with the fluid". That is a claim
about what the operator computes, and it is the first conjunct: applied to a
density at a point of a characteristic, the combination is the derivative of the
density as seen along that curve.

The second conjunct is what stops the name from being decoration. The operator
computes the rate along a curve only when the curve is characteristic: for a
curve whose velocity differs from the fluid velocity, the rate observed along it
is the one with that curve's own velocity, and the two differ whenever the
spatial derivative is nonzero. -/
theorem leveque02_materialDerivativeDefinition :
    (∀ (q : ℝ → ℝ → ℝ) (u : ℝ → ℝ) (X : ℝ → ℝ) (qt qx t : ℝ),
        IsCharacteristicCurve u X →
        DifferentiableAt ℝ (Function.uncurry q) (X t, t) →
        HasDerivAt (fun τ => q (X t) τ) qt t →
        HasDerivAt (fun ξ => q ξ t) qx (X t) →
          HasDerivAt (fun τ => q (X τ) τ) (qt + u (X t) * qx) t) ∧
      (∀ (q : ℝ → ℝ → ℝ) (X : ℝ → ℝ) (X' qt qx t : ℝ),
        DifferentiableAt ℝ (Function.uncurry q) (X t, t) →
        HasDerivAt X X' t →
        HasDerivAt (fun τ => q (X t) τ) qt t →
        HasDerivAt (fun ξ => q ξ t) qx (X t) →
          HasDerivAt (fun τ => q (X τ) τ) (qt + X' * qx) t) := by
  refine ⟨fun _ _ _ _ _ _ hX hq ht hx =>
      hasDerivAt_along_characteristicCurve hX hq ht hx,
    fun _ _ _ _ _ _ hq hX ht hx => ?_⟩
  simpa [smul_eq_mul] using hasDerivAt_along_curve hq hX ht hx

/-- Equations (2.19) and the constancy it produces.

The source says that for the nonconservative equation "the second line of the
right-hand side of (2.18) reduces to zero, so that `q` is now constant along
characteristic curves". Both halves are here: the density is constant along
every characteristic, and the two equations really are different, witnessed by a
velocity and a density satisfying the conservative form everywhere and the
nonconservative form nowhere. -/
theorem leveque02_equation19_nonconservativeAdvection :
    (∀ (q qt qx : ℝ → ℝ → ℝ) (u : ℝ → ℝ) (X : ℝ → ℝ),
        IsCharacteristicCurve u X →
        (∀ t, DifferentiableAt ℝ (Function.uncurry q) (X t, t)) →
        (∀ x s, HasDerivAt (fun τ => q x τ) (qt x s) s) →
        (∀ x s, HasDerivAt (fun ξ => q ξ s) (qx x s) x) →
        (∀ x s, qt x s + u x * qx x s = 0) →
          ∀ t, q (X t) t = q (X 0) 0) ∧
      (∃ (v : ℝ → ℝ) (r rt rx : ℝ → ℝ → ℝ),
        (∀ y, HasDerivAt v 1 y) ∧
          (∀ y s, HasDerivAt (fun τ => r y τ) (rt y s) s) ∧
          (∀ y s, HasDerivAt (fun ξ => r ξ s) (rx y s) y) ∧
          (∀ y s, rt y s + deriv (fun ξ => v ξ * r ξ s) y = 0) ∧
          (∀ y s, rt y s + v y * rx y s ≠ 0)) :=
  ⟨fun _ _ _ _ _ hX hq hqt hqx hlaw =>
     characteristic_constant_of_nonconservative hX hq hqt hqx hlaw,
   conservativeForm_ne_advectiveForm⟩

/-- Equation (2.20): Fick's law of diffusion.

The printed law says the net flux is proportional to the gradient of `q`, with
the diffusion coefficient as the constant, and the surrounding sentence gives
the direction: matter moves from where the density is large to where it is
smaller. The first two conjuncts are that direction, and the third is the
equality case.

The fourth is the sentence the source states immediately before the display, and
it is the one that distinguishes this flux from every flux considered so far:
the flux at a point depends on the value of `q_x` there rather than on the value
of `q`. Two densities agreeing at a point carry different diffusive fluxes when
their gradients differ, which no function of the value alone could do. -/
theorem leveque02_equation20_fickLaw {beta : ℝ} (hbeta : 0 < beta) :
    (∀ gradient : ℝ, diffusiveFlux beta gradient = -beta * gradient) ∧
      (∀ gradient : ℝ, 0 < gradient → diffusiveFlux beta gradient < 0) ∧
      (∀ gradient : ℝ, gradient < 0 → 0 < diffusiveFlux beta gradient) ∧
      (∀ gradient : ℝ, diffusiveFlux beta gradient = 0 ↔ gradient = 0) ∧
      (∃ (q r qx rx : ℝ → ℝ → ℝ) (x t : ℝ),
        (∀ y s, HasDerivAt (fun z => q z s) (qx y s) y) ∧
          (∀ y s, HasDerivAt (fun z => r z s) (rx y s) y) ∧
          q x t = r x t ∧
          diffusiveFlux beta (qx x t) ≠ diffusiveFlux beta (rx x t)) :=
  ⟨fun _ => rfl,
   fun _ hg => diffusiveFlux_neg_of_gradient_pos hbeta hg,
   fun _ hg => diffusiveFlux_pos_of_gradient_neg hbeta hg,
   fun _ => diffusiveFlux_eq_zero_iff (ne_of_gt hbeta),
   diffusiveFlux_not_determined_by_value (ne_of_gt hbeta)⟩

/-- Equation (2.21): using the flux (2.20) in (2.10) gives the diffusion
equation.

The first conjunct is the printed equation. The second says which quantity its
right-hand side multiplies, by naming the second spatial derivative as the
derivative operator applied twice to the density; without it the coefficient
would be an unconstrained family and the row would not have said what `q_xx`
is. -/
theorem leveque02_equation21_diffusionEquation
    {q qt qx qxx : ℝ → ℝ → ℝ} {beta : ℝ}
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (hqxx : ∀ x t, HasDerivAt (fun y => qx y t) (qxx x t) x)
    (hlaw : ∀ x t, qt x t + deriv (fun y => diffusiveFlux beta (qx y t)) x = 0)
    (x t : ℝ) :
    qt x t = beta * qxx x t ∧
      qxx x t = deriv (fun y => deriv (fun z => q z t) y) x :=
  diffusionEquation_of_conservationLaw hqx hqxx hlaw x t

end NumStability
