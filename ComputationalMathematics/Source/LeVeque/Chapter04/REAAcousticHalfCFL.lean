/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AcousticFluxMatrices
import ComputationalMathematics.Source.LeVeque.Chapter04.REABoundedBilateralEvolution
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4: the acoustic half-cell noninteraction condition

The two stationary-background acoustic waves travel at speeds `-c` and `c`.
The printed condition (4.36) is exactly the adjacent-front ordering condition,
including contact at equality.
-/

namespace NumStability

/-- For stationary linear acoustics, the printed half-cell CFL condition is
equivalent to nonintersection of neighboring extreme wave fronts at the
specified time, including the endpoint equality case. -/
theorem leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
    (soundSpeed width time origin : ℝ)
    (_hsound : 0 ≤ soundSpeed) (hwidth : 0 < width) (_htime : 0 ≤ time) :
    soundSpeed * time / width ≤ 1 / 2 ↔
      ∀ j : ℤ,
        origin + (j : ℝ) * width +
            leveque04_acousticSpeeds 0 soundSpeed 1 * time ≤
          origin + ((j + 1 : ℤ) : ℝ) * width +
            leveque04_acousticSpeeds 0 soundSpeed 0 * time := by
  constructor
  · intro hcfl j
    have hproduct : 2 * soundSpeed * time ≤ width := by
      have h := (div_le_iff₀ hwidth).mp hcfl
      nlinarith
    simp only [leveque04_acousticSpeeds, Matrix.cons_val_one,
      Matrix.cons_val_zero, zero_add, zero_sub]
    push_cast
    nlinarith
  · intro hfront
    have h := hfront 0
    simp only [leveque04_acousticSpeeds, Matrix.cons_val_one,
      Matrix.cons_val_zero, zero_add, zero_sub] at h
    norm_num at h
    apply (div_le_iff₀ hwidth).2
    nlinarith

/-- The actual bilateral assembly for stationary acoustic-speed fronts exists
through the closed step under the printed half-cell CFL. The supplied local
fields retain their separate Riemann-solution certificates. -/
noncomputable def leveque04_acousticClosedEvolution
    {m : ℕ} (states : ℤ → Fin m → ℝ)
    (fields : ℤ → ℝ → ℝ → Fin m → ℝ)
    (origin width soundSpeed step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 ≤ step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      x < origin + (j : ℝ) * width + (-soundSpeed) * time →
        fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + soundSpeed * time < x →
        fields j x time = states (j + 1)) :
    ℝ → ℝ → Fin m → ℝ :=
  leveque04_reaBoundedEvolution states fields
    (fun _ => -soundSpeed) (fun _ => soundSpeed)
    origin width soundSpeed step hwidth hsound hstep
    (by intro j; exact ⟨le_refl _, neg_le_self hsound, le_refl _⟩)
    (by
      intro j
      have h := (leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
        soundSpeed width step origin hsound hwidth hstep).mp hcfl j
      simpa [leveque04_acousticSpeeds] using h)
    hleft hright

/-- At the printed acoustic half-cell CFL, the assembled closed-step field
obeys the conservative physical-flux update, including final-time contact. -/
theorem leveque04_acousticClosedEvolution_cellAverage_step
    {m : ℕ} (states : ℤ → Fin m → ℝ)
    (fields : ℤ → ℝ → ℝ → Fin m → ℝ)
    (origin width soundSpeed step : ℝ)
    (hwidth : 0 < width) (hsound : 0 ≤ soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (hleft : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      x < origin + (j : ℝ) * width + (-soundSpeed) * time →
        fields j x time = states j)
    (hright : ∀ (j : ℤ) (x time : ℝ), time ∈ Set.Icc 0 step →
      origin + (j : ℝ) * width + soundSpeed * time < x →
        fields j x time = states (j + 1))
    (flux : (Fin m → ℝ) → Fin m → ℝ) (cell : ℤ)
    (hfields : ∀ j, LocalConservationLaw.RectangleReferenceOn (fields j) flux
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) step) :
    let q := leveque04_acousticClosedEvolution states fields origin width soundSpeed step
      hwidth hsound hstep.le hcfl hleft hright
    oneDimensionalCellAverage (fun x => q x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
      states (cell + 1) - (step / width) •
        (oneDimensionalCellAverage
          (fun time => flux (q (origin + ((cell + 1 : ℤ) : ℝ) * width) time)) 0 step -
          oneDimensionalCellAverage
            (fun time => flux (q (origin + (cell : ℝ) * width) time)) 0 step) := by
  have hspeeds : ∀ j : ℤ, -soundSpeed ≤ (fun _ : ℤ => -soundSpeed) j ∧
      (fun _ : ℤ => -soundSpeed) j ≤ (fun _ : ℤ => soundSpeed) j ∧
      (fun _ : ℤ => soundSpeed) j ≤ soundSpeed := by
    intro j
    exact ⟨le_refl _, neg_le_self hsound, le_refl _⟩
  have hinteraction : ∀ j : ℤ,
      origin + (j : ℝ) * width + (fun _ : ℤ => soundSpeed) j * step ≤
        origin + ((j + 1 : ℤ) : ℝ) * width +
          (fun _ : ℤ => -soundSpeed) (j + 1) * step := by
    intro j
    have h := (leveque04_acousticHalfCFL_iff_adjacentFrontsOrdered
      soundSpeed width step origin hsound hwidth hstep.le).mp hcfl j
    simpa [leveque04_acousticSpeeds] using h
  simpa only [leveque04_acousticClosedEvolution] using
    (leveque04_reaBoundedEvolution_cellAverage_step states fields
      (fun _ => -soundSpeed) (fun _ => soundSpeed)
      origin width soundSpeed step hwidth hsound hstep hspeeds hinteraction
      hleft hright flux cell hfields)

end NumStability
