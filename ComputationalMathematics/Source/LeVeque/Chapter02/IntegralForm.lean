/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ScalarFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem

/-!
# LeVeque Chapter 2, the integral form and its flux laws

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 2,
printed pages 15 to 17 (raw PDF pages 37 to 39): the tracer model, the flux sign
convention, the integral form (2.2), the three flux laws (2.3), (2.4) and (2.5),
the autonomous integral law (2.6) and the evaluation shorthand (2.7).

The chapter builds its conservation law in this order, and the wrappers below
follow it. The one place the mathematics is not simply definitional is the
distinction between (2.4) and (2.5): the source calls a flux *autonomous* when
it depends on the state alone, and the general advective flux is autonomous
exactly when the velocity field is constant, which is proved rather than
asserted.

Equation (2.5) is also where Chapter 2 meets integrated Chapter 1 material. The
constant-speed flux is the one-component case of Chapter 1's
`constantLinearFlux` at `constantCoefficientScalarMatrix`, and the two are shown
to agree rather than being formalised twice.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- The tracer density of the printed model is a linear density: the volumetric
density scaled by the cross-sectional area of the pipe. The mass of a section
scales with the area, which is the content of the printed unit conversion. -/
theorem leveque02_tracerDensity_isAreaScaled
    (volumetric : ℝ → ℝ → ℝ) (area x₁ x₂ t : ℝ) :
    sectionMass (fun x => linearDensity volumetric area x t) x₁ x₂ =
      area * sectionMass (fun x => volumetric x t) x₁ x₂ :=
  sectionMass_linearDensity volumetric area x₁ x₂ t

/-- The printed sign convention. For a positive density the flux past a station
is positive exactly when the velocity there is positive, so its sign records the
direction of transport; when it is negative its absolute value is the magnitude
of the leftward transport. -/
theorem leveque02_fluxSign_directionAndMagnitude
    {u : ℝ → ℝ → ℝ} {q x t : ℝ} (hq : 0 < q) :
    (0 < advectiveFlux u q x t ↔ 0 < u x t) ∧
      (advectiveFlux u q x t < 0 →
        |advectiveFlux u q x t| = -advectiveFlux u q x t) :=
  ⟨advectiveFlux_pos_iff hq, advectiveFlux_abs_of_neg⟩

/-- A tracer is present in concentrations so small that it does not affect the
fluid dynamics: the velocity field does not depend on the tracer density. The
consequence the chapter uses is that the tracer's flux is linear in its
density. -/
theorem leveque02_tracer_velocityIndependent
    {velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} (h : IsTracerVelocity velocity)
    (q r : ℝ → ℝ → ℝ) (c s x t : ℝ) :
    advectiveFlux (velocity q) (c * s) x t =
      c * advectiveFlux (velocity r) s x t :=
  advectiveFlux_isLinear_of_tracer h q r c s x t

/-- Equation (2.2), the basic integral form of a conservation law: the rate of
change of the total mass in a section is the flux in at one end minus the flux
out at the other. -/
abbrev leveque02Equation02IntegralForm
    (q : ℝ → ℝ → ℝ) (F : ℝ → ℝ → ℝ) : Prop :=
  IsSectionBalance q F

/-- The content of (2.2) written out: for every section and every time, the time
derivative of the mass between the two stations is the flux past the first minus
the flux past the second.  Stating it as an equivalence makes the abbreviation
auditable against the printed equation rather than merely asserted. -/
theorem leveque02_equation02_iff (q : ℝ → ℝ → ℝ) (F : ℝ → ℝ → ℝ) :
    leveque02Equation02IntegralForm q F ↔
      ∀ x₁ x₂ t,
        HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
          (F x₁ t - F x₂ t) t :=
  Iff.rfl

/-- Both endpoint terms of (2.2) are fluxes *into* the section: the signed flux
at the left endpoint and its negative at the right endpoint sum to the printed
right-hand side. -/
theorem leveque02_equation02_inwardFluxes
    {q : ℝ → ℝ → ℝ} {F : ℝ → ℝ → ℝ}
    (h : leveque02Equation02IntegralForm q F) (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
      (F x₁ t + -F x₂ t) t :=
  sectionBalance_rate_eq_inward h x₁ x₂ t

/-- Equation (2.3): the flux of the tracer at a point is the product of the
velocity and the density there. -/
theorem leveque02_equation03_advectiveFlux
    (u : ℝ → ℝ → ℝ) (q x t : ℝ) :
    advectiveFlux u q x t = u x t * q := rfl

/-- Equation (2.4): since the velocity is a known function, the flux is written
as a flux law `f(q, x, t)` depending on the state, the position and the time. -/
theorem leveque02_equation04_fluxLaw
    (u : ℝ → ℝ → ℝ) :
    (advectiveFlux u : ScalarFluxLaw) = fun q x t => u x t * q := rfl

/-- Equation (2.5): when the velocity is a constant the flux law depends on the
state alone. -/
theorem leveque02_equation05_autonomousFlux (speed : ℝ) :
    (∀ q x t, uniformAdvectiveFlux speed q x t = speed * q) ∧
      IsAutonomousFlux (uniformAdvectiveFlux speed) :=
  ⟨fun _ _ _ => rfl, uniformAdvectiveFlux_isAutonomous speed⟩

/-- The constant-speed flux law of (2.5) is the one-component case of the
integrated Chapter 1 linear flux, so the two chapters name the same object. -/
theorem leveque02_equation05_matchesChapter01LinearFlux (speed q : ℝ) :
    uniformAdvectiveFlux speed q 0 0 =
      constantLinearFlux (constantCoefficientScalarMatrix speed)
        (fun _ : Fin 1 => q) 0 := by
  simp [uniformAdvectiveFlux, constantLinearFlux,
    constantCoefficientScalarMatrix, Matrix.mulVec, dotProduct]

/-- The printed definition of an autonomous conservation law, and the exact
condition under which the general advective flux (2.4) is one. This is where the
chapter's distinction between its two flux forms has content: (2.5) is
autonomous always, (2.4) only for a uniform velocity field. -/
theorem leveque02_autonomousFlux_iff (u : ℝ → ℝ → ℝ) :
    IsAutonomousFlux (advectiveFlux u) ↔ ∀ x t x' t', u x t = u x' t' :=
  advectiveFlux_isAutonomous_iff u

/-- Equation (2.6): for a general autonomous flux the endpoint terms of the
balance are values of one function of the state, so the balance closes in the
state alone. -/
theorem leveque02_equation06_autonomousBalance
    {q : ℝ → ℝ → ℝ} {f : ScalarFluxLaw}
    (hf : IsAutonomousFlux f)
    (h : leveque02Equation02IntegralForm q (fun x t => f (q x t) x t)) :
    ∃ g : ℝ → ℝ, ∀ x₁ x₂ t,
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (g (q x₁ t) - g (q x₂ t)) t :=
  sectionBalance_of_autonomous hf h

/-- The same equation keeping the caller's own flux law in the conclusion, which
is the printed form of (2.6) literally: the endpoint terms are the flux function
applied to the state at the two stations. -/
theorem leveque02_equation06_endpoints
    {q : ℝ → ℝ → ℝ} {f : ScalarFluxLaw}
    (h : leveque02Equation02IntegralForm q (fun x t => f (q x t) x t))
    (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
      (f (q x₁ t) x₁ t - f (q x₂ t) x₂ t) t :=
  sectionBalance_endpoints_of_autonomous h x₁ x₂ t

/-- The identification the chapter makes between (2.2) and (2.3): the balance
whose station flux is the advective flux is exactly the balance with endpoint
terms u q. This connects the modelling definitions to the conservation law
rather than leaving them beside it. -/
theorem leveque02_advectiveBalance_iff (q : ℝ → ℝ → ℝ) (u : ℝ → ℝ → ℝ) :
    IsAdvectiveBalance q u ↔
      ∀ x₁ x₂ t,
        HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
          (u x₁ t * q x₁ t - u x₂ t * q x₂ t) t :=
  isAdvectiveBalance_iff q u

/-- Equation (2.7): the shorthand of evaluating the composed flux between the
limits denotes exactly the endpoint difference of (2.6). -/
theorem leveque02_equation07_evaluationNotation (g : ℝ → ℝ) (x₁ x₂ : ℝ) :
    -evalBetween g x₁ x₂ = g x₁ - g x₂ :=
  neg_evalBetween_eq_flux_difference g x₁ x₂

end NumStability
