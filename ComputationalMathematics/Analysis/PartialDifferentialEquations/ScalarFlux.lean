/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.MeanValue
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

/-- The integral balance of a section: the mass between two stations changes at
the rate of the inward flux at the two endpoints.  `F x t` is the signed flux
past the station `x` at time `t`, positive for transport to the right. -/
def IsSectionBalance (q : ℝ → ℝ → ℝ) (F : ℝ → ℝ → ℝ) : Prop :=
  ∀ x₁ x₂ t,
    HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂) (F x₁ t - F x₂ t) t

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

end NumStability
