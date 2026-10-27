/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAUniformReconstruction

/-!
# Characteristic identification on linear REA fans and gaps

For arbitrary finite real characteristic spectra and bilateral cell data,
noninteraction uses the spread of the extreme speeds. No symmetric
sound-speed bound is imposed on a general linear system.
-/

namespace NumStability

/-- Inside a local fan, every characteristic sample of the uniform initial
field equals the matching adjacent-state Riemann datum. -/
theorem leveque04_linearCharacteristic_eq_localFan
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower upper time : ℝ)
    (hwidth : 0 < width) (htime : 0 ≤ time)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (hcfl : (upper - lower) * time ≤ width)
    (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + (j : ℝ) * width + lower * time)
      (origin + (j : ℝ) * width + upper * time)) :
    linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width states) x time =
    linearRiemannSolution basis speeds (states j) (states j) (states (j + 1))
      (x - (origin + (j : ℝ) * width)) time := by
  classical
  rw [linearRiemannSolution_eq_characteristicEvolution]
  simp only [linearCharacteristicEvolution]
  apply Finset.sum_congr rfl
  intro p _
  have hsampleLower : origin + ((j - 1 : ℤ) : ℝ) * width < x - speeds p * time := by
    have hp := mul_le_mul_of_nonneg_right (hspeeds p).2 htime
    push_cast
    nlinarith [hx.1]
  have hsampleUpper : x - speeds p * time < origin + ((j + 1 : ℤ) : ℝ) * width := by
    have hp := mul_le_mul_of_nonneg_right (hspeeds p).1 htime
    push_cast
    nlinarith [hx.2]
  have hdatum : leveque04_uniformReconstruction origin width states (x - speeds p * time) =
      riemannData (states j) (states j) (states (j + 1))
        (x - (origin + (j : ℝ) * width) - speeds p * time) := by
    rcases lt_trichotomy (x - speeds p * time) (origin + (j : ℝ) * width) with hl | he | hr
    · have hcell := leveque04_uniformReconstruction_cell origin width hwidth states j
        (x - speeds p * time) ⟨hsampleLower, hl⟩
      have harg : x - (origin + (j : ℝ) * width) - speeds p * time < 0 := by linarith
      simpa [riemannData, harg] using hcell
    · have hface := leveque04_uniformReconstruction_face origin width hwidth states j
      have harg : x - (origin + (j : ℝ) * width) - speeds p * time = 0 := by linarith
      rw [he]
      simpa [leveque04_uniformInterface, harg] using hface
    · have hcell := leveque04_uniformReconstruction_cell origin width hwidth states (j + 1)
        (x - speeds p * time) (by simpa only [leveque04_cell, add_sub_cancel_right] using
          (show x - speeds p * time ∈ Set.Ioo (origin + (j : ℝ) * width)
            (origin + ((j + 1 : ℤ) : ℝ) * width) from ⟨hr, hsampleUpper⟩))
      have harg : 0 < x - (origin + (j : ℝ) * width) - speeds p * time := by linarith
      simpa [riemannData, harg, not_lt_of_gt harg] using hcell
  rw [hdatum]

/-- In an open gap between adjacent linear Riemann fans, all characteristic
samples lie in the same reconstructed cell. -/
theorem leveque04_linearCharacteristic_eq_gapState
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speeds : Fin m → ℝ) (states : ℤ → Fin m → ℝ)
    (origin width lower upper time : ℝ)
    (hwidth : 0 < width) (htime : 0 ≤ time)
    (hspeeds : ∀ p, lower ≤ speeds p ∧ speeds p ≤ upper)
    (j : ℤ) (x : ℝ)
    (hx : x ∈ Set.Ioo (origin + ((j - 1 : ℤ) : ℝ) * width + upper * time)
      (origin + (j : ℝ) * width + lower * time)) :
    linearCharacteristicEvolution basis speeds
      (leveque04_uniformReconstruction origin width states) x time = states j := by
  have hsamples (p : Fin m) : leveque04_uniformReconstruction origin width states
      (x - speeds p * time) = states j := by
    apply leveque04_uniformReconstruction_cell origin width hwidth states j
    constructor
    · have hp := mul_le_mul_of_nonneg_right (hspeeds p).2 htime
      change origin + ((j - 1 : ℤ) : ℝ) * width < x - speeds p * time
      linarith [hx.1]
    · have hp := mul_le_mul_of_nonneg_right (hspeeds p).1 htime
      change x - speeds p * time < origin + (j : ℝ) * width
      linarith [hx.2]
  simpa only [linearCharacteristicEvolution, hsamples] using basis.sum_repr (states j)

end NumStability
