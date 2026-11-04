/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.BurgersFiniteActionForwardGradient
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.PotentialWeakCurl
import Mathlib.Analysis.SpecificLimits.Basic

/-!
# Compact C1 curl identity for the actual all-finite action potential

Separate spatial and temporal Lipschitz bounds give joint Lipschitz regularity.
The actual spacetime difference-quotient limits then instantiate the analytic
weak curl theorem. In the auxiliary past extension the flux is zero; positive
times use the physical Burgers flux of the same evolution. Extracting the
forward initial boundary term is a separate subsequent integration step.
-/

noncomputable section
open Set MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability

theorem leveque04_burgersFiniteActionForwardPotential_joint_lipschitz {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width) :
    LipschitzWith ⟨leveque04_burgersPrimitiveBound old + leveque04_burgersPrimitiveBound old ^ 2,
      add_nonneg (leveque04_burgersPrimitiveBound_nonneg old) (sq_nonneg _)⟩
      (fun z : ℝ × ℝ => leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2) := by
  apply LipschitzWith.of_dist_le_mul
  intro z y
  let K := leveque04_burgersPrimitiveBound old
  have hK : 0 ≤ K := leveque04_burgersPrimitiveBound_nonneg old
  have hdx : dist z.1 y.1 ≤ dist z y := le_max_left _ _
  have hdt : dist z.2 y.2 ≤ dist z y := le_max_right _ _
  change dist _ _ ≤ (K + K ^ 2) * dist z y
  calc
    _ ≤ dist (leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2)
        (leveque04_burgersFiniteActionForwardPotential old origin width y.1 z.2) +
        dist (leveque04_burgersFiniteActionForwardPotential old origin width y.1 z.2)
          (leveque04_burgersFiniteActionForwardPotential old origin width y.1 y.2) := dist_triangle _ _ _
    _ ≤ K * dist z.1 y.1 + K ^ 2 * dist z.2 y.2 := add_le_add
      ((leveque04_burgersFiniteActionForwardPotential_spatial_lipschitz old origin width z.2 hwidth).dist_le_mul _ _)
      ((leveque04_burgersFiniteActionForwardPotential_time_lipschitz old origin width y.1 hwidth).dist_le_mul _ _)
    _ ≤ K * dist z y + K ^ 2 * dist z y := add_le_add
      (mul_le_mul_of_nonneg_left hdx hK) (mul_le_mul_of_nonneg_left hdt (sq_nonneg K))
    _ = _ := (add_mul _ _ _).symm

/-- Actual compact C1 whole-plane identity with zero flux in the constant
past extension and the SAME physical Burgers flux at every positive time. -/
theorem leveque04_burgersFiniteActionEvolution_weakPotential_spacetime {N : ℕ}
    (old : Fin (N + 2) → ℝ) (origin width : ℝ) (hwidth : 0 ≤ width)
    (test : ℝ × ℝ → ℝ) (htest : ContDiff ℝ 1 test) (hsupport : HasCompactSupport test) :
    Integrable (fun z : ℝ × ℝ =>
      leveque04_burgersFiniteActionEvolution old origin width z.1 z.2 * fderiv ℝ test z (0, 1) +
        (if 0 < z.2 then
          (leveque04_burgersFiniteActionEvolution old origin width z.1 z.2 ^ 2 / 2) *
            fderiv ℝ test z (1, 0) else 0)) ∧
    (∫ z : ℝ × ℝ,
      leveque04_burgersFiniteActionEvolution old origin width z.1 z.2 * fderiv ℝ test z (0, 1) +
        (if 0 < z.2 then
          (leveque04_burgersFiniteActionEvolution old origin width z.1 z.2 ^ 2 / 2) *
            fderiv ℝ test z (1, 0) else 0)) = 0 := by
  let K := leveque04_burgersPrimitiveBound old
  have hK : 0 ≤ K := leveque04_burgersPrimitiveBound_nonneg old
  let P : ℝ × ℝ → ℝ := fun z => leveque04_burgersFiniteActionForwardPotential old origin width z.1 z.2
  let A : ℝ × ℝ → ℝ := fun z => leveque04_burgersFiniteActionEvolution old origin width z.1 z.2
  let B : ℝ × ℝ → ℝ := fun z => if 0 < z.2 then -(A z) ^ 2 / 2 else 0
  let L : ℝ≥0 := ⟨K + K ^ 2, add_nonneg hK (sq_nonneg K)⟩
  have hA : Measurable A := leveque04_burgersFiniteActionEvolution_joint_measurable old origin width
  have hB : Measurable B := Measurable.ite (measurableSet_lt measurable_const measurable_snd)
    ((hA.pow_const 2).neg.div measurable_const) measurable_const
  have hAbound (z : ℝ × ℝ) : |A z| ≤ L := by
    have hb := leveque04_burgersFiniteActionEvolution_abs_le old origin width z.1 z.2 hwidth
    change |A z| ≤ K + K ^ 2
    linarith [sq_nonneg K]
  have hBbound (z : ℝ × ℝ) : |B z| ≤ L := by
    have hb : |A z| ≤ K := leveque04_burgersFiniteActionEvolution_abs_le old origin width z.1 z.2 hwidth
    have hb2 : A z ^ 2 ≤ K ^ 2 := by
      have hs := mul_self_le_mul_self (abs_nonneg (A z)) hb
      simpa only [← pow_two, sq_abs] using hs
    change |if 0 < z.2 then -(A z) ^ 2 / 2 else 0| ≤ K + K ^ 2
    split_ifs
    · rw [abs_div, abs_neg, abs_of_nonneg (sq_nonneg _)]
      norm_num
      nlinarith [sq_nonneg K]
    · simp only [abs_zero]
      positivity
  let step : ℕ → ℝ := fun n => 1 / ((n : ℝ) + 1)
  have hpos (n : ℕ) : 0 < step n := by dsimp [step]; positivity
  have hle (n : ℕ) : step n ≤ 1 := by
    dsimp [step]
    apply (div_le_iff₀ (by positivity : 0 < (n : ℝ) + 1)).2
    nlinarith [Nat.cast_nonneg (α := ℝ) n]
  have hzero : Tendsto step atTop (𝓝 (0 : ℝ)) := tendsto_one_div_add_atTop_nhds_zero_nat
  have hstep : Tendsto step atTop (𝓝[>] (0 : ℝ)) :=
    tendsto_nhdsWithin_iff.mpr ⟨hzero, Eventually.of_forall hpos⟩
  have hnegative : Tendsto (fun n => -step n) atTop (𝓝[<] (0 : ℝ)) := by
    apply tendsto_nhdsWithin_iff.mpr
    exact ⟨by simpa only [neg_zero] using hzero.neg, Eventually.of_forall (fun n => neg_neg_of_pos (hpos n))⟩
  have hDA := leveque04_burgersFiniteActionForwardPotential_spatial_ae_differenceQuotient
    old origin width hwidth (fun n => -step n) hnegative
  have hDB := leveque04_burgersFiniteActionForwardPotential_temporal_ae_differenceQuotient
    old origin width hwidth (fun n => -step n) hnegative
  have hv : ‖((1 : ℝ), (0 : ℝ))‖ ≤ 1 := by simp
  have hw : ‖((0 : ℝ), (1 : ℝ))‖ ≤ 1 := by simp
  have hcurl := lipschitzPotential_compactTest_weakCurl P A B L
    (leveque04_burgersFiniteActionForwardPotential_joint_lipschitz old origin width hwidth)
    hA hB hAbound hBbound (1, 0) (0, 1) hv hw step hpos hle hstep
    (by simpa [Prod.smul_mk, smul_eq_mul, P, A] using hDA)
    (by simpa [Prod.smul_mk, smul_eq_mul, P, B, A] using hDB)
    test htest hsupport
  have hfun : (fun z : ℝ × ℝ =>
      leveque04_burgersFiniteActionEvolution old origin width z.1 z.2 * fderiv ℝ test z (0, 1) +
        (if 0 < z.2 then (leveque04_burgersFiniteActionEvolution old origin width z.1 z.2 ^ 2 / 2) *
          fderiv ℝ test z (1, 0) else 0)) =
      (fun z => A z * fderiv ℝ test z (0, 1) - B z * fderiv ℝ test z (1, 0)) := by
    funext z
    dsimp [A, B]
    split_ifs <;> ring
  rw [hfun]
  refine ⟨hcurl.1.sub hcurl.2.1, ?_⟩
  rw [integral_sub hcurl.1 hcurl.2.1, hcurl.2.2, sub_self]

end NumStability
