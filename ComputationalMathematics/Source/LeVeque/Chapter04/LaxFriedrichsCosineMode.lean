/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsPeriodicMode
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.PeriodicGridSamples
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Bounds

/-!
# The first discrete cosine mode of a periodic Lax–Friedrichs grid

The sampled cosine is an eigenmode of the zero-flux periodic neighbor
average. The wrapped grid seam is handled by the sequence's full-period
identity.
-/

namespace NumStability

private noncomputable def cosineValues (n : ℕ) (j : ℕ) : ℝ :=
  Real.cos ((2 * Real.pi / (n : ℝ)) * (j : ℝ))

/-- A cosine sequence of frequency one repeats after `n` cells. -/
private theorem cosineValues_periodic
    (n : ℕ) [NeZero n] (j : ℕ) :
    cosineValues n (j + n) = cosineValues n j := by
  have hn : (n : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne n)
  unfold cosineValues
  have harg : (2 * Real.pi / (n : ℝ)) * ((j + n : ℕ) : ℝ) =
      (2 * Real.pi / (n : ℝ)) * (j : ℝ) + 2 * Real.pi := by
    push_cast
    field_simp
  rw [harg, Real.cos_add_two_pi]

/-- The symmetric cosine neighbors average to cosine of the grid
angle times the central value. -/
private theorem cosineValues_neighbor
    (n : ℕ) (j : ℤ) :
    (Real.cos ((2 * Real.pi / (n : ℝ)) * ((j - 1 : ℤ) : ℝ)) +
      Real.cos ((2 * Real.pi / (n : ℝ)) * ((j + 1 : ℤ) : ℝ))) / 2 =
      Real.cos (2 * Real.pi / (n : ℝ)) *
        Real.cos ((2 * Real.pi / (n : ℝ)) * (j : ℝ)) := by
  have hminus : (2 * Real.pi / (n : ℝ)) * ((j - 1 : ℤ) : ℝ) =
      (2 * Real.pi / (n : ℝ)) * (j : ℝ) -
        (2 * Real.pi / (n : ℝ)) := by push_cast; ring
  have hplus : (2 * Real.pi / (n : ℝ)) * ((j + 1 : ℤ) : ℝ) =
      (2 * Real.pi / (n : ℝ)) * (j : ℝ) +
        (2 * Real.pi / (n : ℝ)) := by push_cast; ring
  rw [hminus, hplus, Real.cos_sub, Real.cos_add]
  ring

/-- The first sampled cosine mode on `ZMod n`. -/
noncomputable def leveque04_periodicCosineMode (n : ℕ) : ZMod n → ℝ :=
  periodicGridSample n (cosineValues n)

/-- The sampled cosine written without its internal grid wrapper. -/
theorem leveque04_periodicCosineMode_apply
    (n : ℕ) (i : ZMod n) :
    leveque04_periodicCosineMode n i =
      Real.cos ((2 * Real.pi / (n : ℝ)) * (i.val : ℝ)) := rfl

/-- The sampled cosine is a neighbor-average eigenmode, including the
wrapped neighbors of cell zero and cell `n-1`. -/
theorem leveque04_periodicCosineMode_eigen
    (n : ℕ) [NeZero n] (hn : 2 ≤ n) (i : ZMod n) :
    (leveque04_periodicCosineMode n (i - 1) +
      leveque04_periodicCosineMode n (i + 1)) / 2 =
      Real.cos (2 * Real.pi / (n : ℝ)) *
        leveque04_periodicCosineMode n i := by
  have hr := periodicGridSample_add_one n hn
    (cosineValues n) (cosineValues_periodic n) i
  have hright : leveque04_periodicCosineMode n (i + 1) =
      cosineValues n (i.val + 1) := hr
  by_cases hi : 0 < i.val
  · have hl := periodicGridSample_sub_one_of_pos n hn
      (cosineValues n) i hi
    change (periodicGridSample n (cosineValues n) (i - 1) +
      periodicGridSample n (cosineValues n) (i + 1)) / 2 = _
    rw [hl, hr]
    unfold leveque04_periodicCosineMode periodicGridSample cosineValues
    have hcast : (((i.val - 1 : ℕ) : ℝ)) =
        (((i.val : ℕ) : ℤ) - 1 : ℤ) := by
      have hi1 : 1 ≤ i.val := hi
      simp [Nat.cast_sub hi1]
    rw [hcast]
    have hcast' : (((i.val + 1 : ℕ) : ℝ)) =
        (((i.val : ℕ) : ℤ) + 1 : ℤ) := by norm_cast
    rw [hcast']
    exact cosineValues_neighbor n (i.val : ℤ)
  · have hzero : i.val = 0 := by omega
    have hl := periodicGridSample_sub_one_of_zero n hn
      (cosineValues n) i hzero
    change (periodicGridSample n (cosineValues n) (i - 1) +
      periodicGridSample n (cosineValues n) (i + 1)) / 2 = _
    rw [hl, hr]
    have hnpos : (n : ℝ) ≠ 0 := by exact_mod_cast (NeZero.ne n)
    have hnm1 : ((n - 1 : ℕ) : ℝ) = (n : ℝ) - 1 := by
      have : 1 ≤ n := by omega
      simp [Nat.cast_sub this]
    have hangle : (2 * Real.pi / (n : ℝ)) * ((n - 1 : ℕ) : ℝ) =
        2 * Real.pi - 2 * Real.pi / (n : ℝ) := by
      rw [hnm1]
      field_simp
    simp only [leveque04_periodicCosineMode, periodicGridSample,
      cosineValues, hzero, Nat.cast_zero, mul_zero, Real.cos_zero]
    rw [hangle, Real.cos_two_pi_sub]
    have h1 : ((0 + 1 : ℕ) : ℝ) = 1 := by norm_num
    rw [h1, mul_one]
    ring

/-- The exact amplitude of the first discrete cosine mode after any
number of zero-flux Lax–Friedrichs steps. -/
theorem leveque04_periodicCosineMode_iterate
    (n : ℕ) [NeZero n] (hn : 2 ≤ n)
    (ratio : ℝ) (steps : ℕ) :
    ((leveque04_periodicNonlinearLaxFriedrichsStep n
      (fun _ => 0) ratio)^[steps]
        (leveque04_periodicCosineMode n)) =
      fun i => Real.cos (2 * Real.pi / (n : ℝ)) ^ steps *
        leveque04_periodicCosineMode n i :=
  leveque04_periodicLaxFriedrichs_zeroFlux_mode_iterate
    n ratio (Real.cos (2 * Real.pi / (n : ℝ)))
    (leveque04_periodicCosineMode n)
    (leveque04_periodicCosineMode_eigen n hn) steps

/-- Every positive number of zero-flux Lax–Friedrichs steps changes the
first cosine mode at cell zero on grids with at least five cells. -/
theorem leveque04_periodicCosineMode_error_ne_zero
    (n : ℕ) [NeZero n] (hn : 5 ≤ n)
    (ratio : ℝ) (steps : ℕ) (hsteps : 0 < steps) :
    ((leveque04_periodicNonlinearLaxFriedrichsStep n
      (fun _ => 0) ratio)^[steps]
        (leveque04_periodicCosineMode n)) 0 -
          leveque04_periodicCosineMode n 0 ≠ 0 := by
  have hnreal : (5 : ℝ) ≤ n := by exact_mod_cast hn
  have hnpos : (0 : ℝ) < n := by linarith
  have hanglePos : 0 < 2 * Real.pi / (n : ℝ) := by positivity
  have hangleHalf : 2 * Real.pi / (n : ℝ) < Real.pi / 2 := by
    apply (div_lt_iff₀ hnpos).2
    nlinarith [Real.pi_pos]
  have hcosPos : 0 ≤ Real.cos (2 * Real.pi / (n : ℝ)) := by
    exact (Real.cos_pos_of_mem_Ioo ⟨by linarith [Real.pi_pos], hangleHalf⟩).le
  have hcosLt : Real.cos (2 * Real.pi / (n : ℝ)) < 1 := by
    simpa only [Real.cos_zero] using
      Real.cos_lt_cos_of_nonneg_of_le_pi (by norm_num : (0 : ℝ) ≤ 0)
        (by linarith [Real.pi_pos] : 2 * Real.pi / (n : ℝ) ≤ Real.pi)
        hanglePos
  have hpow : Real.cos (2 * Real.pi / (n : ℝ)) ^ steps < 1 :=
    pow_lt_one₀ hcosPos hcosLt (Nat.ne_of_gt hsteps)
  rw [leveque04_periodicCosineMode_iterate n (by omega) ratio steps]
  have hzero : leveque04_periodicCosineMode n (0 : ZMod n) = 1 := by
    simp [leveque04_periodicCosineMode, periodicGridSample,
      cosineValues]
  simp only [hzero, mul_one]
  exact sub_ne_zero.mpr (ne_of_lt hpow)

/-- The damping of the first cosine mode in one step is bounded below
quadratically in the grid width `1/n`. -/
theorem leveque04_periodicCosineMode_oneStep_damping_lower
    (n : ℕ) [NeZero n] (hn : 2 ≤ n) :
    8 / (n : ℝ) ^ 2 ≤
      1 - Real.cos (2 * Real.pi / (n : ℝ)) := by
  have hnreal : (2 : ℝ) ≤ n := by exact_mod_cast hn
  have hnpos : (0 : ℝ) < n := by linarith
  have hanglePos : 0 < 2 * Real.pi / (n : ℝ) := by positivity
  have hangleLe : 2 * Real.pi / (n : ℝ) ≤ Real.pi := by
    apply (div_le_iff₀ hnpos).2
    nlinarith [Real.pi_pos]
  have habs : |2 * Real.pi / (n : ℝ)| ≤ Real.pi := by
    rw [abs_of_pos hanglePos]
    exact hangleLe
  have hcos := Real.cos_le_one_sub_mul_cos_sq habs
  have hsq : 2 / Real.pi ^ 2 * (2 * Real.pi / (n : ℝ)) ^ 2 =
      8 / (n : ℝ) ^ 2 := by
    have hpi : Real.pi ≠ 0 := ne_of_gt Real.pi_pos
    field_simp
    ring
  linarith [hcos, hsq]

/-- A nonnegative contraction factor loses at least a rational fraction
of its accumulated one-step deficit. -/
private theorem power_damping_lower
    (factor : ℝ) (steps : ℕ)
    (h0 : 0 ≤ factor) (h1 : factor ≤ 1) :
    (steps : ℝ) * (1 - factor) /
        (1 + (steps : ℝ) * (1 - factor)) ≤
      1 - factor ^ steps := by
  let δ : ℝ := 1 - factor
  have hδ : 0 ≤ δ := by dsimp [δ]; linarith
  have hprod : factor * (1 + δ) ≤ 1 := by
    dsimp [δ]
    nlinarith [sq_nonneg (factor - 1)]
  have hpow : (factor * (1 + δ)) ^ steps ≤ 1 := by
    exact (pow_le_pow_left₀ (by positivity) hprod steps).trans (by simp)
  have hbern : 1 + (steps : ℝ) * δ ≤ (1 + δ) ^ steps := by
    exact one_add_mul_le_pow (by linarith [hδ] : (-2 : ℝ) ≤ δ) steps
  have hscaled : factor ^ steps * (1 + (steps : ℝ) * δ) ≤ 1 := by
    calc
      _ ≤ factor ^ steps * (1 + δ) ^ steps :=
        mul_le_mul_of_nonneg_left hbern (pow_nonneg h0 _)
      _ = (factor * (1 + δ)) ^ steps := by rw [mul_pow]
      _ ≤ 1 := hpow
  have hden : 0 < 1 + (steps : ℝ) * δ := by positivity
  apply (div_le_iff₀ hden).2
  dsimp [δ] at *
  nlinarith [hscaled]

/-- After `n` zero-flux steps, the first cosine mode loses at least a
fixed positive multiple of the mesh width `1/n`. -/
theorem leveque04_periodicCosineMode_fixedHorizon_damping_lower
    (n : ℕ) [NeZero n] (hn : 5 ≤ n) :
    8 / ((n : ℝ) * (1 + Real.pi ^ 2)) ≤
      1 - Real.cos (2 * Real.pi / (n : ℝ)) ^ n := by
  let z : ℝ := Real.cos (2 * Real.pi / (n : ℝ))
  let δ : ℝ := 1 - z
  have hnreal : (5 : ℝ) ≤ n := by exact_mod_cast hn
  have hnpos : (0 : ℝ) < n := by linarith
  have hnzero : (n : ℝ) ≠ 0 := ne_of_gt hnpos
  have hanglePos : 0 < 2 * Real.pi / (n : ℝ) := by positivity
  have hangleHalf : 2 * Real.pi / (n : ℝ) < Real.pi / 2 := by
    apply (div_lt_iff₀ hnpos).2
    nlinarith [Real.pi_pos]
  have hz0 : 0 ≤ z := by
    dsimp [z]
    exact (Real.cos_pos_of_mem_Ioo ⟨by linarith [Real.pi_pos], hangleHalf⟩).le
  have hz1 : z ≤ 1 := Real.cos_le_one _
  have hδ0 : 0 ≤ δ := by dsimp [δ]; linarith
  have hδlo : 8 / (n : ℝ) ^ 2 ≤ δ := by
    exact leveque04_periodicCosineMode_oneStep_damping_lower n (by omega)
  have hδhi : δ ≤ 2 * Real.pi ^ 2 / (n : ℝ) ^ 2 := by
    have h := Real.one_sub_sq_div_two_le_cos
      (x := 2 * Real.pi / (n : ℝ))
    have hsq : (2 * Real.pi / (n : ℝ)) ^ 2 / 2 =
        2 * Real.pi ^ 2 / (n : ℝ) ^ 2 := by
      field_simp
    dsimp [δ, z]
    linarith [h, hsq]
  have hnum : 8 / (n : ℝ) ≤ (n : ℝ) * δ := by
    have hmul := mul_le_mul_of_nonneg_left hδlo hnpos.le
    have heq : (n : ℝ) * (8 / (n : ℝ) ^ 2) =
        8 / (n : ℝ) := by field_simp
    linarith [hmul]
  have hden : (n : ℝ) * δ ≤ Real.pi ^ 2 := by
    have hmul := mul_le_mul_of_nonneg_left hδhi hnpos.le
    have heq : (n : ℝ) *
        (2 * Real.pi ^ 2 / (n : ℝ) ^ 2) =
        2 * Real.pi ^ 2 / (n : ℝ) := by field_simp
    have hlast : 2 * Real.pi ^ 2 / (n : ℝ) ≤ Real.pi ^ 2 := by
      apply (div_le_iff₀ hnpos).2
      nlinarith [sq_nonneg Real.pi]
    linarith [hmul]
  have hdenPos : 0 < 1 + (n : ℝ) * δ := by positivity
  have hpiDenPos : 0 < 1 + Real.pi ^ 2 := by positivity
  have hfrac : (8 / (n : ℝ)) / (1 + Real.pi ^ 2) ≤
      (n : ℝ) * δ / (1 + (n : ℝ) * δ) := by
    calc
      _ ≤ ((n : ℝ) * δ) / (1 + Real.pi ^ 2) :=
        div_le_div_of_nonneg_right hnum hpiDenPos.le
      _ ≤ ((n : ℝ) * δ) / (1 + (n : ℝ) * δ) :=
        div_le_div_of_nonneg_left (by positivity) hdenPos (by linarith)
  have hpow := power_damping_lower z n hz0 hz1
  dsimp [z, δ] at *
  calc
    _ = (8 / (n : ℝ)) / (1 + Real.pi ^ 2) := by
      field_simp
    _ ≤ _ := hfrac.trans hpow

/-- At cell zero, the sampled stationary cosine incurs at least a
constant times `1/n` error after `n` zero-flux source-stencil steps. -/
theorem leveque04_periodicCosineMode_fixedHorizon_error_lower
    (n : ℕ) [NeZero n] (hn : 5 ≤ n) (ratio : ℝ) :
    8 / ((n : ℝ) * (1 + Real.pi ^ 2)) ≤
      |((leveque04_periodicNonlinearLaxFriedrichsStep n
        (fun _ => 0) ratio)^[n]
          (leveque04_periodicCosineMode n)) 0 -
            leveque04_periodicCosineMode n 0| := by
  have hbound := leveque04_periodicCosineMode_fixedHorizon_damping_lower n hn
  rw [leveque04_periodicCosineMode_iterate n (by omega) ratio n]
  have hzero : leveque04_periodicCosineMode n (0 : ZMod n) = 1 := by
    simp [leveque04_periodicCosineMode, periodicGridSample,
      cosineValues]
  simp only [hzero, mul_one]
  rw [abs_sub_comm, abs_of_nonneg]
  · exact hbound
  · exact le_trans (by positivity : 0 ≤ 8 / ((n : ℝ) * (1 + Real.pi ^ 2))) hbound

end NumStability
