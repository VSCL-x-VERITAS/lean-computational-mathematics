/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.REAAcousticRiemannFields
import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovREAConnection

/-!
# Acoustic REA averages and the independent characteristic Cauchy solution

The assembled exact acoustic Riemann field gives the same cell averages
as characteristic evolution of its uniform piecewise-constant initial data
through the closed half-cell CFL step. The characteristic field has the
prescribed initial trace and satisfies rectangle conservation.
-/

namespace NumStability

/-- Averaging the assembled acoustic Riemann field over a physical cell
agrees with a separately constructed exact uniform characteristic REA stage. -/
theorem leveque04_acousticREA_average_eq_independentStage
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (cell : ℤ) :
    oneDimensionalCellAverage
      (fun x => leveque04_acousticREAClosedEvolution density soundSpeed
        himpedance states origin width step hwidth hsound.le hstep.le hcfl x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
    (leveque04_linearUniformStage
      (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2) density 0)
      (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
      origin width hwidth states).nextAverage step (cell + 1) := by
  let coefficient := convectedLinearAcousticsMatrix
    (density * soundSpeed ^ 2) density 0
  let hyperbolic := leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance
  let basis := leveque04_acousticEigenbasis density soundSpeed himpedance
  let speeds := leveque04_acousticSpeeds 0 soundSpeed
  let heigen := leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance
  let method := linearRectangleRiemannInterfaceFluxMethod coefficient
    hyperbolic basis speeds heigen
  let ratio := step / width
  have hratio : 0 < ratio := div_pos hstep hwidth
  have hratioWidth : ratio * width = step := by
    dsimp [ratio]
    field_simp
  have hspeeds : ∀ p : Fin 2, -soundSpeed ≤ speeds p ∧ speeds p ≤ soundSpeed := by
    intro p
    fin_cases p <;> simp [speeds, leveque04_acousticSpeeds, hsound.le]
  have hCFL : 2 * soundSpeed * (ratio * width) ≤ width := by
    have h := (div_le_iff₀ hwidth).mp hcfl
    rw [hratioWidth]
    nlinarith
  have hselected := leveque04_linearGodunovWaveStep_selected
    coefficient hyperbolic basis speeds heigen states ratio (cell + 1)
  have hrea := leveque04_linearUniformREA_eq_godunovWaveStep
    coefficient hyperbolic basis speeds heigen origin width ratio soundSpeed
    hwidth hratio hsound.le hspeeds hCFL states (cell + 1)
  calc
    _ = conservativeFluxDifferenceUpdateInt ratio states
        (rectangleRiemannInterfaceFlux method states (fun _ => True.intro))
        (cell + 1) := by
          simpa only [coefficient, hyperbolic, basis, speeds, heigen,
            method, ratio] using
            leveque04_acousticREAClosedEvolution_eq_selectedStep
              density soundSpeed himpedance states origin width step
              hwidth hsound hstep hcfl cell
    _ = leveque04_linearGodunovWaveStep basis speeds ratio states (cell + 1) := by
      simpa only [method] using hselected
    _ = (leveque04_linearUniformStage coefficient hyperbolic basis speeds
          heigen origin width hwidth states).nextAverage step (cell + 1) := by
      rw [← hratioWidth]
      exact hrea.symm

/-- The acoustic REA cell average equals the average of the independent
characteristic evolution of the same piecewise-constant reconstruction. -/
theorem leveque04_acousticREA_average_eq_characteristicCauchy
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2)
    (cell : ℤ) :
    oneDimensionalCellAverage
      (fun x => leveque04_acousticREAClosedEvolution density soundSpeed
        himpedance states origin width step hwidth hsound.le hstep.le hcfl x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) =
    oneDimensionalCellAverage
      (fun x => linearCharacteristicEvolution
        (leveque04_acousticEigenbasis density soundSpeed himpedance)
        (leveque04_acousticSpeeds 0 soundSpeed)
        (leveque04_uniformReconstruction origin width states) x step)
      (origin + (cell : ℝ) * width)
      (origin + ((cell + 1 : ℤ) : ℝ) * width) := by
  have h := leveque04_acousticREA_average_eq_independentStage
    density soundSpeed himpedance states origin width step
    hwidth hsound hstep hcfl cell
  simpa [Leveque04REAStage.nextAverage, leveque04_linearUniformStage,
    leveque04_uniformGrid, leveque04_uniformInterface] using h

/-- The independent characteristic field has the reconstructed initial
trace and solves rectangle conservation; the assembled acoustic field
produces exactly its next-time cell averages under the printed half-cell CFL. -/
theorem leveque04_acousticCharacteristic_exactCauchyAndREAverages
    (density soundSpeed : ℝ)
    (himpedance : acousticImpedance density soundSpeed ≠ 0)
    (states : ℤ → Fin 2 → ℝ)
    (origin width step : ℝ)
    (hwidth : 0 < width) (hsound : 0 < soundSpeed) (hstep : 0 < step)
    (hcfl : soundSpeed * step / width ≤ 1 / 2) :
    let initial := leveque04_uniformReconstruction origin width states
    let exact := linearCharacteristicEvolution
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed) initial
    (∀ x, exact x 0 = initial x) ∧
      IsRectangleConservationLawSolution exact
        (convectedLinearAcousticsMatrix
          (density * soundSpeed ^ 2) density 0).mulVec ∧
      ∀ cell : ℤ,
        oneDimensionalCellAverage
          (fun x => leveque04_acousticREAClosedEvolution density soundSpeed
            himpedance states origin width step hwidth hsound.le hstep.le hcfl x step)
          (origin + (cell : ℝ) * width)
          (origin + ((cell + 1 : ℤ) : ℝ) * width) =
        oneDimensionalCellAverage (fun x => exact x step)
          (origin + (cell : ℝ) * width)
          (origin + ((cell + 1 : ℤ) : ℝ) * width) := by
  dsimp only
  refine ⟨?_, ?_, ?_⟩
  · intro x
    exact linearCharacteristicEvolution_initial
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_uniformReconstruction origin width states) x
  · exact (leveque04_linearUniformStage
      (convectedLinearAcousticsMatrix (density * soundSpeed ^ 2) density 0)
      (leveque04_acoustic_hyperbolic density soundSpeed 0 himpedance)
      (leveque04_acousticEigenbasis density soundSpeed himpedance)
      (leveque04_acousticSpeeds 0 soundSpeed)
      (leveque04_acousticEigenbasis_eigen density soundSpeed 0 himpedance)
      origin width hwidth states).evolution_valid
  · intro cell
    exact leveque04_acousticREA_average_eq_characteristicCauchy
      density soundSpeed himpedance states origin width step
      hwidth hsound hstep hcfl cell

end NumStability
