/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.Normed.Lp.IntegerShift
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CenteredStencilEvolution
import ComputationalMathematics.Source.LeVeque.Chapter04.CenteredModeInstability
import Mathlib.Analysis.SpecificLimits.Normed
import Mathlib.Data.Int.Interval

/-!
# Centered advection on the whole-line two-norm space

The centered operator acts on actual square-summable bilateral sequences.
Finite truncations of a quarter wave give growing two-coordinate energy without
treating the infinite periodic sequence as an element of that space. The final
mesh family keeps physical time and the time/space ratio fixed. The data may
depend on the mesh; the result denies a uniform all-data stability bound.
-/

namespace NumStability

open scoped BigOperators

noncomputable section

/-- The actual centered scalar stencil as a bounded operator on bilateral ℓ². -/
def leveque04_centeredWholeLineL2Step (courant : ℝ) :
    lp (fun _ : ℤ => ℝ) 2 →L[ℝ] lp (fun _ : ℤ => ℝ) 2 :=
  ContinuousLinearMap.id ℝ _ - (courant / 2) •
    (l2IntForwardShift.toContinuousLinearEquiv.toContinuousLinearMap -
      l2IntBackwardShift.toContinuousLinearEquiv.toContinuousLinearMap)

@[simp] theorem leveque04_centeredWholeLineL2Step_apply
    (courant : ℝ) (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    leveque04_centeredWholeLineL2Step courant u i =
      u i - courant / 2 * (u (i + 1) - u (i - 1)) := rfl

/-- This operator is the existing conservative centered-flux update, rather
than a supplied evolution identity. -/
theorem leveque04_centeredWholeLineL2Step_eq_actual
    (timeStep width speed : ℝ) (hwidth : 0 < width)
    (u : lp (fun _ : ℤ => ℝ) 2) (i : ℤ) :
    leveque04_centeredWholeLineL2Step (speed * timeStep / width) u i =
      leveque04_centeredScalarAdvectionStep timeStep width speed u i := by
  rw [leveque04_centeredWholeLineL2Step_apply,
    leveque04_centeredScalarAdvectionStep_ftcs timeStep width speed u i hwidth]
  field_simp [hwidth.ne'] <;> ring

private def centeredArrayStep (courant : ℝ) (u : ℤ → ℝ) (i : ℤ) : ℝ :=
  u i - courant / 2 * (u (i + 1) - u (i - 1))

private theorem centeredL2_coe_iterate
    (courant : ℝ) (n : ℕ) (u : lp (fun _ : ℤ => ℝ) 2) :
    ((leveque04_centeredWholeLineL2Step courant)^[n] u : ℤ → ℝ) =
      (centeredArrayStep courant)^[n] (u : ℤ → ℝ) := by
  have h : Function.Semiconj (fun u : lp (fun _ : ℤ => ℝ) 2 => (u : ℤ → ℝ))
      (leveque04_centeredWholeLineL2Step courant) (centeredArrayStep courant) :=
    fun _ => rfl
  exact h.iterate_right n u

private theorem centeredArrayStep_locality (courant : ℝ)
    (left right : ℤ → ℝ) (i : ℤ)
    (h : ∀ j ∈ Set.Icc (i - (1 : ℤ)) (i + (1 : ℤ)), left j = right j) :
    centeredArrayStep courant left i = centeredArrayStep courant right i := by
  dsimp [centeredArrayStep]
  rw [h i (by constructor <;> omega),
    h (i + 1) (by constructor <;> omega),
    h (i - 1) (by constructor <;> omega)]

private def integerQuarterWave (amplitude : ℝ × ℝ) (i : ℤ) : ℝ :=
  if i % 4 = 0 then amplitude.1 else if i % 4 = 1 then amplitude.2
  else if i % 4 = 2 then -amplitude.1 else -amplitude.2

private theorem integerQuarterWave_step (courant : ℝ) (amplitude : ℝ × ℝ) :
    centeredArrayStep courant (integerQuarterWave amplitude) =
      integerQuarterWave (leveque04_centeredModeStep courant amplitude) := by
  funext i
  have hi : i % 4 = 0 ∨ i % 4 = 1 ∨ i % 4 = 2 ∨ i % 4 = 3 := by omega
  rcases hi with hi | hi | hi | hi
  all_goals
    have hl : (i - 1) % 4 = (i % 4 + 3) % 4 := by omega
    have hr : (i + 1) % 4 = (i % 4 + 1) % 4 := by omega
    simp only [hi] at hl hr
    norm_num at hl hr
    simp [centeredArrayStep, integerQuarterWave, leveque04_centeredModeStep, hi, hl, hr]
    <;> ring

private theorem integerQuarterWave_iterate (courant : ℝ) (n : ℕ) :
    (centeredArrayStep courant)^[n] (integerQuarterWave (1, 0)) =
      integerQuarterWave ((leveque04_centeredModeStep courant)^[n] (1, 0)) := by
  induction n with
  | zero => rfl
  | succ n ih =>
    rw [Function.iterate_succ_apply', ih, integerQuarterWave_step,
      Function.iterate_succ_apply']

/-- A genuinely finite-support two-norm datum, cut off beyond both dependence
windows of cells zero and one at step `n`. -/
def leveque04_centeredTruncatedQuarterWave (n : ℕ) : lp (fun _ : ℤ => ℝ) 2 :=
  ∑ j ∈ Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1),
    lp.single 2 j (integerQuarterWave (1, 0) j)

theorem leveque04_centeredTruncatedQuarterWave_apply (n : ℕ) (j : ℤ) :
    leveque04_centeredTruncatedQuarterWave n j =
      if j ∈ Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1)
      then integerQuarterWave (1, 0) j else 0 := by
  classical
  simp only [leveque04_centeredTruncatedQuarterWave, lp.coeFn_sum,
    lp.coeFn_single, Finset.sum_apply, Finset.sum_pi_single]

@[simp] theorem leveque04_centeredTruncatedQuarterWave_zero (n : ℕ) :
    leveque04_centeredTruncatedQuarterWave n 0 = 1 := by
  rw [leveque04_centeredTruncatedQuarterWave_apply]
  have h : (0 : ℤ) ∈ Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1) := by
    simp only [Finset.mem_Icc]
    constructor <;> omega
  simp [h, integerQuarterWave]

/-- The initial two-norm cost grows at most linearly in the cutoff length. -/
theorem leveque04_centeredTruncatedQuarterWave_initial_bound (n : ℕ) :
    ‖leveque04_centeredTruncatedQuarterWave n‖ ^ 2 ≤ 2 * (n : ℝ) + 2 := by
  classical
  have heq : ‖leveque04_centeredTruncatedQuarterWave n‖ ^ 2 =
      ∑ j ∈ Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1),
        |integerQuarterWave (1, 0) j| ^ 2 := by
    simpa [leveque04_centeredTruncatedQuarterWave, Real.rpow_two, Real.norm_eq_abs] using
      (lp.norm_sum_single (p := (2 : ENNReal)) (by norm_num)
        (integerQuarterWave (1, 0)) (Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1)))
  rw [heq]
  calc
    _ ≤ ∑ _j ∈ Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1), (1 : ℝ) := by
      apply Finset.sum_le_sum
      intro j _hj
      dsimp [integerQuarterWave]
      split_ifs <;> norm_num
    _ = 2 * (n : ℝ) + 2 := by
      simp only [Finset.sum_const, nsmul_eq_mul, mul_one, Int.card_Icc]
      have hc : ((n : ℤ) + 1 + 1 - -(n : ℤ)).toNat = 2 * n + 2 := by omega
      rw [hc]
      push_cast
      ring

private theorem centeredTruncated_iterate_coordinate
    (courant : ℝ) (n : ℕ) (i : ℤ) (hi : i = 0 ∨ i = 1) :
    ((leveque04_centeredWholeLineL2Step courant)^[n]
      (leveque04_centeredTruncatedQuarterWave n)) i =
      integerQuarterWave ((leveque04_centeredModeStep courant)^[n] (1, 0)) i := by
  rw [centeredL2_coe_iterate]
  rw [← integerQuarterWave_iterate]
  apply iterate_eq_of_centeredStencil_locality (centeredArrayStep courant) 1
    (centeredArrayStep_locality courant)
  intro j hj
  have hwindow : j ∈ Finset.Icc (-(n : ℤ)) ((n : ℤ) + 1) := by
    simp only [Finset.mem_Icc]
    rcases hi with rfl | rfl <;> simp only [Set.mem_Icc, mul_one] at hj <;>
      constructor <;> omega
  simp only [leveque04_centeredTruncatedQuarterWave_apply, if_pos hwindow]

/-- The two observed coordinates already contain the exponentially growing
mode energy. The full evolved sequence remains an actual ℓ² element. -/
theorem leveque04_centeredTruncatedQuarterWave_energy_lower (courant : ℝ) (n : ℕ) :
    (1 + courant ^ 2) ^ n ≤
      ‖(leveque04_centeredWholeLineL2Step courant)^[n]
        (leveque04_centeredTruncatedQuarterWave n)‖ ^ 2 := by
  let u := (leveque04_centeredWholeLineL2Step courant)^[n]
    (leveque04_centeredTruncatedQuarterWave n)
  have hnorm : u 0 ^ 2 + u 1 ^ 2 ≤ ‖u‖ ^ 2 := by
    have h := lp.sum_rpow_le_norm_rpow (p := (2 : ENNReal)) (by norm_num) u
      ({0, 1} : Finset ℤ)
    simpa [Real.rpow_two, Real.norm_eq_abs, sq_abs] using h
  have henergy : u 0 ^ 2 + u 1 ^ 2 = (1 + courant ^ 2) ^ n := by
    dsimp [u]
    rw [centeredTruncated_iterate_coordinate courant n 0 (Or.inl rfl),
      centeredTruncated_iterate_coordinate courant n 1 (Or.inr rfl)]
    simpa [integerQuarterWave, leveque04_modeEnergy] using
      leveque04_centeredModeEnergy_iterate courant n
  rw [henergy] at hnorm
  exact hnorm

private theorem exponential_dominates_support (base bound : ℝ) (hbase : 1 < base)
    (start : ℕ) :
    ∃ n : ℕ, start ≤ n ∧ 0 < n ∧
      bound ^ 2 * (2 * (n : ℝ) + 2) < base ^ n := by
  have hlim0 := (((tendsto_pow_const_div_const_pow_of_one_lt 1 hbase).const_mul 2).add
    ((tendsto_pow_const_div_const_pow_of_one_lt 0 hbase).const_mul 2)).const_mul (bound ^ 2)
  have hlim : Filter.Tendsto
      (fun n : ℕ => bound ^ 2 * (2 * (n : ℝ) + 2) / base ^ n)
      Filter.atTop (nhds 0) := by
    convert hlim0 using 1
    · funext n
      simp only [pow_one, pow_zero]
      ring
    · ring
  obtain ⟨cutoff, hc⟩ := Filter.eventually_atTop.mp
    (hlim.eventually (Iio_mem_nhds (by norm_num : (0 : ℝ) < 1)))
  let n := max (max start cutoff) 1
  refine ⟨n, by dsimp [n]; omega, by dsimp [n]; omega, ?_⟩
  have hn : cutoff ≤ n := by dsimp [n]; omega
  exact (div_lt_one (pow_pos (lt_trans zero_lt_one hbase) n)).mp (hc n hn)

/-- No proposed amplification bound works uniformly for all late step counts
and all two-norm data, even though every test datum has finite support. -/
theorem leveque04_centeredWholeLineL2Step_unbounded (courant bound : ℝ)
    (hcourant : courant ≠ 0) (hbound : 0 ≤ bound) (start : ℕ) :
    ∃ n : ℕ, start ≤ n ∧ 0 < n ∧
      bound * ‖leveque04_centeredTruncatedQuarterWave n‖ <
        ‖(leveque04_centeredWholeLineL2Step courant)^[n]
          (leveque04_centeredTruncatedQuarterWave n)‖ := by
  have hbase : 1 < 1 + courant ^ 2 := by nlinarith [sq_pos_of_ne_zero hcourant]
  obtain ⟨n, hn, hnpos, hgrow⟩ := exponential_dominates_support
    (1 + courant ^ 2) bound hbase start
  refine ⟨n, hn, hnpos, ?_⟩
  apply (sq_lt_sq₀ (mul_nonneg hbound (norm_nonneg _)) (norm_nonneg _)).mp
  calc
    (bound * ‖leveque04_centeredTruncatedQuarterWave n‖) ^ 2 =
        bound ^ 2 * ‖leveque04_centeredTruncatedQuarterWave n‖ ^ 2 := by ring
    _ ≤ bound ^ 2 * (2 * (n : ℝ) + 2) :=
      mul_le_mul_of_nonneg_left (leveque04_centeredTruncatedQuarterWave_initial_bound n)
        (sq_nonneg bound)
    _ < (1 + courant ^ 2) ^ n := hgrow
    _ ≤ _ := leveque04_centeredTruncatedQuarterWave_energy_lower courant n

/-- Fixed positive physical time and time/space ratio do not restore uniform
two-norm stability. The positive physical factor `sqrt(width)` is retained. -/
theorem leveque04_centeredWholeLineL2_fixedTime_unstable
    (speed ratio finalTime bound : ℝ) (hspeed : speed ≠ 0) (hratio : 0 < ratio)
    (hfinal : 0 < finalTime) (hbound : 0 ≤ bound) (start : ℕ) :
    ∃ n : ℕ, start ≤ n ∧ 0 < n ∧
      bound * (Real.sqrt (finalTime / (ratio * (n : ℝ))) *
        ‖leveque04_centeredTruncatedQuarterWave n‖) <
      Real.sqrt (finalTime / (ratio * (n : ℝ))) *
        ‖(leveque04_centeredWholeLineL2Step
          (speed * (finalTime / (n : ℝ)) /
            (finalTime / (ratio * (n : ℝ)))))^[n]
          (leveque04_centeredTruncatedQuarterWave n)‖ := by
  obtain ⟨n, hn, hnpos, hnorm⟩ := leveque04_centeredWholeLineL2Step_unbounded
    (speed * ratio) bound (mul_ne_zero hspeed hratio.ne') hbound start
  have hnreal : 0 < (n : ℝ) := Nat.cast_pos.mpr hnpos
  have hwidth : 0 < finalTime / (ratio * (n : ℝ)) :=
    div_pos hfinal (mul_pos hratio hnreal)
  have hnu : speed * (finalTime / (n : ℝ)) /
      (finalTime / (ratio * (n : ℝ))) = speed * ratio := by
    field_simp [hfinal.ne', hratio.ne', hnreal.ne']
  refine ⟨n, hn, hnpos, ?_⟩
  rw [hnu]
  calc
    _ = Real.sqrt (finalTime / (ratio * (n : ℝ))) *
        (bound * ‖leveque04_centeredTruncatedQuarterWave n‖) := by ring
    _ < _ := mul_lt_mul_of_pos_left hnorm (Real.sqrt_pos.mpr hwidth)

/-- The mesh family used in the fixed-time counterexample really refines. -/
theorem leveque04_centeredWholeLineL2_mesh_limits (finalTime ratio : ℝ) :
    Filter.Tendsto (fun n : ℕ => finalTime / (n : ℝ)) Filter.atTop (nhds 0) ∧
    Filter.Tendsto (fun n : ℕ => finalTime / (ratio * (n : ℝ)))
      Filter.atTop (nhds 0) := by
  refine ⟨tendsto_const_div_atTop_nhds_zero_nat finalTime, ?_⟩
  convert tendsto_const_div_atTop_nhds_zero_nat (finalTime / ratio) using 1
  funext n
  simp only [div_div]

/-- The observed step really occurs at the prescribed physical final time. -/
theorem leveque04_centeredWholeLineL2_time_identity
    (finalTime : ℝ) (n : ℕ) (hn : 0 < n) :
    (n : ℝ) * (finalTime / (n : ℝ)) = finalTime := by
  field_simp [Nat.cast_ne_zero.mpr hn.ne']

/-- Zero Courant number is an actual identity, not an unstable exception. -/
@[simp] theorem leveque04_centeredWholeLineL2Step_zero :
    leveque04_centeredWholeLineL2Step 0 = ContinuousLinearMap.id ℝ _ := by
  simp [leveque04_centeredWholeLineL2Step]

end

end NumStability
