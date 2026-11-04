/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionForwardRectangle
import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.MeasureTheory.Constructions.Polish.Basic
import Mathlib.MeasureTheory.Measure.Prod

/-!
# Actual almost-everywhere gradients of the extended finite-action potential

The spatial derivative of the same potential is the actual evolution. Its
temporal derivative is negative physical flux at positive times and zero at
negative times, where the extension is constant. The initial time is a null
set. Measurability of difference quotients and of their convergence sets lets
Fubini lift the proved slice derivatives to almost-everywhere spacetime
convergence along any negative increment sequence approaching zero.

These are derivative identities of the actual constructed field; no weak law
or conservation certificate is an assumption.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Topology

namespace NumStability

theorem leveque04_burgersFiniteActionForwardPotential_spatial_lipschitz {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (hwidth : 0 ≤ width) :
    LipschitzWith ⟨leveque04_burgersPrimitiveBound old,
      leveque04_burgersPrimitiveBound_nonneg old⟩
      (fun x => leveque04_burgersFiniteActionForwardPotential old origin width x time) := by
  by_cases ht : time ≤ 0
  · apply LipschitzWith.of_dist_le_mul
    intro x y
    simpa only [Real.dist_eq, NNReal.coe_mk, leveque04_burgersFiniteActionForwardPotential,
      if_pos ht] using leveque04_burgersInitialPrimitive_abs_sub_le old origin width x y
  · simpa only [leveque04_burgersFiniteActionForwardPotential, if_neg ht] using
      leveque04_burgersFiniteActionPotential_spatial_lipschitz old origin width time
        hwidth (lt_of_not_ge ht)

theorem leveque04_burgersFiniteActionForwardPotential_spatial_ae_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width time : ℝ) (hwidth : 0 ≤ width) :
    ∀ᵐ x : ℝ, HasDerivAt
      (fun y => leveque04_burgersFiniteActionForwardPotential old origin width y time)
      (leveque04_burgersFiniteActionEvolution old origin width x time) x := by
  by_cases ht : time ≤ 0
  · simpa only [leveque04_burgersFiniteActionForwardPotential, leveque04_burgersFiniteActionEvolution,
      if_pos ht] using leveque04_burgersInitialPrimitive_ae_hasDerivAt_initialData old origin width
  · simpa only [leveque04_burgersFiniteActionForwardPotential, leveque04_burgersFiniteActionEvolution,
      if_neg ht] using leveque04_burgersFiniteActionPotential_spatial_ae_hasDerivAt old origin width time
        hwidth (lt_of_not_ge ht)

theorem leveque04_burgersFiniteActionForwardPotential_temporal_ae_hasDerivAt {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width x : ℝ) (hwidth : 0 ≤ width) :
    ∀ᵐ time : ℝ, HasDerivAt
      (fun s => leveque04_burgersFiniteActionForwardPotential old origin width x s)
      (if 0 < time then -(leveque04_burgersFiniteActionEvolution old origin width x time) ^ 2 / 2
        else 0) time := by
  filter_upwards [(leveque04_burgersFiniteActionForwardPotential_time_lipschitz
    old origin width x hwidth).ae_differentiableAt_real, volume.ae_ne (0 : ℝ)] with time hd hne
  by_cases ht : 0 < time
  · rw [if_pos ht]
    exact leveque04_burgersFiniteActionForwardPotential_temporal_hasDerivAt
      old origin width x time hwidth ht hd
  · rw [if_neg ht]
    have hneg : time < 0 := lt_of_le_of_ne (le_of_not_gt ht) hne
    apply (hasDerivAt_const time (leveque04_burgersInitialPrimitive old origin width x)).congr_of_eventuallyEq
    filter_upwards [eventually_lt_nhds hneg] with s hs
    exact if_pos hs.le

/-- Spacetime a.e. convergence of actual spatial difference quotients; the
exceptional set is measurable, so the slice-to-product passage is justified. -/
theorem leveque04_burgersFiniteActionForwardPotential_spatial_ae_differenceQuotient {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width)
    (increment : ℕ → ℝ) (hincrement : Tendsto increment atTop (𝓝[<] (0 : ℝ))) :
    ∀ᵐ z : ℝ × ℝ, Tendsto (fun n =>
      (leveque04_burgersFiniteActionForwardPotential old origin width (z.1 + increment n) z.2 -
        leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2) / increment n)
      atTop (𝓝 (leveque04_burgersFiniteActionEvolution old origin width z.1 z.2)) := by
  have hP := leveque04_burgersFiniteActionForwardPotential_joint_measurable old origin width
  have hq := leveque04_burgersFiniteActionEvolution_joint_measurable old origin width
  have hmeas (n : ℕ) : Measurable (fun z : ℝ × ℝ =>
      (leveque04_burgersFiniteActionForwardPotential old origin width (z.1 + increment n) z.2 -
        leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2) / increment n) :=
    ((hP.comp ((measurable_fst.add measurable_const).prodMk measurable_snd)).sub hP).div measurable_const
  have hset := measurableSet_tendsto_fun (l := atTop) hmeas hq
  change ∀ᵐ z ∂(volume : Measure ℝ).prod volume, _
  apply (Measure.ae_prod_iff_ae_ae hset).2
  apply (Measure.ae_ae_comm hset).2
  apply Eventually.of_forall
  intro time
  filter_upwards [leveque04_burgersFiniteActionForwardPotential_spatial_ae_hasDerivAt
    old origin width time hwidth] with x hx
  simpa only [smul_eq_mul, div_eq_mul_inv, mul_comm] using hx.tendsto_slope_zero_left.comp hincrement

/-- Temporal difference quotients of the same potential converge to its
actual positive-time flux derivative and the zero derivative of its past extension. -/
theorem leveque04_burgersFiniteActionForwardPotential_temporal_ae_differenceQuotient {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width)
    (increment : ℕ → ℝ) (hincrement : Tendsto increment atTop (𝓝[<] (0 : ℝ))) :
    ∀ᵐ z : ℝ × ℝ, Tendsto (fun n =>
      (leveque04_burgersFiniteActionForwardPotential old origin width z.1 (z.2 + increment n) -
        leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2) / increment n)
      atTop (𝓝 (if 0 < z.2 then
        -(leveque04_burgersFiniteActionEvolution old origin width z.1 z.2) ^ 2 / 2 else 0)) := by
  have hP := leveque04_burgersFiniteActionForwardPotential_joint_measurable old origin width
  have hq := leveque04_burgersFiniteActionEvolution_joint_measurable old origin width
  have hmeas (n : ℕ) : Measurable (fun z : ℝ × ℝ =>
      (leveque04_burgersFiniteActionForwardPotential old origin width z.1 (z.2 + increment n) -
        leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2) / increment n) :=
    ((hP.comp (measurable_fst.prodMk (measurable_snd.add measurable_const))).sub hP).div measurable_const
  have hflux : Measurable (fun z : ℝ × ℝ => if 0 < z.2 then
      -(leveque04_burgersFiniteActionEvolution old origin width z.1 z.2) ^ 2 / 2 else 0) :=
    Measurable.ite (measurableSet_lt measurable_const measurable_snd)
      ((hq.pow_const 2).neg.div measurable_const) measurable_const
  have hset := measurableSet_tendsto_fun (l := atTop) hmeas hflux
  change ∀ᵐ z ∂(volume : Measure ℝ).prod volume, _
  apply (Measure.ae_prod_iff_ae_ae hset).2
  apply Eventually.of_forall
  intro x
  filter_upwards [leveque04_burgersFiniteActionForwardPotential_temporal_ae_hasDerivAt
    old origin width x hwidth] with time ht
  simpa only [smul_eq_mul, div_eq_mul_inv, mul_comm] using ht.tendsto_slope_zero_left.comp hincrement

end NumStability
