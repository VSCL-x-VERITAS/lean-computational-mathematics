/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Deriv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.SectionMass

/-!
# Scalar flux laws and the integral balance of a section

A one-dimensional conservation law is assembled from three pieces: the mass a
density assigns to a section, the flux past a station, and the balance saying
the first changes only through the second.  `SectionMass` supplies the first.
This module supplies the other two for scalar state.

A flux law here is the general signature `f q x t`, depending on the state, the
position and the time.  Autonomy is the property of not depending on the last
two, and it is what lets the endpoint terms of a balance be written as a
function of the state alone.  The advective flux is the running example: it is
autonomous exactly when the velocity field is constant along the pipe in the
sense the balance can see.

Every statement carries its integrability and differentiability hypotheses
explicitly rather than assuming a global regularity class.
-/

open MeasureTheory
open scoped Interval

namespace NumStability

/-- A scalar flux law in full generality: the flux carried past position `x` at
time `t` when the state there is `q`. -/
abbrev ScalarFluxLaw : Type := ℝ → ℝ → ℝ → ℝ

/-- A flux law is autonomous when the state alone determines the flux,
independently of where and when it is evaluated. -/
def IsAutonomousFlux (f : ScalarFluxLaw) : Prop :=
  ∀ q x t x' t', f q x t = f q x' t'

/-- The flux law induced by a velocity field: velocity times density. -/
def advectiveFlux (u : ℝ → ℝ → ℝ) : ScalarFluxLaw := fun q x t => u x t * q

/-- The flux law induced by a single constant velocity. -/
def uniformAdvectiveFlux (speed : ℝ) : ScalarFluxLaw := fun q _ _ => speed * q

@[simp] theorem uniformAdvectiveFlux_apply (speed q x t : ℝ) :
    uniformAdvectiveFlux speed q x t = speed * q := rfl

@[simp] theorem advectiveFlux_apply (u : ℝ → ℝ → ℝ) (q x t : ℝ) :
    advectiveFlux u q x t = u x t * q := rfl

/-- A constant velocity gives an autonomous flux law. -/
theorem uniformAdvectiveFlux_isAutonomous (speed : ℝ) :
    IsAutonomousFlux (uniformAdvectiveFlux speed) := fun _ _ _ _ _ => rfl

/-- The advective flux of a varying velocity field is autonomous exactly when
the velocity is the same at every station and time.  So the general flux law is
genuinely more general than the autonomous one, which is the distinction the
source draws between its two flux forms. -/
theorem advectiveFlux_isAutonomous_iff (u : ℝ → ℝ → ℝ) :
    IsAutonomousFlux (advectiveFlux u) ↔ ∀ x t x' t', u x t = u x' t' := by
  constructor
  · intro h x t x' t'
    have := h 1 x t x' t'
    simpa using this
  · intro h q x t x' t'
    simp [advectiveFlux, h x t x' t']

/-- Every autonomous flux law is the composition of a function of the state
with the state, so its endpoint values depend on nothing but the state there. -/
theorem IsAutonomousFlux.exists_state_function {f : ScalarFluxLaw}
    (h : IsAutonomousFlux f) :
    ∃ g : ℝ → ℝ, ∀ q x t, f q x t = g q :=
  ⟨fun q => f q 0 0, fun q x t => h q x t 0 0⟩

/-- The balance of one fixed section, with an interior production term.

This is the shape of the printed derivation before its hypothesis is imposed.
The section is a single one delimited by two stations; the two endpoint fluxes
are functions of time alone, indexed by their endpoint, as the source
introduces them; and `production t` is the net rate at which the substance is
created inside the section at time `t`.  Equation (2.2) is the case where that
term vanishes, and the later source-term equation of the chapter is the case
where it does not. -/
def IsSectionBalanceWithProduction (q : ℝ → ℝ → ℝ) (x₁ x₂ : ℝ)
    (F₁ F₂ production : ℝ → ℝ) : Prop :=
  ∀ t, HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
    (F₁ t - F₂ t + production t) t

/-- The balance of one fixed section with nothing created or destroyed inside
it: the mass between the two stations changes at exactly the rate of the inward
flux at the two endpoints. -/
def IsSectionBalanceOn (q : ℝ → ℝ → ℝ) (x₁ x₂ : ℝ) (F₁ F₂ : ℝ → ℝ) : Prop :=
  ∀ t, HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂) (F₁ t - F₂ t) t

/-- The printed inference: if nothing is created or destroyed within the
section, the balance reduces to the endpoint fluxes alone.  Stating the
production term explicitly is what makes the source's premise a hypothesis that
can be discharged rather than an assumption absorbed into a definition. -/
theorem isSectionBalanceOn_of_no_production {q : ℝ → ℝ → ℝ} {x₁ x₂ : ℝ}
    {F₁ F₂ production : ℝ → ℝ}
    (hbalance : IsSectionBalanceWithProduction q x₁ x₂ F₁ F₂ production)
    (hno : ∀ t, production t = 0) :
    IsSectionBalanceOn q x₁ x₂ F₁ F₂ := by
  intro t
  have h := hbalance t
  rwa [hno t, add_zero] at h

/-- Conversely the premise is necessary as well as sufficient: a section whose
mass obeys the endpoint balance has vanishing net production. -/
theorem no_production_of_isSectionBalanceOn {q : ℝ → ℝ → ℝ} {x₁ x₂ : ℝ}
    {F₁ F₂ production : ℝ → ℝ}
    (hbalance : IsSectionBalanceWithProduction q x₁ x₂ F₁ F₂ production)
    (hplain : IsSectionBalanceOn q x₁ x₂ F₁ F₂) (t : ℝ) :
    production t = 0 := by
  have := (hbalance t).unique (hplain t)
  linarith

/-- The balance holding on every section at once, with a flux field defined at
every station.  This is the later, stronger form the chapter reaches once the
flux has been tied to the state; it is kept separate from the one-section
balance of (2.2). -/
def IsSectionBalance (q : ℝ → ℝ → ℝ) (F : ℝ → ℝ → ℝ) : Prop :=
  ∀ x₁ x₂ t,
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂) (F x₁ t - F x₂ t) t

/-- The global form restricts to the one-section form at any pair of stations,
so the two are related in the expected direction and the stronger one is never
mistaken for the printed claim. -/
theorem IsSectionBalance.on {q : ℝ → ℝ → ℝ} {F : ℝ → ℝ → ℝ}
    (h : IsSectionBalance q F) (x₁ x₂ : ℝ) :
    IsSectionBalanceOn q x₁ x₂ (fun t => F x₁ t) (fun t => F x₂ t) :=
  fun t => h x₁ x₂ t

/-- The inward flux at the left endpoint of a section is the signed flux, and at
the right endpoint it is its negative.  Their sum is the right-hand side of the
balance, which is what the source means by calling both terms fluxes *into* the
section. -/
theorem inward_flux_sum (F : ℝ → ℝ → ℝ) (x₁ x₂ t : ℝ) :
    F x₁ t + -F x₂ t = F x₁ t - F x₂ t := by ring

/-- The balance pins the endpoint flux difference: a density cannot satisfy the
balance against two flux fields whose endpoint differences disagree anywhere,
because a derivative is unique where it exists. -/
theorem sectionBalance_unique_difference {q : ℝ → ℝ → ℝ} {F G : ℝ → ℝ → ℝ}
    (hF : IsSectionBalance q F) (hG : IsSectionBalance q G) (x₁ x₂ t : ℝ) :
    F x₁ t - F x₂ t = G x₁ t - G x₂ t :=
  (hF x₁ x₂ t).unique (hG x₁ x₂ t)

/-- The conservation consequence the source names as the basis of conservation:
if no net flux crosses either end of a section, the mass in that section never
changes. -/
theorem sectionMass_const_of_balanced {q : ℝ → ℝ → ℝ} {F : ℝ → ℝ → ℝ}
    (h : IsSectionBalance q F) {x₁ x₂ : ℝ} (hF : ∀ t, F x₁ t = F x₂ t)
    (s t : ℝ) :
    sectionMass (fun x => q x s) x₁ x₂ = sectionMass (fun x => q x t) x₁ x₂ := by
  have hderiv : ∀ τ : ℝ,
      HasDerivAt (fun σ => sectionMass (fun x => q x σ) x₁ x₂) 0 τ := by
    intro τ
    have hbal := h x₁ x₂ τ
    rwa [hF τ, sub_self] at hbal
  exact is_const_of_deriv_eq_zero (fun τ => (hderiv τ).differentiableAt)
    (fun τ => (hderiv τ).deriv) s t

/-- The balance is satisfiable, and not only by the zero density: a density
growing linearly in time at unit rate is balanced by the flux field `-x`.  The
predicate is therefore not vacuous. -/
theorem sectionBalance_nonvacuous :
    IsSectionBalance (fun _ t => t) (fun x _ => -x) := by
  intro x₁ x₂ t
  have hfun : (fun τ : ℝ => sectionMass (fun x => (fun _ t => t) x τ) x₁ x₂)
      = fun τ : ℝ => (x₂ - x₁) * τ := by
    funext τ
    simp [sectionMass, mul_comm]
  rw [hfun]
  have hlinear : HasDerivAt (fun τ : ℝ => (x₂ - x₁) * τ) (x₂ - x₁) t := by
    simpa using HasDerivAt.const_mul (x₂ - x₁) (hasDerivAt_id t)
  convert hlinear using 1
  ring

/-- A travelling wave is balanced by its own profile: for `q x t = h (x - t)` the
flux field `F x t = h (x - t)` satisfies the balance, provided `h` has the
antiderivative `H`.  This is the unit-speed advective balance written out. -/
theorem sectionBalance_travellingWave {h H : ℝ → ℝ}
    (hH : ∀ y : ℝ, HasDerivAt H (h y) y) (hc : Continuous h) :
    IsSectionBalance (fun x t => h (x - t)) (fun x t => h (x - t)) := by
  intro x₁ x₂ t
  have hmass : ∀ τ : ℝ,
      sectionMass (fun x => h (x - τ)) x₁ x₂ = H (x₂ - τ) - H (x₁ - τ) := by
    intro τ
    rw [sectionMass, intervalIntegral.integral_comp_sub_right (fun y => h y) τ]
    exact intervalIntegral.integral_eq_sub_of_hasDerivAt
      (fun y _ => hH y) (hc.intervalIntegrable _ _)
  have hfun : (fun τ : ℝ => sectionMass (fun x => h (x - τ)) x₁ x₂)
      = fun τ : ℝ => H (x₂ - τ) - H (x₁ - τ) := funext hmass
  rw [hfun]
  have hleft : HasDerivAt (fun τ : ℝ => H (x₁ - τ)) (-h (x₁ - t)) t := by
    simpa using (hH (x₁ - t)).comp t ((hasDerivAt_id t).const_sub x₁)
  have hright : HasDerivAt (fun τ : ℝ => H (x₂ - τ)) (-h (x₂ - t)) t := by
    simpa using (hH (x₂ - t)).comp t ((hasDerivAt_id t).const_sub x₂)
  have := hright.sub hleft
  convert this using 1
  ring

/-- The conservation clause has a genuinely non-degenerate witness: a travelling
sine wave over one full period.  The density varies in both space and time, the
two endpoints are distinct, the endpoint fluxes agree at every time, and the mass
of the section is a nonzero constant.  Without this the conservation clause would
be certified only where its hypothesis forces the section to be degenerate. -/
theorem sectionBalance_periodicWitness (x₁ : ℝ) :
    IsSectionBalance (fun x t => Real.sin (x - t)) (fun x t => Real.sin (x - t)) ∧
      (∀ t : ℝ, Real.sin (x₁ - t) = Real.sin (x₁ + 2 * Real.pi - t)) ∧
      x₁ ≠ x₁ + 2 * Real.pi := by
  refine ⟨sectionBalance_travellingWave (H := fun y => -Real.cos y)
      (fun y => ?_) Real.continuous_sin, fun t => ?_, ?_⟩
  · simpa using (Real.hasDerivAt_cos y).neg
  · rw [show x₁ + 2 * Real.pi - t = x₁ - t + 2 * Real.pi by ring, Real.sin_add_two_pi]
  · have := Real.pi_pos
    intro hcontra
    nlinarith [hcontra]

/-- Under a balance, the rate of change of the section mass is exactly the total
inward flux. -/
theorem sectionBalance_rate_eq_inward {q : ℝ → ℝ → ℝ} {F : ℝ → ℝ → ℝ}
    (h : IsSectionBalance q F) (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
      (F x₁ t + -F x₂ t) t := by
  simpa [inward_flux_sum] using h x₁ x₂ t

/-- With an autonomous flux law the endpoint terms of the balance are values of
a single function of the state, so the balance closes in the state alone.  This
is what makes the autonomous case solvable for the state where the general case
is not. -/
theorem sectionBalance_of_autonomous {q : ℝ → ℝ → ℝ} {f : ScalarFluxLaw}
    (hf : IsAutonomousFlux f)
    (h : IsSectionBalance q (fun x t => f (q x t) x t)) :
    ∃ g : ℝ → ℝ, ∀ x₁ x₂ t,
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (g (q x₁ t) - g (q x₂ t)) t := by
  obtain ⟨g, hg⟩ := hf.exists_state_function
  exact ⟨g, fun x₁ x₂ t => by simpa [hg] using h x₁ x₂ t⟩

/-- The same balance stated with the given flux law rather than an extracted
one.  This keeps the hypothesis's own `f` in the conclusion, so nothing the
caller supplied is discarded. -/
theorem sectionBalance_endpoints_of_autonomous {q : ℝ → ℝ → ℝ} {f : ScalarFluxLaw}
    (h : IsSectionBalance q (fun x t => f (q x t) x t)) (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
      (f (q x₁ t) x₁ t - f (q x₂ t) x₂ t) t :=
  h x₁ x₂ t

/-- The balance induced by a velocity field: the flux past each station is the
advective flux there.  This is what ties the modelling definitions of (2.3) and
(2.4) to the balance of (2.2), rather than leaving them beside it. -/
def IsAdvectiveBalance (q : ℝ → ℝ → ℝ) (u : ℝ → ℝ → ℝ) : Prop :=
  IsSectionBalance q (fun x t => advectiveFlux u (q x t) x t)

theorem isAdvectiveBalance_iff (q : ℝ → ℝ → ℝ) (u : ℝ → ℝ → ℝ) :
    IsAdvectiveBalance q u ↔
      ∀ x₁ x₂ t,
        HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
          (u x₁ t * q x₁ t - u x₂ t * q x₂ t) t :=
  Iff.rfl

/-- A uniform velocity makes the advective balance autonomous, with the single
state function of (2.5) serving every section and time. -/
theorem isAdvectiveBalance_uniform {q : ℝ → ℝ → ℝ} {speed : ℝ}
    (h : IsSectionBalance q (fun x t => uniformAdvectiveFlux speed (q x t) x t)) :
    ∃ g : ℝ → ℝ, ∀ x₁ x₂ t,
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (g (q x₁ t) - g (q x₂ t)) t :=
  sectionBalance_of_autonomous (uniformAdvectiveFlux_isAutonomous speed) h

/-- Evaluation between limits, the notation of the source's shorthand: the value
at the upper limit minus the value at the lower limit. -/
def evalBetween (g : ℝ → ℝ) (a b : ℝ) : ℝ := g b - g a

@[simp] theorem evalBetween_apply (g : ℝ → ℝ) (a b : ℝ) :
    evalBetween g a b = g b - g a := rfl

/-- The shorthand denotes the endpoint flux difference of the balance: minus the
composed flux evaluated between the limits is the inward total. -/
theorem neg_evalBetween_eq_flux_difference (g : ℝ → ℝ) (a b : ℝ) :
    -evalBetween g a b = g a - g b := by
  simp [evalBetween]

/-- The linear density of a substance in a pipe of constant cross-section is the
volumetric density scaled by the cross-sectional area, and the mass of a section
scales with it. -/
noncomputable def linearDensity (volumetric : ℝ → ℝ → ℝ) (area : ℝ) :
    ℝ → ℝ → ℝ := fun x t => area * volumetric x t

theorem sectionMass_linearDensity (volumetric : ℝ → ℝ → ℝ) (area : ℝ)
    (x₁ x₂ t : ℝ) :
    sectionMass (fun x => linearDensity volumetric area x t) x₁ x₂ =
      area * sectionMass (fun x => volumetric x t) x₁ x₂ := by
  simp [sectionMass, linearDensity, intervalIntegral.integral_const_mul]

/-- A tracer is carried by a velocity field that does not depend on the tracer's
own density.  The hypothesis is stated on a velocity assignment indexed by the
density, so that independence is a property rather than a convention. -/
def IsTracerVelocity (velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ) : Prop :=
  ∀ q r, velocity q = velocity r

/-- For a tracer the flux is linear in the density, which is what makes the
conservation law for the tracer a linear equation. -/
theorem advectiveFlux_isLinear_of_tracer
    {velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} (h : IsTracerVelocity velocity)
    (q r : ℝ → ℝ → ℝ) (c s x t : ℝ) :
    advectiveFlux (velocity q) (c * s) x t =
      c * advectiveFlux (velocity r) s x t := by
  rw [h q r]
  simp [advectiveFlux]
  ring

/-- The sign convention: for a nonnegative density the advective flux is
positive exactly where the velocity is, so the sign of the flux records the
direction of transport and its absolute value the magnitude. -/
theorem advectiveFlux_pos_iff {u : ℝ → ℝ → ℝ} {q x t : ℝ} (hq : 0 < q) :
    0 < advectiveFlux u q x t ↔ 0 < u x t := by
  simp [advectiveFlux, mul_pos_iff]
  constructor
  · rintro (⟨h, _⟩ | ⟨_, h⟩)
    · exact h
    · linarith
  · intro h
    exact Or.inl ⟨h, hq⟩

theorem advectiveFlux_abs_of_neg {u : ℝ → ℝ → ℝ} {q x t : ℝ}
    (h : advectiveFlux u q x t < 0) :
    |advectiveFlux u q x t| = -advectiveFlux u q x t :=
  abs_of_neg h

/-! ### Orientation of the endpoint fluxes

The printed sign convention makes a positive flux rightward transport, so
whether a station's flux adds to or subtracts from the mass of a section depends
on which end of the section that station is.  Carrying the outward direction as
data keeps the dependence inside the statement instead of leaving it to the
reader. -/

/-- The rate at which the conserved quantity enters a section across one of its
endpoints.  `normal` is the outward direction there: `-1` at the left end of a
section and `1` at the right end. -/
def inwardFlux (normal : ℝ) (F : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ := -normal * F x t

@[simp] theorem inwardFlux_left (F : ℝ → ℝ → ℝ) (x t : ℝ) :
    inwardFlux (-1) F x t = F x t := by simp [inwardFlux]

@[simp] theorem inwardFlux_right (F : ℝ → ℝ → ℝ) (x t : ℝ) :
    inwardFlux 1 F x t = -F x t := by simp [inwardFlux]

/-- Rightward transport past the left station carries the quantity into the
section. -/
theorem inwardFlux_pos_of_rightward {F : ℝ → ℝ → ℝ} {x t : ℝ} (h : 0 < F x t) :
    0 < inwardFlux (-1) F x t := by simpa using h

/-- Leftward transport past the right station also carries it in. -/
theorem inwardFlux_pos_of_leftward {F : ℝ → ℝ → ℝ} {x t : ℝ} (h : F x t < 0) :
    0 < inwardFlux 1 F x t := by simpa using h

/-- The two orientations differ, so the sign flip at the right station carries
information rather than restating the left one. -/
theorem inwardFlux_orientation_ne :
    ∃ (F : ℝ → ℝ → ℝ) (x t : ℝ), inwardFlux (-1) F x t ≠ inwardFlux 1 F x t :=
  ⟨fun _ _ => 1, 0, 0, by norm_num⟩

/-- The right-hand side of the balance is the sum of the two inward fluxes. -/
theorem sectionBalance_rate_eq_inflow {q : ℝ → ℝ → ℝ} {F : ℝ → ℝ → ℝ}
    (h : IsSectionBalance q F) (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
      (inwardFlux (-1) F x₁ t + inwardFlux 1 F x₂ t) t := by
  simpa [inward_flux_sum] using h x₁ x₂ t

/-- Reversing the section exchanges the roles of the two stations and negates
the rate, so the source's ordering `x₁ < x₂` is load-bearing for the sign. -/
theorem isSectionBalanceWithProduction_reverse {q : ℝ → ℝ → ℝ} {x₁ x₂ : ℝ}
    {F₁ F₂ production : ℝ → ℝ}
    (h : IsSectionBalanceWithProduction q x₁ x₂ F₁ F₂ production) (t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₂ x₁)
      (-(F₁ t - F₂ t + production t)) t := by
  have hfun : (fun τ => sectionMass (fun x => q x τ) x₂ x₁)
      = fun τ => -sectionMass (fun x => q x τ) x₁ x₂ := by
    funext τ
    exact sectionMass_symm _ _ _
  rw [hfun]
  exact (h t).neg

/-! ### The linear density carries the cross-sectional area -/

@[simp] theorem linearDensity_apply (volumetric : ℝ → ℝ → ℝ) (area x t : ℝ) :
    linearDensity volumetric area x t = area * volumetric x t := rfl

/-- A positive cross-section preserves the sign of the density, which is what
makes the rescaled quantity a density at all. -/
theorem linearDensity_nonneg_iff {volumetric : ℝ → ℝ → ℝ} {area : ℝ}
    (harea : 0 < area) (x t : ℝ) :
    0 ≤ linearDensity volumetric area x t ↔ 0 ≤ volumetric x t := by
  rw [linearDensity_apply]
  exact mul_nonneg_iff_of_pos_left harea

/-- The volumetric density is recoverable from the linear one, so the area
factor is genuine data rather than a lost constant. -/
theorem volumetric_of_linearDensity {volumetric : ℝ → ℝ → ℝ} {area : ℝ}
    (harea : area ≠ 0) (x t : ℝ) :
    volumetric x t = linearDensity volumetric area x t / area := by
  rw [linearDensity_apply]
  field_simp

/-- The rescaling is not the identity, so the area factor is not vacuous. -/
theorem linearDensity_ne_self :
    ∃ (w : ℝ → ℝ → ℝ) (a x t : ℝ), 0 < a ∧ linearDensity w a x t ≠ w x t :=
  ⟨fun _ _ => 1, 2, 0, 0, by norm_num, by norm_num⟩

/-! ### A tracer's velocity is fixed data -/

/-- Independence of the tracer means there is a single velocity field, the same
for every density. -/
theorem IsTracerVelocity.exists_field
    {velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} (h : IsTracerVelocity velocity) :
    ∃ u : ℝ → ℝ → ℝ, ∀ q, velocity q = u :=
  ⟨velocity fun _ _ => 0, fun q => h q _⟩

/-- The flux of the tracer at its own value is computed from that one common
field, which is the whole content of the one-way coupling. -/
theorem advectiveFlux_tracer_eval
    {velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} (h : IsTracerVelocity velocity)
    (q r : ℝ → ℝ → ℝ) (x t : ℝ) :
    advectiveFlux (velocity q) (q x t) x t = velocity r x t * q x t := by
  rw [h q r]
  rfl

/-- Tracer independence is a real restriction: a velocity that responds to the
density fails it. -/
theorem exists_not_isTracerVelocity :
    ∃ w : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ, ¬ IsTracerVelocity w := by
  refine ⟨fun q => q, fun h => ?_⟩
  have := congrFun (congrFun (h (fun _ _ => 0) fun _ _ => 1) 0) 0
  norm_num at this

/-! ### The sign convention in full -/

/-- For a positive density the flux is negative exactly where the velocity is,
so a negative flux records leftward transport. -/
theorem advectiveFlux_neg_iff {u : ℝ → ℝ → ℝ} {q x t : ℝ} (hq : 0 < q) :
    advectiveFlux u q x t < 0 ↔ u x t < 0 := by
  rw [advectiveFlux_apply]
  constructor
  · intro h
    by_contra hu
    push_neg at hu
    nlinarith
  · intro h
    exact mul_neg_of_neg_of_pos h hq

/-- The remaining case of the trichotomy: no transport exactly where the
velocity vanishes. -/
theorem advectiveFlux_eq_zero_iff {u : ℝ → ℝ → ℝ} {q x t : ℝ} (hq : 0 < q) :
    advectiveFlux u q x t = 0 ↔ u x t = 0 := by
  rw [advectiveFlux_apply, mul_eq_zero]
  exact ⟨fun h => h.resolve_right (ne_of_gt hq), Or.inl⟩

/-- The magnitude of a leftward flux is the leftward speed times the density,
which is the source's `|F_i(t)|`. -/
theorem advectiveFlux_abs_of_leftward {u : ℝ → ℝ → ℝ} {q x t : ℝ} (hq : 0 < q)
    (hu : u x t < 0) : |advectiveFlux u q x t| = -u x t * q := by
  rw [advectiveFlux_apply, abs_of_neg (mul_neg_of_neg_of_pos hu hq), neg_mul]

/-- Positivity of the density is load-bearing: for a negative density the sign
of the flux no longer records the direction of the velocity. -/
theorem advectiveFlux_sign_needs_pos :
    ∃ (v : ℝ → ℝ → ℝ) (p x t : ℝ),
      p < 0 ∧ v x t < 0 ∧ 0 < advectiveFlux v p x t := by
  refine ⟨fun _ _ => -1, -1, 0, 0, by norm_num, by norm_num, ?_⟩
  rw [advectiveFlux_apply]
  norm_num


/-! ### The flux law carries the velocity that produced it -/

/-- Evaluating the density at a different station changes the flux, so the
source's insistence that both factors are taken *at the same point* is content
rather than notation. -/
theorem advectiveFlux_point_matters :
    ∃ (v w : ℝ → ℝ → ℝ) (y s y' : ℝ),
      advectiveFlux v (w y' s) y s ≠ advectiveFlux v (w y s) y s := by
  refine ⟨fun _ _ => 1, fun a _ => a, 0, 0, 1, ?_⟩
  simp [advectiveFlux]

/-- The flux vanishes where either factor does. -/
theorem advectiveFlux_eq_zero_of {u : ℝ → ℝ → ℝ} {q x t : ℝ}
    (h : u x t = 0 ∨ q = 0) : advectiveFlux u q x t = 0 := by
  rcases h with h | h <;> simp [advectiveFlux, h]

/-- The flux law determines the velocity field that produced it.  This is what
makes "since the velocity is a known function we can write the flux as a flux
law" a lossless rewriting rather than a discarding of data. -/
theorem advectiveFlux_inj {u v : ℝ → ℝ → ℝ} :
    advectiveFlux u = advectiveFlux v ↔ u = v := by
  constructor
  · intro h
    funext x t
    have hxt := congrFun (congrFun (congrFun h 1) x) t
    simpa [advectiveFlux] using hxt
  · rintro rfl
    rfl

/-- The constant-velocity flux law is the advective law of the constant field,
which is the sense in which the source's "in particular" specialises the general
flux law. -/
theorem uniformAdvectiveFlux_eq_advectiveFlux (speed : ℝ) :
    uniformAdvectiveFlux speed = advectiveFlux fun _ _ => speed := rfl

/-- The constant speed is recoverable from the law it induces. -/
theorem uniformAdvectiveFlux_inj {a b : ℝ} :
    uniformAdvectiveFlux a = uniformAdvectiveFlux b ↔ a = b := by
  constructor
  · intro h
    have h0 := congrFun (congrFun (congrFun h 1) 0) 0
    simpa using h0
  · rintro rfl
    rfl

/-- Constancy of the velocity is load-bearing: a velocity that varies in space
gives a law that is not autonomous. -/
theorem exists_not_isAutonomousFlux :
    ∃ v : ℝ → ℝ → ℝ, ¬ IsAutonomousFlux (advectiveFlux v) := by
  refine ⟨fun x _ => x, fun h => ?_⟩
  have h1 := h 1 0 0 1 0
  simp [advectiveFlux] at h1

/-- The evaluation shorthand is not its own negation, so the minus sign the
source writes in front of it carries information. -/
theorem evalBetween_ne_neg_evalBetween :
    ∃ (h : ℝ → ℝ) (a b : ℝ), evalBetween h a b ≠ -evalBetween h a b := by
  refine ⟨id, 0, 1, ?_⟩
  norm_num [evalBetween]


/-! ### What the three modelling conventions actually pin down -/

/-- The inward sign assignment is forced, not chosen.  If some pair of
coefficients makes the rate of change of every balanced section read as a
combination of the two endpoint fluxes, those coefficients are `+1` at the left
station and `-1` at the right one.  This is the content of the printed remark
that both terms represent fluxes *into* the section: the minus sign on the
right-hand station is the only one that works. -/
theorem inwardFlux_coefficients_unique {a b : ℝ}
    (h : ∀ (q F : ℝ → ℝ → ℝ), IsSectionBalance q F → ∀ x₁ x₂ t,
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (a * F x₁ t + b * F x₂ t) t) :
    a = 1 ∧ b = -1 := by
  have key : ∀ x₁ x₂ : ℝ, a * -x₁ + b * -x₂ = -x₁ - -x₂ := fun x₁ x₂ =>
    (h _ _ sectionBalance_nonvacuous x₁ x₂ 0).unique
      (sectionBalance_nonvacuous x₁ x₂ 0)
  constructor <;> linarith [key 1 0, key 0 1]

/-- The cross-sectional area is determined by the linear density it produces, so
it is genuine data rather than a factor that washes out. -/
theorem linearDensity_area_unique {w : ℝ → ℝ → ℝ} {a b : ℝ}
    (hw : ∃ y s, w y s ≠ 0) (h : linearDensity w a = linearDensity w b) :
    a = b := by
  obtain ⟨y, s, hys⟩ := hw
  have hys' := congrFun (congrFun h y) s
  simp only [linearDensity] at hys'
  exact mul_right_cancel₀ hys hys'

/-- For a tracer the flux scales with the density: rescaling the transported
field rescales its flux by the same factor.  This is the linearity the chapter
relies on, and it needs the velocity to ignore the field it carries. -/
theorem advectiveFlux_scale_of_tracer
    {velocity : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ} (h : IsTracerVelocity velocity)
    (q : ℝ → ℝ → ℝ) (c x t : ℝ) :
    advectiveFlux (velocity fun y s => c * q y s) (c * q x t) x t
      = c * advectiveFlux (velocity q) (q x t) x t := by
  rw [h (fun y s => c * q y s) q]
  simp only [advectiveFlux]
  ring

/-- Without tracer independence that scaling fails, so the hypothesis is exactly
what buys the linearity rather than decorating it. -/
theorem exists_state_dependent_velocity_not_linear :
    ∃ w : (ℝ → ℝ → ℝ) → ℝ → ℝ → ℝ, ¬ IsTracerVelocity w ∧
      ∃ (q : ℝ → ℝ → ℝ) (c x t : ℝ),
        advectiveFlux (w fun y s => c * q y s) (c * q x t) x t
          ≠ c * advectiveFlux (w q) (q x t) x t := by
  refine ⟨fun q => q, fun hcon => ?_, fun _ _ => 1, 2, 0, 0, ?_⟩
  · have hzo := congrFun (congrFun (hcon (fun _ _ => 0) fun _ _ => 1) 0) 0
    norm_num at hzo
  · norm_num [advectiveFlux]


end NumStability
