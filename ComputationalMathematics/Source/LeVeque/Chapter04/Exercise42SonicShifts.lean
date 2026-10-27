/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovCharacteristicStep
import ComputationalMathematics.Source.LeVeque.Chapter04.Exercise42AcousticAlignment
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, Exercise 4.2(d): sonic characteristic shifts

When the acoustics background velocity equals either signed sound speed,
one characteristic remains stationary and the other moves one cell in
a time step of width `dx/(2c)`.
-/

namespace NumStability

/-- At background velocity `+c`, the left family is stationary and the
right family moves one cell to the right. -/
theorem leveque04_linearGodunov_positiveSonicShifts
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let next := leveque04_linearGodunovWaveStep eigenbasis
      ![(soundSpeed - soundSpeed), (soundSpeed + soundSpeed)]
      (1 / (2 * soundSpeed)) old i
    eigenbasis.equivFun next 0 = eigenbasis.equivFun (old i) 0 ∧
      eigenbasis.equivFun next 1 = eigenbasis.equivFun (old (i - 1)) 1 := by
  dsimp only
  constructor
  · rw [leveque04_linearGodunovWaveStep_characteristic]
    simp [leveque04_positiveVelocity, leveque04_negativeVelocity]
  · rw [leveque04_linearGodunovWaveStep_characteristic]
    simp only [Matrix.cons_val_one, Matrix.cons_val_zero]
    have h2 : 0 ≤ soundSpeed + soundSpeed := by linarith
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity]
    rw [max_eq_left h2, min_eq_right h2]
    field_simp [hspeed.ne'] <;> ring_nf <;> simp
    all_goals exact Or.inl rfl

/-- At background velocity `-c`, the left family moves one cell to the
left and the right family is stationary. -/
theorem leveque04_linearGodunov_negativeSonicShifts
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let next := leveque04_linearGodunovWaveStep eigenbasis
      ![(-soundSpeed - soundSpeed), (-soundSpeed + soundSpeed)]
      (1 / (2 * soundSpeed)) old i
    eigenbasis.equivFun next 0 = eigenbasis.equivFun (old (i + 1)) 0 ∧
      eigenbasis.equivFun next 1 = eigenbasis.equivFun (old i) 1 := by
  dsimp only
  constructor
  · rw [leveque04_linearGodunovWaveStep_characteristic]
    simp only [Matrix.cons_val_zero]
    have h2 : -soundSpeed - soundSpeed ≤ 0 := by linarith
    simp only [leveque04_positiveVelocity, leveque04_negativeVelocity]
    rw [max_eq_right h2, min_eq_left h2]
    field_simp [hspeed.ne'] <;> ring_nf <;> simp
    all_goals exact Or.inl rfl
  · rw [leveque04_linearGodunovWaveStep_characteristic]
    simp [leveque04_positiveVelocity, leveque04_negativeVelocity]

/-- The certified linear Riemann solver inherits the positive-sonic
stationary/one-cell characteristic update. -/
theorem leveque04_selectedGodunov_positiveSonicShifts
    (coefficient : Matrix (Fin 2) (Fin 2) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      (![(soundSpeed - soundSpeed),
        (soundSpeed + soundSpeed)] p) • eigenbasis p)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis
      ![(soundSpeed - soundSpeed), (soundSpeed + soundSpeed)] heigen
    let next := conservativeFluxDifferenceUpdateInt (1 / (2 * soundSpeed))
      old (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i
    eigenbasis.equivFun next 0 = eigenbasis.equivFun (old i) 0 ∧
      eigenbasis.equivFun next 1 = eigenbasis.equivFun (old (i - 1)) 1 := by
  dsimp only
  rw [leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
    eigenbasis ![(soundSpeed - soundSpeed),
      (soundSpeed + soundSpeed)] heigen old (1 / (2 * soundSpeed)) i]
  exact leveque04_linearGodunov_positiveSonicShifts
    eigenbasis soundSpeed hspeed old i

/-- The certified linear Riemann solver inherits the negative-sonic
one-cell/stationary characteristic update. -/
theorem leveque04_selectedGodunov_negativeSonicShifts
    (coefficient : Matrix (Fin 2) (Fin 2) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      (![(-soundSpeed - soundSpeed),
        (-soundSpeed + soundSpeed)] p) • eigenbasis p)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis
      ![(-soundSpeed - soundSpeed), (-soundSpeed + soundSpeed)] heigen
    let next := conservativeFluxDifferenceUpdateInt (1 / (2 * soundSpeed))
      old (rectangleRiemannInterfaceFlux method old (fun _ => True.intro)) i
    eigenbasis.equivFun next 0 = eigenbasis.equivFun (old (i + 1)) 0 ∧
      eigenbasis.equivFun next 1 = eigenbasis.equivFun (old i) 1 := by
  dsimp only
  rw [leveque04_linearGodunovWaveStep_selected coefficient hcoefficient
    eigenbasis ![(-soundSpeed - soundSpeed),
      (-soundSpeed + soundSpeed)] heigen old (1 / (2 * soundSpeed)) i]
  exact leveque04_linearGodunov_negativeSonicShifts
    eigenbasis soundSpeed hspeed old i

end NumStability
