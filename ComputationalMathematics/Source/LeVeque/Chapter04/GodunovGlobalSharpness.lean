/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovOrderWitness

/-!
# Fixed-horizon sharpness for positive-speed Godunov advection

The actual repeated selected upwind/Godunov step on quadratic cell averages
accumulates a nonzero error proportional to mesh width at fixed physical time.
-/

namespace NumStability

/-- One positive-speed Godunov step translates a quadratic cell-average
profile and adds the Courant-dependent constant defect. -/
theorem leveque04_positiveGodunov_quadraticShift_step
    (speed ratio width offset constant : ℝ) (i : ℤ)
    (hspeed : 0 < speed) (hwidth : 0 < width) :
    leveque04_positiveUpwindStep (ratio * width) width speed
      (fun j => ((j : ℝ) * width - offset) ^ 2 + width ^ 2 / 12 + constant) i =
      ((i : ℝ) * width - offset - speed * (ratio * width)) ^ 2 +
        width ^ 2 / 12 + constant +
          (speed * ratio) * (1 - speed * ratio) * width ^ 2 := by
  rw [leveque04_equation26 (ratio * width) width speed _ i hspeed]
  have hne : width ≠ 0 := ne_of_gt hwidth
  push_cast
  field_simp
  ring

/-- The exact formula for any number of actual repeated Godunov steps
on the initial quadratic cell averages. -/
theorem leveque04_positiveGodunov_quadratic_iterate
    (speed ratio width : ℝ) (steps : ℕ) (i : ℤ)
    (hspeed : 0 < speed) (hwidth : 0 < width) :
    ((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
      (leveque04_quadraticCellAverage width)) i =
      ((i : ℝ) * width - speed * (steps : ℝ) * (ratio * width)) ^ 2 +
        width ^ 2 / 12 +
          (steps : ℝ) * (speed * ratio) * (1 - speed * ratio) * width ^ 2 := by
  induction steps generalizing i with
  | zero => simp [leveque04_quadraticCellAverage]
  | succ steps ih =>
      rw [Function.iterate_succ_apply']
      have hstate :
          ((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
            (leveque04_quadraticCellAverage width)) =
          fun j : ℤ => ((j : ℝ) * width - speed * (steps : ℝ) * (ratio * width)) ^ 2 +
            width ^ 2 / 12 +
              (steps : ℝ) * (speed * ratio) * (1 - speed * ratio) * width ^ 2 := by
        funext j
        exact ih j
      rw [hstate, leveque04_positiveGodunov_quadraticShift_step speed ratio width
        (speed * (steps : ℝ) * (ratio * width))
        ((steps : ℝ) * (speed * ratio) * (1 - speed * ratio) * width ^ 2)
        i hspeed hwidth]
      push_cast
      ring

/-- The accumulated numerical error relative to exact translated
cell averages is `steps * courant * (1 - courant) * width²`. -/
theorem leveque04_positiveGodunov_quadratic_globalExactAverageError
    (speed ratio width : ℝ) (steps : ℕ) (i : ℤ)
    (hspeed : 0 < speed) (hwidth : 0 < width) :
    ((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
      (leveque04_quadraticCellAverage width)) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * (steps : ℝ) * (ratio * width)) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      (steps : ℝ) * (speed * ratio) * (1 - speed * ratio) * width ^ 2 := by
  rw [leveque04_positiveGodunov_quadratic_iterate speed ratio width steps i hspeed hwidth,
    leveque04_translatedQuadraticAverage
      ((i : ℝ) * width) width
      (speed * (steps : ℝ) * (ratio * width)) hwidth]
  ring

/-- At a fixed physical horizon, the exact global error is a positive
multiple of the mesh width for an interior Courant number. -/
theorem leveque04_positiveGodunov_quadratic_fixedHorizonError
    (speed ratio width horizon : ℝ) (steps : ℕ) (i : ℤ)
    (hspeed : 0 < speed) (hwidth : 0 < width)
    (hhorizon : (steps : ℝ) * (ratio * width) = horizon) :
    ((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
      (leveque04_quadraticCellAverage width)) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * horizon) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2) =
      (horizon * speed * (1 - speed * ratio)) * width := by
  have hshift : speed * (steps : ℝ) * (ratio * width) = speed * horizon := by
    rw [← hhorizon]
    ring
  rw [← hshift, leveque04_positiveGodunov_quadratic_globalExactAverageError
    speed ratio width steps i hspeed hwidth]
  rw [← hhorizon]
  ring

/-- The fixed-horizon error divided by width is mesh independent. -/
theorem leveque04_positiveGodunov_quadratic_fixedHorizonRate
    (speed ratio width horizon : ℝ) (steps : ℕ) (i : ℤ)
    (hspeed : 0 < speed) (hwidth : 0 < width)
    (hhorizon : (steps : ℝ) * (ratio * width) = horizon) :
    (((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
      (leveque04_quadraticCellAverage width)) i -
      oneDimensionalCellAverage
        (fun x : ℝ => (x - speed * horizon) ^ 2)
        ((i : ℝ) * width - width / 2)
        ((i : ℝ) * width + width / 2)) / width =
      horizon * speed * (1 - speed * ratio) := by
  rw [leveque04_positiveGodunov_quadratic_fixedHorizonError
    speed ratio width horizon steps i hspeed hwidth hhorizon]
  field_simp

/-- For every proposed quadratic global-error constant, some integer-step
mesh at the prescribed horizon violates that bound. This sharpness
witness is for positive-speed linear advection at an interior CFL number. -/
theorem leveque04_positiveGodunov_quadratic_fixedHorizon_not_secondOrder
    (speed ratio horizon : ℝ)
    (hspeed : 0 < speed) (hratio : 0 < ratio)
    (hhorizon : 0 < horizon) (hcfl : speed * ratio < 1) :
    ∀ C : ℝ, 0 ≤ C →
      ∃ steps : ℕ, ∃ width : ℝ,
        0 < width ∧ (steps : ℝ) * (ratio * width) = horizon ∧
          ∀ i : ℤ, C * width ^ 2 <
            ((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
              (leveque04_quadraticCellAverage width)) i -
              oneDimensionalCellAverage
                (fun x : ℝ => (x - speed * horizon) ^ 2)
                ((i : ℝ) * width - width / 2)
                ((i : ℝ) * width + width / 2) := by
  intro C hC
  let K := horizon * speed * (1 - speed * ratio)
  have hK : 0 < K := mul_pos (mul_pos hhorizon hspeed) (sub_pos.mpr hcfl)
  have hKr : 0 < K * ratio := mul_pos hK hratio
  obtain ⟨n, hn⟩ := exists_nat_gt (C * horizon / (K * ratio))
  let steps := n + 1
  have hsteps : 0 < (steps : ℝ) := by exact_mod_cast Nat.succ_pos n
  have hn' : C * horizon < (n : ℝ) * (K * ratio) := by
    have := (div_lt_iff₀ hKr).mp hn
    nlinarith
  have hden : 0 < (steps : ℝ) * ratio := mul_pos hsteps hratio
  let width := horizon / ((steps : ℝ) * ratio)
  have hwidth : 0 < width := div_pos hhorizon hden
  have htime : (steps : ℝ) * (ratio * width) = horizon := by
    dsimp [width]
    field_simp [hden.ne']
  refine ⟨steps, width, hwidth, htime, ?_⟩
  have hCwidth : C * width < K := by
    have hnum : C * horizon < K * ((steps : ℝ) * ratio) := by
      dsimp [steps] at *
      push_cast at *
      nlinarith [hKr]
    have := (div_lt_iff₀ hden).mpr hnum
    dsimp [width]
    convert this using 1; ring
  intro i
  rw [leveque04_positiveGodunov_quadratic_fixedHorizonError
    speed ratio width horizon steps i hspeed hwidth htime]
  have := mul_lt_mul_of_pos_right hCwidth hwidth
  dsimp [K] at *
  nlinarith

/-- The fixed-horizon quadratic global error violates every proposed
second-order bound on an arbitrarily fine integer-step mesh. This is a
sharp asymptotic witness for positive-speed linear advection at a fixed
interior Courant number. -/
theorem leveque04_positiveGodunov_fixedHorizon_arbitrarilyFine_not_secondOrder
    (speed ratio horizon : ℝ)
    (hspeed : 0 < speed) (hratio : 0 < ratio)
    (hhorizon : 0 < horizon) (hcfl : speed * ratio < 1) :
    ∀ C ε : ℝ, 0 ≤ C → 0 < ε →
      ∃ steps : ℕ, ∃ width : ℝ,
        0 < width ∧ width < ε ∧
          (steps : ℝ) * (ratio * width) = horizon ∧
            ∀ i : ℤ, C * width ^ 2 <
              ((leveque04_positiveUpwindStep (ratio * width) width speed)^[steps]
                (leveque04_quadraticCellAverage width)) i -
                oneDimensionalCellAverage
                  (fun x : ℝ => (x - speed * horizon) ^ 2)
                  ((i : ℝ) * width - width / 2)
                  ((i : ℝ) * width + width / 2) := by
  intro C ε hC hε
  let K := horizon * speed * (1 - speed * ratio)
  have hK : 0 < K := mul_pos (mul_pos hhorizon hspeed) (sub_pos.mpr hcfl)
  let C' := C + K / ε
  have hC' : 0 ≤ C' := add_nonneg hC (div_nonneg hK.le hε.le)
  obtain ⟨steps, width, hwidth, htime, herror⟩ :=
    leveque04_positiveGodunov_quadratic_fixedHorizon_not_secondOrder
      speed ratio horizon hspeed hratio hhorizon hcfl C' hC'
  have hfactor : C' * width < K := by
    have hraw := herror 0
    rw [leveque04_positiveGodunov_quadratic_fixedHorizonError
      speed ratio width horizon steps 0 hspeed hwidth htime] at hraw
    have hmul : (C' * width) * width < K * width := by
      dsimp [K] at *
      nlinarith
    exact lt_of_mul_lt_mul_right hmul hwidth.le
  have hsmall : width < ε := by
    have hbound : (K / ε) * width < K := by
      dsimp [C'] at hfactor
      nlinarith [mul_nonneg hC hwidth.le]
    have hbound' : K * width < K * ε := by
      have hrewrite : K / ε * width = K * width / ε := by ring
      rw [hrewrite] at hbound
      have := (div_lt_iff₀ hε).mp hbound
      simpa only [mul_comm] using this
    exact lt_of_mul_lt_mul_left hbound' hK.le
  refine ⟨steps, width, hwidth, hsmall, htime, ?_⟩
  intro i
  have hraw := herror i
  have hCdiff : C * width ^ 2 ≤ C' * width ^ 2 := by
    apply mul_le_mul_of_nonneg_right
    · dsimp [C']
      exact le_add_of_nonneg_right (div_nonneg hK.le hε.le)
    · positivity
  exact lt_of_le_of_lt hCdiff hraw

end NumStability
