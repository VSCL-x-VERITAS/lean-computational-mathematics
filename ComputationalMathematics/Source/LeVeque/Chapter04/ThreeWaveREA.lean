/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.WaveFluctuations
import ComputationalMathematics.Source.LeVeque.Chapter04.NonconservativeWaveScope
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring
import Mathlib.Tactic.Linarith

/-!
# LeVeque Chapter 4, equation (4.39): the three-wave REA cell average

The four constant regions of Figure 4.7 are weighted by their lengths.
The two positive-speed waves enter from the left and the negative-speed
wave enters from the right. Their lengths give the stated average update.
-/

namespace NumStability

/-- The cell average of the four constant regions in Figure 4.7. The
leftmost state is behind both right-going waves; the rightmost state is
behind the left-going wave from the right face. -/
noncomputable def leveque04_threeWaveREAaverage
    (timeStep cellWidth : ℝ) (waveSpeed : Fin 3 → ℝ)
    (old : Fin 3 → ℝ) (leftWave rightWave : Fin 3 → (Fin 3 → ℝ)) :
    Fin 3 → ℝ :=
  (cellWidth)⁻¹ •
    ((waveSpeed 1 * timeStep) • (old - leftWave 1 - leftWave 2) +
      ((waveSpeed 2 - waveSpeed 1) * timeStep) • (old - leftWave 2) +
      (cellWidth - (waveSpeed 2 - waveSpeed 0) * timeStep) • old +
      (-(waveSpeed 0 * timeStep)) • (old + rightWave 0))

/-- Under the ordered speeds and noninteraction CFL bound, the four
weights used in the reconstructed average are nonnegative and add to
the cell width. -/
theorem leveque04_threeWaveREA_regionLengths
    (timeStep cellWidth : ℝ) (waveSpeed : Fin 3 → ℝ)
    (htime : 0 ≤ timeStep)
    (h1 : waveSpeed 0 < 0) (h2 : 0 < waveSpeed 1)
    (h23 : waveSpeed 1 < waveSpeed 2)
    (hcfl : (waveSpeed 2 - waveSpeed 0) * timeStep ≤ cellWidth) :
    0 ≤ waveSpeed 1 * timeStep ∧
      0 ≤ (waveSpeed 2 - waveSpeed 1) * timeStep ∧
      0 ≤ cellWidth - (waveSpeed 2 - waveSpeed 0) * timeStep ∧
      0 ≤ -(waveSpeed 0 * timeStep) ∧
      waveSpeed 1 * timeStep +
          (waveSpeed 2 - waveSpeed 1) * timeStep +
          (cellWidth - (waveSpeed 2 - waveSpeed 0) * timeStep) +
          -(waveSpeed 0 * timeStep) = cellWidth := by
  constructor
  · exact mul_nonneg h2.le htime
  constructor
  · exact mul_nonneg (sub_nonneg.mpr h23.le) htime
  constructor
  · linarith
  constructor
  · exact neg_nonneg.mpr (mul_nonpos_of_nonpos_of_nonneg h1.le htime)
  · ring

/-- Equation (4.39): averaging the four noninteracting wave regions
subtracts the two right-going effects from the left face and the
left-going effect from the right face. -/
theorem leveque04_equation39
    (timeStep cellWidth : ℝ) (waveSpeed : Fin 3 → ℝ)
    (old : Fin 3 → ℝ) (leftWave rightWave : Fin 3 → (Fin 3 → ℝ))
    (htime : 0 ≤ timeStep) (hwidth : 0 < cellWidth)
    (h1 : waveSpeed 0 < 0) (h2 : 0 < waveSpeed 1)
    (h23 : waveSpeed 1 < waveSpeed 2)
    (hcfl : (waveSpeed 2 - waveSpeed 0) * timeStep ≤ cellWidth) :
    leveque04_threeWaveREAaverage timeStep cellWidth waveSpeed
        old leftWave rightWave =
      old - (timeStep / cellWidth) •
        (waveSpeed 1 • leftWave 1 + waveSpeed 2 • leftWave 2 +
          waveSpeed 0 • rightWave 0) := by
  have _ := leveque04_threeWaveREA_regionLengths timeStep cellWidth
    waveSpeed htime h1 h2 h23 hcfl
  have hne : cellWidth ≠ 0 := ne_of_gt hwidth
  funext j
  simp only [leveque04_threeWaveREAaverage, Pi.smul_apply,
    Pi.add_apply, Pi.sub_apply, smul_eq_mul]
  field_simp
  ring


/-- The numerical recurrence (4.39), without the nonoverlap restriction used
by the separate ordered-region averaging interpretation. The interface index
`i` denotes the left face of cell `i`. -/
theorem leveque04_equation39_numerical
    (timeStep cellWidth : ℝ) (waveSpeed : Fin 3 → ℝ)
    (old : ℤ → Fin 3 → ℝ) (wave : ℤ → Fin 3 → Fin 3 → ℝ) (i : ℤ)
    (_htime : 0 < timeStep) (_hwidth : 0 < cellWidth)
    (h0 : waveSpeed 0 < 0) (h1 : 0 < waveSpeed 1)
    (h12 : waveSpeed 1 < waveSpeed 2) :
    leveque04_directWavePropagationStep (timeStep / cellWidth) old
        (fun _ => waveSpeed) wave i =
      old i - (timeStep / cellWidth) •
        (waveSpeed 1 • wave i 1 + waveSpeed 2 • wave i 2 +
          waveSpeed 0 • wave (i + 1) 0) := by
  have h2 : 0 < waveSpeed 2 := lt_trans h1 h12
  have hpositive : leveque04_positiveFluctuation waveSpeed (wave i) =
      waveSpeed 1 • wave i 1 + waveSpeed 2 • wave i 2 := by
    simp [leveque04_positiveFluctuation, Fin.sum_univ_succ,
      leveque04_positiveVelocity, max_eq_right h0.le,
      max_eq_left h1.le, max_eq_left h2.le]
  have hnegative : leveque04_negativeFluctuation waveSpeed (wave (i + 1)) =
      waveSpeed 0 • wave (i + 1) 0 := by
    simp [leveque04_negativeFluctuation, Fin.sum_univ_succ,
      leveque04_negativeVelocity, min_eq_left h0.le,
      min_eq_right h1.le, min_eq_right h2.le]
  simp only [leveque04_directWavePropagationStep]
  rw [hpositive, hnegative]


end NumStability
