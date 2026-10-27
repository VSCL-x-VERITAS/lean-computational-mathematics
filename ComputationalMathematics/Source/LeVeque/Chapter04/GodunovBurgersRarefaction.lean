/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.ExactTimeAverageRiemannMethod
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearRiemannSolution
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannData
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleFluxShift
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.Calculus.Deriv.Inv
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.IntegrableOn
import Mathlib.Topology.MetricSpace.Lipschitz

/-!
# Forward Burgers rarefaction profile

For ascending states, the Burgers characteristic relation `f'(q) = x/t`
gives the centered profile that equals the left state, the ray `x/t`, or
the right state in its three regions. This file establishes its elementary
geometry and positive-time ray trace. Rectangle conservation and an
entropy-selected certified Riemann method are separate obligations.
-/

namespace NumStability

/-- The centered scalar Burgers rarefaction profile for an ordered
ascending pair, with the value on each edge chosen continuously. -/
def leveque04_burgersRarefactionProfile
    (left right ray : ℝ) : ℝ :=
  max left (min ray right)

theorem leveque04_burgersRarefactionProfile_left
    (left right ray : ℝ) (horder : left ≤ right)
    (hleft : ray ≤ left) :
    leveque04_burgersRarefactionProfile left right ray = left := by
  rw [leveque04_burgersRarefactionProfile,
    min_eq_left (hleft.trans horder), max_eq_left hleft]

theorem leveque04_burgersRarefactionProfile_interior
    (left right ray : ℝ) (hleft : left ≤ ray)
    (hright : ray ≤ right) :
    leveque04_burgersRarefactionProfile left right ray = ray := by
  rw [leveque04_burgersRarefactionProfile,
    min_eq_left hright, max_eq_right hleft]

theorem leveque04_burgersRarefactionProfile_right
    (left right ray : ℝ) (horder : left ≤ right)
    (hright : right ≤ ray) :
    leveque04_burgersRarefactionProfile left right ray = right := by
  rw [leveque04_burgersRarefactionProfile,
    min_eq_right hright, max_eq_right horder]

/-- Every state inside the centered fan stays between its ordered
Riemann endpoint states. -/
theorem leveque04_burgersRarefactionProfile_bounds
    (left right ray : ℝ) (horder : left ≤ right) :
    left ≤ leveque04_burgersRarefactionProfile left right ray ∧
      leveque04_burgersRarefactionProfile left right ray ≤ right := by
  unfold leveque04_burgersRarefactionProfile
  exact ⟨le_max_left _ _, max_le horder (min_le_right _ _)⟩

/-- The fan profile is monotone along similarity rays. -/
theorem leveque04_burgersRarefactionProfile_monotone
    (left right : ℝ) :
    Monotone (leveque04_burgersRarefactionProfile left right) := by
  intro a b hab
  exact max_le_max_left left (min_le_min_right right hab)

/-- Clamping the Burgers similarity ray does not increase distances. -/
theorem leveque04_burgersRarefactionProfile_lipschitz
    (left right : ℝ) :
    LipschitzWith 1 (leveque04_burgersRarefactionProfile left right) := by
  have hmin : LipschitzWith 1 (fun ray : ℝ => min ray right) :=
    LipschitzWith.id.min_const right
  simpa only [leveque04_burgersRarefactionProfile, max_comm] using
    hmin.max_const left

/-- The forward fan field is defined for positive time, where its
similarity ray is meaningful. -/
noncomputable def leveque04_burgersRarefactionForward
    (left right x t : ℝ) : ℝ :=
  leveque04_burgersRarefactionProfile left right (x / t)

/-- Each positive-time similarity ray carries one constant fan state. -/
theorem leveque04_burgersRarefactionForward_ray
    (left right ray t : ℝ) (htime : 0 < t) :
    leveque04_burgersRarefactionForward left right (ray * t) t =
      leveque04_burgersRarefactionProfile left right ray := by
  simp [leveque04_burgersRarefactionForward, mul_div_cancel_right₀,
    ne_of_gt htime]

/-- The forward fan agrees with its left constant state up to the
moving left characteristic. -/
theorem leveque04_burgersRarefactionForward_leftRegion
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t)
    (hleft : x ≤ left * t) :
    leveque04_burgersRarefactionForward left right x t = left := by
  exact leveque04_burgersRarefactionProfile_left left right (x / t)
    horder ((div_le_iff₀ htime).2 hleft)

/-- The forward fan agrees with its right constant state from the
moving right characteristic onward. -/
theorem leveque04_burgersRarefactionForward_rightRegion
    (left right x t : ℝ) (horder : left ≤ right) (htime : 0 < t)
    (hright : right * t ≤ x) :
    leveque04_burgersRarefactionForward left right x t = right := by
  exact leveque04_burgersRarefactionProfile_right left right (x / t)
    horder ((le_div_iff₀ htime).2 hright)

/-- Both moving characteristic edges have the same trace from the
constant region and from the centered fan. -/
theorem leveque04_burgersRarefactionForward_edgeStates
    (left right t : ℝ) (horder : left ≤ right) (htime : 0 < t) :
    leveque04_burgersRarefactionForward left right (left * t) t = left ∧
      leveque04_burgersRarefactionForward left right (right * t) t = right := by
  exact ⟨leveque04_burgersRarefactionForward_leftRegion
      left right (left * t) t horder htime le_rfl,
    leveque04_burgersRarefactionForward_rightRegion
      left right (right * t) t horder htime le_rfl⟩

/-- On each positive-time slice, the rarefaction field has spatial
Lipschitz constant `1/t`. -/
theorem leveque04_burgersRarefactionForward_spaceBound
    (left right x y t : ℝ) (htime : 0 < t) :
    |leveque04_burgersRarefactionForward left right x t -
        leveque04_burgersRarefactionForward left right y t| ≤
      |x - y| / t := by
  have h := (leveque04_burgersRarefactionProfile_lipschitz left right).dist_le_mul
    (x / t) (y / t)
  simp only [Real.dist_eq, NNReal.coe_one, one_mul] at h
  change |leveque04_burgersRarefactionForward left right x t -
      leveque04_burgersRarefactionForward left right y t| ≤
    |x / t - y / t| at h
  rw [← sub_div, abs_div, abs_of_pos htime] at h
  exact h

/-- Every algebraic Burgers fan slice is integrable on each spatial
interval; the forward Riemann interpretation uses positive time. -/
theorem leveque04_burgersRarefactionForward_intervalIntegrable_space
    (left right t a b : ℝ) :
    IntervalIntegrable
      (fun x => leveque04_burgersRarefactionForward left right x t)
      MeasureTheory.volume a b := by
  have hcont : Continuous (fun x : ℝ => x / t) :=
    continuous_id.div_const t
  have hfan : Continuous
      (fun x : ℝ => leveque04_burgersRarefactionForward left right x t) := by
    exact (leveque04_burgersRarefactionProfile_lipschitz left right).continuous.comp
      hcont
  exact hfan.intervalIntegrable a b

/-- At a fixed location, the centered fan has an integrable time trace
on every compact interval strictly after the initial time. -/
theorem leveque04_burgersRarefactionForward_intervalIntegrable_time
    (left right x s t : ℝ) (hs : 0 < s) (hst : s ≤ t) :
    IntervalIntegrable
      (fun τ => leveque04_burgersRarefactionForward left right x τ)
      MeasureTheory.volume s t := by
  apply ContinuousOn.intervalIntegrable_of_Icc hst
  intro τ hτ
  have hτpos : 0 < τ := hs.trans_le hτ.1
  have hquot : ContinuousAt (fun σ : ℝ => x / σ) τ :=
    continuousAt_const.div continuousAt_id (ne_of_gt hτpos)
  exact ((leveque04_burgersRarefactionProfile_lipschitz left right).continuous
    |>.continuousAt.comp hquot).continuousWithinAt

/-- A continuous physical flux has an integrable time trace on the
forward fan, including when a fixed location crosses a moving edge. -/
theorem leveque04_burgersRarefactionForward_intervalIntegrable_fluxTime
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hflux : Continuous (fun u : ℝ =>
      law.physicalFlux (fun _ : Fin 1 => u)))
    (left right x s t : ℝ) (hs : 0 < s) (hst : s ≤ t) :
    IntervalIntegrable
      (fun τ => law.physicalFlux (fun _ : Fin 1 =>
        leveque04_burgersRarefactionForward left right x τ))
      MeasureTheory.volume s t := by
  apply ContinuousOn.intervalIntegrable_of_Icc hst
  intro τ hτ
  have hτpos : 0 < τ := hs.trans_le hτ.1
  have hquot : ContinuousAt (fun σ : ℝ => x / σ) τ :=
    continuousAt_const.div continuousAt_id (ne_of_gt hτpos)
  have hstate : ContinuousAt
      (fun σ => leveque04_burgersRarefactionForward left right x σ) τ :=
    (leveque04_burgersRarefactionProfile_lipschitz left right).continuous
      |>.continuousAt.comp hquot
  exact (hflux.continuousAt.comp hstate).continuousWithinAt

/-- For the scalar Burgers physical flux `u²/2`, the fixed-face flux
trace is integrable on every strictly positive time interval. -/
theorem leveque04_burgersRarefactionForward_intervalIntegrable_burgersFluxTime
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (left right x s t : ℝ) (hs : 0 < s) (hst : s ≤ t) :
    IntervalIntegrable
      (fun τ => law.physicalFlux (fun _ : Fin 1 =>
        leveque04_burgersRarefactionForward left right x τ))
      MeasureTheory.volume s t := by
  apply leveque04_burgersRarefactionForward_intervalIntegrable_fluxTime
    law _ left right x s t hs hst
  apply continuous_pi
  intro i
  fin_cases i
  have heq : (fun u : ℝ =>
      law.physicalFlux (fun _ : Fin 1 => u) 0) =
      fun u => u ^ 2 / 2 := by
    funext u
    exact hburgers u
  have hzero : Continuous (fun u : ℝ =>
      law.physicalFlux (fun _ : Fin 1 => u) 0) := by
    rw [heq]
    fun_prop
  simpa using hzero

/-- A whole-time candidate for the Burgers Riemann field: the
Rankine--Hugoniot moving jump runs backward from the initial slice,
and the centered rarefaction runs forward. The rectangle balance at
their time-zero junction is a separate obligation. -/
noncomputable def leveque04_burgersRarefactionGlobalCandidate
    (left right x t : ℝ) : ℝ :=
  if t ≤ 0 then
    travelingWave (riemannData left right right)
      ((left + right) / 2) x t
  else
    leveque04_burgersRarefactionForward left right x t

/-- The global candidate has exactly the chosen Riemann initial data,
including the right representative at the jump point. -/
theorem leveque04_burgersRarefactionGlobalCandidate_initial
    (left right x : ℝ) :
    leveque04_burgersRarefactionGlobalCandidate left right x 0 =
      riemannData left right right x := by
  simp [leveque04_burgersRarefactionGlobalCandidate, travelingWave]

/-- The global candidate satisfies the source Riemann initial-state
predicate, which leaves the value at the jump unconstrained. -/
theorem leveque04_burgersRarefactionGlobalCandidate_isRiemannData
    (left right : ℝ) :
    IsRiemannData
      (fun x => leveque04_burgersRarefactionGlobalCandidate left right x 0)
      left right := by
  simpa only [leveque04_burgersRarefactionGlobalCandidate_initial] using
    riemannData_isRiemannData left right right

/-- At every positive time, the candidate is the centered Burgers fan. -/
theorem leveque04_burgersRarefactionGlobalCandidate_positive
    (left right x t : ℝ) (htime : 0 < t) :
    leveque04_burgersRarefactionGlobalCandidate left right x t =
      leveque04_burgersRarefactionForward left right x t := by
  simp [leveque04_burgersRarefactionGlobalCandidate, not_le.mpr htime]

/-- At nonpositive time, the candidate is the moving Riemann jump. -/
theorem leveque04_burgersRarefactionGlobalCandidate_nonpositive
    (left right x t : ℝ) (htime : t ≤ 0) :
    leveque04_burgersRarefactionGlobalCandidate left right x t =
      travelingWave (riemannData left right right)
        ((left + right) / 2) x t := by
  simp [leveque04_burgersRarefactionGlobalCandidate, htime]

/-- The joined moving jump and clamped fan define a measurable time
trace at every fixed spatial location. -/
theorem leveque04_burgersRarefactionGlobalCandidate_measurable_time
    (left right x : ℝ) :
    Measurable (fun t =>
      leveque04_burgersRarefactionGlobalCandidate left right x t) := by
  unfold leveque04_burgersRarefactionGlobalCandidate travelingWave
    riemannData leveque04_burgersRarefactionForward
    leveque04_burgersRarefactionProfile
  apply Measurable.ite measurableSet_Iic
  · simp only [ite_self]
    apply Measurable.ite
    · exact measurableSet_lt
        (measurable_const.sub (measurable_const.mul measurable_id))
        measurable_const
    · exact measurable_const
    · exact measurable_const
  · measurability

/-- For ascending states, both branches of the global candidate stay
inside the closed interval of the two Riemann states. -/
theorem leveque04_burgersRarefactionGlobalCandidate_bounds
    (left right x t : ℝ) (horder : left ≤ right) :
    left ≤ leveque04_burgersRarefactionGlobalCandidate left right x t ∧
      leveque04_burgersRarefactionGlobalCandidate left right x t ≤ right := by
  by_cases htime : t ≤ 0
  · rw [leveque04_burgersRarefactionGlobalCandidate_nonpositive
      left right x t htime]
    unfold travelingWave riemannData
    split_ifs <;> simp [horder]
  · rw [leveque04_burgersRarefactionGlobalCandidate_positive
      left right x t (lt_of_not_ge htime)]
    exact leveque04_burgersRarefactionProfile_bounds
      left right (x / t) horder

/-- The quadratic Burgers flux of the whole-time candidate is
integrable along every fixed spatial face, even across initial time. -/
theorem leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_fluxTime
    (left right x s t : ℝ) (horder : left ≤ right) :
    IntervalIntegrable
      (fun τ =>
        (leveque04_burgersRarefactionGlobalCandidate left right x τ) ^ 2 / 2)
      MeasureTheory.volume s t := by
  let B := max |left| |right|
  have hbound (τ : ℝ) :
      |leveque04_burgersRarefactionGlobalCandidate left right x τ| ≤ B := by
    have hq := leveque04_burgersRarefactionGlobalCandidate_bounds
      left right x τ horder
    apply abs_le.mpr
    constructor
    · exact (neg_le_neg (le_max_left |left| |right|)).trans
        ((neg_abs_le left).trans hq.1)
    · exact hq.2.trans
        ((le_abs_self right).trans (le_max_right |left| |right|))
  have hmeas : Measurable (fun τ =>
      (leveque04_burgersRarefactionGlobalCandidate left right x τ) ^ 2 / 2) := by
    exact ((leveque04_burgersRarefactionGlobalCandidate_measurable_time
      left right x).pow_const 2).div_const 2
  rw [intervalIntegrable_iff]
  apply MeasureTheory.Measure.integrableOn_of_bounded measure_Ioc_lt_top.ne
    hmeas.aestronglyMeasurable
  filter_upwards [] with τ
  have hq := hbound τ
  calc
    ‖(leveque04_burgersRarefactionGlobalCandidate left right x τ) ^ 2 / 2‖ =
        |leveque04_burgersRarefactionGlobalCandidate left right x τ| ^ 2 / 2 := by
      rw [Real.norm_eq_abs, abs_div, abs_pow]
      norm_num
    _ ≤ B ^ 2 / 2 := by gcongr

/-- Every spatial slice of the whole-time candidate is integrable on
bounded intervals, on both sides of the initial-time junction. -/
theorem leveque04_burgersRarefactionGlobalCandidate_intervalIntegrable_space
    (left right t a b : ℝ) :
    IntervalIntegrable
      (fun x => leveque04_burgersRarefactionGlobalCandidate left right x t)
      MeasureTheory.volume a b := by
  by_cases htime : t ≤ 0
  · simpa only [leveque04_burgersRarefactionGlobalCandidate_nonpositive
      left right _ t htime] using
      travelingWave_intervalIntegrable_space
        (riemannData left right right)
        (riemannData_intervalIntegrable left right right)
        ((left + right) / 2) a b t
  · have hpositive : 0 < t := lt_of_not_ge htime
    simpa only [leveque04_burgersRarefactionGlobalCandidate_positive
      left right _ t hpositive] using
      leveque04_burgersRarefactionForward_intervalIntegrable_space
        left right t a b

/-- The backward branch is a weak Burgers solution at every time:
its Rankine--Hugoniot speed makes the quadratic flux affine on the two
states attained by the moving jump. -/
theorem leveque04_burgersRarefaction_backwardJump_rectangle
    (left right : ℝ) :
    IsRectangleConservationLawSolution
      (travelingWave (riemannData left right right)
        ((left + right) / 2))
      (fun u : ℝ => u ^ 2 / 2) := by
  let speed := (left + right) / 2
  let offset := left ^ 2 / 2 - speed * left
  have hleft : left ^ 2 / 2 = speed • left + offset := by
    simp [offset, smul_eq_mul]
  have hright : right ^ 2 / 2 = speed • right + offset := by
    dsimp [speed, offset]
    ring
  apply IsRectangleConservationLawSolution.of_flux_eq_add_const
    _ (fun u : ℝ => speed • u) (fun u : ℝ => u ^ 2 / 2) offset
    (travelingWave_isRectangleConservationLawSolution
      (riemannData left right right)
      (riemannData_intervalIntegrable left right right) speed)
  intro x t
  have hstate : travelingWave (riemannData left right right) speed x t = left ∨
      travelingWave (riemannData left right right) speed x t = right := by
    unfold travelingWave riemannData
    split_ifs <;> simp
  rcases hstate with h | h
  · rw [h]
    exact hleft
  · rw [h]
    exact hright

/-- Inside the open centered fan, the forward field has its
characteristic spatial slope `1/t`. -/
theorem leveque04_burgersRarefactionForward_space_hasDerivAt_interior
    (left right x t : ℝ) (htime : 0 < t)
    (hleft : left * t < x) (hright : x < right * t) :
    HasDerivAt
      (fun y => leveque04_burgersRarefactionForward left right y t)
      (1 / t) x := by
  apply ((hasDerivAt_id x).div_const t).congr_of_eventuallyEq
  · filter_upwards [eventually_gt_nhds hleft,
      eventually_lt_nhds hright] with y hyLeft hyRight
    have hyl : left ≤ y / t :=
      le_of_lt ((lt_div_iff₀ htime).2 hyLeft)
    have hyr : y / t ≤ right :=
      le_of_lt ((div_lt_iff₀ htime).2 hyRight)
    exact (leveque04_burgersRarefactionProfile_interior
      left right (y / t) hyl hyr)

/-- Inside the same open fan, the time derivative is `-x/t²`. -/
theorem leveque04_burgersRarefactionForward_time_hasDerivAt_interior
    (left right x t : ℝ) (htime : 0 < t)
    (hleft : left * t < x) (hright : x < right * t) :
    HasDerivAt
      (fun τ => leveque04_burgersRarefactionForward left right x τ)
      (-x / t ^ 2) t := by
  have hquot : HasDerivAt (fun τ : ℝ => x / τ) (-x / t ^ 2) t := by
    convert (hasDerivAt_const t x).div (hasDerivAt_id t)
      (ne_of_gt htime) using 1
    simp
  have hxl : left < x / t := (lt_div_iff₀ htime).2 hleft
  have hxr : x / t < right := (div_lt_iff₀ htime).2 hright
  have hev : ∀ᶠ τ in nhds t, x / τ ∈ Set.Ioo left right :=
    hquot.continuousAt (Ioo_mem_nhds hxl hxr)
  apply hquot.congr_of_eventuallyEq
  filter_upwards [hev] with τ hτ
  exact leveque04_burgersRarefactionProfile_interior
    left right (x / τ) hτ.1.le hτ.2.le

/-- The open Burgers rarefaction fan satisfies the classical
quasilinear equation `q_t + q q_x = 0`. -/
theorem leveque04_burgersRarefactionForward_classicalPDE_interior
    (left right x t : ℝ) (htime : 0 < t)
    (hleft : left * t < x) (hright : x < right * t) :
    HasDerivAt
        (fun τ => leveque04_burgersRarefactionForward left right x τ)
        (-x / t ^ 2) t ∧
      HasDerivAt
        (fun y => leveque04_burgersRarefactionForward left right y t)
        (1 / t) x ∧
      -x / t ^ 2 +
        leveque04_burgersRarefactionForward left right x t * (1 / t) = 0 := by
  refine ⟨leveque04_burgersRarefactionForward_time_hasDerivAt_interior
      left right x t htime hleft hright,
    leveque04_burgersRarefactionForward_space_hasDerivAt_interior
      left right x t htime hleft hright, ?_⟩
  have hxl : left ≤ x / t :=
    le_of_lt ((lt_div_iff₀ htime).2 hleft)
  have hxr : x / t ≤ right :=
    le_of_lt ((div_lt_iff₀ htime).2 hright)
  rw [leveque04_burgersRarefactionForward,
    leveque04_burgersRarefactionProfile_interior left right
      (x / t) hxl hxr]
  field_simp
  ring

/-- The same open fan satisfies the conservative Burgers equation with
physical flux `q²/2`. -/
theorem leveque04_burgersRarefactionForward_conservativePDE_interior
    (left right x t : ℝ) (htime : 0 < t)
    (hleft : left * t < x) (hright : x < right * t) :
    HasDerivAt
        (fun τ => leveque04_burgersRarefactionForward left right x τ)
        (-x / t ^ 2) t ∧
      HasDerivAt
        (fun y =>
          (leveque04_burgersRarefactionForward left right y t) ^ 2 / 2)
        (leveque04_burgersRarefactionForward left right x t / t) x ∧
      -x / t ^ 2 +
        leveque04_burgersRarefactionForward left right x t / t = 0 := by
  have hpde := leveque04_burgersRarefactionForward_classicalPDE_interior
    left right x t htime hleft hright
  have hflux : HasDerivAt
      (fun y =>
        (leveque04_burgersRarefactionForward left right y t) ^ 2 / 2)
      (leveque04_burgersRarefactionForward left right x t / t) x := by
    convert (hpde.2.1.pow 2).div_const 2 using 1
    ring
  refine ⟨hpde.1, hflux, ?_⟩
  simpa only [div_eq_mul_inv, one_mul] using hpde.2.2

/-- The ray-zero trace, used by the exact Godunov interface flux, is
constant throughout positive time. -/
theorem leveque04_burgersRarefactionForward_rayZero
    (left right t : ℝ) (htime : 0 < t) :
    leveque04_burgersRarefactionForward left right 0 t =
      leveque04_burgersRarefactionProfile left right 0 := by
  simpa using leveque04_burgersRarefactionForward_ray left right 0 t htime

/-- A positive-speed rarefaction samples its left state at the
Godunov interface. -/
theorem leveque04_burgersRarefaction_rayZero_left
    (left right : ℝ) (horder : left ≤ right) (hleft : 0 ≤ left) :
    leveque04_burgersRarefactionProfile left right 0 = left :=
  leveque04_burgersRarefactionProfile_left left right 0 horder hleft

/-- A negative-speed rarefaction samples its right state. -/
theorem leveque04_burgersRarefaction_rayZero_right
    (left right : ℝ) (horder : left ≤ right) (hright : right ≤ 0) :
    leveque04_burgersRarefactionProfile left right 0 = right :=
  leveque04_burgersRarefactionProfile_right left right 0 horder hright

/-- A transonic rarefaction samples the sonic state at the interface. -/
theorem leveque04_burgersRarefaction_rayZero_sonic
    (left right : ℝ) (hleft : left ≤ 0) (hright : 0 ≤ right) :
    leveque04_burgersRarefactionProfile left right 0 = 0 :=
  leveque04_burgersRarefactionProfile_interior left right 0 hleft hright

/-- The forward Burgers fan has a time-independent interface state, so
the positive-time average of any physical flux there equals its flux at
the similarity-ray-zero state. -/
theorem leveque04_burgersRarefaction_fluxTimeAverage
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (left right timeStep : ℝ) (htime : 0 < timeStep) :
    oneDimensionalCellAverage
      (fun τ => law.physicalFlux
        (fun _ : Fin 1 =>
          leveque04_burgersRarefactionForward left right 0 τ))
      0 timeStep =
        law.physicalFlux
          (fun _ : Fin 1 =>
            leveque04_burgersRarefactionProfile left right 0) := by
  apply oneDimensionalCellAverage_flux_of_constantTrace law
    (fun _ τ _ => leveque04_burgersRarefactionForward left right 0 τ)
    (fun _ : Fin 1 => leveque04_burgersRarefactionProfile left right 0)
    timeStep htime
  intro τ hτ
  funext i
  exact leveque04_burgersRarefactionForward_rayZero left right τ (by
    simpa only [min_eq_left htime.le] using hτ.1)

/-- Along the two moving fan edges, time-averaged physical fluxes
match those of the adjoining constant states. -/
theorem leveque04_burgersRarefaction_movingEdgeFluxTimeAverage
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (left right timeStep : ℝ) (horder : left ≤ right)
    (htime : 0 < timeStep) :
    oneDimensionalCellAverage
        (fun τ => law.physicalFlux
          (fun _ : Fin 1 =>
            leveque04_burgersRarefactionForward left right (left * τ) τ))
        0 timeStep = law.physicalFlux (fun _ : Fin 1 => left) ∧
      oneDimensionalCellAverage
        (fun τ => law.physicalFlux
          (fun _ : Fin 1 =>
            leveque04_burgersRarefactionForward left right (right * τ) τ))
        0 timeStep = law.physicalFlux (fun _ : Fin 1 => right) := by
  constructor
  · apply oneDimensionalCellAverage_flux_of_constantTrace law
      (fun _ τ _ =>
        leveque04_burgersRarefactionForward left right (left * τ) τ)
      (fun _ : Fin 1 => left) timeStep htime
    intro τ hτ
    funext i
    exact (leveque04_burgersRarefactionForward_edgeStates left right τ
      horder (by simpa only [min_eq_left htime.le] using hτ.1)).1
  · apply oneDimensionalCellAverage_flux_of_constantTrace law
      (fun _ τ _ =>
        leveque04_burgersRarefactionForward left right (right * τ) τ)
      (fun _ : Fin 1 => right) timeStep htime
    intro τ hτ
    funext i
    exact (leveque04_burgersRarefactionForward_edgeStates left right τ
      horder (by simpa only [min_eq_left htime.le] using hτ.1)).2

/-- The time-averaged Burgers physical flux at a transonic rarefaction
interface is zero, matching the sonic state. -/
theorem leveque04_burgersRarefaction_transonicFluxTimeAverage
    (law : OneDimensionalHyperbolicConservationLaw (Fin 1))
    (hburgers : ∀ u : ℝ,
      law.physicalFlux (fun _ : Fin 1 => u) 0 = u ^ 2 / 2)
    (left right timeStep : ℝ) (htime : 0 < timeStep)
    (hleft : left ≤ 0) (hright : 0 ≤ right) :
    (oneDimensionalCellAverage
      (fun τ => law.physicalFlux
        (fun _ : Fin 1 =>
          leveque04_burgersRarefactionForward left right 0 τ))
      0 timeStep) 0 = 0 := by
  rw [leveque04_burgersRarefaction_fluxTimeAverage law left right
    timeStep htime]
  rw [leveque04_burgersRarefaction_rayZero_sonic left right hleft hright]
  simpa using hburgers 0

end NumStability
