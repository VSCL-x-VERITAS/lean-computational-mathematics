/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm

/-!
# LeVeque Chapter 2, printed page 17: the combined integral and the subscripts

Two more steps of the passage from the integral form to the differential form.

Equation (2.9) is the middle step: the source says "with some further
modification" and combines the time derivative of the section mass with the
integrated flux derivative under a single integral sign. Equation (2.11) is the
notational remark that closes the passage: partial derivatives will be written
as subscripts.

Both wrappers write the flux as the composite `f(q(x,t))` of a flux function
with the density, as the source does, rather than as an unrelated field of
position and time. The composite is what the printed integrands differentiate,
and abstracting it away would leave the row unable to say which function the
`x`-subscript is attached to.

Each wrapper states the printed claim and, alongside it, the evidence that the
claim is not a bookkeeping identity: for (2.9) that the interchange the source
licenses only by "sufficiently smooth" is what carries the step, and for (2.11)
that the subscript is well defined and denotes the derivative operator.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm`.
-/

namespace NumStability

/-- Equation (2.9): the single integral the printed derivation forms from (2.6)
and (2.8).

The conclusion is written with the derivative operator applied to the density in
time and to the composed flux in space, which is what the printed integrand
says; the two derivative hypotheses are what let the named families stand in for
those operators.

The second conjunct shows that the interchange of `d/dt` with the spatial
integral is what carries the step: a density constant in time, balanced by a
zero flux, satisfies every other hypothesis the printed derivation cites, fails
only the interchange, and has a residual whose section integral is the length of
the section. The third gives a model in which the vanishing integral is a
cancellation of two nonzero halves rather than a statement about the zero
density, so the conclusion is not vacuous. -/
theorem leveque02_equation09_vanishingIntervalIntegral
    {q qt Fx : ℝ → ℝ → ℝ} {f : ℝ → ℝ}
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hcomm : CommutesWithSectionIntegral q qt)
    (hbalance : IsSectionBalance q fun x t => f (q x t))
    (hflux : ∀ x t, HasDerivAt (fun y => f (q y t)) (Fx x t) x)
    (hfluxint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => Fx x t) MeasureTheory.volume x₁ x₂)
    (hqtint : ∀ t x₁ x₂,
      IntervalIntegrable (fun x => qt x t) MeasureTheory.volume x₁ x₂)
    (x₁ x₂ t : ℝ) :
    (∫ x in x₁..x₂,
        (deriv (fun τ => q x τ) t + deriv (fun y => f (q y t)) x)) = 0 ∧
      (∃ q' qt' F' Fx' : ℝ → ℝ → ℝ,
        IsSectionBalance q' F' ∧
          (∀ s y₁ y₂, ∀ y ∈ Set.uIcc y₁ y₂,
            HasDerivAt (fun z => F' z s) (Fx' y s) y) ∧
          (∀ s y₁ y₂,
            IntervalIntegrable (fun y => Fx' y s) MeasureTheory.volume y₁ y₂) ∧
          (∀ s y₁ y₂,
            IntervalIntegrable (fun y => qt' y s) MeasureTheory.volume y₁ y₂) ∧
          ¬ CommutesWithSectionIntegral q' qt' ∧
          (∫ y in (0 : ℝ)..1, (qt' y 0 + Fx' y 0)) ≠ 0) ∧
      (CommutesWithSectionIntegral (fun _ s => s) (fun _ _ => 1) ∧
        IsSectionBalance (fun _ s => s) (fun y _ => -y) ∧
        (∫ _y in (0 : ℝ)..1, ((1 : ℝ) + (-1 : ℝ))) = 0 ∧
        (∫ _y in (0 : ℝ)..1, (1 : ℝ)) ≠ 0 ∧
        (∫ _y in (0 : ℝ)..1, (-1 : ℝ)) ≠ 0) := by
  refine ⟨?_, sectionIntegral_residual_needs_interchange,
    sectionIntegral_residual_nonvacuous⟩
  have hcongr : (∫ x in x₁..x₂,
      (deriv (fun τ => q x τ) t + deriv (fun y => f (q y t)) x))
      = ∫ x in x₁..x₂, (qt x t + Fx x t) := by
    refine intervalIntegral.integral_congr fun x _ => ?_
    rw [← timePartial_eq_deriv hqt x t, ← spacePartial_eq_deriv hflux x t]
  rw [hcongr]
  exact sectionIntegral_residual_eq_zero hcomm hbalance
    (fun s _ _ y _ => hflux y s) hfluxint hqtint x₁ x₂ t

/-- Equation (2.11): the differential conservation law in subscript notation.

LeVeque writes that partial derivatives will usually be denoted by subscripts
and reprints (2.10) as `q_t(x,t) + f(q(x,t))_x = 0`. The claim is that the
subscript form is the same statement, and that is what the first conjunct says:
the equation written with families supplied as data and constrained to be
derivatives holds exactly when the equation written with the derivative operator
does. The two sides are different objects in the formal language, so the
equivalence is a theorem about what the notation denotes and not an unfolding.

The second conjunct is what makes the notation legitimate rather than ambiguous.
A subscript names no new data: any two families that differentiate the same
function agree everywhere, so `q_t` and `f(q)_x` each denote one thing. The third
gives a model in which both subscripted quantities are nonzero, so the
equivalence is not read off a class in which every term vanishes. -/
theorem leveque02_equation11_subscriptNotation
    {q qt Fx : ℝ → ℝ → ℝ} {f : ℝ → ℝ}
    (hq : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hF : ∀ x t, HasDerivAt (fun y => f (q y t)) (Fx x t) x) :
    ((∀ x t, qt x t + Fx x t = 0) ↔
        (∀ x t,
          deriv (fun τ => q x τ) t + deriv (fun y => f (q y t)) x = 0)) ∧
      (∀ qt' Fx' : ℝ → ℝ → ℝ,
        (∀ x t, HasDerivAt (fun τ => q x τ) (qt' x t) t) →
        (∀ x t, HasDerivAt (fun y => f (q y t)) (Fx' x t) x) →
          qt' = qt ∧ Fx' = Fx) ∧
      ((∀ x t : ℝ, HasDerivAt (fun τ => (fun _ s => s : ℝ → ℝ → ℝ) x τ)
            ((fun _ _ => (1 : ℝ)) x t) t) ∧
        (∀ x t : ℝ, HasDerivAt (fun y => (fun x _ => -x : ℝ → ℝ → ℝ) y t)
            ((fun _ _ => (-1 : ℝ)) x t) x) ∧
        (∀ x t : ℝ, (fun _ _ => (1 : ℝ)) x t + (fun _ _ => (-1 : ℝ)) x t = 0) ∧
        (fun _ _ => (1 : ℝ)) 0 0 ≠ 0 ∧ (fun _ _ => (-1 : ℝ)) 0 0 ≠ 0) :=
  ⟨subscriptForm_iff_operatorForm hq hF,
   fun _ _ hqt' hFx' => ⟨timePartial_unique hqt' hq, spacePartial_unique hFx' hF⟩,
   subscriptForm_nonvacuous⟩

end NumStability
