/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.VariableCoefficientAdvection

/-!
# Mass and momentum in a compressible flow

Printed page 24 of LeVeque's Chapter 2 stops treating the velocity as given. A
gas can be compressed, so its density varies, and the velocity becomes a second
unknown rather than a coefficient.

Two claims on that page are checkable rather than descriptive, and both are here.

The continuity equation agrees with the constant-velocity advection equation
exactly when the velocity is that constant. The source says "only if u is
constant"; what the mathematics gives is slightly sharper, that the velocity
must equal the very speed the advection equation uses, and both directions hold.

The momentum flux splits into a part carried along with the fluid and a part due
to pressure. The first is what the chapter's own advective flux formula gives
for the momentum density, so the split is a determination rather than a naming:
the total flux minus the convective one is the pressure, exactly. And only
pressure differences across a section move momentum, which is why a constant
added to the pressure changes nothing.
-/

namespace NumStability

/-! ### Continuity against constant-velocity advection -/

/-- Equation (2.32) agrees with equation (2.31) exactly when the velocity is the
constant the latter uses.

The left-hand side is the spatial derivative of the density flux `ρ u` expanded
by the product rule, and the right-hand side is the advective term of (2.31).
Requiring them to agree for every density forces the velocity to be constant and
then to be that speed; conversely a velocity equal to it makes them agree. -/
theorem continuityFlux_eq_uniform_iff
    {u u' : ℝ → ℝ} {speed : ℝ} (hu : ∀ x, HasDerivAt u (u' x) x) :
    (∀ rho rhox : ℝ → ℝ → ℝ,
        (∀ x t, HasDerivAt (fun y => rho y t) (rhox x t) x) →
        ∀ x t, u' x * rho x t + u x * rhox x t = speed * rhox x t)
      ↔ ∀ x, u x = speed := by
  constructor
  · intro h x
    have hflat := h (fun _ _ => 1) (fun _ _ => 0)
      (fun y s => by simpa using hasDerivAt_const y (1 : ℝ)) x 0
    have hu' : u' x = 0 := by simpa using hflat
    have hramp := h (fun y _ => y) (fun _ _ => 1)
      (fun y s => by simpa using hasDerivAt_id y) x 0
    rw [hu'] at hramp
    simpa using hramp
  · intro h rho rhox _ x t
    have hconst : u' x = 0 := by
      have hc : HasDerivAt u 0 x := by
        have : u = fun _ => speed := funext h
        rw [this]
        simpa using hasDerivAt_const x speed
      exact (hu x).unique hc
    rw [hconst, h x]
    ring

/-! ### The momentum flux -/

/-- The momentum flux of printed page 24: the momentum carried along with the
fluid, plus the pressure. -/
def momentumFlux (rho u pressure : ℝ → ℝ → ℝ) : ℝ → ℝ → ℝ :=
  fun x t => rho x t * u x t * u x t + pressure x t

/-- The convective part is exactly what the chapter's advective flux formula
gives when the quantity being carried is the momentum density itself. -/
theorem momentumFlux_convective_eq_advectiveFlux
    (rho u : ℝ → ℝ → ℝ) (x t : ℝ) :
    advectiveFlux u (rho x t * u x t) x t = rho x t * u x t * u x t := by
  simp [advectiveFlux]
  ring

/-- So the split is a determination: the total momentum flux minus its
convective part is the pressure, with nothing left over and no choice of how to
apportion the two. -/
theorem momentumFlux_sub_convective_eq_pressure
    (rho u pressure : ℝ → ℝ → ℝ) (x t : ℝ) :
    momentumFlux rho u pressure x t - advectiveFlux u (rho x t * u x t) x t
      = pressure x t := by
  rw [momentumFlux_convective_eq_advectiveFlux]
  simp [momentumFlux]

/-- Wherever the pressure is nonzero the momentum flux is not purely convective,
so the pressure part is a genuine second contribution rather than a way of
writing the first. -/
theorem momentumFlux_ne_convective_of_pressure_ne_zero
    {rho u pressure : ℝ → ℝ → ℝ} {x t : ℝ} (h : pressure x t ≠ 0) :
    momentumFlux rho u pressure x t ≠ advectiveFlux u (rho x t * u x t) x t := by
  intro hcon
  exact h (by rw [← momentumFlux_sub_convective_eq_pressure rho u pressure x t,
    hcon, sub_self])

/-- Only a difference in pressure between the two ends of a section changes the
net momentum there, so adding a constant to the pressure leaves the balance
untouched. -/
theorem momentumFlux_difference_invariant_under_constant
    (rho u pressure : ℝ → ℝ → ℝ) (c x₁ x₂ t : ℝ) :
    momentumFlux rho u (fun y s => pressure y s + c) x₁ t
        - momentumFlux rho u (fun y s => pressure y s + c) x₂ t
      = momentumFlux rho u pressure x₁ t - momentumFlux rho u pressure x₂ t := by
  simp only [momentumFlux]
  ring

/-- A nonuniform pressure does change the balance, so the invariance above is
about constants and not about pressure in general. -/
theorem momentumFlux_difference_not_invariant_under_nonconstant :
    ∃ (rho u pressure shifted : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ),
      momentumFlux rho u shifted x₁ t - momentumFlux rho u shifted x₂ t
        ≠ momentumFlux rho u pressure x₁ t - momentumFlux rho u pressure x₂ t := by
  refine ⟨fun _ _ => 0, fun _ _ => 0, fun _ _ => 0, fun y _ => y, 0, 1, 0, ?_⟩
  simp [momentumFlux]

end NumStability
