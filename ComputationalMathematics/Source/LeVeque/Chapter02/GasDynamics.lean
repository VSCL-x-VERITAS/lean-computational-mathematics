/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.GasDynamics
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02

/-!
# LeVeque Chapter 2, printed page 24: mass and momentum in a gas

Section 2.6 stops treating the velocity as given data. A gas can be compressed,
so the density varies from point to point, and the velocity becomes a second
unknown to be found alongside it.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.GasDynamics`.
-/

namespace NumStability

/-- Equation (2.31): at constant velocity the density satisfies the advection
equation.

The source's reason is that the flux is `ū ρ` and `ū` is constant, which is the
uniform advective flux of (2.5) applied to the density instead of a tracer. The
first conjunct is that specialisation and the second writes it in the subscript
form the equation is printed in. -/
theorem leveque02_equation31_constantVelocityDensityAdvection
    {rho rhot rhox : ℝ → ℝ → ℝ} {speed : ℝ}
    (hrhot : ∀ x t, HasDerivAt (fun τ => rho x τ) (rhot x t) t)
    (hrhox : ∀ x t, HasDerivAt (fun y => rho y t) (rhox x t) x) :
    (∀ x t,
        (deriv (fun τ => rho x τ) t
            + deriv (fun y => uniformAdvectiveFlux speed (rho y t) y t) x = 0)
          ↔ leveque01_equation02_scalarAdvectionAt rho speed x t) ∧
      (∀ x t, leveque01_equation02_scalarAdvectionAt rho speed x t ↔
        rhot x t + speed * rhox x t = 0) :=
  ⟨fun x t => by
     rw [(hrhot x t).deriv]
     exact advectionEquation_iff_uniformFluxLaw hrhot hrhox x t,
   fun x t => advectionSolution_iff_residual hrhot hrhox x t⟩

/-- Equation (2.32): the continuity equation.

The density flux still takes the form (2.3), a velocity times the density, but
the velocity is now an unknown of its own. The first conjunct identifies the
flux as that product; the second expands its spatial derivative by the product
rule, which is where the term the constant-velocity case does not have appears.

The equation models conservation of mass in the sense the chapter has used
throughout: the density's balance carries no source. -/
theorem leveque02_equation32_continuityEquation
    {rho rhox u ux : ℝ → ℝ → ℝ}
    (hu : ∀ x t, HasDerivAt (fun y => u y t) (ux x t) x)
    (hrhox : ∀ x t, HasDerivAt (fun y => rho y t) (rhox x t) x) :
    (∀ x t, advectiveFlux u (rho x t) x t = u x t * rho x t) ∧
      (∀ x t, HasDerivAt (fun y => u y t * rho y t)
        (ux x t * rho x t + u x t * rhox x t) x) :=
  ⟨fun _ _ => rfl, fun x t => (hu x t).mul (hrhox x t)⟩

/-- Equation (2.32) agrees with equation (2.31) only when the velocity is
constant.

The source says "only if", and the mathematics gives both directions and a
sharper constant: the two equations have the same spatial flux term for every
density exactly when the velocity equals the very speed the advection equation
uses. -/
theorem leveque02_continuityMatchesAdvectionIffConstant
    {u u' : ℝ → ℝ} {speed : ℝ} (hu : ∀ x, HasDerivAt u (u' x) x) :
    (∀ rho rhox : ℝ → ℝ → ℝ,
        (∀ x t, HasDerivAt (fun y => rho y t) (rhox x t) x) →
        ∀ x t, u' x * rho x t + u x * rhox x t = speed * rhox x t)
      ↔ ∀ x, u x = speed :=
  continuityFlux_eq_uniform_iff hu

/-- The momentum flux is a convective part and a pressure part.

The source derives the convective part rather than declaring it: for any density
`q` the flux carried with the fluid is `q u`, so for the momentum density `ρ u`
it is `ρ u²`. The first conjunct is that derivation, using the chapter's own
advective flux.

The second is what makes the decomposition a determination rather than a naming:
the total flux minus the convective part is the pressure exactly. The third
shows the pressure part is a genuine second contribution, since a nonzero
pressure makes the flux differ from the purely convective one.

The fourth is the remark that only pressure differences matter: adding a
constant to the pressure leaves the endpoint difference, and so the momentum
balance, unchanged. The fifth shows that is special to constants. -/
theorem leveque02_momentumFluxDecomposition :
    (∀ (rho u : ℝ → ℝ → ℝ) (x t : ℝ),
        advectiveFlux u (rho x t * u x t) x t = rho x t * u x t * u x t) ∧
      (∀ (rho u pressure : ℝ → ℝ → ℝ) (x t : ℝ),
        momentumFlux rho u pressure x t
            - advectiveFlux u (rho x t * u x t) x t = pressure x t) ∧
      (∀ (rho u pressure : ℝ → ℝ → ℝ) (x t : ℝ), pressure x t ≠ 0 →
        momentumFlux rho u pressure x t
          ≠ advectiveFlux u (rho x t * u x t) x t) ∧
      (∀ (rho u pressure : ℝ → ℝ → ℝ) (c x₁ x₂ t : ℝ),
        momentumFlux rho u (fun y s => pressure y s + c) x₁ t
            - momentumFlux rho u (fun y s => pressure y s + c) x₂ t
          = momentumFlux rho u pressure x₁ t
            - momentumFlux rho u pressure x₂ t) ∧
      (∃ (rho u pressure shifted : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ),
        momentumFlux rho u shifted x₁ t - momentumFlux rho u shifted x₂ t
          ≠ momentumFlux rho u pressure x₁ t
            - momentumFlux rho u pressure x₂ t) :=
  ⟨fun rho u x t => momentumFlux_convective_eq_advectiveFlux rho u x t,
   fun rho u pressure x t =>
     momentumFlux_sub_convective_eq_pressure rho u pressure x t,
   fun _ _ _ _ _ h => momentumFlux_ne_convective_of_pressure_ne_zero h,
   fun rho u pressure c x₁ x₂ t =>
     momentumFlux_difference_invariant_under_constant rho u pressure c x₁ x₂ t,
   momentumFlux_difference_not_invariant_under_nonconstant⟩

/-- Equation (2.33): the momentum integral law.

The total momentum in a section is the integral of the momentum density, and it
changes only through the flux at the endpoints, which is the chapter's section
balance with the momentum flux in place of the tracer flux. The second conjunct
records that this flux is the decomposed one, so the row says which flux the
balance is taken against rather than leaving it abstract. -/
theorem leveque02_equation33_momentumIntegralLaw
    {rho u pressure : ℝ → ℝ → ℝ}
    (hbalance : IsSectionBalance (fun x t => rho x t * u x t)
      (momentumFlux rho u pressure)) :
    IsSectionBalance (fun x t => rho x t * u x t)
        (momentumFlux rho u pressure) ∧
      (∀ x t, momentumFlux rho u pressure x t
        = rho x t * u x t * u x t + pressure x t) :=
  ⟨hbalance, fun _ _ => rfl⟩

end NumStability
