/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.InflowBoundaryValue
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02

/-!
# LeVeque Chapter 2, printed page 19: the solution on a pipe with an inflow end

The source writes the solution of the advection equation on a pipe of finite
length, with the fluid entering at the left, as a formula in two cases. This
wrapper states that formula and what it does.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.InflowBoundaryValue`.
-/

namespace NumStability

/-- The solution on a pipe with an inflow end.

The printed formula is `g₀(t - (x - a)/ū)` where `a < x < a + ū(t - t₀)` and
`q°(x - ū(t - t₀))` where `a + ū(t - t₀) < x < b`. The last two conjuncts state
those two expressions verbatim, so the row says which functions the formula is
built from rather than hiding them behind a name.

The first two conjuncts are what makes the formula a solution *of the stated
problem*: it carries the initial profile across the pipe at the initial time,
and it carries the inflow datum at the inflow station afterwards. The middle two
are that it solves the advection equation in each of the two printed regions,
under the differentiability of whichever datum governs that region.

The right end `b` does not appear. That is faithful rather than careless: the
printed formula does not mention it either, and the row records by its absence
that nothing about the outflow end enters the solution. The separate claim that
no boundary condition may be imposed there is a different row, and it needs a
uniqueness theorem on the strip that is not proved here.

Nothing is asserted on the line `x = a + ū(t - t₀)`, where the source's two
cases are also silent, because the two pieces need not agree there unless the
initial and inflow data are compatible at the corner. -/
theorem leveque02_initialBoundaryAdvectionSolution
    {speed a t₀ : ℝ} (initial boundary : ℝ → ℝ) (hspeed : 0 < speed) :
    (∀ x, a ≤ x → inflowProfile speed a t₀ initial boundary x t₀ = initial x) ∧
      (∀ t, t₀ < t →
        inflowProfile speed a t₀ initial boundary a t = boundary t) ∧
      (∀ x t b' : ℝ, x < a + speed * (t - t₀) →
        HasDerivAt boundary b' (t - (x - a) / speed) →
        leveque01_equation02_scalarAdvectionAt
          (inflowProfile speed a t₀ initial boundary) speed x t) ∧
      (∀ x t i' : ℝ, a + speed * (t - t₀) < x →
        HasDerivAt initial i' (x - speed * (t - t₀)) →
        leveque01_equation02_scalarAdvectionAt
          (inflowProfile speed a t₀ initial boundary) speed x t) ∧
      (∀ x t, x < a + speed * (t - t₀) →
        inflowProfile speed a t₀ initial boundary x t
          = boundary (t - (x - a) / speed)) ∧
      (∀ x t, a + speed * (t - t₀) < x →
        inflowProfile speed a t₀ initial boundary x t
          = initial (x - speed * (t - t₀))) := by
  refine ⟨fun x hx => inflowProfile_at_initialTime initial boundary hx,
    fun t ht => inflowProfile_at_inflow initial boundary hspeed ht,
    fun x t b' hx hb =>
      inflowProfile_isLinearAdvectionSolutionAt_inflow hspeed hx hb,
    fun x t i' hx hi =>
      inflowProfile_isLinearAdvectionSolutionAt_interior hx hi,
    fun x t hx => ?_, fun x t hx => ?_⟩
  · simp [inflowProfile, hx]
  · simp [inflowProfile, not_lt.2 (le_of_lt hx)]


/-- No boundary condition may be imposed at the outflow end.

The source says we do not need to specify a condition at `x = b`, "and in fact
cannot, since the density there is entirely determined by the data given
already". That is the claim here, and it is a uniqueness statement rather than a
remark about convenience: two solutions of the advection equation along the
backward characteristic from the outflow station, carrying the same initial
profile across the pipe and the same inflow datum, take the same value at the
outflow station. There is therefore nothing left to prescribe there.

The hypotheses are confined to the backward ray from `(b,t)` down to the time at
which it leaves the pipe, which is all a pipe of finite length can supply. The
ray leaves through the initial line when it has not had time to reach the inflow
station, and through the inflow station otherwise; the proof splits on exactly
that, which is the content of the source's figure. -/
theorem leveque02_outflowBoundaryDetermined
    {q r : ℝ → ℝ → ℝ} {speed a b t₀ t : ℝ}
    (hspeed : 0 < speed) (hab : a ≤ b) (ht : t₀ ≤ t)
    (hqdiff : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      DifferentiableAt ℝ (Function.uncurry q) (b - speed * (t - s), s))
    (hqpde : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      leveque01_equation02_scalarAdvectionAt q speed (b - speed * (t - s)) s)
    (hrdiff : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      DifferentiableAt ℝ (Function.uncurry r) (b - speed * (t - s), s))
    (hrpde : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      leveque01_equation02_scalarAdvectionAt r speed (b - speed * (t - s)) s)
    (hinit : ∀ x, a ≤ x → x ≤ b → q x t₀ = r x t₀)
    (hinflow : ∀ s, t₀ ≤ s → q a s = r a s) :
    q b t = r b t :=
  outflow_value_determined hspeed hab ht hqdiff hqpde hrdiff hrpde hinit hinflow

end NumStability
