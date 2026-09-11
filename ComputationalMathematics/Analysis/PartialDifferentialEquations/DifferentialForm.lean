/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ScalarFlux

/-!
# From an integral balance to a pointwise conservation law

Printed page 17 of LeVeque's Chapter 2 passes from the integral form to the
differential form in four steps: the endpoint flux difference is rewritten as
the integral of an `x`-derivative, the two integrals are combined under one
sign, the section is allowed to be arbitrary, and the integrand is concluded to
vanish.

Unlike the modelling conventions of pages 15 and 16, these steps are ordinary
analysis, and they are stated here as theorems with their hypotheses carried
explicitly. Two of those hypotheses are load-bearing in a way the source leaves
implicit, and each is accompanied here by a witness showing it cannot be
dropped:

* the flux difference step needs the derivative to exist across the section and
  to be integrable there;
* the final step needs the integrand to be continuous, not merely integrable.
  Without continuity only an almost-everywhere conclusion is available, and the
  witness below exhibits a nonzero function all of whose section integrals
  vanish.

The one step the source performs that is *not* reproduced as a theorem is the
interchange of `d/dt` with the spatial integral. LeVeque justifies it only by
saying that `q` and `f(q)` are "sufficiently smooth". It is carried here as a
named hypothesis so that a caller must supply it and a reader can see what the
printed derivation costs.
-/

namespace NumStability

/-! ### The endpoint flux difference as an integral -/

/-- Equation (2.8): the difference of a function between the two ends of a
section is minus the integral of its derivative across the section.

This is the fundamental theorem of calculus in the orientation the source uses,
where the left endpoint enters positively. -/
theorem fluxDifference_eq_neg_integral {F F' : ℝ → ℝ} {x₁ x₂ : ℝ}
    (hderiv : ∀ x ∈ Set.uIcc x₁ x₂, HasDerivAt F (F' x) x)
    (hint : IntervalIntegrable F' MeasureTheory.volume x₁ x₂) :
    F x₁ - F x₂ = -∫ x in x₁..x₂, F' x := by
  rw [intervalIntegral.integral_eq_sub_of_hasDerivAt hderiv hint]
  ring

/-- The differentiability hypothesis is load-bearing, and failing at a single
interior point is enough to break the identity.

The witness is differentiable with the stated derivative at every point of the
section except one, and is interval-integrable throughout, yet its endpoint
difference is not the integral of that derivative. So the hypothesis cannot be
weakened to differentiability off a single point, which is the weakening the
source's silence would most naturally invite. -/
theorem fluxDifference_needs_hasDerivAt :
    ∃ (F F' : ℝ → ℝ) (x₁ x₂ z : ℝ),
      z ∈ Set.uIcc x₁ x₂ ∧
        IntervalIntegrable F' MeasureTheory.volume x₁ x₂ ∧
        (∀ x ∈ Set.uIcc x₁ x₂, x ≠ z → HasDerivAt F (F' x) x) ∧
        F x₁ - F x₂ ≠ -∫ x in x₁..x₂, F' x := by
  refine ⟨fun x => if x < 0 then 0 else 1, fun _ => 0, -1, 1, 0, ?_,
    intervalIntegrable_const, ?_, ?_⟩
  · rw [Set.uIcc_of_le (by norm_num : (-1 : ℝ) ≤ 1)]
    constructor <;> norm_num
  · intro x _ hne
    rcases lt_or_gt_of_ne hne with h | h
    · refine (hasDerivAt_const x (0 : ℝ)).congr_of_eventuallyEq ?_
      filter_upwards [isOpen_Iio.mem_nhds h] with y hy
      simp [Set.mem_Iio.1 hy]
    · refine (hasDerivAt_const x (1 : ℝ)).congr_of_eventuallyEq ?_
      filter_upwards [isOpen_Ioi.mem_nhds h] with y hy
      simp [not_lt.2 (le_of_lt (Set.mem_Ioi.1 hy))]
  · intro hcon
    simp at hcon

/-! ### From every section to the integrand -/

/-- The step at which "since this holds for every `x₁` and `x₂`" becomes a
pointwise identity.

Continuity is what makes the step valid: the primitive of a continuous function
has that function as its derivative, so a vanishing primitive forces the
function to vanish. -/
theorem eq_zero_of_forall_intervalIntegral_eq_zero {g : ℝ → ℝ}
    (hg : Continuous g) (h : ∀ a b : ℝ, ∫ x in a..b, g x = 0) (x : ℝ) :
    g x = 0 := by
  have hzero : (fun u => ∫ y in (0 : ℝ)..u, g y) = fun _ => (0 : ℝ) := by
    funext u
    exact h 0 u
  have hderiv : deriv (fun u => ∫ y in (0 : ℝ)..u, g y) x = g x :=
    Continuous.deriv_integral g hg 0 x
  rw [hzero] at hderiv
  simpa using hderiv.symm

/-- Continuity cannot be weakened to integrability. The indicator of a single
point is nonzero somewhere, yet every section integral of it vanishes, because a
point carries no length. So the printed step genuinely uses the smoothness the
source assumes rather than merely the existence of the integrals. -/
theorem forall_intervalIntegral_eq_zero_needs_continuity :
    ∃ g : ℝ → ℝ, (∀ a b : ℝ, ∫ x in a..b, g x = 0) ∧ ∃ x, g x ≠ 0 := by
  refine ⟨fun x => if x = 0 then 1 else 0, fun a b => ?_, 0, by norm_num⟩
  have hae : (fun x : ℝ => if x = 0 then (1 : ℝ) else 0)
      =ᵐ[MeasureTheory.volume] fun _ => 0 := by
    have hsub : {x : ℝ | (if x = 0 then (1 : ℝ) else 0) ≠ 0} ⊆ {0} := by
      intro x hx
      by_contra hne
      simp [hne] at hx
    exact MeasureTheory.measure_mono_null hsub (by simp)
  have key : ∀ c d : ℝ,
      ∫ x in Set.Ioc c d, (if x = 0 then (1 : ℝ) else 0) = 0 := by
    intro c d
    refine MeasureTheory.integral_eq_zero_of_ae ?_
    exact MeasureTheory.ae_restrict_of_ae hae
  simp [intervalIntegral, key]

/-! ### The differential form, with the interchange carried explicitly -/

/-- The interchange the source performs without proof: the time derivative of
the section integral is the section integral of the time derivative.

LeVeque licenses this by saying `q` is sufficiently smooth. Carrying it as a
hypothesis keeps that cost visible instead of burying it in a definition. -/
def CommutesWithSectionIntegral (q qt : ℝ → ℝ → ℝ) : Prop :=
  ∀ x₁ x₂ t, HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
    (sectionMass (fun x => qt x t) x₁ x₂) t

/-- Equations (2.9) and (2.10): once the flux difference is an integral and the
time derivative passes inside, the balance says that a single integral vanishes
over every section, and therefore that its integrand vanishes pointwise.

This is the printed derivation of the differential form, with each of its three
costs a named hypothesis: the interchange, the differentiability of the composed
flux in `x`, and the continuity that licenses the final pointwise step. -/
theorem differentialForm_of_sectionBalance
    {q qt F Fx : ℝ → ℝ → ℝ}
    (hcomm : CommutesWithSectionIntegral q qt)
    (hbalance : IsSectionBalance q F)
    (hflux : ∀ t x₁ x₂, ∀ x ∈ Set.uIcc x₁ x₂, HasDerivAt (fun y => F y t) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂, IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂)
    (hcontq : ∀ t, Continuous fun x => qt x t)
    (hcontF : ∀ t, Continuous fun x => Fx x t)
    (x t : ℝ) :
    qt x t + Fx x t = 0 := by
  have hcsum : Continuous fun y => qt y t + Fx y t := (hcontq t).add (hcontF t)
  refine eq_zero_of_forall_intervalIntegral_eq_zero hcsum (fun a b => ?_) x
  have hq : sectionMass (fun y => qt y t) a b = F a t - F b t :=
    (hcomm a b t).unique (hbalance a b t)
  have hF : F a t - F b t = -∫ y in a..b, Fx y t :=
    fluxDifference_eq_neg_integral (hflux t a b) (hfluxint t a b)
  have hsplit : ∫ y in a..b, (qt y t + Fx y t)
      = (∫ y in a..b, qt y t) + ∫ y in a..b, Fx y t :=
    intervalIntegral.integral_add ((hcontq t).intervalIntegrable a b)
      ((hcontF t).intervalIntegrable a b)
  rw [hsplit]
  have hmass : (∫ y in a..b, qt y t) = F a t - F b t := hq
  rw [hmass, hF]
  ring

end NumStability
