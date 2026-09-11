/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm

/-!
# LeVeque Chapter 2, printed page 17: the differential form

Source-local wrappers for the passage that turns the integral balance into a
pointwise conservation law. Each wrapper states what the printed step claims and
carries, alongside it, the evidence that the step's hypotheses are doing work —
the source states them only as "sufficiently smooth".

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm`;
this module only binds it to the printed claims.
-/

namespace NumStability

/-- Equation (2.8): the endpoint flux difference written as an integral.

The printed step rewrites `f(q(x₁,t)) - f(q(x₂,t))` as minus the integral of the
`x`-derivative of the composed flux across the section. It is the fundamental
theorem of calculus, and it needs the derivative to exist across the whole
section and to be integrable there — neither of which the source states. The
second conjunct shows that the first hypothesis cannot be dropped: a step
function with a constant candidate derivative has an endpoint difference that no
such integral reproduces. -/
theorem leveque02_equation08_fluxDifferenceAsIntegral
    {F F' : ℝ → ℝ} {x₁ x₂ : ℝ}
    (hderiv : ∀ x ∈ Set.uIcc x₁ x₂, HasDerivAt F (F' x) x)
    (hint : IntervalIntegrable F' MeasureTheory.volume x₁ x₂) :
    F x₁ - F x₂ = -∫ x in x₁..x₂, F' x ∧
      (∃ (G G' : ℝ → ℝ) (y₁ y₂ : ℝ),
        IntervalIntegrable G' MeasureTheory.volume y₁ y₂ ∧
          G y₁ - G y₂ ≠ -∫ x in y₁..y₂, G' x) :=
  ⟨fluxDifference_eq_neg_integral hderiv hint, fluxDifference_needs_hasDerivAt⟩

/-- The step the source makes when it says the identity holds for every section
and concludes that the integrand vanishes.

Continuity is the hypothesis that licenses it, and the second conjunct shows it
is indispensable rather than a convenience: the indicator of a single point is
nonzero yet every one of its section integrals vanishes, so integrability alone
would yield no pointwise conclusion at all. -/
theorem leveque02_arbitraryInterval_vanishingIntegrand
    {g : ℝ → ℝ} (hg : Continuous g) (h : ∀ a b : ℝ, ∫ x in a..b, g x = 0) :
    (∀ x, g x = 0) ∧
      (∃ w : ℝ → ℝ, (∀ a b : ℝ, ∫ x in a..b, w x = 0) ∧ ∃ x, w x ≠ 0) :=
  ⟨fun x => eq_zero_of_forall_intervalIntegral_eq_zero hg h x,
   forall_intervalIntegral_eq_zero_needs_continuity⟩

/-- The smoothness the source invokes, made explicit.

LeVeque writes that the derivation of the differential form assumes `q` and
`f(q)` are sufficiently smooth. The one place that assumption is irreducible is
the interchange of `d/dt` with the spatial integral, which is carried here as a
hypothesis rather than proved, because the chapter gives no argument for it. The
statement records that the interchange is a genuine restriction: a density whose
section mass is constant in time while the candidate time-derivative is not
identically zero fails it. -/
theorem leveque02_integralToDifferential_smoothness :
    (∀ q qt : ℝ → ℝ → ℝ, CommutesWithSectionIntegral q qt →
      ∀ x₁ x₂ t, HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (sectionMass (fun x => qt x t) x₁ x₂) t) ∧
      (∃ q qt : ℝ → ℝ → ℝ, ¬ CommutesWithSectionIntegral q qt) := by
  refine ⟨fun _ _ h => h, ⟨fun _ _ => 0, fun _ _ => 1, fun hcon => ?_⟩⟩
  have h := hcon 0 1 0
  have hzero : HasDerivAt (fun _ : ℝ => sectionMass (fun _ : ℝ => (0 : ℝ)) 0 1) 0 0 := by
    simpa [sectionMass] using (hasDerivAt_const (0 : ℝ) (0 : ℝ))
  have huniq := hzero.unique (by simpa [sectionMass] using h)
  simp at huniq

/-- Equation (2.10): the differential form of the conservation law.

Given the balance on every section, the interchange, differentiability of the
composed flux in `x`, and continuity of both terms, the sum of the time
derivative of the density and the space derivative of the flux vanishes at every
point. This is the printed conclusion, with each of the four costs named rather
than absorbed. -/
theorem leveque02_equation10_differentialConservationLaw
    {q qt F Fx : ℝ → ℝ → ℝ}
    (hcomm : CommutesWithSectionIntegral q qt)
    (hbalance : IsSectionBalance q F)
    (hflux : ∀ t x₁ x₂, ∀ x ∈ Set.uIcc x₁ x₂,
      HasDerivAt (fun y => F y t) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂)
    (hcontq : ∀ t, Continuous fun x => qt x t)
    (hcontF : ∀ t, Continuous fun x => Fx x t) :
    ∀ x t, qt x t + Fx x t = 0 :=
  fun x t => differentialForm_of_sectionBalance hcomm hbalance hflux hfluxint
    hcontq hcontF x t

end NumStability
