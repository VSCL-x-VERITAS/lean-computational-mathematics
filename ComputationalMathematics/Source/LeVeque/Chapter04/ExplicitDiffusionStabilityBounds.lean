/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.ExplicitDiffusionStep
import Mathlib.Data.Real.Archimedean
import Mathlib.Algebra.Order.Field.Power
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Whole-line explicit diffusion stability bounds

All operators below are the actual conservative Chapter4 diffusion update on
the entire integer grid. Uniform bounds are bounds on arbitrary perturbations
in the supremum norm, expressed pointwise without choosing a supremum for
unbounded arrays. Fixed-physical-time refinement stability is distinguished
from power stability of one fixed mesh.
-/

namespace NumStability

/-- Uniform amplification of every bounded grid perturbation through a fixed
physical horizon. The constant is common to all initial data and step counts. -/
def IsExplicitDiffusionStableThrough (horizon bound timeStep width : ℝ)
    (diffusivity : ℤ → ℝ) : Prop :=
  ∀ (before reference : ℤ → ℝ) (B : ℝ), 0 ≤ B →
    (∀ i, |before i - reference i| ≤ B) →
    ∀ n : ℕ, (n : ℝ) * timeStep ≤ horizon → ∀ i : ℤ,
      |((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n] before) i -
        ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n] reference) i| ≤
          bound * B

/-- Power stability on a fixed mesh is a uniform bound for all step counts,
not only for times below one fixed physical horizon. -/
def IsExplicitDiffusionSupPowerStable (timeStep width : ℝ)
    (diffusivity : ℤ → ℝ) : Prop :=
  ∃ bound : ℝ, 0 ≤ bound ∧ ∀ (before reference : ℤ → ℝ) (B : ℝ),
    0 ≤ B → (∀ i, |before i - reference i| ≤ B) → ∀ n : ℕ, ∀ i : ℤ,
      |((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n] before) i -
        ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n] reference) i| ≤
          bound * B

theorem leveque04_explicitDiffusionStep_zero
    (timeStep width : ℝ) (diffusivity : ℤ → ℝ) :
    leveque04_explicitDiffusionStep timeStep width diffusivity (fun _ => 0) =
      (fun _ => 0) := by
  funext i
  simp [leveque04_explicitDiffusionStep, conservativeFluxDifferenceUpdateInt,
    leveque04_diffusionInterfaceFlux, Leveque02Tracer.fickFlux]

/-- The difference of two actual conservative updates is the three-weight
diffusion average, with the same left-face coefficient shared by adjacent cells. -/
theorem leveque04_explicitDiffusionStep_sub_weights
    (timeStep width : ℝ) (diffusivity before reference : ℤ → ℝ)
    (hwidth : 0 < width) (i : ℤ) :
    leveque04_explicitDiffusionStep timeStep width diffusivity before i -
        leveque04_explicitDiffusionStep timeStep width diffusivity reference i =
      (timeStep / width ^ 2 * diffusivity i) * (before (i - 1) - reference (i - 1)) +
      (1 - timeStep / width ^ 2 * (diffusivity i + diffusivity (i + 1))) *
        (before i - reference i) +
      (timeStep / width ^ 2 * diffusivity (i + 1)) *
        (before (i + 1) - reference (i + 1)) := by
  rw [leveque04_equation11 timeStep width diffusivity before i hwidth,
    leveque04_equation11 timeStep width diffusivity reference i hwidth]
  ring

/-- Nonnegative interface conductivities and the local row-sum restriction
give one-step supremum-norm nonexpansion for all grid perturbations. -/
theorem leveque04_explicitDiffusionStep_sub_bound
    (timeStep width B : ℝ) (diffusivity before reference : ℤ → ℝ)
    (htime : 0 ≤ timeStep) (hwidth : 0 < width)
    (hnonneg : ∀ i, 0 ≤ diffusivity i)
    (hcfl : ∀ i, timeStep / width ^ 2 * (diffusivity i + diffusivity (i + 1)) ≤ 1)
    (hbound : ∀ i, |before i - reference i| ≤ B) (i : ℤ) :
    |leveque04_explicitDiffusionStep timeStep width diffusivity before i -
      leveque04_explicitDiffusionStep timeStep width diffusivity reference i| ≤ B := by
  let a := timeStep / width ^ 2
  have ha : 0 ≤ a := div_nonneg htime (sq_nonneg _)
  have hwL : 0 ≤ a * diffusivity i := mul_nonneg ha (hnonneg i)
  have hwC : 0 ≤ 1 - a * (diffusivity i + diffusivity (i + 1)) :=
    sub_nonneg.mpr (hcfl i)
  have hwR : 0 ≤ a * diffusivity (i + 1) := mul_nonneg ha (hnonneg (i + 1))
  rw [leveque04_explicitDiffusionStep_sub_weights timeStep width diffusivity
    before reference hwidth i]
  change |a * diffusivity i * _ + (1 - a * _) * _ + a * diffusivity (i + 1) * _| ≤ B
  calc
    _ ≤ |a * diffusivity i * (before (i - 1) - reference (i - 1))| +
        |(1 - a * (diffusivity i + diffusivity (i + 1))) * (before i - reference i)| +
        |a * diffusivity (i + 1) * (before (i + 1) - reference (i + 1))| := by
          exact (abs_add_le _ _).trans (add_le_add (abs_add_le _ _) le_rfl)
    _ ≤ a * diffusivity i * B +
        (1 - a * (diffusivity i + diffusivity (i + 1))) * B +
        a * diffusivity (i + 1) * B := by
          simp only [abs_mul, abs_of_nonneg hwL, abs_of_nonneg hwC, abs_of_nonneg hwR]
          exact add_le_add (add_le_add
            (mul_le_mul_of_nonneg_left (hbound (i - 1)) hwL)
            (mul_le_mul_of_nonneg_left (hbound i) hwC))
            (mul_le_mul_of_nonneg_left (hbound (i + 1)) hwR)
    _ = B := by ring

/-- The same genuine local CFL condition controls every pair and every
iterate on the whole line, with amplification constant one. -/
theorem leveque04_explicitDiffusion_iterate_sub_bound
    (timeStep width B : ℝ) (diffusivity before reference : ℤ → ℝ)
    (htime : 0 ≤ timeStep) (hwidth : 0 < width)
    (hnonneg : ∀ i, 0 ≤ diffusivity i)
    (hcfl : ∀ i, timeStep / width ^ 2 * (diffusivity i + diffusivity (i + 1)) ≤ 1)
    (hbound : ∀ i, |before i - reference i| ≤ B) (n : ℕ) (i : ℤ) :
    |((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n] before) i -
      ((leveque04_explicitDiffusionStep timeStep width diffusivity)^[n] reference) i| ≤ B := by
  induction n generalizing i with
  | zero => exact hbound i
  | succ n ih =>
      rw [Function.iterate_succ_apply', Function.iterate_succ_apply']
      exact leveque04_explicitDiffusionStep_sub_bound timeStep width B diffusivity _ _
        htime hwidth hnonneg hcfl ih i

theorem leveque04_explicitDiffusion_stableThrough_of_localCFL
    (horizon timeStep width : ℝ) (diffusivity : ℤ → ℝ)
    (htime : 0 ≤ timeStep) (hwidth : 0 < width)
    (hnonneg : ∀ i, 0 ≤ diffusivity i)
    (hcfl : ∀ i, timeStep / width ^ 2 * (diffusivity i + diffusivity (i + 1)) ≤ 1) :
    IsExplicitDiffusionStableThrough horizon 1 timeStep width diffusivity := by
  intro before reference B _ hbound n _ i
  simpa only [one_mul] using leveque04_explicitDiffusion_iterate_sub_bound
    timeStep width B diffusivity before reference htime hwidth hnonneg hcfl hbound n i

/-- A bounded whole-line alternating perturbation. It is not a two-cell
periodic model and is not asserted to be square-summable. -/
noncomputable def leveque04_wholeLineAlternatingDiffusionData (i : ℤ) : ℝ := (-1 : ℝ) ^ i

theorem leveque04_wholeLineAlternatingDiffusionData_abs (i : ℤ) :
    |leveque04_wholeLineAlternatingDiffusionData i| = 1 := by
  exact abs_neg_one_zpow i

theorem leveque04_explicitDiffusionStep_alternating
    (timeStep width diffusivity amplitude : ℝ) (hwidth : 0 < width) (i : ℤ) :
    leveque04_explicitDiffusionStep timeStep width (fun _ => diffusivity)
        (fun j => amplitude * leveque04_wholeLineAlternatingDiffusionData j) i =
      ((1 - 4 * (timeStep * diffusivity / width ^ 2)) * amplitude) *
        leveque04_wholeLineAlternatingDiffusionData i := by
  rw [leveque04_equation12 timeStep width diffusivity _ i hwidth]
  have hl : leveque04_wholeLineAlternatingDiffusionData (i - 1) =
      -leveque04_wholeLineAlternatingDiffusionData i := by
    dsimp only [leveque04_wholeLineAlternatingDiffusionData]
    rw [zpow_sub₀ (by norm_num : (-1 : ℝ) ≠ 0), zpow_one]
    ring
  have hr : leveque04_wholeLineAlternatingDiffusionData (i + 1) =
      -leveque04_wholeLineAlternatingDiffusionData i := by
    dsimp only [leveque04_wholeLineAlternatingDiffusionData]
    rw [zpow_add₀ (by norm_num : (-1 : ℝ) ≠ 0), zpow_one]
    ring
  rw [hl, hr]
  ring

theorem leveque04_explicitDiffusion_alternating_iterate
    (timeStep width diffusivity : ℝ) (hwidth : 0 < width) (n : ℕ) :
    (leveque04_explicitDiffusionStep timeStep width (fun _ => diffusivity))^[n]
        leveque04_wholeLineAlternatingDiffusionData =
      fun i => (1 - 4 * (timeStep * diffusivity / width ^ 2)) ^ n *
        leveque04_wholeLineAlternatingDiffusionData i := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [Function.iterate_succ_apply', ih]
      funext i
      rw [leveque04_explicitDiffusionStep_alternating timeStep width diffusivity _ hwidth i,
        pow_succ]
      ring

theorem leveque04_explicitDiffusion_constantRatio_bound
    (horizon bound timeStep width diffusivity : ℝ) (hwidth : 0 < width)
    (hstep : timeStep ≤ horizon)
    (hstable : IsExplicitDiffusionStableThrough horizon bound timeStep width
      (fun _ => diffusivity)) :
    timeStep * diffusivity / width ^ 2 ≤ (bound + 1) / 4 := by
  have h := hstable leveque04_wholeLineAlternatingDiffusionData (fun _ => 0) 1
    (by norm_num) (by intro i; simpa using (leveque04_wholeLineAlternatingDiffusionData_abs i).le)
    1 (by simpa using hstep) 0
  have hz := leveque04_explicitDiffusionStep_zero timeStep width (fun _ => diffusivity)
  have ha := leveque04_explicitDiffusionStep_alternating
    timeStep width diffusivity 1 hwidth 0
  simp only [Function.iterate_one, hz, sub_zero, mul_one] at h
  have heval : leveque04_explicitDiffusionStep timeStep width (fun _ => diffusivity)
      leveque04_wholeLineAlternatingDiffusionData 0 =
        1 - 4 * (timeStep * diffusivity / width ^ 2) := by
    simpa [leveque04_wholeLineAlternatingDiffusionData] using ha
  have hf : |1 - 4 * (timeStep * diffusivity / width ^ 2)| ≤ bound := by
    simpa only [heval] using h
  have hlo := (abs_le.mp hf).1
  linarith

/-- The alternating orbit is a necessity test on the actual whole-line
operator. It supplements the all-data sufficiency estimate above. -/
theorem leveque04_explicitDiffusion_constantPowerStable_iff
    (timeStep width diffusivity : ℝ) (htime : 0 ≤ timeStep)
    (hwidth : 0 < width) (hpositive : 0 < diffusivity) :
    IsExplicitDiffusionSupPowerStable timeStep width (fun _ => diffusivity) ↔
      timeStep * diffusivity / width ^ 2 ≤ 1 / 2 := by
  constructor
  · rintro ⟨bound, _, hbound⟩
    by_contra hlimit
    have hr : 1 / 2 < timeStep * diffusivity / width ^ 2 := lt_of_not_ge hlimit
    have hf : 1 < |1 - 4 * (timeStep * diffusivity / width ^ 2)| := by
      rw [abs_of_neg (by linarith)]
      linarith
    obtain ⟨n, hn⟩ := pow_unbounded_of_one_lt bound hf
    have h := hbound leveque04_wholeLineAlternatingDiffusionData (fun _ => 0) 1
      (by norm_num)
      (by intro i; simpa using (leveque04_wholeLineAlternatingDiffusionData_abs i).le) n 0
    have hz : (leveque04_explicitDiffusionStep timeStep width
        (fun _ => diffusivity))^[n] (fun _ => 0) = (fun _ => 0) := by
      clear hn h
      induction n with
      | zero => rfl
      | succ n ih => rw [Function.iterate_succ_apply', ih,
          leveque04_explicitDiffusionStep_zero]
    rw [leveque04_explicitDiffusion_alternating_iterate timeStep width diffusivity hwidth n,
      hz] at h
    have hpow : |1 - 4 * (timeStep * diffusivity / width ^ 2)| ^ n ≤ bound := by
      simpa [leveque04_wholeLineAlternatingDiffusionData, abs_pow] using h
    exact (not_lt_of_ge hpow) hn
  · intro hlimit
    refine ⟨1, by norm_num, ?_⟩
    intro before reference B _ hbound n i
    have hcfl : ∀ i : ℤ, timeStep / width ^ 2 *
        ((fun _ => diffusivity) i + (fun _ => diffusivity) (i + 1)) ≤ 1 := by
      intro i
      change timeStep / width ^ 2 * (diffusivity + diffusivity) ≤ 1
      have heq : timeStep / width ^ 2 * (diffusivity + diffusivity) =
          2 * (timeStep * diffusivity / width ^ 2) := by ring
      rw [heq]
      linarith
    simpa only [one_mul] using leveque04_explicitDiffusion_iterate_sub_bound
      timeStep width B (fun _ => diffusivity) before reference htime hwidth
      (fun _ => hpositive.le) hcfl hbound n i

/-- A uniformly bounded one-step operator already bounds the ratio at every
nondegenerate face. This keeps the variable-coefficient source scope explicit. -/
theorem leveque04_explicitDiffusion_faceRatio_bound
    (horizon bound timeStep width : ℝ) (diffusivity : ℤ → ℝ)
    (hwidth : 0 < width) (hstep : timeStep ≤ horizon)
    (hstable : IsExplicitDiffusionStableThrough horizon bound timeStep width diffusivity) :
    |timeStep / width ^ 2 * diffusivity 0| ≤ bound := by
  let impulse : ℤ → ℝ := fun j => if j = -1 then 1 else 0
  have hb : ∀ i, |impulse i - (0 : ℝ)| ≤ 1 := by
    intro i
    dsimp only [impulse]
    split_ifs <;> norm_num
  have h := hstable impulse (fun _ => 0) 1 (by norm_num) hb
    1 (by simpa using hstep) 0
  simp only [Function.iterate_one, leveque04_explicitDiffusionStep_zero,
    sub_zero, mul_one] at h
  rw [leveque04_equation11 timeStep width diffusivity impulse 0 hwidth] at h
  simpa [impulse] using h

/-- The source's quadratic refinement necessity uses the weaker uniform
fixed-physical-time stability notion. It does not assume power stability of
each fixed mesh or infer the sharp `1/2` threshold from that weaker premise. -/
theorem leveque04_explicitDiffusion_constant_refinement_necessary
    (horizon bound diffusivity : ℝ) (timeStep width : ℕ → ℝ) (start : ℕ)
    (hhorizon : 0 < horizon) (_hbound : 0 ≤ bound) (hpositive : 0 < diffusivity)
    (hwidth : ∀ j, 0 < width j)
    (htime : Filter.Tendsto timeStep Filter.atTop (nhds 0))
    (hstable : ∀ j ≥ start, IsExplicitDiffusionStableThrough horizon bound
      (timeStep j) (width j) (fun _ => diffusivity)) :
    ∃ cutoff : ℕ, ∀ j ≥ cutoff,
      timeStep j ≤ ((bound + 1) / (4 * diffusivity)) * width j ^ 2 := by
  obtain ⟨cutoff, hc⟩ := Filter.eventually_atTop.mp (htime.eventually (Iio_mem_nhds hhorizon))
  refine ⟨max cutoff start, ?_⟩
  intro j hj
  have hratio := leveque04_explicitDiffusion_constantRatio_bound
    horizon bound (timeStep j) (width j) diffusivity (hwidth j)
    (hc j (le_trans (le_max_left _ _) hj)).le
    (hstable j (le_trans (le_max_right _ _) hj))
  have hmul := (div_le_iff₀ (sq_pos_of_pos (hwidth j))).mp hratio
  rw [div_mul_eq_mul_div]
  apply (le_div_iff₀ (by positivity : 0 < 4 * diffusivity)).mpr
  nlinarith

/-- The same quadratic necessity for variable interfaces needs only one
uniformly positive face, not a global upper/lower conductivity or derivative
bound. A fixed positive coefficient sampled at the origin is included. -/
theorem leveque04_explicitDiffusion_variable_refinement_necessary
    (horizon bound lower : ℝ) (timeStep width : ℕ → ℝ)
    (diffusivity : ℕ → ℤ → ℝ) (start : ℕ)
    (hhorizon : 0 < horizon) (_hbound : 0 ≤ bound) (hlower : 0 < lower)
    (hwidth : ∀ j, 0 < width j) (hnonnegtime : ∀ j, 0 ≤ timeStep j)
    (hface : ∀ j ≥ start, lower ≤ diffusivity j 0)
    (htime : Filter.Tendsto timeStep Filter.atTop (nhds 0))
    (hstable : ∀ j ≥ start, IsExplicitDiffusionStableThrough horizon bound
      (timeStep j) (width j) (diffusivity j)) :
    ∃ cutoff : ℕ, ∀ j ≥ cutoff,
      timeStep j ≤ ((bound + 1) / lower) * width j ^ 2 := by
  obtain ⟨cutoff, hc⟩ := Filter.eventually_atTop.mp (htime.eventually (Iio_mem_nhds hhorizon))
  refine ⟨max cutoff start, ?_⟩
  intro j hj
  have hjs : start ≤ j := le_trans (le_max_right _ _) hj
  have hratio := leveque04_explicitDiffusion_faceRatio_bound
    horizon bound (timeStep j) (width j) (diffusivity j) (hwidth j)
    (hc j (le_trans (le_max_left _ _) hj)).le (hstable j hjs)
  have hb : timeStep j / width j ^ 2 * lower ≤ bound := by
    calc
      _ ≤ timeStep j / width j ^ 2 * diffusivity j 0 :=
        mul_le_mul_of_nonneg_left (hface j hjs)
          (div_nonneg (hnonnegtime j) (sq_nonneg _))
      _ ≤ |timeStep j / width j ^ 2 * diffusivity j 0| := le_abs_self _
      _ ≤ bound := hratio
  have hm : timeStep j * lower ≤ bound * width j ^ 2 := by
    have hb' : timeStep j * lower / width j ^ 2 ≤ bound := by
      simpa only [div_mul_eq_mul_div] using hb
    exact (div_le_iff₀ (sq_pos_of_pos (hwidth j))).mp hb'
  rw [div_mul_eq_mul_div]
  apply (le_div_iff₀ hlower).mpr
  nlinarith [sq_nonneg (width j)]

/-- Vanishing physical conductivity gives the identity, so no quadratic
time-step necessity is asserted for the degenerate zero-diffusion equation. -/
theorem leveque04_explicitDiffusion_zeroDiffusivity
    (timeStep width : ℝ) (hwidth : 0 < width) :
    leveque04_explicitDiffusionStep timeStep width (fun _ => 0) =
      (id : (ℤ → ℝ) → ℤ → ℝ) := by
  funext before i
  rw [leveque04_equation12 timeStep width 0 before i hwidth]
  simp

end NumStability
