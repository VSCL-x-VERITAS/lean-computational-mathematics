/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DiffusiveFlux
import ComputationalMathematics.Analysis.PartialDifferentialEquations.SourceTerms

/-!
# LeVeque Chapter 2, printed page 22: capacity functions and source terms

Sections 2.4 and 2.5 relax the conservation law in two independent ways: a
capacity multiplying the time derivative, and a source density inside the
section.

The integral balance of Section 2.5 is printed with a sign that disagrees with
(2.8) on printed page 17 and with (2.28) printed two lines below it; that is
`LEV-CH02-INC-005`. The row here states the balance in the shape that yields
(2.28), which is the shape (2.8) requires, and says so rather than silently
choosing. The printed variant is not formalized.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.SourceTerms`.
-/

namespace NumStability

/-- The capacity function.

The source describes the situation rather than defining a symbol: the flux is
naturally a function of one quantity `q` while a different quantity `κ q` is
what is conserved. The first conjunct is that derivation, from the balance of
the conserved quantity to the capacity form, using that the capacity does not
vary with time.

The second and third are what make the capacity more than notation. At unit
capacity the form collapses to the ordinary conservation law, and wherever the
capacity is not one the two forms have different solutions. So absorbing `κ`
into the reading of the law, which the source says is possible but often
undesirable, is not available for free. -/
theorem leveque02_capacityFunctionDefinition :
    (∀ (q qt Fx Et : ℝ → ℝ → ℝ) (capacity : ℝ → ℝ),
        (∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t) →
        (∀ x t, HasDerivAt (fun τ => capacity x * q x τ) (Et x t) t) →
        (∀ x t, Et x t + Fx x t = 0) →
          IsCapacityConservationLaw capacity qt Fx) ∧
      (∀ qt Fx : ℝ → ℝ → ℝ,
        IsCapacityConservationLaw (fun _ => 1) qt Fx ↔ ∀ x t, qt x t + Fx x t = 0) ∧
      (∀ (capacity : ℝ → ℝ) (x₀ : ℝ), capacity x₀ ≠ 1 →
        ∃ qt Fx : ℝ → ℝ → ℝ,
          IsCapacityConservationLaw capacity qt Fx ∧
            ¬ ∀ x t, qt x t + Fx x t = 0) :=
  ⟨fun _ _ _ _ _ hqt hEt hlaw =>
     isCapacityConservationLaw_of_energyBalance hqt hEt hlaw,
   fun qt Fx => isCapacityConservationLaw_one_iff qt Fx,
   fun _ _ h => exists_isCapacityConservationLaw_not_plain h⟩

/-- Equation (2.27): the capacity form of a conservation law.

The printed equation is `κ q_t + f(q)_x = 0`. The first conjunct is that the
predicate used here is that equation; the second derives it from the balance of
the conserved quantity `κ q` under a capacity that does not vary with time,
which is the generalisation of (2.26) the source calls obvious. -/
theorem leveque02_equation27_capacityFormConservation
    {q qt Fx Et : ℝ → ℝ → ℝ} {capacity : ℝ → ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hEt : ∀ x t, HasDerivAt (fun τ => capacity x * q x τ) (Et x t) t)
    (hlaw : ∀ x t, Et x t + Fx x t = 0) :
    (IsCapacityConservationLaw capacity qt Fx
        ↔ ∀ x t, capacity x * qt x t + Fx x t = 0) ∧
      IsCapacityConservationLaw capacity qt Fx :=
  ⟨Iff.rfl, isCapacityConservationLaw_of_energyBalance hqt hEt hlaw⟩

/-- The source density, and what its sign means.

The source introduces `ψ(q,x,t)` and adds only that negative values correspond
to a sink rather than a source. That parenthesis is the content: where the flux
contributes nothing, the sign of `ψ` decides whether the density there is rising
or falling. Both directions are stated, since a sink is as much of the claim as
a source. -/
theorem leveque02_sourceDensityDefinition
    {q qt Fx S : ℝ → ℝ → ℝ} {psi : ℝ → ℝ → ℝ → ℝ}
    (hS : ∀ x t, S x t = psi (q x t) x t)
    (hlaw : ∀ x t, qt x t + Fx x t = S x t) :
    (∀ x t, Fx x t = 0 → 0 < psi (q x t) x t → 0 < qt x t) ∧
      (∀ x t, Fx x t = 0 → psi (q x t) x t < 0 → qt x t < 0) := by
  constructor <;> intro x t hflux hsign
  · have h := hlaw x t
    rw [hS x t] at h
    linarith
  · have h := hlaw x t
    rw [hS x t] at h
    linarith

/-- The integral balance with a source, and equation (2.28).

The balance that yields (2.28) subtracts the integrated flux derivative and adds
the integrated source. The printed display on this page adds both, which
contradicts (2.8) and the equation it is said to produce; that discrepancy is
`LEV-CH02-INC-005`, and the shape used here is the one (2.8) and (2.28) require.

Given that balance on every section, together with the interchange, the
differentiability and integrability of the flux derivative, the integrability of
the source and the continuity that licenses the pointwise step, the conclusion
is (2.28) at every point. Each of those costs is a named hypothesis, exactly as
in the page 17 derivation this one extends. -/
theorem leveque02_equation28_sourceTermEquation
    {q qt F Fx S : ℝ → ℝ → ℝ}
    (hcomm : CommutesWithSectionIntegral q qt)
    (hbalance : ∀ x₁ x₂ t,
      HasDerivAt (fun τ => sectionMass (fun x => q x τ) x₁ x₂)
        (F x₁ t - F x₂ t + sectionMass (fun x => S x t) x₁ x₂) t)
    (hflux : ∀ x t, HasDerivAt (fun y => F y t) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂)
    (hqtint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => qt x t) MeasureTheory.volume x₁ x₂)
    (hSint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => S x t) MeasureTheory.volume x₁ x₂)
    (hcont : ∀ t, Continuous fun x => qt x t + Fx x t - S x t)
    (x t : ℝ) :
    qt x t + Fx x t = S x t :=
  sourceEquation_of_sectionBalance hcomm hbalance hflux hfluxint hqtint hSint
    hcont x t

/-- The external heat source equation.

With unit heat capacity and a constant conductivity the flux is Fick's, so
(2.28) reads `q_t = β q_xx + ψ`. The second conjunct names the second spatial
derivative as the derivative operator applied twice, so the row says which
quantity the conductivity multiplies. -/
theorem leveque02_externalHeatSourceEquation
    {q qt qx qxx S : ℝ → ℝ → ℝ} {beta : ℝ}
    (hqx : ∀ x t, HasDerivAt (fun y => q y t) (qx x t) x)
    (hqxx : ∀ x t, HasDerivAt (fun y => qx y t) (qxx x t) x)
    (hlaw : ∀ x t,
      qt x t + deriv (fun y => diffusiveFlux beta (qx y t)) x = S x t)
    (x t : ℝ) :
    qt x t = beta * qxx x t + S x t ∧
      qxx x t = deriv (fun y => deriv (fun z => q z t) y) x := by
  have hflux : HasDerivAt (fun y => diffusiveFlux beta (qx y t))
      (-beta * qxx x t) x := by
    simpa [diffusiveFlux] using (hqxx x t).const_mul (-beta)
  have hzero := hlaw x t
  rw [hflux.deriv] at hzero
  refine ⟨by linarith, ?_⟩
  have hfun : (fun y => deriv (fun z => q z t) y) = fun y => qx y t :=
    funext fun y => (hqx y t).deriv
  rw [hfun, (hqxx x t).deriv]

/-- The external heat source is assumed independent of the temperature.

The source writes the external source as `ψ(x,t)` rather than `ψ(q,x,t)`, and
the first conjunct says what that amounts to: being independent of the state is
exactly being a function of position and time. The second is what it buys, that
the difference of two solutions satisfies the law with no source, which is why
the equation stays linear in the temperature. The third and fourth show the
assumption is a restriction and that dropping it loses the consequence. -/
theorem leveque02_externalSourceStateIndependence :
    (∀ psi : ℝ → ℝ → ℝ → ℝ,
        IsStateIndependentSource psi ↔ ∃ g : ℝ → ℝ → ℝ, ∀ v x t, psi v x t = g x t) ∧
      (∀ (q r qt rt Fx Gx : ℝ → ℝ → ℝ) (psi : ℝ → ℝ → ℝ → ℝ),
        IsStateIndependentSource psi →
        (∀ x t, qt x t + Fx x t = psi (q x t) x t) →
        (∀ x t, rt x t + Gx x t = psi (r x t) x t) →
          ∀ x t, (qt x t - rt x t) + (Fx x t - Gx x t) = 0) ∧
      (∃ psi : ℝ → ℝ → ℝ → ℝ, ¬ IsStateIndependentSource psi) ∧
      (∃ (psi : ℝ → ℝ → ℝ → ℝ) (q r qt rt Fx Gx : ℝ → ℝ → ℝ) (x t : ℝ),
        (∀ y s, qt y s + Fx y s = psi (q y s) y s) ∧
          (∀ y s, rt y s + Gx y s = psi (r y s) y s) ∧
          (qt x t - rt x t) + (Fx x t - Gx x t) ≠ 0) :=
  ⟨fun psi => isStateIndependentSource_iff psi,
   fun _ _ _ _ _ _ _ hpsi hq hr x t => source_difference_isHomogeneous hpsi hq hr x t,
   exists_not_isStateIndependentSource,
   source_difference_needs_stateIndependence⟩

end NumStability
