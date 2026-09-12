/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm

/-!
# Capacity functions and source terms

Sections 2.4 and 2.5 of LeVeque's Chapter 2 relax the conservation law in two
independent ways.

A capacity function appears when the flux is naturally a function of one
quantity `q` while a different quantity `κ q` is what is conserved. The law then
carries the capacity on the time derivative alone. That is not a rewriting of
the ordinary law: unless the capacity is one, the two have different solutions,
and a witness below says so.

A source term appears when the section's contents change for reasons other than
flux through the endpoints. The derivation of the pointwise equation is the same
one printed page 17 gives, with the source integral carried along, and it is
reproduced here rather than assumed: the balance on every section plus
continuity gives the pointwise equation.

The last piece is the assumption the source makes without naming it when it
writes an external heat source as `ψ(x,t)` rather than `ψ(q,x,t)`: the source
does not depend on the state. What that buys is stated as what it is, that the
difference of two solutions satisfies the law with no source at all, together
with a witness that a state-dependent source loses it.
-/

namespace NumStability

open MeasureTheory

/-! ### Capacity functions -/

/-- Equation (2.27): a conservation law in capacity form, with the capacity
multiplying the time derivative alone. -/
def IsCapacityConservationLaw
    (capacity : ℝ → ℝ) (qt Fx : ℝ → ℝ → ℝ) : Prop :=
  ∀ x t, capacity x * qt x t + Fx x t = 0

/-- At unit capacity the capacity form is the ordinary conservation law. -/
theorem isCapacityConservationLaw_one_iff (qt Fx : ℝ → ℝ → ℝ) :
    IsCapacityConservationLaw (fun _ => 1) qt Fx ↔ ∀ x t, qt x t + Fx x t = 0 := by
  simp [IsCapacityConservationLaw]

/-- The capacity form follows from the balance of the quantity that is actually
conserved: if `κ q` is the conserved density and the capacity does not vary with
time, the law carries `κ` on the time derivative. -/
theorem isCapacityConservationLaw_of_energyBalance
    {q qt Fx Et : ℝ → ℝ → ℝ} {capacity : ℝ → ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hEt : ∀ x t, HasDerivAt (fun τ => capacity x * q x τ) (Et x t) t)
    (hlaw : ∀ x t, Et x t + Fx x t = 0) :
    IsCapacityConservationLaw capacity qt Fx := by
  intro x t
  have hE : Et x t = capacity x * qt x t :=
    (hEt x t).unique ((hqt x t).const_mul (capacity x))
  have := hlaw x t
  linarith [hE.symm ▸ this]

/-- Wherever the capacity is not one, the capacity form and the ordinary
conservation law are different equations, so `κ` cannot simply be absorbed into
the reading of the law. -/
theorem exists_isCapacityConservationLaw_not_plain
    {capacity : ℝ → ℝ} {x₀ : ℝ} (h : capacity x₀ ≠ 1) :
    ∃ qt Fx : ℝ → ℝ → ℝ,
      IsCapacityConservationLaw capacity qt Fx ∧
        ¬ ∀ x t, qt x t + Fx x t = 0 := by
  refine ⟨fun _ _ => 1, fun x _ => -capacity x, fun x t => by ring, ?_⟩
  intro hcon
  have := hcon x₀ 0
  simp only at this
  exact h (by linarith)

/-! ### Source terms -/

/-- Equation (2.28), derived rather than assumed: a balance holding on every
section, with a source integral carried along, gives the pointwise equation with
the source on the right.

This is the page 17 derivation with one more term. The interchange of `d/dt`
with the spatial integral, the differentiability and integrability of the flux
derivative, the integrability of the source, and the continuity that licenses
the pointwise step are all carried explicitly, exactly as they are there. -/
theorem sourceEquation_of_sectionBalance
    {q qt F Fx S : ℝ → ℝ → ℝ}
    (hcomm : CommutesWithSectionIntegral q qt)
    (hbalance : ∀ x₁ x₂ t,
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (F x₁ t - F x₂ t + sectionMass (fun x => S x t) x₁ x₂) t)
    (hflux : ∀ x t, HasDerivAt (fun y => F y t) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂, IntervalIntegrable (fun x => Fx x t) volume x₁ x₂)
    (hqtint : ∀ t x₁ x₂, IntervalIntegrable (fun x => qt x t) volume x₁ x₂)
    (hSint : ∀ t x₁ x₂, IntervalIntegrable (fun x => S x t) volume x₁ x₂)
    (hcont : ∀ t, Continuous fun x => qt x t + Fx x t - S x t)
    (x t : ℝ) :
    qt x t + Fx x t = S x t := by
  have hkey : ∀ a b : ℝ, ∫ y in a..b, (qt y t + Fx y t - S y t) = 0 := by
    intro a b
    have hmass : sectionMass (fun y => qt y t) a b
        = F a t - F b t + sectionMass (fun y => S y t) a b :=
      (hcomm a b t).unique (hbalance a b t)
    have hF : F a t - F b t = -∫ y in a..b, Fx y t :=
      fluxDifference_eq_neg_integral (fun y _ => hflux y t) (hfluxint t a b)
    have hsplit : ∫ y in a..b, (qt y t + Fx y t - S y t)
        = ((∫ y in a..b, qt y t) + ∫ y in a..b, Fx y t) - ∫ y in a..b, S y t := by
      rw [intervalIntegral.integral_sub
        ((hqtint t a b).add (hfluxint t a b)) (hSint t a b),
        intervalIntegral.integral_add (hqtint t a b) (hfluxint t a b)]
    rw [hsplit]
    have hq : (∫ y in a..b, qt y t)
        = F a t - F b t + ∫ y in a..b, S y t := hmass
    rw [hq, hF]
    ring
  have := eq_zero_of_forall_intervalIntegral_eq_zero (hcont t) hkey x
  linarith

/-- A source density that does not depend on the state. -/
def IsStateIndependentSource (psi : ℝ → ℝ → ℝ → ℝ) : Prop :=
  ∀ v w x t, psi v x t = psi w x t

/-- Being state independent is exactly being a function of position and time
alone, which is the form the external-heat-source example writes. -/
theorem isStateIndependentSource_iff (psi : ℝ → ℝ → ℝ → ℝ) :
    IsStateIndependentSource psi ↔ ∃ g : ℝ → ℝ → ℝ, ∀ v x t, psi v x t = g x t := by
  constructor
  · intro h
    exact ⟨fun x t => psi 0 x t, fun v x t => h v 0 x t⟩
  · rintro ⟨g, hg⟩ v w x t
    rw [hg v x t, hg w x t]

/-- It is a restriction: a source proportional to the state fails it. -/
theorem exists_not_isStateIndependentSource :
    ∃ psi : ℝ → ℝ → ℝ → ℝ, ¬ IsStateIndependentSource psi := by
  refine ⟨fun v _ _ => v, ?_⟩
  intro h
  have := h 0 1 0 0
  norm_num at this

/-- What state independence buys: the difference of two solutions satisfies the
law with no source at all.

This is why an external heat source leaves the equation linear in the
temperature, and it is the reason the distinction the source draws between
`ψ(x,t)` and `ψ(q,x,t)` matters. -/
theorem source_difference_isHomogeneous
    {q r qt rt Fx Gx : ℝ → ℝ → ℝ} {psi : ℝ → ℝ → ℝ → ℝ}
    (hpsi : IsStateIndependentSource psi)
    (hq : ∀ x t, qt x t + Fx x t = psi (q x t) x t)
    (hr : ∀ x t, rt x t + Gx x t = psi (r x t) x t) (x t : ℝ) :
    (qt x t - rt x t) + (Fx x t - Gx x t) = 0 := by
  have hsame : psi (q x t) x t = psi (r x t) x t := hpsi _ _ x t
  have h1 := hq x t
  have h2 := hr x t
  linarith [hsame]

/-- And a state-dependent source loses it, so the hypothesis above is doing work
rather than describing the situation. -/
theorem source_difference_needs_stateIndependence :
    ∃ (psi : ℝ → ℝ → ℝ → ℝ) (q r qt rt Fx Gx : ℝ → ℝ → ℝ) (x t : ℝ),
      (∀ y s, qt y s + Fx y s = psi (q y s) y s) ∧
        (∀ y s, rt y s + Gx y s = psi (r y s) y s) ∧
        (qt x t - rt x t) + (Fx x t - Gx x t) ≠ 0 := by
  refine ⟨fun v _ _ => v, fun _ _ => 1, fun _ _ => 0, fun _ _ => 1,
    fun _ _ => 0, fun _ _ => 0, fun _ _ => 0, 0, 0,
    fun y s => by norm_num, fun y s => by norm_num, by simp⟩

end NumStability
