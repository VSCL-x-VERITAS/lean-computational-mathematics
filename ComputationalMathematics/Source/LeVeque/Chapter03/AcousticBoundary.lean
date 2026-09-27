/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.BoundaryPartition
import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticCharacteristics

/-!
# Acoustic wall reflection and outflow boundary data

Equations (3.39)–(3.40), Examples 3.2–3.3, and the Figure 3.8 wave-family
sign change. The printed `B₁ = 1` statement in Example 3.2 is refuted by a
concrete closed-wall state; its corrected coefficient is `-1`.
-/

namespace NumStability

def leveque03_closedTubeVelocity
    (velocity : ℝ → ℝ → ℝ) (left right : ℝ) : Prop :=
  ∀ t, velocity left t = 0 ∧ velocity right t = 0

def leveque03_acousticBoundaryVariables
    (density soundSpeed pressure velocity : ℝ) : Fin 2 → ℝ :=
  ![-pressure + acousticImpedance density soundSpeed * velocity,
    pressure + acousticImpedance density soundSpeed * velocity]

theorem leveque03_acousticBoundaryVariables_normalization
    (density soundSpeed pressure velocity : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    acousticWaveStrengths density soundSpeed pressure velocity =
      ![leveque03_acousticBoundaryVariables density soundSpeed pressure velocity 0 /
          (2 * acousticImpedance density soundSpeed),
        leveque03_acousticBoundaryVariables density soundSpeed pressure velocity 1 /
          (2 * acousticImpedance density soundSpeed)] := by
  simpa only [leveque03_acousticBoundaryVariables, Matrix.cons_val_zero,
    Matrix.cons_val_one] using
    (Leveque02Tracer.acousticWaveStrengthsFormula
      density soundSpeed pressure velocity hZ)

theorem leveque03_acousticBoundaryVariables_sum
    (density soundSpeed pressure velocity : ℝ) :
    leveque03_acousticBoundaryVariables density soundSpeed pressure velocity 0 +
      leveque03_acousticBoundaryVariables density soundSpeed pressure velocity 1 =
      2 * acousticImpedance density soundSpeed * velocity := by
  simp [leveque03_acousticBoundaryVariables]
  ring

theorem leveque03_closedTube_reflection
    (density soundSpeed : ℝ)
    (hZ : acousticImpedance density soundSpeed ≠ 0)
    (pressure velocity : ℝ → ℝ → ℝ) (left right : ℝ) :
    leveque03_closedTubeVelocity velocity left right ↔
      (∀ t,
        leveque03_acousticBoundaryVariables density soundSpeed
          (pressure left t) (velocity left t) 1 =
          -leveque03_acousticBoundaryVariables density soundSpeed
            (pressure left t) (velocity left t) 0) ∧
      (∀ t,
        leveque03_acousticBoundaryVariables density soundSpeed
          (pressure right t) (velocity right t) 0 =
          -leveque03_acousticBoundaryVariables density soundSpeed
            (pressure right t) (velocity right t) 1) := by
  constructor
  · intro hv
    constructor
    · intro t
      have h := (hv t).1
      simp [leveque03_acousticBoundaryVariables, h]
    · intro t
      have h := (hv t).2
      simp [leveque03_acousticBoundaryVariables, h]
  · rintro ⟨hleft, hright⟩ t
    constructor
    · have hs := leveque03_acousticBoundaryVariables_sum density soundSpeed
        (pressure left t) (velocity left t)
      rw [hleft t] at hs
      have hzero : 2 * acousticImpedance density soundSpeed * velocity left t = 0 := by
        linarith
      exact (mul_eq_zero.mp hzero).resolve_left (mul_ne_zero (by norm_num) hZ)
    · have hs := leveque03_acousticBoundaryVariables_sum density soundSpeed
        (pressure right t) (velocity right t)
      rw [hright t] at hs
      have hzero : 2 * acousticImpedance density soundSpeed * velocity right t = 0 := by
        linarith
      exact (mul_eq_zero.mp hzero).resolve_left (mul_ne_zero (by norm_num) hZ)

theorem leveque03_closedTube_correctedLeftCoefficient
    (density soundSpeed pressure : ℝ) :
    leveque03_acousticBoundaryVariables density soundSpeed pressure 0 1 =
      (-1 : ℝ) *
        leveque03_acousticBoundaryVariables density soundSpeed pressure 0 0 := by
  simp [leveque03_acousticBoundaryVariables]

theorem leveque03_closedTube_printedLeftCoefficient_false :
    leveque03_acousticBoundaryVariables 1 1 1 0 1 ≠
      (1 : ℝ) * leveque03_acousticBoundaryVariables 1 1 1 0 0 := by
  norm_num [leveque03_acousticBoundaryVariables, acousticImpedance]

theorem leveque03_rightAcousticOutflow
    (density soundSpeed pressure velocity : ℝ) :
    leveque03_acousticBoundaryVariables density soundSpeed pressure velocity 0 = 0 ↔
      pressure = acousticImpedance density soundSpeed * velocity := by
  simp [leveque03_acousticBoundaryVariables]
  constructor <;> intro h <;> linarith

theorem leveque03_figure38_reflectedWave
    (incidentPressure incidentVelocity reflectedPressure reflectedVelocity : ℝ)
    (hincident : incidentPressure = -(1 / 2) * incidentVelocity)
    (hpressure : reflectedPressure = incidentPressure)
    (hvelocity : reflectedVelocity = -incidentVelocity) :
    reflectedPressure = (1 / 2) * reflectedVelocity := by
  linarith

end NumStability
