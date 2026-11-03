/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.PotentialDiscreteCurl
import Mathlib.Analysis.Calculus.ContDiff.Operations
import Mathlib.Analysis.Calculus.Deriv.Slope
import Mathlib.Analysis.Calculus.Deriv.Mul
import Mathlib.Analysis.Calculus.FDeriv.Const
import Mathlib.Analysis.Calculus.MeanValue
import Mathlib.MeasureTheory.Group.Prod
import Mathlib.MeasureTheory.Integral.DominatedConvergence
import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.Topology.Order.Compact
import Mathlib.Tactic.FunProp
import Mathlib.Tactic.Linarith

/-!
# The compact C1 weak curl identity of an actual Lipschitz potential

Exact finite-difference cancellation passes to the actual directional
derivatives by dominated convergence. Compact support and the first derivative
of the test provide the common integrable bound. No second derivative of the
test and no weak/conservation identity are assumptions.
-/

noncomputable section
open Set MeasureTheory Filter Metric
open scoped Topology NNReal

namespace NumStability

theorem contDiff_compactTest_exists_lipschitz
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test) (hsupport : HasCompactSupport test) :
    ∃ C : ℝ≥0, LipschitzWith C test := by
  have hb : BddAbove (range (fun z => ‖fderiv ℝ test z‖)) := by
    apply (htest.continuous_fderiv one_ne_zero).norm.bddAbove_range_of_hasCompactSupport
    exact (hsupport.fderiv ℝ).norm
  obtain ⟨B, hB⟩ := hb
  refine ⟨⟨max B 0, le_max_right _ _⟩, lipschitzWith_of_nnnorm_fderiv_le
    (htest.differentiable one_ne_zero) ?_⟩
  intro z
  exact_mod_cast (hB (mem_range_self z)).trans (le_max_left B 0)

private theorem differenceQuotient_norm_le
    (f : ℝ × ℝ → ℝ) {C : ℝ≥0} (hf : LipschitzWith C f)
    (z v : ℝ × ℝ) (hv : ‖v‖ ≤ 1) (h : ℝ) (hne : h ≠ 0) :
    ‖(f (z + h • v) - f z) / h‖ ≤ C := by
  simp only [norm_div, Real.norm_eq_abs]
  apply (div_le_iff₀ (abs_pos.mpr hne)).2
  have hb := hf.norm_sub_le (z + h • v) z
  simp only [add_sub_cancel_left, norm_smul, Real.norm_eq_abs] at hb
  calc
    _ ≤ (C : ℝ) * (|h| * ‖v‖) := hb
    _ ≤ (C : ℝ) * |h| := by
      nlinarith [mul_le_mul_of_nonneg_left hv (mul_nonneg C.coe_nonneg (abs_nonneg h))]

private theorem differenceQuotient_zero_outside
    (test : ℝ × ℝ → ℝ) (R : ℝ)
    (hR : ∀ z ∈ tsupport test, ‖z‖ ≤ R)
    (z v : ℝ × ℝ) (hv : ‖v‖ ≤ 1) (h : ℝ) (hh : 0 < h) (hh1 : h ≤ 1)
    (hz : z ∉ closedBall (0 : ℝ × ℝ) (R + 1)) :
    (test (z + h • v) - test z) / h = 0 := by
  have hout : R + 1 < ‖z‖ := by
    simpa only [mem_closedBall, dist_zero_right, not_le] using hz
  have hzero : test z = 0 := by
    by_contra hn
    have hb := hR z (subset_tsupport test (Function.mem_support.mpr hn))
    linarith
  have hshift : test (z + h • v) = 0 := by
    by_contra hn
    have hb := hR (z + h • v) (subset_tsupport test (Function.mem_support.mpr hn))
    have hd : ‖z‖ ≤ ‖z + h • v‖ + ‖h • v‖ := by
      simpa only [add_sub_cancel_right] using norm_sub_le (z + h • v) (h • v)
    rw [norm_smul, Real.norm_eq_abs, abs_of_pos hh] at hd
    have hhv : h * ‖v‖ ≤ 1 := (mul_le_mul_of_nonneg_left hv hh.le).trans (by simpa using hh1)
    linarith
  rw [hshift, hzero, sub_self, zero_div]

private theorem compactTest_differenceQuotient_tendsto
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test) (z v : ℝ × ℝ)
    (step : ℕ → ℝ) (hstep : Tendsto step atTop (𝓝[>] (0 : ℝ))) :
    Tendsto (fun n => (test (z + step n • v) - test z) / step n)
      atTop (𝓝 (fderiv ℝ test z v)) := by
  have hcurve : HasDerivAt (fun h : ℝ => z + h • v) v 0 := by
    simpa only [one_smul] using ((hasDerivAt_id (0 : ℝ)).smul_const v).const_add z
  have hd := (htest.differentiable one_ne_zero (z + (0 : ℝ) • v)).hasFDerivAt.comp_hasDerivAt 0 hcurve
  have hd' : HasDerivAt (fun h : ℝ => test (z + h • v)) (fderiv ℝ test z v) 0 := by
    simpa only [zero_smul, add_zero] using hd
  simpa only [zero_add, zero_smul, add_zero, smul_eq_mul, div_eq_mul_inv, mul_comm] using
    hd'.tendsto_slope_zero_right.comp hstep

private theorem bounded_mul_compact_integrable
    (q g : ℝ × ℝ → ℝ) (hq : Measurable q) (B : ℝ)
    (hbound : ∀ z, |q z| ≤ B) (hg : Continuous g) (hsupport : HasCompactSupport g) :
    Integrable (fun z => q z * g z) := by
  apply ((hg.integrable_of_hasCompactSupport hsupport).norm.const_mul B).mono'
    (hq.mul hg.measurable).aestronglyMeasurable
  filter_upwards [] with z
  simpa only [Real.norm_eq_abs, abs_mul] using
    mul_le_mul_of_nonneg_right (hbound z) (abs_nonneg (g z))

/-- Actual a.e. limits of directional potential quotients imply the compact
C1 weak curl identity. All product integrabilities are conclusions or are
derived from continuity and compact support, not conservation premises. -/
theorem lipschitzPotential_compactTest_weakCurl
    (potential A B : ℝ × ℝ → ℝ) (L : ℝ≥0) (hpotential : LipschitzWith L potential)
    (hA : Measurable A) (hB : Measurable B)
    (hAbound : ∀ z, |A z| ≤ L) (hBbound : ∀ z, |B z| ≤ L)
    (v w : ℝ × ℝ) (hv : ‖v‖ ≤ 1) (hw : ‖w‖ ≤ 1)
    (step : ℕ → ℝ) (hpos : ∀ n, 0 < step n) (hle : ∀ n, step n ≤ 1)
    (hstep : Tendsto step atTop (𝓝[>] (0 : ℝ)))
    (hDA : ∀ᵐ z : ℝ × ℝ, Tendsto (fun n =>
      (potential (z + (-step n) • v) - potential z) / (-step n)) atTop (𝓝 (A z)))
    (hDB : ∀ᵐ z : ℝ × ℝ, Tendsto (fun n =>
      (potential (z + (-step n) • w) - potential z) / (-step n)) atTop (𝓝 (B z)))
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test) (hsupport : HasCompactSupport test) :
    Integrable (fun z => A z * fderiv ℝ test z w) ∧
      Integrable (fun z => B z * fderiv ℝ test z v) ∧
      (∫ z, A z * fderiv ℝ test z w) = ∫ z, B z * fderiv ℝ test z v := by
  obtain ⟨C, hC⟩ := contDiff_compactTest_exists_lipschitz test htest hsupport
  obtain ⟨R₀, hR₀⟩ := hsupport.isCompact.exists_bound_of_continuousOn continuous_id.continuousOn
  let R := |R₀|
  have hR (z : ℝ × ℝ) (hz : z ∈ tsupport test) : ‖z‖ ≤ R :=
    (hR₀ z hz).trans (le_abs_self R₀)
  let S := closedBall (0 : ℝ × ℝ) (R + 1)
  let bound : ℝ × ℝ → ℝ := S.indicator (fun _ => (L : ℝ) * C)
  let F : ℕ → (ℝ × ℝ) → ℝ := fun n z =>
    ((potential (z + (-step n) • v) - potential z) / (-step n)) *
      ((test (z + step n • w) - test z) / step n)
  let G : ℕ → (ℝ × ℝ) → ℝ := fun n z =>
    ((potential (z + (-step n) • w) - potential z) / (-step n)) *
      ((test (z + step n • v) - test z) / step n)
  have hboundInt : Integrable bound := by
    rw [integrable_indicator_iff measurableSet_closedBall]
    exact integrableOn_const (measure_closedBall_lt_top.ne)
  have hFmeas (n : ℕ) : AEStronglyMeasurable (F n) volume := by
    apply Continuous.aestronglyMeasurable
    exact (((hpotential.continuous.comp (continuous_id.add continuous_const)).sub
      hpotential.continuous).div_const _).mul
      (((htest.continuous.comp (continuous_id.add continuous_const)).sub htest.continuous).div_const _)
  have hGmeas (n : ℕ) : AEStronglyMeasurable (G n) volume := by
    apply Continuous.aestronglyMeasurable
    exact (((hpotential.continuous.comp (continuous_id.add continuous_const)).sub
      hpotential.continuous).div_const _).mul
      (((htest.continuous.comp (continuous_id.add continuous_const)).sub htest.continuous).div_const _)
  have hFbound (n : ℕ) : ∀ᵐ z : ℝ × ℝ, ‖F n z‖ ≤ bound z := by
    filter_upwards [] with z
    by_cases hz : z ∈ S
    · rw [show bound z = (L : ℝ) * C from indicator_of_mem hz _]
      dsimp [F]
      rw [abs_mul]
      exact mul_le_mul
        (differenceQuotient_norm_le potential hpotential z v hv (-step n) (neg_ne_zero.mpr (hpos n).ne'))
        (differenceQuotient_norm_le test hC z w hw (step n) (hpos n).ne')
        (abs_nonneg _) L.coe_nonneg
    · have hzero := differenceQuotient_zero_outside test R hR z w hw (step n) (hpos n) (hle n) hz
      simp only [F, hzero, mul_zero, norm_zero, bound, indicator_of_notMem hz]
      exact le_refl 0
  have hGbound (n : ℕ) : ∀ᵐ z : ℝ × ℝ, ‖G n z‖ ≤ bound z := by
    filter_upwards [] with z
    by_cases hz : z ∈ S
    · rw [show bound z = (L : ℝ) * C from indicator_of_mem hz _]
      dsimp [G]
      rw [abs_mul]
      exact mul_le_mul
        (differenceQuotient_norm_le potential hpotential z w hw (-step n) (neg_ne_zero.mpr (hpos n).ne'))
        (differenceQuotient_norm_le test hC z v hv (step n) (hpos n).ne')
        (abs_nonneg _) L.coe_nonneg
    · have hzero := differenceQuotient_zero_outside test R hR z v hv (step n) (hpos n) (hle n) hz
      simp only [G, hzero, mul_zero, norm_zero, bound, indicator_of_notMem hz]
      exact le_refl 0
  have hFlim : ∀ᵐ z : ℝ × ℝ, Tendsto (fun n => F n z) atTop
      (𝓝 (A z * fderiv ℝ test z w)) := by
    filter_upwards [hDA] with z hz
    exact hz.mul (compactTest_differenceQuotient_tendsto test htest z w step hstep)
  have hGlim : ∀ᵐ z : ℝ × ℝ, Tendsto (fun n => G n z) atTop
      (𝓝 (B z * fderiv ℝ test z v)) := by
    filter_upwards [hDB] with z hz
    exact hz.mul (compactTest_differenceQuotient_tendsto test htest z v step hstep)
  have hprod (c : ℝ × ℝ) : Integrable (fun z => potential z * test (z + c)) := by
    exact (hpotential.continuous.mul (htest.continuous.comp (continuous_id.add continuous_const))).integrable_of_hasCompactSupport
      (hsupport.comp_homeomorph (Homeomorph.addRight c)).mul_left
  have heq (n : ℕ) : (∫ z, F n z) = ∫ z, G n z := by
    letI : (volume : Measure (ℝ × ℝ)).IsAddRightInvariant :=
      Measure.prod.instIsAddRightInvariant (μ := (volume : Measure ℝ)) (ν := (volume : Measure ℝ))
    have hd := integral_potential_discreteCurl (volume : Measure (ℝ × ℝ)) potential test
      (step n • v) (step n • w) (by simpa only [add_zero] using hprod 0)
      (hprod _) (hprod _) (hprod _)
    have hn : step n ≠ 0 := (hpos n).ne'
    calc
      _ = (∫ z, (potential z - potential (z - step n • v)) *
          (test (z + step n • w) - test z)) / step n ^ 2 := by
        rw [← integral_div]
        apply integral_congr_ae
        filter_upwards [] with z
        dsimp [F]
        rw [neg_smul, ← sub_eq_add_neg]
        field_simp [hn]
        ring
      _ = (∫ z, (potential z - potential (z - step n • w)) *
          (test (z + step n • v) - test z)) / step n ^ 2 := congrArg (fun a => a / step n ^ 2) hd.2.2
      _ = _ := by
        rw [← integral_div]
        apply integral_congr_ae
        filter_upwards [] with z
        dsimp [G]
        rw [neg_smul, ← sub_eq_add_neg]
        field_simp [hn]
        ring
  have hFint := tendsto_integral_of_dominated_convergence bound hFmeas hboundInt hFbound hFlim
  have hGint := tendsto_integral_of_dominated_convergence bound hGmeas hboundInt hGbound hGlim
  have hD (u : ℝ × ℝ) : Continuous (fun z => fderiv ℝ test z u) :=
    (htest.continuous_fderiv_apply one_ne_zero).comp (continuous_id.prodMk continuous_const)
  refine ⟨bounded_mul_compact_integrable A _ hA L hAbound (hD w) (hsupport.fderiv_apply ℝ w),
    bounded_mul_compact_integrable B _ hB L hBbound (hD v) (hsupport.fderiv_apply ℝ v), ?_⟩
  exact tendsto_nhds_unique hFint ((tendsto_congr heq).mpr hGint)

end NumStability
