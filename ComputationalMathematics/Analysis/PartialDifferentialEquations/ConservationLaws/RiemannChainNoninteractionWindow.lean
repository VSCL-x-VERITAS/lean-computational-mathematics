/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RiemannChainUniformWindow
import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.FiniteRiemannChainAffineFronts
import Mathlib.Order.Monotone.Basic

/-!
# Finite windows strictly before wave interaction

Adjacent noninteraction of affine fronts at a comparison horizon forces
constant exterior tails uniformly on each compact box strictly before that
horizon. No global bound on propagation speeds is required.
-/

namespace NumStability

theorem affine_front_upper_bound_on_early_interval (a speed finalBound horizon step time : ℝ)
    (hfinal : a + speed * horizon ≤ finalBound) (hstart : a ≤ finalBound)
    (htime : time ∈ Set.Icc 0 step) :
    horizon * (a + speed * time) ≤ (horizon - step) * a + step * finalBound := by
  have h1 := mul_le_mul_of_nonneg_left hfinal htime.1
  have h2 := mul_le_mul_of_nonneg_right htime.2 (sub_nonneg.mpr hstart)
  nlinarith

theorem affine_front_lower_bound_on_early_interval (a speed finalBound horizon step time : ℝ)
    (hfinal : finalBound ≤ a + speed * horizon) (hstart : finalBound ≤ a)
    (htime : time ∈ Set.Icc 0 step) :
    (horizon - step) * a + step * finalBound ≤ horizon * (a + speed * time) := by
  have h := affine_front_upper_bound_on_early_interval (-a) (-speed) (-finalBound)
    horizon step time (by nlinarith) (by linarith) htime
  nlinarith

theorem integer_affine_fronts_uniform_exterior_of_noninteraction
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step left right : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon) :
    ∃ radius : ℕ,
      (∀ j : ℤ, j < -(radius : ℤ) → ∀ time ∈ Set.Icc 0 step,
        origin + (j : ℝ) * width + rightSpeed j * time < left) ∧
      (∀ j : ℤ, (radius : ℤ) ≤ j → ∀ time ∈ Set.Icc 0 step,
        right < origin + (j : ℝ) * width + leftSpeed j * time) := by
  have hH : 0 < horizon := hstep.trans_lt hbefore
  have hC : 0 < horizon - step := sub_pos.mpr hbefore
  let finalLeft := origin + leftSpeed 0 * horizon
  let finalRight := origin + rightSpeed 0 * horizon
  have hinterval (j : ℤ) : origin + (j : ℝ) * width + leftSpeed j * horizon ≤
      origin + (j : ℝ) * width + rightSpeed j * horizon := by
    have := mul_le_mul_of_nonneg_right (hspeeds j) hH.le
    linarith
  have hmonoLeft : Monotone (fun j : ℤ => origin + (j : ℝ) * width + leftSpeed j * horizon) :=
    monotone_int_of_le_succ (fun j => (hinterval j).trans (hinteraction j))
  have hmonoRight : Monotone (fun j : ℤ => origin + (j : ℝ) * width + rightSpeed j * horizon) :=
    monotone_int_of_le_succ (fun j => (hinteraction j).trans (hinterval (j + 1)))
  obtain ⟨centerRadius, hcenter⟩ := exists_nat_gt ((|origin - finalRight| + |origin - finalLeft|) / width)
  have hcenter' := (div_lt_iff₀ hwidth).mp hcenter
  obtain ⟨boxRadius, hbox⟩ := exists_nat_gt
    ((|(horizon - step) * origin + step * finalRight - horizon * left| +
      |horizon * right - ((horizon - step) * origin + step * finalLeft)|) /
        ((horizon - step) * width))
  have hbox' := (div_lt_iff₀ (mul_pos hC hwidth)).mp hbox
  let radius := max centerRadius boxRadius
  have hcenterLe : centerRadius ≤ radius := Nat.le_max_left _ _
  have hboxLe : boxRadius ≤ radius := Nat.le_max_right _ _
  have hcenterReal : (centerRadius : ℝ) ≤ (radius : ℝ) := by exact_mod_cast hcenterLe
  have hboxReal : (boxRadius : ℝ) ≤ (radius : ℝ) := by exact_mod_cast hboxLe
  have hcenterR := mul_le_mul_of_nonneg_right hcenterReal hwidth.le
  have hboxR := mul_le_mul_of_nonneg_right hboxReal (mul_pos hC hwidth).le
  refine ⟨radius, ?_, ?_⟩
  · intro j hj time ht
    have hj0 : j ≤ 0 := by omega
    have hfinal := hmonoRight hj0
    simp only [Int.cast_zero, zero_mul, add_zero] at hfinal
    have hjReal : (j : ℝ) < -(radius : ℝ) := by exact_mod_cast hj
    have hjw := mul_lt_mul_of_pos_right hjReal hwidth
    have hstart : origin + (j : ℝ) * width ≤ finalRight := by
      nlinarith [le_abs_self (origin - finalRight), abs_nonneg (origin - finalLeft)]
    have hfront := affine_front_upper_bound_on_early_interval
      (origin + (j : ℝ) * width) (rightSpeed j) finalRight horizon step time hfinal hstart ht
    have hjC := mul_lt_mul_of_pos_left hjw hC
    have habs := le_abs_self ((horizon - step) * origin + step * finalRight - horizon * left)
    have hnonneg := abs_nonneg (horizon * right - ((horizon - step) * origin + step * finalLeft))
    nlinarith

  · intro j hj time ht
    have hj0 : 0 ≤ j := by omega
    have hfinal := hmonoLeft hj0
    simp only [Int.cast_zero, zero_mul, add_zero] at hfinal
    have hjReal : (radius : ℝ) ≤ (j : ℝ) := by exact_mod_cast hj
    have hjw := mul_le_mul_of_nonneg_right hjReal hwidth.le
    have hstart : finalLeft ≤ origin + (j : ℝ) * width := by
      nlinarith [neg_le_abs (origin - finalLeft), abs_nonneg (origin - finalRight)]
    have hfront := affine_front_lower_bound_on_early_interval
      (origin + (j : ℝ) * width) (leftSpeed j) finalLeft horizon step time hfinal hstart ht
    have hjC := mul_le_mul_of_nonneg_left hjw hC.le
    have habs := le_abs_self (horizon * right - ((horizon - step) * origin + step * finalLeft))
    have hnonneg := abs_nonneg ((horizon - step) * origin + step * finalRight - horizon * left)
    nlinarith


theorem riemannChainWindow_exists_of_noninteraction
    {E : Type*} (states : ℤ → E) (fields : ℤ → ℝ → ℝ → E)
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon step left right : ℝ)
    (hwidth : 0 < width) (hstep : 0 ≤ step) (hbefore : step < horizon)
    (hspeeds : ∀ j, leftSpeed j ≤ rightSpeed j)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      x < origin + (j : ℝ) * width + leftSpeed j * time → fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 horizon →
      origin + (j : ℝ) * width + rightSpeed j * time < x → fields j x time = states (j + 1)) :
    ∃ radius : ℕ, ∀ x ∈ Set.Icc left right, ∀ time ∈ Set.Icc 0 step,
      IsRiemannChainWindow states (fun j => fields j x time) radius := by
  obtain ⟨radius, hrightExterior, hleftExterior⟩ :=
    integer_affine_fronts_uniform_exterior_of_noninteraction leftSpeed rightSpeed
      origin width horizon step left right hwidth hstep hbefore hspeeds hinteraction
  refine ⟨radius, ?_⟩
  intro x hx time ht
  have ht' : time ∈ Set.Icc 0 horizon := ⟨ht.1, ht.2.trans hbefore.le⟩
  exact ⟨fun j hj => hright j x time ht' ((hrightExterior j hj time ht).trans_le hx.1),
    fun j hj => hleft j x time ht' (hx.2.trans_lt (hleftExterior j hj time ht))⟩

theorem integer_affine_fronts_noninteraction_before_horizon
    (leftSpeed rightSpeed : ℤ → ℝ) (origin width horizon time : ℝ)
    (hwidth : 0 < width) (htime : time ∈ Set.Ico 0 horizon)
    (hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + rightSpeed j * horizon ≤
        origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * horizon) :
    ∀ j : ℤ, origin + (j : ℝ) * width + rightSpeed j * time <
      origin + ((j + 1 : ℤ) : ℝ) * width + leftSpeed (j + 1) * time := by
  intro j
  apply affine_front_gap_before_horizon _ _ _ _ horizon time ?_ (hinteraction j) htime
  simp only [Int.cast_add, Int.cast_one]
  linarith

end NumStability