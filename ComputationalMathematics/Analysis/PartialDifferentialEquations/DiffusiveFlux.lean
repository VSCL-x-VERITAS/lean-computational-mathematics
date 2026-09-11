/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm

/-!
# A flux that depends on the gradient

Section 2.2 of LeVeque's Chapter 2 introduces a second kind of flux. Up to this
point the flux at a point was a function of the density there. Fick's law makes
it a function of the density's *gradient* instead, and the source says so
explicitly: "The flux at a point `x` now depends on the value of `q_x` at this
point, rather than on the value of `q`".

That difference is the content of this module, and it is stated rather than
implied: two densities can agree at a point and carry different diffusive fluxes
there, which no flux depending on the value alone can do.

The sign is the other half of Fick's law. The source's reason for it is physical
-- "there will tend to be a net motion from regions where the density is large
to regions where it is smaller" -- and the formal counterpart is that a positive
diffusion coefficient makes the flux oppose the gradient.

Feeding this flux into the differential conservation law turns it into the
diffusion equation, and that step is here too, with the second spatial
derivative named as the derivative operator applied twice.
-/

namespace NumStability

/-- Equation (2.20): Fick's law of diffusion. The flux is the diffusion
coefficient times the gradient, directed against it. -/
def diffusiveFlux (beta gradient : ℝ) : ℝ := -beta * gradient

/-- With a positive diffusion coefficient the flux opposes the gradient: where
the density is rising in space the flux runs the other way, which is the formal
counterpart of matter moving from where it is dense to where it is not. -/
theorem diffusiveFlux_neg_of_gradient_pos {beta gradient : ℝ}
    (hbeta : 0 < beta) (hgrad : 0 < gradient) :
    diffusiveFlux beta gradient < 0 := by
  have : 0 < beta * gradient := mul_pos hbeta hgrad
  simpa [diffusiveFlux] using this

/-- And symmetrically where the density is falling. -/
theorem diffusiveFlux_pos_of_gradient_neg {beta gradient : ℝ}
    (hbeta : 0 < beta) (hgrad : gradient < 0) :
    0 < diffusiveFlux beta gradient := by
  have : beta * gradient < 0 := mul_neg_of_pos_of_neg hbeta hgrad
  simpa [diffusiveFlux] using this

/-- A uniform density carries no diffusive flux, and with a nonzero coefficient
that is the only way to carry none. -/
theorem diffusiveFlux_eq_zero_iff {beta gradient : ℝ} (hbeta : beta ≠ 0) :
    diffusiveFlux beta gradient = 0 ↔ gradient = 0 := by
  simp [diffusiveFlux, hbeta]

/-- The diffusive flux is not a function of the density's value.

Two densities agreeing at a point can have different gradients there, and then
their diffusive fluxes differ. So Fick's law is a genuinely different
constitutive assumption from the advective flux of (2.4), not a rewriting of it:
no function of the value alone can reproduce it. -/
theorem diffusiveFlux_not_determined_by_value {beta : ℝ} (hbeta : beta ≠ 0) :
    ∃ (q r : ℝ → ℝ → ℝ) (qx rx : ℝ → ℝ → ℝ) (x t : ℝ),
      (∀ y s, HasDerivAt (fun z => q z s) (qx y s) y) ∧
        (∀ y s, HasDerivAt (fun z => r z s) (rx y s) y) ∧
        q x t = r x t ∧
        diffusiveFlux beta (qx x t) ≠ diffusiveFlux beta (rx x t) := by
  refine ⟨fun y _ => y, fun y _ => 2 * y, fun _ _ => 1, fun _ _ => 2,
    0, 0, fun y s => ?_, fun y s => ?_, by norm_num, ?_⟩
  · simpa using hasDerivAt_id y
  · simpa using (hasDerivAt_id y).const_mul (2 : ℝ)
  · simp [diffusiveFlux, hbeta]

/-- Equation (2.21): using Fick's flux in the differential conservation law
gives the diffusion equation.

The first conjunct is the printed equation. The second names the coefficient of
the diffusion coefficient as the second spatial derivative of the density, so
the row says which quantity `q_xx` is rather than leaving it a bound family. -/
theorem diffusionEquation_of_conservationLaw
    {q qt qx qxx : ℝ → ℝ → ℝ} {beta : ℝ}
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (hqxx : ∀ x t, HasDerivAt (fun y => qx y t) (qxx x t) x)
    (hlaw : ∀ x t, qt x t + deriv (fun y => diffusiveFlux beta (qx y t)) x = 0)
    (x t : ℝ) :
    qt x t = beta * qxx x t ∧
      qxx x t = deriv (fun y => deriv (fun z => q z t) y) x := by
  have hflux : HasDerivAt (fun y => diffusiveFlux beta (qx y t))
      (-beta * qxx x t) x := by
    simpa [diffusiveFlux] using (hqxx x t).const_mul (-beta)
  have hzero := hlaw x t
  rw [hflux.deriv] at hzero
  refine ⟨by linarith, ?_⟩
  have hfun : (fun y => deriv (fun z => q z t) y) = fun y => qx y t :=
    funext fun y => (hqx y t).deriv
  rw [hfun, (hqxx x t).deriv]

end NumStability
