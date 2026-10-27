/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LinearGodunovUpdate
import Mathlib.Tactic.FieldSimp
import Mathlib.Tactic.Ring

/-!
# LeVeque Chapter 4: characteristic form of the linear Godunov step

Each characteristic coordinate of the selected linear Godunov update is
a scalar upwind step at the corresponding signed wave speed.
-/

namespace NumStability

/-- The pth coordinate of a signed Riemann-wave fluctuation is the
signed speed times the jump in that coordinate. -/
theorem leveque04_riemannFluctuation_coordinate
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (speedPart : Fin m → ℝ) (left right : Fin m → ℝ) (p : Fin m) :
    eigenbasis.equivFun
        (∑ j, speedPart j •
          leveque03_riemannWave eigenbasis left right j) p =
      speedPart p *
        (eigenbasis.equivFun right p -
          eigenbasis.equivFun left p) := by
  simp [leveque03_riemannWave, leveque03_waveStrength,
    leveque03_characteristicCoordinates,
    leveque03_characteristicVariables]
  simp [Finsupp.single_apply]

/-- The wave form of the linear Godunov cell update (4.51). -/
noncomputable def leveque04_linearGodunovWaveStep
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (ratio : ℝ)
    (old : ℤ → (Fin m → ℝ)) (i : ℤ) : Fin m → ℝ :=
  old i - ratio •
    (leveque04_positiveFluctuation waveSpeed
        (leveque03_riemannWave eigenbasis (old (i - 1)) (old i)) +
      leveque04_negativeFluctuation waveSpeed
        (leveque03_riemannWave eigenbasis (old i) (old (i + 1))))

/-- Each characteristic coordinate is a scalar upwind step with its
own positive and negative wave-speed parts. -/
theorem leveque04_linearGodunovWaveStep_characteristic
    {m : ℕ} (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ) (ratio : ℝ)
    (old : ℤ → (Fin m → ℝ)) (i : ℤ) (p : Fin m) :
    eigenbasis.equivFun
        (leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio old i) p =
      eigenbasis.equivFun (old i) p - ratio *
        (leveque04_positiveVelocity (waveSpeed p) *
            (eigenbasis.equivFun (old i) p -
              eigenbasis.equivFun (old (i - 1)) p) +
          leveque04_negativeVelocity (waveSpeed p) *
            (eigenbasis.equivFun (old (i + 1)) p -
              eigenbasis.equivFun (old i) p)) := by
  simp only [leveque04_linearGodunovWaveStep,
    leveque04_positiveFluctuation, leveque04_negativeFluctuation,
    map_sub, map_smul, map_add, Pi.sub_apply, Pi.smul_apply,
    Pi.add_apply, smul_eq_mul,
    leveque04_riemannFluctuation_coordinate]

/-- The selected certified linear Riemann face fluxes produce exactly
the wave step whose characteristic formula is given above. -/
theorem leveque04_linearGodunovWaveStep_selected
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (hcoefficient : IsRealHyperbolicMatrix coefficient)
    (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (waveSpeed : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (eigenbasis p) =
      waveSpeed p • eigenbasis p)
    (old : ℤ → (Fin m → ℝ)) (ratio : ℝ) (i : ℤ) :
    let method := linearRectangleRiemannInterfaceFluxMethod coefficient
      hcoefficient eigenbasis waveSpeed heigen
    let faceFlux := rectangleRiemannInterfaceFlux method old (fun _ => True.intro)
    conservativeFluxDifferenceUpdateInt ratio old faceFlux i =
      leveque04_linearGodunovWaveStep eigenbasis waveSpeed ratio old i := by
  simpa only [leveque04_linearGodunovWaveStep] using
    leveque04_equation51_selected coefficient hcoefficient eigenbasis
      waveSpeed heigen old ratio i

/-- At `c Δt = Δx`, the negative acoustic characteristic shifts one
cell from the right in the selected linear Godunov wave update. -/
theorem leveque04_linearGodunov_negativeUnitShift
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    eigenbasis.equivFun
        (leveque04_linearGodunovWaveStep eigenbasis
          ![-soundSpeed, soundSpeed] (1 / soundSpeed) old i) 0 =
      eigenbasis.equivFun (old (i + 1)) 0 := by
  rw [leveque04_linearGodunovWaveStep_characteristic]
  simp only [Matrix.cons_val_zero]
  simp [leveque04_positiveVelocity, leveque04_negativeVelocity,
    max_eq_right (neg_nonpos.mpr hspeed.le),
    min_eq_left (neg_nonpos.mpr hspeed.le)]
  field_simp [hspeed.ne']
  ring

/-- The positive acoustic characteristic shifts one cell from the left. -/
theorem leveque04_linearGodunov_positiveUnitShift
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    eigenbasis.equivFun
        (leveque04_linearGodunovWaveStep eigenbasis
          ![-soundSpeed, soundSpeed] (1 / soundSpeed) old i) 1 =
      eigenbasis.equivFun (old (i - 1)) 1 := by
  rw [leveque04_linearGodunovWaveStep_characteristic]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one]
  simp [leveque04_positiveVelocity, leveque04_negativeVelocity,
    max_eq_left hspeed.le, min_eq_right hspeed.le]
  field_simp [hspeed.ne']
  ring

/-- For acoustic speeds `±c`, every selected Godunov wave step with
Courant number in `[0,1]` interpolates between the current and one
upwind neighboring characteristic value. The formula includes the
full unit-CFL step even though opposing REA fronts then interact. -/
theorem leveque04_linearGodunov_acousticCourantInterpolation
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed ratio : ℝ) (hspeed : 0 < soundSpeed)
    (hcfl : 0 ≤ soundSpeed * ratio ∧ soundSpeed * ratio ≤ 1)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    let next := leveque04_linearGodunovWaveStep eigenbasis
      ![-soundSpeed, soundSpeed] ratio old i
    eigenbasis.equivFun next 0 =
        (1 - soundSpeed * ratio) * eigenbasis.equivFun (old i) 0 +
          (soundSpeed * ratio) * eigenbasis.equivFun (old (i + 1)) 0 ∧
      eigenbasis.equivFun next 1 =
        (1 - soundSpeed * ratio) * eigenbasis.equivFun (old i) 1 +
          (soundSpeed * ratio) * eigenbasis.equivFun (old (i - 1)) 1 ∧
      0 ≤ 1 - soundSpeed * ratio ∧ 0 ≤ soundSpeed * ratio := by
  dsimp only
  have hleft := leveque04_linearGodunovWaveStep_characteristic
    eigenbasis ![-soundSpeed, soundSpeed] ratio old i 0
  have hright := leveque04_linearGodunovWaveStep_characteristic
    eigenbasis ![-soundSpeed, soundSpeed] ratio old i 1
  constructor
  · simpa [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_right (neg_nonpos.mpr hspeed.le),
      min_eq_left (neg_nonpos.mpr hspeed.le)] using
      (show eigenbasis.equivFun
        (leveque04_linearGodunovWaveStep eigenbasis
          ![-soundSpeed, soundSpeed] ratio old i) 0 =
        (1 - soundSpeed * ratio) * eigenbasis.equivFun (old i) 0 +
          (soundSpeed * ratio) * eigenbasis.equivFun (old (i + 1)) 0 by
        rw [hleft]
        simp [leveque04_positiveVelocity, leveque04_negativeVelocity,
          max_eq_right (neg_nonpos.mpr hspeed.le),
          min_eq_left (neg_nonpos.mpr hspeed.le)]
        ring)
  constructor
  · rw [hright]
    simp [leveque04_positiveVelocity, leveque04_negativeVelocity,
      max_eq_left hspeed.le, min_eq_right hspeed.le]
    ring
  exact ⟨sub_nonneg.mpr hcfl.2, hcfl.1⟩

/-- The unit-CFL endpoint of the selected linear wave update lies
strictly beyond the half-Courant REA fan-noninteraction range and
still gives exact one-cell characteristic shifts. -/
theorem leveque04_linearGodunov_unitCourantBeyondREA
    (eigenbasis : Module.Basis (Fin 2) ℝ (Fin 2 → ℝ))
    (soundSpeed : ℝ) (hspeed : 0 < soundSpeed)
    (old : ℤ → (Fin 2 → ℝ)) (i : ℤ) :
    ¬ soundSpeed * (1 / soundSpeed) ≤ (1 / 2 : ℝ) ∧
      eigenbasis.equivFun
          (leveque04_linearGodunovWaveStep eigenbasis
            ![-soundSpeed, soundSpeed] (1 / soundSpeed) old i) 0 =
        eigenbasis.equivFun (old (i + 1)) 0 ∧
      eigenbasis.equivFun
          (leveque04_linearGodunovWaveStep eigenbasis
            ![-soundSpeed, soundSpeed] (1 / soundSpeed) old i) 1 =
        eigenbasis.equivFun (old (i - 1)) 1 := by
  refine ⟨?_, leveque04_linearGodunov_negativeUnitShift
    eigenbasis soundSpeed hspeed old i,
    leveque04_linearGodunov_positiveUnitShift
      eigenbasis soundSpeed hspeed old i⟩
  rw [mul_one_div_cancel (ne_of_gt hspeed)]
  norm_num

end NumStability
