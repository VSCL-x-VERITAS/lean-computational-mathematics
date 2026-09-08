import Mathlib.Analysis.Convex.Deriv
import Mathlib.Analysis.Convex.Jensen
import Mathlib.Analysis.SpecialFunctions.Integrals.Basic
import Mathlib.Analysis.Calculus.ContDiff.Deriv
import Mathlib.Analysis.Calculus.Deriv.Abs
import Mathlib.Tactic

/-! Scratch construction of a nonlinear scalar conservation law whose smooth initial
data evolve into a stationary compressive jump. Source closure and entropy interpretation
require independent review; no desired balance identity is assumed in these definitions. -/

open MeasureTheory Set Filter
open scoped Topology

namespace NumStability.ShockContinuation

noncomputable section

/-- The clipped characteristic speed. -/
def huberSlope (q : ℝ) : ℝ := min 1 (max (-1) q)

/-- Defining the flux as the primitive of the continuous slope gives its C1 regularity
without assuming a derivative at either clipping point. Explicit formulas are proved below. -/
def huberFlux (q : ℝ) : ℝ := ∫ z in (0 : ℝ)..q, huberSlope z

theorem huberSlope_continuous : Continuous huberSlope :=
  continuous_const.min (continuous_const.max continuous_id)

theorem huberSlope_of_abs_le {q : ℝ} (hq : |q| ≤ 1) : huberSlope q = q := by
  rw [huberSlope, max_eq_right (abs_le.mp hq).1, min_eq_right (abs_le.mp hq).2]

theorem huberSlope_of_ge {q : ℝ} (hq : 1 ≤ q) : huberSlope q = 1 := by
  simp only [huberSlope, min_eq_left (le_trans hq (le_max_right _ _))]

theorem huberSlope_of_le {q : ℝ} (hq : q ≤ -1) : huberSlope q = -1 := by
  simp only [huberSlope, max_eq_left hq]
  norm_num

theorem hasDerivAt_huberFlux (q : ℝ) : HasDerivAt huberFlux (huberSlope q) q :=
  intervalIntegral.integral_hasDerivAt_right
    (huberSlope_continuous.intervalIntegrable _ _)
    huberSlope_continuous.aestronglyMeasurable.stronglyMeasurableAtFilter
    huberSlope_continuous.continuousAt

theorem huberFlux_contDiff_one : ContDiff ℝ 1 huberFlux := by
  rw [contDiff_one_iff_deriv]
  refine ⟨fun q => (hasDerivAt_huberFlux q).differentiableAt, ?_⟩
  have heq : deriv huberFlux = huberSlope := funext fun q => (hasDerivAt_huberFlux q).deriv
  rw [heq]
  exact huberSlope_continuous

theorem huberFlux_of_abs_le {q : ℝ} (hq : |q| ≤ 1) : huberFlux q = q ^ 2 / 2 := by
  have heq : (∫ z in (0 : ℝ)..q, huberSlope z) = ∫ z in (0 : ℝ)..q, z := by
    apply intervalIntegral.integral_congr_ae
    filter_upwards [] with z hz
    apply huberSlope_of_abs_le
    have hb : z ∈ Ioc (min 0 q) (max 0 q) := hz
    have hlo : -1 ≤ min 0 q := le_min (by norm_num) (abs_le.mp hq).1
    have hhi : max 0 q ≤ 1 := max_le (by norm_num) (abs_le.mp hq).2
    exact abs_le.mpr ⟨by linarith [hb.1], by linarith [hb.2]⟩
  simpa only [huberFlux, integral_id, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true,
    zero_pow, sub_zero] using heq

theorem huberFlux_of_ge {q : ℝ} (hq : 1 ≤ q) : huberFlux q = q - 1 / 2 := by
  have heq : (∫ z in (1 : ℝ)..q, huberSlope z) = q - 1 := by
    calc
      _ = ∫ _ in (1 : ℝ)..q, (1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with z hz
        have hz' : z ∈ Ioc (1 : ℝ) q := by simpa only [uIoc_of_le hq] using hz
        exact huberSlope_of_ge hz'.1.le
      _ = q - 1 := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (μ := volume)
    (huberSlope_continuous.intervalIntegrable 0 1)
    (huberSlope_continuous.intervalIntegrable 1 q)
  have hbase : huberFlux 1 = 1 / 2 := by
    simpa using huberFlux_of_abs_le (q := 1) (by norm_num)
  change huberFlux 1 + (∫ z in (1 : ℝ)..q, huberSlope z) = huberFlux q at hadd
  rw [hbase, heq] at hadd
  linarith

theorem huberFlux_of_le {q : ℝ} (hq : q ≤ -1) : huberFlux q = -q - 1 / 2 := by
  have heq : (∫ z in (-1 : ℝ)..q, huberSlope z) = -(q + 1) := by
    calc
      _ = ∫ _ in (-1 : ℝ)..q, (-1 : ℝ) := by
        apply intervalIntegral.integral_congr_ae
        filter_upwards [] with z hz
        have hz' : z ∈ Ioc q (-1 : ℝ) := by simpa only [uIoc_of_ge hq] using hz
        exact huberSlope_of_le hz'.2
      _ = -(q + 1) := by simp
  have hadd := intervalIntegral.integral_add_adjacent_intervals (μ := volume)
    (huberSlope_continuous.intervalIntegrable 0 (-1))
    (huberSlope_continuous.intervalIntegrable (-1) q)
  have hbase : huberFlux (-1) = 1 / 2 := by
    simpa using huberFlux_of_abs_le (q := -1) (by norm_num)
  change huberFlux (-1) + (∫ z in (-1 : ℝ)..q, huberSlope z) = huberFlux q at hadd
  rw [hbase, heq] at hadd
  linarith

theorem huberFlux_formula (q : ℝ) :
    huberFlux q = if |q| ≤ 1 then q ^ 2 / 2 else |q| - 1 / 2 := by
  split_ifs with hq
  · exact huberFlux_of_abs_le hq
  · rcases lt_or_gt_of_ne (show q ≠ 0 by intro h; simp [h] at hq) with hneg | hpos
    · rw [abs_of_neg hneg] at hq ⊢
      exact huberFlux_of_le (by linarith)
    · rw [abs_of_pos hpos] at hq ⊢
      exact huberFlux_of_ge (by linarith)

theorem huberFlux_not_linear : ¬ ∃ c : ℝ, ∀ q, huberFlux q = c * q := by
  rintro ⟨c, hc⟩
  have h₁ := hc 1
  have h₂ := hc 2
  rw [huberFlux_of_ge (by norm_num : (1 : ℝ) ≤ 1)] at h₁
  rw [huberFlux_of_ge (by norm_num : (1 : ℝ) ≤ 2)] at h₂
  norm_num at h₁ h₂
  linarith


/-- The central primitive, with division interpreted in the ambient real field. -/
def centralPotential (x t : ℝ) : ℝ := (-x ^ 2 / 2) / (1 - t)

/-- The outer primitive, also used after the central interval collapses. -/
def outerPotential (x t : ℝ) : ℝ := -x ^ 2 / 2 - t * |x| + t / 2 - t ^ 2 / 2

/-- Right trace is selected at the stationary interface. -/
def outerState (x t : ℝ) : ℝ := if x < 0 then t - x else -t - x

def shockPotential (x t : ℝ) : ℝ :=
  if t < 1 - |x| then centralPotential x t else outerPotential x t

def shockState (x t : ℝ) : ℝ :=
  if t < 1 - |x| then -x / (1 - t) else outerState x t

theorem shockState_initial (x : ℝ) : shockState x 0 = -x := by
  simp only [shockState, outerState]
  split_ifs <;> simp

theorem shockState_initial_smooth : ContDiff ℝ ⊤ (fun x => shockState x 0) := by
  simp only [shockState_initial]
  exact contDiff_id.neg

theorem shockState_after {t : ℝ} (ht : 1 ≤ t) (x : ℝ) :
    shockState x t = outerState x t := by
  simp only [shockState, if_neg (show ¬ t < 1 - |x| by linarith [abs_nonneg x])]

theorem central_flux {x t : ℝ} (h : t < 1 - |x|) :
    huberFlux (-x / (1 - t)) = (-x / (1 - t)) ^ 2 / 2 := by
  apply huberFlux_of_abs_le
  have hr : 0 < 1 - t := by linarith [abs_nonneg x]
  rw [abs_div, abs_neg, abs_of_pos hr]
  exact (div_le_one hr).mpr (by linarith)

theorem outer_flux {x t : ℝ} (h : 1 - |x| ≤ t) :
    huberFlux (outerState x t) = t + |x| - 1 / 2 := by
  by_cases hx : x < 0
  · rw [outerState, if_pos hx, abs_of_neg hx] at *
    rw [huberFlux_of_ge (by linarith : 1 ≤ t - x)]
    ring
  · rw [outerState, if_neg hx, abs_of_nonneg (le_of_not_gt hx)] at *
    rw [huberFlux_of_le (by linarith : -t - x ≤ -1)]
    ring

theorem stationary_shock_flux_and_speeds {t : ℝ} (ht : 1 ≤ t) :
    huberFlux t = huberFlux (-t) ∧ huberSlope t = 1 ∧ huberSlope (-t) = -1 := by
  refine ⟨?_, huberSlope_of_ge ht, huberSlope_of_le (by linarith)⟩
  rw [huberFlux_of_ge ht, huberFlux_of_le (by linarith : -t ≤ -1)]
  ring

/-- The primitive values match on the boundary of the central region. -/
theorem potential_match {x t : ℝ} (h : t = 1 - |x|) :
    centralPotential x t = outerPotential x t := by
  by_cases hx : x = 0
  · subst x
    simp only [abs_zero, sub_zero] at h
    subst t
    norm_num [centralPotential, outerPotential]
    rfl
  have ha : 0 < |x| := abs_pos.mpr hx
  have hr : 1 - t ≠ 0 := by linarith
  have hsq : |x| ^ 2 = x ^ 2 := sq_abs x
  dsimp [centralPotential, outerPotential]
  field_simp
  nlinarith [sq_nonneg (|x| - (1 - t))]

/-- Distinct one-sided limits certify an actual jump, independently of the value at zero. -/
theorem shockState_jump_traces {t : ℝ} (ht : 1 ≤ t) :
    Tendsto (fun x => shockState x t) (𝓝[<] 0) (𝓝 t) ∧
    Tendsto (fun x => shockState x t) (𝓝[>] 0) (𝓝 (-t)) ∧ -t < t := by
  refine ⟨?_, ?_, by linarith⟩
  ·
    have hh : Tendsto (fun x : ℝ => t - x) (𝓝[<] 0) (𝓝 t) := by
      have hlinear : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[<] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, mem_Iio.mp hx, if_pos]
  · have hh : Tendsto (fun x : ℝ => -t - x) (𝓝[>] 0) (𝓝 (-t)) := by
      have hlinear : Continuous (fun y : ℝ => -t - y) := continuous_const.sub continuous_id
      simpa only [sub_zero] using
        (hlinear.continuousAt (x := (0 : ℝ))).tendsto.mono_left
          (show 𝓝[>] (0 : ℝ) ≤ 𝓝 0 from inf_le_left)
    apply hh.congr'
    filter_upwards [self_mem_nhdsWithin] with x hx
    simp only [shockState_after ht, outerState, if_neg (not_lt.mpr (le_of_lt (mem_Ioi.mp hx)))]

/-- A genuine discontinuity is present at every time at or after collapse. -/
theorem shockState_not_continuous_after {t : ℝ} (ht : 1 ≤ t) :
    ¬ ContinuousAt (fun x => shockState x t) 0 := by
  intro hc
  have hleft := (shockState_jump_traces ht).1
  have hboth := tendsto_nhds_unique hleft hc.continuousWithinAt.tendsto
  simp only [shockState_after ht, outerState, lt_self_iff_false, if_false, sub_zero] at hboth
  linarith



/-- Glue a right derivative at a threshold, choosing the upper branch at the threshold. -/
theorem hasDerivWithinAt_if_lt_right {f g : ℝ → ℝ} {c x df dg : ℝ}
    (hf : x < c → HasDerivWithinAt f df (Ioi x) x)
    (hg : c ≤ x → HasDerivWithinAt g dg (Ioi x) x) :
    HasDerivWithinAt (fun y => if y < c then f y else g y)
      (if x < c then df else dg) (Ioi x) x := by
  by_cases hx : x < c
  · simp only [if_pos hx]
    apply (hf hx).congr_of_eventuallyEq
    · filter_upwards [(eventually_lt_nhds hx).filter_mono inf_le_left] with y hy
      simp only [if_pos hy]
    · simp only [if_pos hx]
  · simp only [if_neg hx]
    apply (hg (le_of_not_gt hx)).congr
    · intro y hy
      have hh : ¬ y < c := by linarith [mem_Ioi.mp hy]
      simp only [if_neg hh]
    · simp only [if_neg hx]

/-- Two differentiable formulas with matching values and derivatives can be glued
over any predicate at the point. -/
theorem hasDerivAt_if_of_eq {f g : ℝ → ℝ} (p : ℝ → Prop) [DecidablePred p]
    {x d : ℝ} (hf : HasDerivAt f d x) (hg : HasDerivAt g d x) (heq : f x = g x) :
    HasDerivAt (fun y => if p y then f y else g y) d x := by
  have h₁ : HasDerivWithinAt (fun y => if p y then f y else g y) d {y | p y} x := by
    apply hf.hasDerivWithinAt.congr
    · intro y hy
      simp only [mem_setOf_eq] at hy
      simp only [if_pos hy]
    · split_ifs <;> simp [heq]
  have h₂ : HasDerivWithinAt (fun y => if p y then f y else g y) d {y | p y}ᶜ x := by
    apply hg.hasDerivWithinAt.congr
    · intro y hy
      simp only [mem_compl_iff, mem_setOf_eq] at hy
      simp only [if_neg hy]
    · split_ifs <;> simp [heq]
  exact hasDerivWithinAt_univ.mp (by simpa only [union_compl_self] using h₁.union h₂)

theorem continuous_if_lt_of_closed {f g : ℝ → ℝ} {c : ℝ}
    (hf : ContinuousOn f (Iic c)) (hg : ContinuousOn g (Ici c)) (heq : f c = g c) :
    Continuous (fun y => if y < c then f y else g y) := by
  have hh : Continuous (fun y => if c ≤ y then g y else f y) :=
    continuous_if_le continuous_const continuous_id hg hf (fun y hy => by simpa [← hy] using heq.symm)
  convert hh using 1
  funext y
  by_cases hy : y < c
  · simp only [if_pos hy, if_neg (not_le.mpr hy)]
  · simp only [if_neg hy, if_pos (le_of_not_gt hy)]

theorem hasDerivWithinAt_abs_right (x : ℝ) :
    HasDerivWithinAt (abs : ℝ → ℝ) (if x < 0 then -1 else 1) (Ioi x) x := by
  by_cases hx : x < 0
  · simpa only [if_pos hx] using (hasDerivAt_abs_neg hx).hasDerivWithinAt
  by_cases hpos : 0 < x
  · simpa only [if_neg hx] using (hasDerivAt_abs_pos hpos).hasDerivWithinAt
  have hz : x = 0 := by linarith
  subst x
  simp only [lt_self_iff_false, if_false]
  apply (hasDerivAt_id (0 : ℝ)).hasDerivWithinAt.congr
  · intro y hy
    exact abs_of_pos hy
  · exact abs_zero

theorem centralPotential_space_deriv (x t : ℝ) :
    HasDerivAt (fun y => centralPotential y t) (-x / (1 - t)) x := by
  convert (((hasDerivAt_id x).pow 2).neg.div_const 2).div_const (1 - t) using 1
  norm_num [id_eq]
  ring

theorem centralPotential_time_deriv {x t : ℝ} (ht : t < 1) :
    HasDerivAt (centralPotential x) (-((-x / (1 - t)) ^ 2 / 2)) t := by
  have hr : 1 - t ≠ 0 := by linarith
  convert (hasDerivAt_const t (-x ^ 2 / 2)).div
    ((hasDerivAt_const t (1 : ℝ)).sub (hasDerivAt_id t)) hr using 1
  dsimp
  field_simp
  ring

theorem outerPotential_time_deriv (x t : ℝ) :
    HasDerivAt (outerPotential x) (-|x| + 1 / 2 - t) t := by
  convert ((((hasDerivAt_const t (-x ^ 2 / 2)).sub ((hasDerivAt_id t).mul_const |x|)).add
    ((hasDerivAt_id t).div_const 2)).sub (((hasDerivAt_id t).pow 2).div_const 2)) using 1
  norm_num [id_eq]

theorem outerPotential_space_right_deriv (x t : ℝ) :
    HasDerivWithinAt (fun y => outerPotential y t) (outerState x t) (Ioi x) x := by
  have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).hasDerivWithinAt.sub
    ((hasDerivWithinAt_abs_right x).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
  convert hh using 1
  simp only [outerState]
  split_ifs <;> norm_num [id_eq] <;> ring

theorem outerPotential_space_deriv {x : ℝ} (hx : x ≠ 0) (t : ℝ) :
    HasDerivAt (fun y => outerPotential y t) (outerState x t) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).sub
      ((hasDerivAt_abs_neg hneg).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
    convert hh using 1
    norm_num [outerState, hneg, id_eq]
    ring
  · have hh := ((((((hasDerivAt_id x).pow 2).neg.div_const 2).sub
      ((hasDerivAt_abs_pos hpos).const_mul t)).add_const (t / 2)).sub_const (t ^ 2 / 2))
    convert hh using 1
    norm_num [outerState, not_lt.mpr hpos.le, id_eq]
    ring

theorem centralPotential_time_continuousOn (x : ℝ) :
    ContinuousOn (centralPotential x) (Iic (1 - |x|)) := by
  by_cases hx : x = 0
  · subst x
    unfold centralPotential
    simpa [centralPotential] using
      (continuousOn_const : ContinuousOn (fun _ : ℝ => (0 : ℝ)) (Iic (1 - |(0 : ℝ)|)))
  apply ContinuousOn.div continuousOn_const (continuous_const.sub continuous_id).continuousOn
  intro t ht
  have ha : 0 < |x| := abs_pos.mpr hx
  change t ≤ 1 - |x| at ht
  change 1 - t ≠ 0
  linarith

theorem shockPotential_time_continuous (x : ℝ) : Continuous (shockPotential x) := by
  apply continuous_if_lt_of_closed (centralPotential_time_continuousOn x)
  · exact (by unfold outerPotential; fun_prop : Continuous (outerPotential x)).continuousOn
  · exact potential_match rfl

theorem shockPotential_time_right_deriv (x t : ℝ) :
    HasDerivWithinAt (shockPotential x) (-huberFlux (shockState x t)) (Ioi t) t := by
  have hh : HasDerivWithinAt (shockPotential x)
      (if t < 1 - |x| then -((-x / (1 - t)) ^ 2 / 2) else -|x| + 1 / 2 - t) (Ioi t) t := by
    apply hasDerivWithinAt_if_lt_right
    · intro ht
      exact (centralPotential_time_deriv (by linarith [abs_nonneg x])).hasDerivWithinAt
    · intro _
      exact (outerPotential_time_deriv x t).hasDerivWithinAt
  apply hh.congr_deriv
  by_cases ht : t < 1 - |x|
  · simp only [if_pos ht, shockState, central_flux ht]
  · simp only [if_neg ht, shockState, outer_flux (le_of_not_gt ht)]
    ring



theorem huberFlux_convex : ConvexOn ℝ univ huberFlux := by
  apply Monotone.convexOn_univ_of_deriv (fun x => (hasDerivAt_huberFlux x).differentiableAt)
  have hm : Monotone huberSlope := monotone_const.min (monotone_const.max monotone_id)
  simpa only [funext (fun x => (hasDerivAt_huberFlux x).deriv)] using hm

/-- The flux graph lies below the stationary shock chord between its two traces. -/
theorem stationary_shock_oleinik {t k : ℝ} (ht : 1 ≤ t) (hk : k ∈ Icc (-t) t) :
    huberFlux k ≤ huberFlux t := by
  have hh := huberFlux_convex.le_max_of_mem_Icc (mem_univ (-t)) (mem_univ t) hk
  simpa only [← (stationary_shock_flux_and_speeds ht).1, max_self] using hh

theorem central_outer_state_match {x t : ℝ} (ht : t < 1) (h : t = 1 - |x|) :
    -x / (1 - t) = outerState x t := by
  have hr : 1 - t ≠ 0 := by linarith
  by_cases hx : x < 0
  · have hrel : t = 1 + x := by simpa only [abs_of_neg hx, sub_neg_eq_add] using h
    have hc : -x / (1 - t) = 1 := (div_eq_one_iff_eq hr).mpr (by linarith)
    rw [hc, outerState, if_pos hx]
    linarith
  · have hrel : t = 1 - x := by simpa only [abs_of_nonneg (le_of_not_gt hx)] using h
    have hc : -x / (1 - t) = -1 := (div_eq_iff hr).mpr (by linarith)
    rw [hc, outerState, if_neg hx]
    linarith

theorem shockPotential_space_continuous (t : ℝ) :
    Continuous (fun x => shockPotential x t) := by
  apply Continuous.if
  · intro x hx
    exact potential_match (frontier_lt_subset_eq continuous_const
      (continuous_const.sub continuous_abs) hx)
  · unfold centralPotential
    fun_prop
  · unfold outerPotential
    fun_prop

theorem outerState_space_continuousAt {x : ℝ} (hx : x ≠ 0) (t : ℝ) :
    ContinuousAt (fun y => outerState y t) x := by
  rcases lt_or_gt_of_ne hx with hneg | hpos
  · have hh : Continuous (fun y : ℝ => t - y) := continuous_const.sub continuous_id
    apply hh.continuousAt.congr_of_eventuallyEq
    filter_upwards [eventually_lt_nhds hneg] with y hy
    simp only [outerState, if_pos hy]
  · have hh : Continuous (fun y : ℝ => -t - y) := continuous_const.sub continuous_id
    apply hh.continuousAt.congr_of_eventuallyEq
    filter_upwards [eventually_gt_nhds hpos] with y hy
    simp only [outerState, if_neg (not_lt.mpr hy.le)]

theorem shockState_continuous_before {t : ℝ} (ht : t < 1) :
    Continuous (fun x => shockState x t) := by
  apply continuous_if
  · intro x hx
    exact central_outer_state_match ht (frontier_lt_subset_eq continuous_const
      (continuous_const.sub continuous_abs) hx)
  · exact (by fun_prop : Continuous (fun x : ℝ => -x / (1 - t))).continuousOn
  · intro x hx
    have hclosed : IsClosed {y : ℝ | ¬t < 1 - |y|} := by
      simp only [not_lt]
      exact isClosed_le (continuous_const.sub continuous_abs) continuous_const
    have hout : ¬t < 1 - |x| := by simpa only [hclosed.closure_eq] using hx
    have hxne : x ≠ 0 := by intro hz; simp only [hz, abs_zero, sub_zero] at hout; linarith
    exact (outerState_space_continuousAt hxne t).continuousWithinAt

theorem shockPotential_space_right_deriv (x t : ℝ) :
    HasDerivWithinAt (fun y => shockPotential y t) (shockState x t) (Ioi x) x := by
  by_cases ht : 1 ≤ t
  · have hpot : (fun y => shockPotential y t) = fun y => outerPotential y t := by
      funext y
      simp only [shockPotential, if_neg (show ¬t < 1 - |y| by linarith [abs_nonneg y])]
    rw [hpot, shockState_after ht]
    exact outerPotential_space_right_deriv x t
  have ht' : t < 1 := lt_of_not_ge ht
  by_cases hc : t < 1 - |x|
  · simp only [shockState, if_pos hc]
    apply (centralPotential_space_deriv x t).hasDerivWithinAt.congr_of_eventuallyEq
    · have hopen : IsOpen {y : ℝ | t < 1 - |y|} :=
        isOpen_lt continuous_const (continuous_const.sub continuous_abs)
      have hev : ∀ᶠ y in 𝓝 x, t < 1 - |y| := hopen.mem_nhds hc
      filter_upwards [hev.filter_mono inf_le_left] with y hy
      simp only [shockPotential, if_pos hy]
    · simp only [shockPotential, if_pos hc]
  by_cases heq : t = 1 - |x|
  · have hx : x ≠ 0 := by intro hz; simp only [hz, abs_zero, sub_zero] at heq; linarith
    have hmatch := central_outer_state_match ht' heq
    have hg : HasDerivAt (fun y => outerPotential y t) (-x / (1 - t)) x :=
      (outerPotential_space_deriv hx t).congr_deriv hmatch.symm
    have hh := hasDerivAt_if_of_eq (fun y => t < 1 - |y|)
      (centralPotential_space_deriv x t) hg (potential_match heq)
    simp only [shockState, if_neg hc]
    exact hh.hasDerivWithinAt.congr_deriv hmatch
  · have hstrict : 1 - |x| < t := lt_of_le_of_ne (le_of_not_gt hc) (Ne.symm heq)
    simp only [shockState, if_neg hc]
    apply (outerPotential_space_right_deriv x t).congr_of_eventuallyEq
    · have hopen : IsOpen {y : ℝ | 1 - |y| < t} :=
        isOpen_lt (continuous_const.sub continuous_abs) continuous_const
      have hev : ∀ᶠ y in 𝓝 x, 1 - |y| < t := hopen.mem_nhds hstrict
      filter_upwards [hev.filter_mono inf_le_left] with y hy
      simp only [shockPotential, if_neg (not_lt.mpr (le_of_lt hy))]
    · simp only [shockPotential, if_neg hc]

theorem intervalIntegrable_piecewise {s : Set ℝ} [DecidablePred (· ∈ s)]
    {f g : ℝ → ℝ} {a b : ℝ} (hs : MeasurableSet s)
    (hf : IntervalIntegrable f volume a b) (hg : IntervalIntegrable g volume a b) :
    IntervalIntegrable (s.piecewise f g) volume a b := by
  rw [intervalIntegrable_iff]
  exact Integrable.piecewise (s := s) (μ := volume.restrict (uIoc a b)) hs
    hf.def'.integrableOn hg.def'.integrableOn

theorem shockState_space_intervalIntegrable (a b t : ℝ) :
    IntervalIntegrable (fun x => shockState x t) volume a b := by
  have hout : IntervalIntegrable (fun x => outerState x t) volume a b := by
    apply intervalIntegrable_piecewise measurableSet_Iio
    · exact (by fun_prop : Continuous (fun x : ℝ => t - x)).intervalIntegrable a b
    · exact (by fun_prop : Continuous (fun x : ℝ => -t - x)).intervalIntegrable a b
  apply intervalIntegrable_piecewise
    (isOpen_lt continuous_const (continuous_const.sub continuous_abs)).measurableSet
  · exact (by fun_prop : Continuous (fun x : ℝ => -x / (1 - t))).intervalIntegrable a b
  · exact hout

theorem clippedCentralState_continuous (x : ℝ) :
    Continuous (fun t : ℝ => -x / max (1 - t) |x|) := by
  by_cases hx : x = 0
  · subst x
    simpa only [neg_zero, zero_div] using (continuous_const : Continuous (fun _ : ℝ => (0 : ℝ)))
  apply continuous_const.div ((continuous_const.sub continuous_id).max continuous_const)
  intro t
  exact ne_of_gt ((abs_pos.mpr hx).trans_le (le_max_right (1 - t) |x|))

theorem shockState_flux_time_intervalIntegrable (x a b : ℝ) :
    IntervalIntegrable (fun t => huberFlux (shockState x t)) volume a b := by
  have hrepr : (fun t => huberFlux (shockState x t)) =
      fun t => if t < 1 - |x| then huberFlux (-x / max (1 - t) |x|)
        else huberFlux (outerState x t) := by
    funext t
    by_cases ht : t < 1 - |x|
    · simp only [shockState, if_pos ht, max_eq_left (show |x| ≤ 1 - t by linarith)]
    · simp only [shockState, if_neg ht]
  rw [hrepr]
  apply intervalIntegrable_piecewise measurableSet_Iio
  · exact (huberFlux_contDiff_one.continuous.comp (clippedCentralState_continuous x)).intervalIntegrable a b
  · have hout : Continuous (outerState x) := by
      unfold outerState
      split_ifs <;> fun_prop
    exact (huberFlux_contDiff_one.continuous.comp hout).intervalIntegrable a b

theorem shockState_mass_potential (a b t : ℝ) :
    (∫ x in a..b, shockState x t) = shockPotential b t - shockPotential a t := by
  exact intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (shockPotential_space_continuous t).continuousOn
    (fun x _ => shockPotential_space_right_deriv x t)
    (shockState_space_intervalIntegrable a b t)

theorem shockState_flux_potential (x a b : ℝ) :
    (∫ t in a..b, huberFlux (shockState x t)) = shockPotential x a - shockPotential x b := by
  have hh := intervalIntegral.integral_eq_sub_of_hasDeriv_right
    (shockPotential_time_continuous x).continuousOn
    (fun t _ => shockPotential_time_right_deriv x t)
    (shockState_flux_time_intervalIntegrable x a b).neg
  rw [intervalIntegral.integral_neg] at hh
  linarith

/-- Complete oriented rectangle balance for the constructed field, proved from its
primitive and right-derivative FTC; no conservation-law certificate is an input. -/
theorem shockState_rectangle_balance (a b s t : ℝ) :
    (∫ x in a..b, shockState x t) - (∫ x in a..b, shockState x s) =
      ∫ τ in s..t, (huberFlux (shockState a τ) - huberFlux (shockState b τ)) := by
  rw [shockState_mass_potential, shockState_mass_potential,
    intervalIntegral.integral_sub (shockState_flux_time_intervalIntegrable a s t)
      (shockState_flux_time_intervalIntegrable b s t),
    shockState_flux_potential, shockState_flux_potential]
  ring

/-- A concrete nonlinear C1 convex flux and its locally integrable, rectangle-balanced
solution have smooth whole-line initial data and a genuine jump at positive time. -/
theorem smooth_data_shock_example :
    ContDiff ℝ 1 huberFlux ∧ ConvexOn ℝ univ huberFlux ∧
    (¬ ∃ c : ℝ, ∀ q, huberFlux q = c * q) ∧
    ContDiff ℝ ⊤ (fun x => shockState x 0) ∧
    (∀ x, shockState x 0 = -x) ∧
    (∀ t < 1, Continuous (fun x => shockState x t)) ∧
    (∀ a b t, IntervalIntegrable (fun x => shockState x t) volume a b) ∧
    (∀ x a b, IntervalIntegrable (fun t => huberFlux (shockState x t)) volume a b) ∧
    (∀ a b s t, (∫ x in a..b, shockState x t) - (∫ x in a..b, shockState x s) =
      ∫ τ in s..t, (huberFlux (shockState a τ) - huberFlux (shockState b τ))) ∧
    (¬ ContinuousAt (fun x => shockState x 2) 0) ∧
    (Tendsto (fun x => shockState x 2) (𝓝[<] 0) (𝓝 2) ∧
      Tendsto (fun x => shockState x 2) (𝓝[>] 0) (𝓝 (-2)) ∧ (-2 : ℝ) < 2) := by
  exact ⟨huberFlux_contDiff_one, huberFlux_convex, huberFlux_not_linear,
    shockState_initial_smooth, shockState_initial, fun _ ht => shockState_continuous_before ht,
    shockState_space_intervalIntegrable,
    shockState_flux_time_intervalIntegrable, shockState_rectangle_balance,
    shockState_not_continuous_after (by norm_num), shockState_jump_traces (by norm_num)⟩


#check huberSlope_continuous
#print axioms huberSlope_continuous
#check huberSlope_of_abs_le
#print axioms huberSlope_of_abs_le
#check huberSlope_of_ge
#print axioms huberSlope_of_ge
#check huberSlope_of_le
#print axioms huberSlope_of_le
#check hasDerivAt_huberFlux
#print axioms hasDerivAt_huberFlux
#check huberFlux_contDiff_one
#print axioms huberFlux_contDiff_one
#check huberFlux_of_abs_le
#print axioms huberFlux_of_abs_le
#check huberFlux_of_ge
#print axioms huberFlux_of_ge
#check huberFlux_of_le
#print axioms huberFlux_of_le
#check huberFlux_formula
#print axioms huberFlux_formula
#check huberFlux_not_linear
#print axioms huberFlux_not_linear
#check shockState_initial
#print axioms shockState_initial
#check shockState_initial_smooth
#print axioms shockState_initial_smooth
#check shockState_after
#print axioms shockState_after
#check central_flux
#print axioms central_flux
#check outer_flux
#print axioms outer_flux
#check stationary_shock_flux_and_speeds
#print axioms stationary_shock_flux_and_speeds
#check potential_match
#print axioms potential_match
#check shockState_jump_traces
#print axioms shockState_jump_traces
#check shockState_not_continuous_after
#print axioms shockState_not_continuous_after
#check hasDerivWithinAt_if_lt_right
#print axioms hasDerivWithinAt_if_lt_right
#check hasDerivAt_if_of_eq
#print axioms hasDerivAt_if_of_eq
#check continuous_if_lt_of_closed
#print axioms continuous_if_lt_of_closed
#check hasDerivWithinAt_abs_right
#print axioms hasDerivWithinAt_abs_right
#check centralPotential_space_deriv
#print axioms centralPotential_space_deriv
#check centralPotential_time_deriv
#print axioms centralPotential_time_deriv
#check outerPotential_time_deriv
#print axioms outerPotential_time_deriv
#check outerPotential_space_right_deriv
#print axioms outerPotential_space_right_deriv
#check outerPotential_space_deriv
#print axioms outerPotential_space_deriv
#check centralPotential_time_continuousOn
#print axioms centralPotential_time_continuousOn
#check shockPotential_time_continuous
#print axioms shockPotential_time_continuous
#check shockPotential_time_right_deriv
#print axioms shockPotential_time_right_deriv
#check huberFlux_convex
#print axioms huberFlux_convex
#check stationary_shock_oleinik
#print axioms stationary_shock_oleinik
#check central_outer_state_match
#print axioms central_outer_state_match
#check shockPotential_space_continuous
#print axioms shockPotential_space_continuous
#check outerState_space_continuousAt
#print axioms outerState_space_continuousAt
#check shockState_continuous_before
#print axioms shockState_continuous_before
#check shockPotential_space_right_deriv
#print axioms shockPotential_space_right_deriv
#check intervalIntegrable_piecewise
#print axioms intervalIntegrable_piecewise
#check shockState_space_intervalIntegrable
#print axioms shockState_space_intervalIntegrable
#check clippedCentralState_continuous
#print axioms clippedCentralState_continuous
#check shockState_flux_time_intervalIntegrable
#print axioms shockState_flux_time_intervalIntegrable
#check shockState_mass_potential
#print axioms shockState_mass_potential
#check shockState_flux_potential
#print axioms shockState_flux_potential
#check shockState_rectangle_balance
#print axioms shockState_rectangle_balance
#check smooth_data_shock_example
#print axioms smooth_data_shock_example
end
end NumStability.ShockContinuation
