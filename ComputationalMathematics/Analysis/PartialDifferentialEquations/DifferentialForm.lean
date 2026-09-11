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

/-- Equation (2.9): the two integrals of the printed derivation combined under
one sign.

The source reaches it from (2.6) by moving `d/dt` inside the integral and
substituting (2.8) for the endpoint difference. Both moves are hypotheses here:
the interchange, and the differentiability and integrability that (2.8) needs.
Note what is *not* needed yet -- continuity. Equation (2.9) is a statement about
one integral over one section, and integrability of the two terms is enough to
split it; continuity is spent only at the next step, where an arbitrary section
becomes a point. Keeping the two apart is what makes the printed derivation's
cost visible step by step rather than in one lump. -/
theorem sectionIntegral_residual_eq_zero
    {q qt F Fx : ℝ → ℝ → ℝ}
    (hcomm : CommutesWithSectionIntegral q qt)
    (hbalance : IsSectionBalance q F)
    (hflux : ∀ t x₁ x₂, ∀ x ∈ Set.uIcc x₁ x₂,
      HasDerivAt (fun y => F y t) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂)
    (hqtint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => qt x t) MeasureTheory.volume x₁ x₂)
    (x₁ x₂ t : ℝ) :
    ∫ x in x₁..x₂, (qt x t + Fx x t) = 0 := by
  have hq : sectionMass (fun y => qt y t) x₁ x₂ = F x₁ t - F x₂ t :=
    (hcomm x₁ x₂ t).unique (hbalance x₁ x₂ t)
  have hF : F x₁ t - F x₂ t = -∫ y in x₁..x₂, Fx y t :=
    fluxDifference_eq_neg_integral (hflux t x₁ x₂) (hfluxint t x₁ x₂)
  rw [intervalIntegral.integral_add (hqtint t x₁ x₂) (hfluxint t x₁ x₂)]
  have hmass : (∫ y in x₁..x₂, qt y t) = F x₁ t - F x₂ t := hq
  rw [hmass, hF]
  ring

/-! ### Subscript notation -/

/-- A family written `q_t` is determined by the function it differentiates.
Uniqueness of derivatives is what makes the subscript a notation rather than an
extra piece of data carried alongside `q`. -/
theorem timePartial_unique {q a b : ℝ → ℝ → ℝ}
    (ha : ∀ x t, HasDerivAt (fun τ => q x τ) (a x t) t)
    (hb : ∀ x t, HasDerivAt (fun τ => q x τ) (b x t) t) : a = b := by
  funext x t
  exact (ha x t).unique (hb x t)

/-- The same for a family written with an `x` subscript. -/
theorem spacePartial_unique {F a b : ℝ → ℝ → ℝ}
    (ha : ∀ x t, HasDerivAt (fun y => F y t) (a x t) x)
    (hb : ∀ x t, HasDerivAt (fun y => F y t) (b x t) x) : a = b := by
  funext x t
  exact (ha x t).unique (hb x t)

/-- `q_t` names the partial derivative operator applied to `q`. -/
theorem timePartial_eq_deriv {q a : ℝ → ℝ → ℝ}
    (ha : ∀ x t, HasDerivAt (fun τ => q x τ) (a x t) t) (x t : ℝ) :
    a x t = deriv (fun τ => q x τ) t := ((ha x t).deriv).symm

/-- `F_x` names the partial derivative operator applied to `F`. -/
theorem spacePartial_eq_deriv {F a : ℝ → ℝ → ℝ}
    (ha : ∀ x t, HasDerivAt (fun y => F y t) (a x t) x) (x t : ℝ) :
    a x t = deriv (fun y => F y t) x := ((ha x t).deriv).symm

/-- Equation (2.11): the subscript form and the operator form of the
differential conservation law are the same statement.

The two sides are different objects in the formal language -- the left is built
from families supplied as data and constrained to be derivatives, the right from
the derivative operator itself -- so the equivalence is a theorem about what the
notation denotes, not an unfolding of a definition. -/
theorem subscriptForm_iff_operatorForm {q F qt Fx : ℝ → ℝ → ℝ}
    (hq : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hF : ∀ x t, HasDerivAt (fun y => F y t) (Fx x t) x) (x t : ℝ) :
    qt x t + Fx x t = 0 ↔
      deriv (fun τ => q x τ) t + deriv (fun y => F y t) x = 0 := by
  rw [timePartial_eq_deriv hq x t, spacePartial_eq_deriv hF x t]

/-- The notation has a model in which both subscripted quantities are nonzero,
so the equivalence above is not read off a class in which every term is `0`. -/
theorem subscriptForm_nonvacuous :
    (∀ x t : ℝ, HasDerivAt (fun τ => (fun _ t => t : ℝ → ℝ → ℝ) x τ)
        ((fun _ _ => (1 : ℝ)) x t) t) ∧
      (∀ x t : ℝ, HasDerivAt (fun y => (fun x _ => -x : ℝ → ℝ → ℝ) y t)
        ((fun _ _ => (-1 : ℝ)) x t) x) ∧
      (∀ x t : ℝ, (fun _ _ => (1 : ℝ)) x t + (fun _ _ => (-1 : ℝ)) x t = 0) ∧
      (fun _ _ => (1 : ℝ)) 0 0 ≠ 0 ∧ (fun _ _ => (-1 : ℝ)) 0 0 ≠ 0 := by
  refine ⟨fun x t => ?_, fun x t => ?_, by norm_num, by norm_num, by norm_num⟩
  · simpa using (hasDerivAt_id t)
  · simpa using (hasDerivAt_neg x)

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
  exact sectionIntegral_residual_eq_zero hcomm hbalance hflux hfluxint
    (fun τ c d => (hcontq τ).intervalIntegrable c d) a b t

/-- The interchange has a non-degenerate model: a density rising uniformly in
time, with the balance carried by a flux linear in position.

This is the satisfiability witness the derivation needs. Without it every
statement guarded by the four hypotheses of the differential form could be
vacuous, and the cheapest member of the hypothesis class — everything zero — is
no evidence that the class contains anything of interest. -/
theorem differentialForm_hypotheses_satisfiable :
    CommutesWithSectionIntegral (fun _ t => t) (fun _ _ => 1) ∧
      IsSectionBalance (fun _ t => t) (fun x _ => -x) ∧
      (∀ t x₁ x₂, ∀ x ∈ Set.uIcc x₁ x₂,
        HasDerivAt (fun y => (fun x _ => -x : ℝ → ℝ → ℝ) y t) (-1 : ℝ) x) ∧
      (∃ x t : ℝ, (fun _ _ => (1 : ℝ)) x t ≠ 0) := by
  refine ⟨fun x₁ x₂ t => ?_, sectionBalance_nonvacuous, fun _ _ _ x _ => ?_,
    0, 0, one_ne_zero⟩
  · simpa [sectionMass, mul_comm] using
      (hasDerivAt_id t).mul_const (x₂ - x₁)
  · simpa using (hasDerivAt_neg x)



/-! ### One non-degenerate model for the whole passage -/

/-- The section mass of a profile falling linearly in space rises at the rate of
the section's length, whatever the constant of integration happens to be. -/
theorem hasDerivAt_sectionMass_linearProfile (x₁ x₂ t : ℝ) :
    HasDerivAt (fun τ => sectionMass (fun x => τ - x) x₁ x₂) (x₂ - x₁) t := by
  have hsub : ∀ τ : ℝ, sectionMass (fun x => τ - x) x₁ x₂
      = (x₂ - x₁) * τ - ∫ x in x₁..x₂, x := by
    intro τ
    have hid : IntervalIntegrable (fun x : ℝ => x) MeasureTheory.volume x₁ x₂ :=
      Continuous.intervalIntegrable continuous_id x₁ x₂
    simp only [sectionMass]
    rw [intervalIntegral.integral_sub intervalIntegrable_const hid,
      intervalIntegral.integral_const, smul_eq_mul]
  simp only [hsub]
  simpa using ((hasDerivAt_id t).const_mul (x₂ - x₁)).sub_const (∫ x in x₁..x₂, x)

/-- A single model satisfying every hypothesis of the printed derivation at
once, with no quantity in it identically zero.

The density `q(x,t) = t - x` rises uniformly in time and falls uniformly in
space, and the flux function is the identity, so the composed flux really is a
flux function applied to the density rather than an unrelated field of position
and time. Both halves of the printed integrand are constant and nonzero -- the
time derivative is `1` everywhere and the flux derivative is `-1` everywhere --
so the vanishing of their sum is a cancellation and not an artefact of a
degenerate model.

Exhibiting the data as one existential, outside every binder, is the point.
Clauses asserting the pieces separately can each be true while no single
instance satisfies them together, which is exactly what happened to the first
draft of this witness: a density constant in space admits no flux function whose
composite varies in space. -/
theorem differentialForm_composedFlux_nonvacuous :
    ∃ (q : ℝ → ℝ → ℝ) (f : ℝ → ℝ) (qt Fx : ℝ → ℝ → ℝ),
      CommutesWithSectionIntegral q qt ∧
        IsSectionBalance q (fun x t => f (q x t)) ∧
        (∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t) ∧
        (∀ x t, HasDerivAt (fun y => f (q y t)) (Fx x t) x) ∧
        (∀ t x₁ x₂,
          IntervalIntegrable (fun x => qt x t) MeasureTheory.volume x₁ x₂) ∧
        (∀ t x₁ x₂,
          IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂) ∧
        (∀ x t, qt x t + Fx x t = 0) ∧
        (∀ x t, qt x t ≠ 0) ∧ (∀ x t, Fx x t ≠ 0) := by
  refine ⟨fun x t => t - x, id, fun _ _ => 1, fun _ _ => -1, ?_, ?_, ?_, ?_,
    fun _ _ _ => intervalIntegrable_const, fun _ _ _ => intervalIntegrable_const,
    ?_, ?_, ?_⟩
  · intro x₁ x₂ t
    have hmass : sectionMass (fun _ : ℝ => (1 : ℝ)) x₁ x₂ = x₂ - x₁ := by
      simp [sectionMass]
    rw [hmass]
    exact hasDerivAt_sectionMass_linearProfile x₁ x₂ t
  · intro x₁ x₂ t
    have hval : (t - x₁) - (t - x₂) = x₂ - x₁ := by ring
    show HasDerivAt (fun τ => sectionMass (fun x => τ - x) x₁ x₂)
      (id (t - x₁) - id (t - x₂)) t
    simp only [id_eq, hval]
    exact hasDerivAt_sectionMass_linearProfile x₁ x₂ t
  · intro x t
    simpa using (hasDerivAt_id t).sub_const x
  · intro x t
    simpa using (hasDerivAt_const x t).sub (hasDerivAt_id x)
  · intro _ _; norm_num
  · intro _ _; norm_num
  · intro _ _; norm_num

end NumStability
