/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths
import ComputationalMathematics.Source.LeVeque.Chapter04.LinearRiemannWaveJump
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4, Exercise 4.1(b): the two acoustics waves

The wave strengths and eigenvectors come from the existing Chapter 2
acoustics formalization. Background velocity changes their propagation
speeds but not their jump vectors.
-/

namespace NumStability

/-- The two Riemann waves for arbitrary pressure--velocity states,
ordered by the `u₀-c` and `u₀+c` characteristic families. -/
noncomputable def leveque04_acousticRiemannWave
    (density soundSpeed : ℝ) (left right : Fin 2 → ℝ) :
    Fin 2 → (Fin 2 → ℝ) :=
  let strength := acousticWaveStrengths density soundSpeed
    (right 0 - left 0) (right 1 - left 1)
  ![strength 0 • linearAcousticsLeftEigenvector density soundSpeed,
    strength 1 • linearAcousticsRightEigenvector density soundSpeed]

/-- Exercise 4.1(b): explicit pressure and velocity components of the
left-going first wave and right-going second wave. -/
theorem leveque04_exercise41_acousticWaves
    (density soundSpeed : ℝ) (left right : Fin 2 → ℝ)
    (himpedance : 0 < acousticImpedance density soundSpeed) :
    let Z := acousticImpedance density soundSpeed
    let dp := right 0 - left 0
    let du := right 1 - left 1
    leveque04_acousticRiemannWave density soundSpeed left right 0 =
        ![(dp - Z * du) / 2, (-dp + Z * du) / (2 * Z)] ∧
      leveque04_acousticRiemannWave density soundSpeed left right 1 =
        ![(dp + Z * du) / 2, (dp + Z * du) / (2 * Z)] := by
  dsimp only
  have hZ : acousticImpedance density soundSpeed ≠ 0 :=
    ne_of_gt himpedance
  have hdensity : density ≠ 0 := by
    intro h
    exact hZ (by simp [acousticImpedance, h])
  have hspeed : soundSpeed ≠ 0 := by
    intro h
    exact hZ (by simp [acousticImpedance, h])
  have hs := Leveque02Tracer.acousticWaveStrengthsFormula
    density soundSpeed (right 0 - left 0) (right 1 - left 1)
    himpedance
  constructor
  · funext k
    fin_cases k <;>
      simp [leveque04_acousticRiemannWave, hs,
        linearAcousticsLeftEigenvector, acousticImpedance,
        Pi.smul_apply, smul_eq_mul] <;>
      field_simp [hdensity, hspeed] <;> ring
  · funext k
    fin_cases k <;>
      simp [leveque04_acousticRiemannWave, hs,
        linearAcousticsRightEigenvector, acousticImpedance,
        Pi.smul_apply, smul_eq_mul] <;>
      field_simp [hdensity, hspeed] <;> ring

/-- The two computed waves reconstruct the original interface jump. -/
theorem leveque04_acousticRiemannWaves_sum
    (density soundSpeed : ℝ) (left right : Fin 2 → ℝ)
    (himpedance : 0 < acousticImpedance density soundSpeed) :
    leveque04_acousticRiemannWave density soundSpeed left right 0 +
      leveque04_acousticRiemannWave density soundSpeed left right 1 =
        right - left := by
  have h := leveque04_exercise41_acousticWaves density soundSpeed
    left right himpedance
  have hZ : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt himpedance
  have hdensity : density ≠ 0 := by
    intro hz
    exact hZ (by simp [acousticImpedance, hz])
  have hspeed : soundSpeed ≠ 0 := by
    intro hz
    exact hZ (by simp [acousticImpedance, hz])
  ext k
  fin_cases k <;>
    simp [h.1, h.2, acousticImpedance, Pi.add_apply, Pi.sub_apply] <;>
    field_simp [hdensity, hspeed] <;> ring

end NumStability
