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

Both also carry the same model as their evidence of non-degeneracy, exhibited as
a single existential outside every binder: the density `q(x,t) = t - x` with the
identity flux function, whose two printed derivative terms are `1` and `-1`
everywhere. Asserting the pieces of a model in separate clauses is not the same
as asserting the model, and in an earlier draft of these rows it was not even
consistent.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.DifferentialForm`.
-/

namespace NumStability

/-- Equation (2.9): the single integral the printed derivation forms from (2.6)
and (2.8).

The first conjunct is the printed equation, written with the derivative operator
applied to the density in time and to the composed flux in space, which is what
the printed integrand says. The second names those two operators as the families
the hypotheses supply, so the statement constrains both families rather than
carrying one of them unused.

The third is the model: one density, one flux function, one pair of derivative
families satisfying every hypothesis of the printed step at once, with neither
half of the integrand identically zero. So the vanishing integral is a
cancellation rather than a statement about the zero density. -/
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
      (∀ x, deriv (fun τ => q x τ) t = qt x t ∧
        deriv (fun y => f (q y t)) x = Fx x t) ∧
      (∃ (q' : ℝ → ℝ → ℝ) (f' : ℝ → ℝ) (qt' Fx' : ℝ → ℝ → ℝ),
        CommutesWithSectionIntegral q' qt' ∧
          IsSectionBalance q' (fun y s => f' (q' y s)) ∧
          (∀ y s, HasDerivAt (fun τ => q' y τ) (qt' y s) s) ∧
          (∀ y s, HasDerivAt (fun z => f' (q' z s)) (Fx' y s) y) ∧
          (∀ s y₁ y₂,
            IntervalIntegrable (fun y => qt' y s) MeasureTheory.volume y₁ y₂) ∧
          (∀ s y₁ y₂,
            IntervalIntegrable (fun y => Fx' y s) MeasureTheory.volume y₁ y₂) ∧
          (∀ y s, qt' y s + Fx' y s = 0) ∧
          (∀ y s, qt' y s ≠ 0) ∧ (∀ y s, Fx' y s ≠ 0)) := by
  refine ⟨?_, fun x => ⟨(timePartial_eq_deriv hqt x t).symm,
      (spacePartial_eq_deriv hflux x t).symm⟩,
    differentialForm_composedFlux_nonvacuous⟩
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
subscript form is the same statement, and the first conjunct says so at every
point: the equation written with families supplied as data and constrained to be
derivatives holds exactly where the equation written with the derivative
operator does. The two sides are different objects in the formal language, so
the equivalence is a theorem about what the notation denotes and not an
unfolding.

The second conjunct is what makes the notation legitimate rather than ambiguous.
A subscript names no new data: any two families that differentiate the same
function agree everywhere, so `q_t` and `f(q)_x` each denote one thing. The third
supplies a model in which both subscripted quantities are nonzero everywhere, so
the equivalence is not read off a class in which every term vanishes. -/
theorem leveque02_equation11_subscriptNotation
    {q qt Fx : ℝ → ℝ → ℝ} {f : ℝ → ℝ}
    (hq : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hF : ∀ x t, HasDerivAt (fun y => f (q y t)) (Fx x t) x) :
    (∀ x t, qt x t + Fx x t = 0 ↔
        deriv (fun τ => q x τ) t + deriv (fun y => f (q y t)) x = 0) ∧
      (∀ qt' Fx' : ℝ → ℝ → ℝ,
        (∀ x t, HasDerivAt (fun τ => q x τ) (qt' x t) t) →
        (∀ x t, HasDerivAt (fun y => f (q y t)) (Fx' x t) x) →
          qt' = qt ∧ Fx' = Fx) ∧
      (∃ (q' : ℝ → ℝ → ℝ) (f' : ℝ → ℝ) (qt' Fx' : ℝ → ℝ → ℝ),
        (∀ y s, HasDerivAt (fun τ => q' y τ) (qt' y s) s) ∧
          (∀ y s, HasDerivAt (fun z => f' (q' z s)) (Fx' y s) y) ∧
          (∀ y s, qt' y s + Fx' y s = 0) ∧
          (∀ y s, qt' y s ≠ 0) ∧ (∀ y s, Fx' y s ≠ 0)) := by
  refine ⟨fun x t => subscriptForm_iff_operatorForm hq hF x t,
    fun _ _ hqt' hFx' => ⟨timePartial_unique hqt' hq, spacePartial_unique hFx' hF⟩,
    ?_⟩
  obtain ⟨q', f', qt', Fx', _, _, hd, hs, _, _, hsum, hqne, hFne⟩ :=
    differentialForm_composedFlux_nonvacuous
  exact ⟨q', f', qt', Fx', hd, hs, hsum, hqne, hFne⟩

end NumStability
