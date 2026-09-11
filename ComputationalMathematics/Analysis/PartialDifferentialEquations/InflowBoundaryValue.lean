/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.PartialDifferentialEquations.AdvectionInitialValue

/-!
# Advection on a pipe with an inflow end

Printed page 19 of LeVeque's Chapter 2 writes down the solution of the advection
equation on a pipe of finite length when the fluid enters at the left. The
solution is given in two pieces: near the inflow end the density is whatever
entered there and has not yet travelled out, and further along it is the initial
profile carried downstream.

This module defines that two-piece field and proves what the printed formula
claims about it: it carries the initial profile at the initial time, it carries
the inflow datum at the inflow station, and it solves the advection equation at
every point off the line where the two pieces meet.

The line `x = a + ū(t - t₀)` is exactly where the printed formula is silent: the
source's two cases are `a < x < a + ū(t - t₀)` and `a + ū(t - t₀) < x < b`, with
no case at equality. That is not an oversight to be patched, because the two
pieces need not agree there unless the initial and inflow data are compatible at
the corner, so the theorems below are stated off that line, as the source's are.
-/

namespace NumStability

open scoped Topology

/-- The two-piece field of printed page 19: the inflow datum carried downstream
where it has had time to arrive, and the initial profile carried downstream
elsewhere. -/
noncomputable def inflowProfile (speed a t₀ : ℝ) (initial boundary : ℝ → ℝ) :
    ℝ → ℝ → ℝ :=
  fun x t =>
    if x < a + speed * (t - t₀) then boundary (t - (x - a) / speed)
    else initial (x - speed * (t - t₀))

/-- At the initial time the field is the initial profile everywhere in the
pipe. -/
theorem inflowProfile_at_initialTime {speed a t₀ x : ℝ}
    (initial boundary : ℝ → ℝ) (hx : a ≤ x) :
    inflowProfile speed a t₀ initial boundary x t₀ = initial x := by
  have hcond : ¬ x < a + speed * (t₀ - t₀) := by
    simp only [sub_self, mul_zero, add_zero]
    exact not_lt.2 hx
  simp only [inflowProfile, sub_self, mul_zero, add_zero, sub_zero,
    if_neg (not_lt.2 hx)]

/-- At the inflow station, after the initial time, the field is the inflow
datum. -/
theorem inflowProfile_at_inflow {speed a t₀ t : ℝ}
    (initial boundary : ℝ → ℝ) (hspeed : 0 < speed) (ht : t₀ < t) :
    inflowProfile speed a t₀ initial boundary a t = boundary t := by
  have hcond : a < a + speed * (t - t₀) := by
    have : 0 < speed * (t - t₀) := mul_pos hspeed (by linarith)
    linarith
  simp [inflowProfile, hcond]

/-- The inflow region is open in the space variable, so the field agrees with
its inflow piece on a neighbourhood of any of its points. -/
theorem inflowProfile_eventuallyEq_space_inflow {speed a t₀ x t : ℝ}
    {initial boundary : ℝ → ℝ} (hx : x < a + speed * (t - t₀)) :
    (fun ξ => inflowProfile speed a t₀ initial boundary ξ t)
      =ᶠ[𝓝 x] fun ξ => boundary (t - (ξ - a) / speed) := by
  filter_upwards [isOpen_Iio.mem_nhds (Set.mem_Iio.2 hx)] with ξ hξ
  simp [inflowProfile, Set.mem_Iio.1 hξ]

/-- The inflow region is open in the time variable too. -/
theorem inflowProfile_eventuallyEq_time_inflow {speed a t₀ x t : ℝ}
    {initial boundary : ℝ → ℝ} (hspeed : 0 < speed)
    (hx : x < a + speed * (t - t₀)) :
    (fun τ => inflowProfile speed a t₀ initial boundary x τ)
      =ᶠ[𝓝 t] fun τ => boundary (τ - (x - a) / speed) := by
  have hxa : x - a < (t - t₀) * speed := by rw [mul_comm]; linarith
  have hc : t₀ + (x - a) / speed < t := by
    have := (div_lt_iff₀ hspeed).2 hxa
    linarith
  filter_upwards [isOpen_Ioi.mem_nhds (Set.mem_Ioi.2 hc)] with τ hτ
  have hτ' : (x - a) / speed < τ - t₀ := by
    have := Set.mem_Ioi.1 hτ
    linarith
  have hlt : x < a + speed * (τ - t₀) := by
    have h := (div_lt_iff₀ hspeed).1 hτ'
    rw [mul_comm] at h
    linarith
  simp [inflowProfile, hlt]

/-- Off the interface, in the inflow region, the two-piece field solves the
advection equation.

The inflow datum is carried along the characteristic that left the inflow
station, so the time derivative and the space derivative are the derivative of
that datum scaled by `1` and by `-1/ū`, and the residual cancels. -/
theorem inflowProfile_isLinearAdvectionSolutionAt_inflow
    {speed a t₀ x t b' : ℝ} {initial boundary : ℝ → ℝ}
    (hspeed : 0 < speed) (hx : x < a + speed * (t - t₀))
    (hb : HasDerivAt boundary b' (t - (x - a) / speed)) :
    IsLinearAdvectionSolutionAt
      (inflowProfile speed a t₀ initial boundary) speed x t := by
  refine ⟨b', -(b' / speed), ?_, ?_, ?_⟩
  · refine HasDerivAt.congr_of_eventuallyEq ?_
      (inflowProfile_eventuallyEq_time_inflow hspeed hx)
    have hshift : HasDerivAt (fun τ : ℝ => τ - (x - a) / speed) 1 t := by
      simpa using (hasDerivAt_id t).sub_const ((x - a) / speed)
    simpa [Function.comp_def] using hb.comp t hshift
  · refine HasDerivAt.congr_of_eventuallyEq ?_
      (inflowProfile_eventuallyEq_space_inflow hx)
    have hshift : HasDerivAt (fun ξ : ℝ => t - (ξ - a) / speed) (-(1 / speed)) x := by
      have h1 : HasDerivAt (fun ξ : ℝ => (ξ - a) / speed) (1 / speed) x := by
        simpa [div_eq_mul_inv] using ((hasDerivAt_id x).sub_const a).mul_const speed⁻¹
      simpa using h1.const_sub t
    have := hb.comp x hshift
    simpa [Function.comp_def, mul_comm, div_eq_mul_inv] using this
  · have hne : speed ≠ 0 := ne_of_gt hspeed
    rw [smul_eq_mul]
    field_simp
    ring

/-- Off the interface, beyond the reach of the inflow datum, the two-piece field
is the initial profile carried downstream and solves the equation there. -/
theorem inflowProfile_isLinearAdvectionSolutionAt_interior
    {speed a t₀ x t i' : ℝ} {initial boundary : ℝ → ℝ}
    (hx : a + speed * (t - t₀) < x)
    (hi : HasDerivAt initial i' (x - speed * (t - t₀))) :
    IsLinearAdvectionSolutionAt
      (inflowProfile speed a t₀ initial boundary) speed x t := by
  have hspace : (fun ξ => inflowProfile speed a t₀ initial boundary ξ t)
      =ᶠ[𝓝 x] fun ξ => initial (ξ - speed * (t - t₀)) := by
    filter_upwards [isOpen_Ioi.mem_nhds (Set.mem_Ioi.2 hx)] with ξ hξ
    simp [inflowProfile, not_lt.2 (le_of_lt (Set.mem_Ioi.1 hξ))]
  have htime : (fun τ => inflowProfile speed a t₀ initial boundary x τ)
      =ᶠ[𝓝 t] fun τ => initial (x - speed * (τ - t₀)) := by
    have hopen : {τ : ℝ | a + speed * (τ - t₀) < x} ∈ 𝓝 t := by
      have hcont : Continuous fun τ : ℝ => a + speed * (τ - t₀) :=
        continuous_const.add (continuous_const.mul (continuous_id.sub continuous_const))
      exact (isOpen_lt hcont continuous_const).mem_nhds hx
    filter_upwards [hopen] with τ hτ
    simp [inflowProfile, not_lt.2 (le_of_lt hτ)]
  refine ⟨-(speed * i'), i', ?_, ?_, ?_⟩
  · refine HasDerivAt.congr_of_eventuallyEq ?_ htime
    have hshift : HasDerivAt (fun τ : ℝ => x - speed * (τ - t₀)) (-speed) t := by
      have h1 : HasDerivAt (fun τ : ℝ => speed * (τ - t₀)) speed t := by
        simpa using ((hasDerivAt_id t).sub_const t₀).const_mul speed
      simpa using h1.const_sub x
    simpa [Function.comp_def, mul_comm] using hi.comp t hshift
  · refine HasDerivAt.congr_of_eventuallyEq ?_ hspace
    have hshift : HasDerivAt (fun ξ : ℝ => ξ - speed * (t - t₀)) 1 x := by
      simpa using (hasDerivAt_id x).sub_const (speed * (t - t₀))
    simpa [Function.comp_def] using hi.comp x hshift
  · simp


/-! ### The value at the outflow end is not free -/

/-- A solution keeps its value along a characteristic segment, given the
equation and joint differentiability only on that segment.

The library's global result needs the equation everywhere. Here the hypotheses
are confined to the backward ray from `(x, s₁)` down to time `s₀`, which is what a
pipe of finite length can supply. -/
theorem eq_endpoint_of_characteristic
    {q : ℝ → ℝ → ℝ} {speed x s₀ s₁ : ℝ} (hs : s₀ ≤ s₁)
    (hdiff : ∀ s ∈ Set.Icc s₀ s₁,
      DifferentiableAt ℝ (Function.uncurry q) (x - speed * (s₁ - s), s))
    (hpde : ∀ s ∈ Set.Icc s₀ s₁,
      IsLinearAdvectionSolutionAt q speed (x - speed * (s₁ - s)) s) :
    q x s₁ = q (x - speed * (s₁ - s₀)) s₀ := by
  set x₀ : ℝ := x - speed * s₁ with hx₀
  have hpt : ∀ s : ℝ, x₀ + speed * s = x - speed * (s₁ - s) := by
    intro s; rw [hx₀]; ring
  have hd : ∀ s ∈ Set.Icc s₀ s₁,
      HasDerivAt (fun τ => q (x₀ + speed * τ) τ) 0 s := by
    intro s hs'
    refine linearAdvection_hasDerivAt_characteristic ?_ ?_
    · rw [hpt s]; exact hdiff s hs'
    · rw [hpt s]; exact hpde s hs'
  have hcont : ContinuousOn (fun τ => q (x₀ + speed * τ) τ) (Set.Icc s₀ s₁) :=
    fun s hs' => ((hd s hs').continuousAt).continuousWithinAt
  have key := constant_of_has_deriv_right_zero hcont
    (fun s hs' => (hd s ⟨hs'.1, le_of_lt hs'.2⟩).hasDerivWithinAt) s₁
    (Set.right_mem_Icc.2 hs)
  have hend : x₀ + speed * s₁ = x := by rw [hx₀]; ring
  have hstart : x₀ + speed * s₀ = x - speed * (s₁ - s₀) := by rw [hx₀]; ring
  rw [hend, hstart] at key
  exact key

/-- The density at the outflow end is determined by the data already given.

For a positive velocity the characteristic through a point of the outflow
station runs backwards and leaves the pipe either through the initial line or
through the inflow station, whichever it meets first. Its value there is fixed
by the initial profile or by the inflow datum, so two solutions carrying the
same data agree at the outflow end. That is why no boundary condition may be
imposed there: the value is not free to be prescribed. -/
theorem outflow_value_determined
    {q r : ℝ → ℝ → ℝ} {speed a b t₀ t : ℝ}
    (hspeed : 0 < speed) (hab : a ≤ b) (ht : t₀ ≤ t)
    (hqdiff : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      DifferentiableAt ℝ (Function.uncurry q) (b - speed * (t - s), s))
    (hqpde : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      IsLinearAdvectionSolutionAt q speed (b - speed * (t - s)) s)
    (hrdiff : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      DifferentiableAt ℝ (Function.uncurry r) (b - speed * (t - s), s))
    (hrpde : ∀ s ∈ Set.Icc (max t₀ (t - (b - a) / speed)) t,
      IsLinearAdvectionSolutionAt r speed (b - speed * (t - s)) s)
    (hinit : ∀ x, a ≤ x → x ≤ b → q x t₀ = r x t₀)
    (hinflow : ∀ s, t₀ ≤ s → q a s = r a s) :
    q b t = r b t := by
  set s₀ : ℝ := max t₀ (t - (b - a) / speed) with hs₀
  have hwidth : 0 ≤ (b - a) / speed := div_nonneg (by linarith) (le_of_lt hspeed)
  have hle : s₀ ≤ t := max_le ht (by linarith)
  have hq := eq_endpoint_of_characteristic hle hqdiff hqpde
  have hr := eq_endpoint_of_characteristic hle hrdiff hrpde
  have hmid : q (b - speed * (t - s₀)) s₀ = r (b - speed * (t - s₀)) s₀ := by
    rcases max_cases t₀ (t - (b - a) / speed) with ⟨heq, hcmp⟩ | ⟨heq, hcmp⟩
    · have hs : s₀ = t₀ := by rw [hs₀, heq]
      have hlow : a ≤ b - speed * (t - t₀) := by
        have h1 : t - t₀ ≤ (b - a) / speed := by linarith
        have h2 : (t - t₀) * speed ≤ b - a := (le_div_iff₀ hspeed).1 h1
        nlinarith [h2]
      have hhigh : b - speed * (t - t₀) ≤ b := by
        have : 0 ≤ speed * (t - t₀) := mul_nonneg (le_of_lt hspeed) (by linarith)
        linarith
      rw [hs]
      exact hinit _ hlow hhigh
    · have hs : s₀ = t - (b - a) / speed := by rw [hs₀, heq]
      have hpos : b - speed * (t - s₀) = a := by
        have hne : speed ≠ 0 := ne_of_gt hspeed
        rw [hs]
        field_simp
        ring
      rw [hpos]
      exact hinflow s₀ (le_max_left _ _)
  rw [hq, hr, hmid]

end NumStability
