/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.ClassicalCharacteristics
import Mathlib.Analysis.SpecialFunctions.SmoothTransition

/-!
# Characteristics and initial data for linear advection

Printed page 18 of LeVeque's Chapter 2 solves the advection equation. It gives
the general solution as a translated profile, introduces the characteristic
rays, computes the total derivative along one of them, and then asks what extra
data pin a particular solution down: an initial profile on an infinite pipe, and
an inflow value as well once the pipe has a left end.

The mathematics of the first two steps already exists in this library. What is
added here is the part of each printed step that the existing declarations do
not carry:

* the total derivative along a ray, computed *before* the equation is used, so
  the printed chain `d/dt q(X(t),t) = q_t + ū q_x = 0` has its middle term;
* the fact that the advection speed is the only ray slope along which every
  solution is constant, so "characteristic" is a determination and not a label;
* the translation of an initial profile from an arbitrary initial time;
* the failure of the initial profile alone to determine a solution on a pipe
  with a left end, which is what forces the inflow condition.
-/

namespace NumStability

open scoped Topology

variable {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E]

/-! ### The total derivative along a ray -/

/-- Equation (2.14) before the equation is used: along the ray
`X(t) = x₀ + ū t`, the total derivative of `q(X(t), t)` is `q_t + ū q_x`.

The existing library result jumps straight to the value `0` by assuming the
advection equation. Separating the chain rule from the equation is what lets the
printed calculation be stated as the source writes it, with the middle
expression named and then shown to vanish. -/
theorem hasDerivAt_along_characteristic
    {q : ℝ → ℝ → E} {qt qx : E} {speed x₀ t : ℝ}
    (hq : DifferentiableAt ℝ (Function.uncurry q) (x₀ + speed * t, t))
    (ht : HasDerivAt (fun τ => q (x₀ + speed * t) τ) qt t)
    (hx : HasDerivAt (fun ξ => q ξ t) qx (x₀ + speed * t)) :
    HasDerivAt (fun τ => q (x₀ + speed * τ) τ) (qt + speed • qx) t := by
  set F := fderiv ℝ (Function.uncurry q) (x₀ + speed * t, t) with hFdef
  have hF : HasFDerivAt (Function.uncurry q) F (x₀ + speed * t, t) := hq.hasFDerivAt
  have hx' : HasDerivAt (fun ξ => q ξ t) (F (1, 0)) (x₀ + speed * t) := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt (x₀ + speed * t)
        ((hasDerivAt_id (x₀ + speed * t)).prodMk (hasDerivAt_const _ t))
  have ht' : HasDerivAt (fun τ => q (x₀ + speed * t) τ) (F (0, 1)) t := by
    simpa only [Function.comp_def, Function.uncurry_apply_pair] using
      hF.comp_hasDerivAt t
        ((hasDerivAt_const t (x₀ + speed * t)).prodMk (hasDerivAt_id t))
  have hpair : (speed, (1 : ℝ)) = speed • ((1 : ℝ), 0) + (0, 1) := by
    ext <;> simp
  have hvalue : F (speed, 1) = qt + speed • qx := by
    rw [hpair, map_add, map_smul, hx'.unique hx, ht'.unique ht, add_comm]
  have hcurve : HasDerivAt (fun τ : ℝ => (x₀ + speed * τ, τ)) (speed, 1) t := by
    convert ((hasDerivAt_const t x₀).add ((hasDerivAt_id t).const_mul speed)).prodMk
      (hasDerivAt_id t) using 1
    simp
  simpa only [Function.comp_def, Function.uncurry_apply_pair, hvalue] using
    hF.comp_hasDerivAt (f := fun τ : ℝ => (x₀ + speed * τ, τ)) t hcurve

/-! ### The advection speed is the only characteristic slope -/

/-- No ray slope other than the advection speed carries every solution
unchanged.

The witness is the profile `q(x,t) = x - ū t`, which solves the equation and is
constant along every ray of slope `ū`, and varies along every other ray. So
calling `X(t) = x₀ + ū t` the characteristic records a property of the equation
rather than a choice of name. -/
theorem characteristic_slope_unique {speed c : ℝ} (hc : c ≠ speed) :
    ∃ q : ℝ → ℝ → ℝ,
      Differentiable ℝ (Function.uncurry q) ∧
        IsLinearAdvectionSolution q speed ∧
        (∀ x t, q (x + speed * t) t = q x 0) ∧
        ¬ (∀ x t, q (x + c * t) t = q x 0) := by
  refine ⟨travelingWave id speed, ?_,
    travelingWave_isLinearAdvectionSolution speed differentiable_id, ?_, ?_⟩
  · have : Function.uncurry (travelingWave (id : ℝ → ℝ) speed)
        = fun p : ℝ × ℝ => p.1 - speed * p.2 := by
      funext p
      simp [travelingWave, Function.uncurry]
    rw [this]
    exact differentiable_fst.sub (differentiable_snd.const_mul speed)
  · intro x t
    simp [travelingWave]
  · intro hcon
    have h := hcon 0 1
    simp [travelingWave] at h
    exact hc (by linarith [h])

/-! ### Initial data on an unbounded pipe -/

/-- The initial profile at an arbitrary initial time translates with the flow.

This is the printed conclusion `q(x,t) = q°(x - ū(t - t₀))`, obtained from the
library's identification of a differentiable solution with a translated profile
at time zero. -/
theorem linearAdvection_eq_translated_initial
    {q : ℝ → ℝ → E} {speed t₀ : ℝ} {initial : ℝ → E}
    (hdiff : Differentiable ℝ (Function.uncurry q))
    (hpde : IsLinearAdvectionSolution q speed)
    (hinit : ∀ x, q x t₀ = initial x) (x t : ℝ) :
    q x t = initial (x - speed * (t - t₀)) := by
  have heq := linearAdvection_eq_travelingWave_of_differentiable hdiff hpde
  have key (y s : ℝ) : q y s = q (y - speed * s) 0 := by
    simpa [travelingWave] using congrFun (congrFun heq y) s
  rw [key x t, ← hinit, key (x - speed * (t - t₀)) t₀]
  congr 1
  ring

/-- Two differentiable solutions with the same profile at one time agree
everywhere, so the initial condition is what makes the solution unique. -/
theorem linearAdvection_unique_of_initial
    {q r : ℝ → ℝ → E} {speed t₀ : ℝ}
    (hq : Differentiable ℝ (Function.uncurry q))
    (hr : Differentiable ℝ (Function.uncurry r))
    (hqpde : IsLinearAdvectionSolution q speed)
    (hrpde : IsLinearAdvectionSolution r speed)
    (hagree : ∀ x, q x t₀ = r x t₀) : q = r := by
  funext x t
  rw [linearAdvection_eq_translated_initial hq hqpde (fun y => rfl) x t,
    linearAdvection_eq_translated_initial hr hrpde (fun y => rfl) x t]
  exact hagree _

/-! ### A pipe with a left end needs an inflow condition -/

/-- On a pipe of finite length with the fluid entering at the left, the initial
profile inside the pipe does not determine the density there.

The two witnesses solve the equation and carry the same profile across the whole
open pipe at the initial time, yet differ at an interior station at a later time
and at the inflow station itself. The information they disagree about is exactly
what the source says must be supplied: the density of tracer entering the pipe.

The second profile is the standard smooth glue function, so both witnesses are
genuinely differentiable rather than only piecewise so. -/
theorem inflow_condition_needed {speed a b t₀ : ℝ} (hspeed : 0 < speed)
    (hab : a < b) :
    ∃ q r : ℝ → ℝ → ℝ,
      IsLinearAdvectionSolution q speed ∧
        IsLinearAdvectionSolution r speed ∧
        (∀ x, a < x → x < b → q x t₀ = r x t₀) ∧
        (∃ x s, a < x ∧ x < b ∧ t₀ < s ∧ q x s ≠ r x s) ∧
        (∃ s, t₀ < s ∧ q a s ≠ r a s) := by
  have hglue : Differentiable ℝ expNegInvGlue :=
    (expNegInvGlue.contDiff (n := 1)).differentiable (by simp)
  set c : ℝ := a - speed * t₀ with hc
  have hpd : Differentiable ℝ fun y : ℝ => expNegInvGlue (c - y) := by
    have hlin : Differentiable ℝ fun y : ℝ => c - y :=
      (differentiable_const c).sub differentiable_id
    simpa [Function.comp_def] using hglue.comp hlin
  set s : ℝ := t₀ + (b - a) / speed with hs
  have hpos : 0 < (b - a) / speed := div_pos (by linarith) hspeed
  have hslt : t₀ < s := by rw [hs]; linarith
  have hspeeds : speed * s = speed * t₀ + (b - a) := by
    rw [hs]; field_simp
  refine ⟨fun _ _ => 0, fun ξ τ => expNegInvGlue (c - (ξ - speed * τ)),
    ?_, ?_, ?_, ⟨(a + b) / 2, s, by linarith, by linarith, hslt, ?_⟩,
    ⟨s, hslt, ?_⟩⟩
  · simpa using travelingWave_isLinearAdvectionSolution (E := ℝ) speed
      (differentiable_const (0 : ℝ))
  · simpa [travelingWave] using
      travelingWave_isLinearAdvectionSolution (E := ℝ) speed hpd
  · intro x hax _
    show (0 : ℝ) = expNegInvGlue (c - (x - speed * t₀))
    have hval : c - (x - speed * t₀) = a - x := by rw [hc]; ring
    rw [hval, expNegInvGlue.zero_of_nonpos (by linarith)]
  · show (0 : ℝ) ≠ expNegInvGlue (c - ((a + b) / 2 - speed * s))
    have hval : c - ((a + b) / 2 - speed * s) = b - (a + b) / 2 := by
      rw [hspeeds, hc]; ring
    rw [hval]
    exact (expNegInvGlue.pos_of_pos (by linarith)).ne
  · show (0 : ℝ) ≠ expNegInvGlue (c - (a - speed * s))
    have hval : c - (a - speed * s) = b - a := by rw [hspeeds, hc]; ring
    rw [hval]
    exact (expNegInvGlue.pos_of_pos (by linarith)).ne

end NumStability
