/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionClassification
import ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionInitialValue
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation02

/-!
# LeVeque Chapter 2, printed page 18: solving the advection equation

Page 18 writes down the general solution of (2.12), names the rays along which
it is constant, computes the derivative along one of them, and then asks what
extra data single out one solution: an initial profile on an infinite pipe, and
an inflow value as well once the pipe has a left end.

Each wrapper states the printed claim in the printed shape. A translated profile
is written `q̃(x - ū t)` rather than through a named combinator, so the reader can
see the translation rather than trust an identifier; the derivative chain of
(2.14) keeps its middle term, so it is a calculation rather than an assertion;
and each claim about what a datum *does* carries both halves, the determination
and the failure without it.

The reusable mathematics lives in
`ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionInitialValue`
and its imports; the Chapter 1 advection predicate is reused rather than
restated.
-/

namespace NumStability

/-- Equation (2.13): the general solution of the advection equation.

The source claims both directions and both are here: every differentiable
profile translated at the advection speed solves the equation, and every
differentiable solution is such a translate. The third conjunct exhibits, outside
every binder, a solution whose spatial derivative vanishes nowhere, so the
general form describes a class that is not exhausted by the constants.

The source says "smooth" where this row asks only for differentiability, once of
the profile in the forward direction and jointly in the converse. That is a
weaker hypothesis than the printed one, so both directions are obtained under
less than the source assumes. -/
theorem leveque02_equation13_translatingProfile (speed : ℝ) :
    (∀ profile : ℝ → ℝ, Differentiable ℝ profile →
        ∀ x t, leveque01_equation02_scalarAdvectionAt
          (fun ξ τ => profile (ξ - speed * τ)) speed x t) ∧
      (∀ q : ℝ → ℝ → ℝ, Differentiable ℝ (Function.uncurry q) →
        (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t) →
          ∃ profile : ℝ → ℝ, Differentiable ℝ profile ∧
            ∀ x t, q x t = profile (x - speed * t)) ∧
      (∃ r rt rx : ℝ → ℝ → ℝ,
        (∀ y s, HasDerivAt (fun τ => r y τ) (rt y s) s) ∧
          (∀ y s, HasDerivAt (fun ξ => r ξ s) (rx y s) y) ∧
          (∀ y s, leveque01_equation02_scalarAdvectionAt r speed y s) ∧
          (∀ y s, rx y s ≠ 0) ∧
          ¬ ∃ c : ℝ, ∀ y s, r y s = c) := by
  refine ⟨fun profile hprofile x t =>
      travelingWave_isLinearAdvectionSolution speed hprofile x t,
    fun q hq hpde => ⟨fun y => q y 0, ?_, ?_⟩,
    exists_isLinearAdvectionSolution_nonconstant speed⟩
  · have hcomp : Differentiable ℝ fun y : ℝ => (y, (0 : ℝ)) :=
      differentiable_id.prodMk (differentiable_const 0)
    simpa [Function.comp_def] using hq.comp hcomp
  · intro x t
    have heq := linearAdvection_eq_travelingWave_of_differentiable hq hpde
    simpa [travelingWave] using congrFun (congrFun heq x) t

/-- Equation (2.14): the derivative of the density along a characteristic ray.

The printed calculation is a chain of three expressions and all three appear: the
total derivative of `q(X(t), t)` along `X(t) = x₀ + ū t`, its value
`q_t + ū q_x`, and the conclusion that this vanishes. The middle term is what
makes the calculation a derivation rather than an assertion, and obtaining it
needs the chain rule and not the equation; only the last step uses (2.12). -/
theorem leveque02_equation14_characteristicDerivative
    {q qt qx : ℝ → ℝ → ℝ} {speed : ℝ}
    (hq : Differentiable ℝ (Function.uncurry q))
    (hqt : ∀ x t, HasDerivAt (fun τ => q x τ) (qt x t) t)
    (hqx : ∀ x t, HasDerivAt (fun ξ => q ξ t) (qx x t) x)
    (hpde : ∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t)
    (x₀ t : ℝ) :
    HasDerivAt (fun τ => q (x₀ + speed * τ) τ)
        (qt (x₀ + speed * t) t + speed * qx (x₀ + speed * t) t) t ∧
      qt (x₀ + speed * t) t + speed * qx (x₀ + speed * t) t = 0 ∧
      HasDerivAt (fun τ => q (x₀ + speed * τ) τ) 0 t := by
  have hchain : HasDerivAt (fun τ => q (x₀ + speed * τ) τ)
      (qt (x₀ + speed * t) t + speed * qx (x₀ + speed * t) t) t := by
    simpa [smul_eq_mul] using
      hasDerivAt_along_characteristic (hq (x₀ + speed * t, t))
        (hqt (x₀ + speed * t) t) (hqx (x₀ + speed * t) t)
  have hzero : qt (x₀ + speed * t) t + speed * qx (x₀ + speed * t) t = 0 :=
    (advectionSolution_iff_residual hqt hqx (x₀ + speed * t) t).mp
      (hpde (x₀ + speed * t) t)
  exact ⟨hchain, hzero, hzero ▸ hchain⟩

/-- The characteristic curves of (2.12).

The source defines characteristic curves as the curves along which the equation
simplifies, and says that for (2.12) they are the rays `X(t) = x₀ + ū t`. The
first conjunct is the simplification: along such a ray the density keeps its
initial value, so the partial differential equation reduces to the trivial
ordinary equation `dQ/dt = 0`. The second is what makes `ū` the answer rather
than a label: for every other slope there is a solution of (2.12) that is not
constant along the rays of that slope. -/
theorem leveque02_characteristicCurves (speed : ℝ) :
    (∀ q : ℝ → ℝ → ℝ, Differentiable ℝ (Function.uncurry q) →
        (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t) →
          ∀ x₀ t, q (x₀ + speed * t) t = q x₀ 0) ∧
      (∀ c : ℝ, c ≠ speed → ∃ q : ℝ → ℝ → ℝ,
        Differentiable ℝ (Function.uncurry q) ∧
          (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t) ∧
          (∀ x t, q (x + speed * t) t = q x 0) ∧
          ¬ ∀ x t, q (x + c * t) t = q x 0) := by
  refine ⟨fun q hq hpde x₀ t => ?_, fun c hc => characteristic_slope_unique hc⟩
  have heq := linearAdvection_eq_travelingWave_of_differentiable hq hpde
  have hval := congrFun (congrFun heq (x₀ + speed * t)) t
  simpa [travelingWave] using hval

/-- Equation (2.15): the initial condition.

The source says that to determine `q(x,t)` uniquely for all `t > t₀` on an
infinite pipe we need to know the density distribution at `t₀`. That is a claim
about what the datum does, and both halves of it are here: two differentiable
solutions carrying the same profile at `t₀` are the same solution, and the
equation alone does not determine one, since two distinct solutions exist. -/
theorem leveque02_equation15_initialCondition (speed t₀ : ℝ) :
    (∀ q r : ℝ → ℝ → ℝ, Differentiable ℝ (Function.uncurry q) →
        Differentiable ℝ (Function.uncurry r) →
        (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t) →
        (∀ x t, leveque01_equation02_scalarAdvectionAt r speed x t) →
        (∀ x, q x t₀ = r x t₀) → q = r) ∧
      (∃ q r : ℝ → ℝ → ℝ,
        (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t) ∧
          (∀ x t, leveque01_equation02_scalarAdvectionAt r speed x t) ∧
          q ≠ r) := by
  refine ⟨fun q r hq hr hqp hrp hagree =>
      linearAdvection_unique_of_initial hq hr hqp hrp hagree,
    ⟨fun _ _ => 0, fun x t => x - speed * t, ?_, ?_, ?_⟩⟩
  · exact fun x t => travelingWave_isLinearAdvectionSolution (E := ℝ) speed
      (differentiable_const 0) x t
  · exact fun x t => travelingWave_isLinearAdvectionSolution (E := ℝ) speed
      differentiable_id x t
  · intro hcon
    have h := congrFun (congrFun hcon 1) 0
    norm_num at h

/-- The solution of the initial-value problem on an unbounded pipe.

The printed conclusion is that the initial profile simply translates with speed
`ū`, so `q(x,t) = q°(x - ū(t - t₀))`. The first conjunct is that claim on the
printed range `t ≥ t₀`. The second records that the restriction to `t ≥ t₀` is
not needed, which is a difference from the source worth naming rather than
absorbing: the same formula holds backwards in time, so the row is stronger than
the printed claim on that point. The formula solves the stated
problem and not a different one. The third replaces that arithmetic remark with
a model: a differentiable, non-constant solution whose initial profile is itself
non-constant, so the conclusion is not read off a class of flat densities. -/
theorem leveque02_cauchyAdvectionSolution
    {q : ℝ → ℝ → ℝ} {initial : ℝ → ℝ} {speed t₀ : ℝ}
    (hq : Differentiable ℝ (Function.uncurry q))
    (hpde : ∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t)
    (hinit : ∀ x, q x t₀ = initial x) :
    (∀ x t, t₀ ≤ t → q x t = initial (x - speed * (t - t₀))) ∧
      (∀ x t, q x t = initial (x - speed * (t - t₀))) ∧
      (∃ (r : ℝ → ℝ → ℝ) (r₀ : ℝ → ℝ),
        Differentiable ℝ (Function.uncurry r) ∧
          (∀ x t, leveque01_equation02_scalarAdvectionAt r speed x t) ∧
          (∀ x, r x t₀ = r₀ x) ∧
          ¬ ∃ c : ℝ, ∀ x, r₀ x = c) := by
  have hmain : ∀ x t, q x t = initial (x - speed * (t - t₀)) := fun x t =>
    linearAdvection_eq_translated_initial hq hpde hinit x t
  refine ⟨fun x t _ => hmain x t, hmain,
    fun x t => x - speed * t, fun x => x - speed * t₀, ?_, ?_, fun _ => rfl, ?_⟩
  · have huncurry : Function.uncurry (fun x t : ℝ => x - speed * t)
        = fun p : ℝ × ℝ => p.1 - speed * p.2 := by
      funext p
      simp [Function.uncurry]
    rw [huncurry]
    exact differentiable_fst.sub (differentiable_snd.const_mul speed)
  · exact fun x t => travelingWave_isLinearAdvectionSolution (E := ℝ) speed
      differentiable_id x t
  · rintro ⟨c, hc⟩
    have h0 : (0 : ℝ) - speed * t₀ = c := hc 0
    have h1 : (1 : ℝ) - speed * t₀ = c := hc 1
    rw [← h0] at h1
    norm_num at h1

/-- The inflow boundary condition on a pipe of finite length.

With `a < x < b` and `ū > 0` the source says we must also specify the density of
tracer entering the pipe, as a boundary condition at the inflow end `x = a`, in
addition to the initial condition. The statement is that necessity: two
solutions of (2.12) can carry the same profile across the whole open pipe at the
initial time and still differ at an interior station later, and differ at the
inflow station itself, which is precisely the datum the source says is
missing. -/
theorem leveque02_inflowBoundaryCondition
    {speed a b t₀ : ℝ} (hspeed : 0 < speed) (hab : a < b) :
    ∃ q r : ℝ → ℝ → ℝ,
      (∀ x t, leveque01_equation02_scalarAdvectionAt q speed x t) ∧
        (∀ x t, leveque01_equation02_scalarAdvectionAt r speed x t) ∧
        (∀ x, a < x → x < b → q x t₀ = r x t₀) ∧
        (∃ x s, a < x ∧ x < b ∧ t₀ < s ∧ q x s ≠ r x s) ∧
        (∃ s, t₀ < s ∧ q a s ≠ r a s) :=
  inflow_condition_needed hspeed hab

end NumStability
