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
    (volumetric : ℝ → ℝ → ℝ) {area : ℝ} (harea : 0 < area) (x₁ x₂ t : ℝ) :
    sectionMass (fun x => linearDensity volumetric area x t) x₁ x₂ =
        area * sectionMass (fun x => volumetric x t) x₁ x₂ ∧
      (∀ x, 0 ≤ linearDensity volumetric area x t ↔ 0 ≤ volumetric x t) ∧
      (∀ b : ℝ, (∃ y s, volumetric y s ≠ 0) →
        linearDensity volumetric area = linearDensity volumetric b → area = b) ∧
      (∃ (w : ℝ → ℝ → ℝ) (a y s : ℝ), 0 < a ∧ linearDensity w a y s ≠ w y s) :=
  ⟨sectionMass_linearDensity volumetric area x₁ x₂ t,
   fun x => linearDensity_nonneg_iff harea x t,
   fun _ hw hb => linearDensity_area_unique hw hb,
   linearDensity_ne_self⟩

/-- The printed sign convention. For a positive density the flux past a station
is positive exactly when the velocity there is positive, so its sign records the
direction of transport; when it is negative its absolute value is the magnitude
of the leftward transport. -/
theorem leveque02_fluxSign_directionAndMagnitude
    {u : ℝ → ℝ → ℝ} {q x t : ℝ} (hq : 0 < q) :
    (0 < advectiveFlux u q x t ↔ 0 < u x t) ∧
      (advectiveFlux u q x t < 0 ↔ u x t < 0) ∧
      (advectiveFlux u q x t = 0 ↔ u x t = 0) ∧
      (u x t < 0 → |advectiveFlux u q x t| = -u x t * q) ∧
      (∃ (v : ℝ → ℝ → ℝ) (p y s : ℝ),
        p < 0 ∧ v y s < 0 ∧ 0 < advectiveFlux v p y s) :=
  ⟨advectiveFlux_pos_iff hq, advectiveFlux_neg_iff hq,
   advectiveFlux_eq_zero_iff hq, advectiveFlux_abs_of_leftward hq,
   advectiveFlux_sign_needs_pos⟩

/-- A tracer is present in concentrations so small that it does not affect the
fluid dynamics: the velocity field does not depend on the tracer density. The
consequence the chapter uses is that the tracer's flux is linear in its
density. -/
theorem leveque02_tracer_velocityIndependent
    {velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} (h : IsTracerVelocity velocity) :
    (∃ u : ℝ → ℝ → ℝ, ∀ q, velocity q = u) ∧
      (∀ (q : ℝ → ℝ → ℝ) (c x t : ℝ),
        advectiveFlux (velocity fun y s => c * q y s) (c * q x t) x t
          = c * advectiveFlux (velocity q) (q x t) x t) ∧
      (∃ w : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ, ¬ IsTracerVelocity w ∧
        ∃ (q : ℝ → ℝ → ℝ) (c x t : ℝ),
          advectiveFlux (w fun y s => c * q y s) (c * q x t) x t
            ≠ c * advectiveFlux (w q) (q x t) x t) :=
  ⟨h.exists_field, advectiveFlux_scale_of_tracer h,
   exists_state_dependent_velocity_not_linear⟩

/-- Equation (2.2) as the page states it.

The printed claim is about one section `x₁ < x₂` of the pipe, with `F₁` and `F₂`
the rates at which the tracer flows past the two fixed stations, each a function
of time alone. Its stated hypothesis is that the substance is neither created
nor destroyed within the section, which the source uses as the premise of a
`Since ... we have`. The conclusion is the displayed equation.

This states that inference: from the balance carrying an interior production
term, together with the premise that the production vanishes, the time
derivative of the section mass is the flux at the left station minus the flux at
the right one. The premise is a hypothesis here rather than something absorbed
into a definition, so it can be discharged, and the companion theorem below
shows it is necessary as well as sufficient.

The ordering `x₁ < x₂` is the source's own, and it is what makes the left and
right stations distinguishable and the integral a mass rather than a signed
quantity. The remaining clauses record that: the two stations are distinct;
reversing the section negates the rate, so the roles of `F₁` and `F₂` are not
interchangeable; and on the stated ordering a nonnegative density has
nonnegative mass. -/
theorem leveque02_equation02
    {q : ℝ → ℝ → ℝ} {x₁ x₂ : ℝ} {F₁ F₂ production : ℝ → ℝ}
    (hbalance : IsSectionBalanceWithProduction q x₁ x₂ F₁ F₂ production) :
    (∀ t, production t = 0) ↔ IsSectionBalanceOn q x₁ x₂ F₁ F₂ :=
  ⟨isSectionBalanceOn_of_no_production hbalance,
   fun hplain t => no_production_of_isSectionBalanceOn hbalance hplain t⟩

/-- The printed section is ordered, `x₁ < x₂`.  The ordering is not needed for
(2.2) itself, which is why it is not a hypothesis there; what it buys is that
the integral (2.1) is a mass rather than a signed quantity.  Recording it here
keeps that separation visible instead of padding the equation with a clause its
own hypotheses do not reach. -/
theorem leveque02_equation02_orderedSection
    {q : ℝ → ℝ → ℝ} {x₁ x₂ : ℝ} (hsection : x₁ < x₂) (τ : ℝ)
    (hq : ∀ x ∈ Set.Icc x₁ x₂, 0 ≤ q x τ) :
    0 ≤ sectionMass (fun x => q x τ) x₁ x₂ :=
  sectionMass_nonneg hsection.le hq

/-- The premise of (2.2) is exactly what the equation costs: a section obeying
the endpoint balance is one in which nothing is created or destroyed. Without
this the premise would be unfalsifiable decoration. -/
theorem leveque02_equation02_premise_necessary
    {q : ℝ → ℝ → ℝ} {x₁ x₂ : ℝ} {F₁ F₂ production : ℝ → ℝ}
    (hbalance : IsSectionBalanceWithProduction q x₁ x₂ F₁ F₂ production)
    (hplain : IsSectionBalanceOn q x₁ x₂ F₁ F₂) (t : ℝ) :
    production t = 0 :=
  no_production_of_isSectionBalanceOn hbalance hplain t

/-- The global flux-field form of the balance, which the chapter reaches only
after tying the flux to the state. It is kept distinct from (2.2). -/
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

/-- What equation (2.2) asserts, stated so that it carries content rather than
unfolding a name.

The printed equation is a modelling posit, so a Lean rendering of it alone is a
definition and an equivalence with that definition is reflexive. The three
clauses here are the facts that make the posit worth asserting, and each can
fail for a weaker predicate. The balance is satisfiable by a density that
genuinely varies, so the notion is not empty. It determines the endpoint flux
difference uniquely, so the fluxes are not free once the density is fixed. And
when no net flux crosses either end, the mass of the section never changes,
which is what the source names as the basis of conservation.

The fourth clause exists because the first three do not certify the third one
non-degenerately: under the linear witness the equal-flux hypothesis forces the
two stations to coincide, and a degenerate section carries no mass. A travelling
sine wave observed over one full period supplies a section with distinct
endpoints, a density varying in both space and time, and endpoint fluxes that
agree at every instant. -/
theorem leveque02_equation02_content :
    leveque02Equation02IntegralForm (fun _ t => t) (fun x _ => -x) ∧
      (∀ (q F G : ℝ → ℝ → ℝ), leveque02Equation02IntegralForm q F →
        leveque02Equation02IntegralForm q G →
        ∀ x₁ x₂ t, F x₁ t - F x₂ t = G x₁ t - G x₂ t) ∧
      (∀ (q F : ℝ → ℝ → ℝ), leveque02Equation02IntegralForm q F →
        ∀ x₁ x₂ : ℝ, (∀ t, F x₁ t = F x₂ t) →
          ∀ s t : ℝ,
            sectionMass (fun x => q x s) x₁ x₂
              = sectionMass (fun x => q x t) x₁ x₂) ∧
      (∀ x₁ : ℝ,
        leveque02Equation02IntegralForm
            (fun x t => Real.sin (x - t)) (fun x t => Real.sin (x - t)) ∧
          (∀ t : ℝ, Real.sin (x₁ - t) = Real.sin (x₁ + 2 * Real.pi - t)) ∧
          x₁ ≠ x₁ + 2 * Real.pi) :=
  ⟨sectionBalance_nonvacuous,
   fun _ _ _ hF hG => sectionBalance_unique_difference hF hG,
   fun _ _ h _ _ hF => sectionMass_const_of_balanced h hF,
   sectionBalance_periodicWitness⟩

/-- Both endpoint terms of (2.2) are fluxes *into* the section: the signed flux
at the left endpoint and its negative at the right endpoint sum to the printed
right-hand side. -/
theorem leveque02_equation02_inwardFluxes
    {q : ℝ → ℝ → ℝ} {F : ℝ → ℝ → ℝ}
    (h : leveque02Equation02IntegralForm q F) (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (inwardFlux (-1) F x₁ t + inwardFlux 1 F x₂ t) t ∧
      (0 < F x₁ t → 0 < inwardFlux (-1) F x₁ t) ∧
      (F x₂ t < 0 → 0 < inwardFlux 1 F x₂ t) ∧
      (∀ a b : ℝ,
        (∀ (r G : ℝ → ℝ → ℝ), IsSectionBalance r G → ∀ y₁ y₂ s,
          HasDerivAt (fun τ => sectionMass (fun x => r x τ) y₁ y₂)
            (a * G y₁ s + b * G y₂ s) s) → a = 1 ∧ b = -1) :=
  ⟨sectionBalance_rate_eq_inflow h x₁ x₂ t,
   fun hr => inwardFlux_pos_of_rightward hr,
   fun hl => inwardFlux_pos_of_leftward hl,
   fun _ _ hab => inwardFlux_coefficients_unique hab⟩

/-- Equation (2.3): the flux of the tracer at a point is the product of the
velocity and the density there. -/
theorem leveque02_equation03_advectiveFlux
    (u q : ℝ → ℝ → ℝ) (x t : ℝ) :
    advectiveFlux u (q x t) x t = u x t * q x t ∧
      (0 < q x t → (0 < advectiveFlux u (q x t) x t ↔ 0 < u x t)) ∧
      (u x t = 0 ∨ q x t = 0 → advectiveFlux u (q x t) x t = 0) ∧
      (∃ (v w : ℝ → ℝ → ℝ) (y s y' : ℝ),
        advectiveFlux v (w y' s) y s ≠ advectiveFlux v (w y s) y s) :=
  ⟨rfl, fun hq => advectiveFlux_pos_iff hq, advectiveFlux_eq_zero_of,
   advectiveFlux_point_matters⟩

/-- Equation (2.4): since the velocity is a known function, the flux is written
as a flux law `f(q, x, t)` depending on the state, the position and the time. -/
theorem leveque02_equation04_fluxLaw
    (u : ℝ → ℝ → ℝ) :
    (advectiveFlux u : ScalarFluxLaw) = (fun q x t => u x t * q) ∧
      (∀ (q : ℝ → ℝ → ℝ) (x t : ℝ),
        advectiveFlux u (q x t) x t = u x t * q x t) ∧
      (∀ v : ℝ → ℝ → ℝ, advectiveFlux u = advectiveFlux v ↔ u = v) ∧
      (∀ c q x t : ℝ,
        advectiveFlux u (c * q) x t = c * advectiveFlux u q x t) :=
  ⟨rfl, fun _ _ _ => rfl, fun _ => advectiveFlux_inj, fun c q x t => by
    simp only [advectiveFlux]
    ring⟩

/-- Equation (2.5): when the velocity is a constant the flux law depends on the
state alone. -/
theorem leveque02_equation05_autonomousFlux (speed : ℝ) :
    (∀ q x t, uniformAdvectiveFlux speed q x t = speed * q) ∧
      uniformAdvectiveFlux speed = advectiveFlux (fun _ _ => speed) ∧
      IsAutonomousFlux (uniformAdvectiveFlux speed) ∧
      (∀ s : ℝ, uniformAdvectiveFlux speed = uniformAdvectiveFlux s ↔ speed = s) ∧
      (∃ v : ℝ → ℝ → ℝ, ¬ IsAutonomousFlux (advectiveFlux v)) :=
  ⟨fun _ _ _ => rfl, uniformAdvectiveFlux_eq_advectiveFlux speed,
   uniformAdvectiveFlux_isAutonomous speed, fun _ => uniformAdvectiveFlux_inj,
   exists_not_isAutonomousFlux⟩

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
    {q : ℝ → ℝ → ℝ} {f : ScalarFluxLaw} (hf : IsAutonomousFlux f)
    (h : leveque02Equation02IntegralForm q (fun x t => f (q x t) x t))
    (x₁ x₂ t : ℝ) :
    (∃ g : ℝ → ℝ, (∀ u y s, f u y s = g u) ∧
        HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
          (g (q x₁ t) - g (q x₂ t)) t) ∧
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (f (q x₁ t) x₁ t - f (q x₂ t) x₂ t) t ∧
      (∃ v : ℝ → ℝ → ℝ, ¬ IsAutonomousFlux (advectiveFlux v)) := by
  refine ⟨?_, sectionBalance_endpoints_of_autonomous h x₁ x₂ t,
    exists_not_isAutonomousFlux⟩
  obtain ⟨g, hg⟩ := hf.exists_state_function
  refine ⟨g, hg, ?_⟩
  simpa [hg] using h x₁ x₂ t

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
theorem leveque02_equation07_evaluationNotation
    {q : ℝ → ℝ → ℝ} {g : ℝ → ℝ}
    (h : ∀ y₁ y₂ s, HasDerivAt (fun τ => sectionMass (fun x => q x τ) y₁ y₂)
        (g (q y₁ s) - g (q y₂ s)) s)
    (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (-evalBetween (fun x => g (q x t)) x₁ x₂) t ∧
      (∀ (r : ℝ → ℝ) (a b : ℝ), -evalBetween r a b = r a - r b) ∧
      (∃ (r : ℝ → ℝ) (a b : ℝ), evalBetween r a b ≠ -evalBetween r a b) := by
  refine ⟨?_, neg_evalBetween_eq_flux_difference, evalBetween_ne_neg_evalBetween⟩
  simpa [evalBetween] using h x₁ x₂ t

end NumStability
