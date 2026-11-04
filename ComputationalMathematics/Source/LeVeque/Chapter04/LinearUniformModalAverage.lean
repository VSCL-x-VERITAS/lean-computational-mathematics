/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.GodunovRiemannREAStep
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.CellAverageLinearEquiv
import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.LinearCharacteristicCoordinates

/-!
# Actual uniform characteristic averages under the full CFL condition

The spatial integrals of the characteristic evolution of arbitrary bilateral
cell data give the signed Godunov update, including zero time and CFL endpoints.
Each individual translated mode has the corresponding scalar and vector effect.
-/

namespace NumStability

open MeasureTheory

/-- The actual evolved uniform field averages to the Godunov wave step under
the per-mode full-cell travel bound. -/
theorem leveque04_linearUniformEvolution_cellAverage_of_CFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 ≤ time)
    (hCFL : ∀ p, |speeds p * time| ≤ width)
    (old : ℤ → Fin m → ℝ) (i : ℤ) :
    oneDimensionalCellAverage
      (fun x => linearCharacteristicEvolution basis speeds
        (leveque04_uniformReconstruction origin width old) x time)
      (leveque04_uniformInterface origin width (i - 1))
      (leveque04_uniformInterface origin width i) =
      leveque04_linearGodunovWaveStep basis speeds (time / width) old i := by
  rcases eq_or_lt_of_le htime with hzero | hpos
  · subst time
    simp only [linearCharacteristicEvolution_initial, zero_div,
      leveque04_linearGodunovWaveStep, zero_smul, sub_zero]
    exact leveque04_uniformReconstruction_cellAverage origin width hwidth old i
  · have hcoefficient : IsRealHyperbolicMatrix coefficient := ⟨speeds, basis, heigen⟩
    have hspeeds : ∀ p, -(width / time) ≤ speeds p ∧ speeds p ≤ width / time := by
      intro p
      have hp := abs_le.mp (hCFL p)
      constructor
      · rw [← neg_div]
        apply (div_le_iff₀ hpos).2
        nlinarith [hp.1]
      · exact (le_div_iff₀ hpos).2 hp.2
    have hratio : 0 < time / width := div_pos hpos hwidth
    have hbound : 0 ≤ width / time := (div_pos hwidth hpos).le
    have hproduct : width / time * (time / width) ≤ 1 := by
      have : width / time * (time / width) = 1 := by
        field_simp [hwidth.ne', hpos.ne']
      exact this.le
    have havg := leveque04_linearUniformREA_eq_godunovWaveStep_of_CFL
      coefficient hcoefficient basis speeds heigen origin width (time / width)
      (width / time) hwidth hratio hbound hspeeds hproduct old i
    have hcancel : time / width * width = time := div_mul_cancel₀ time hwidth.ne'
    rw [hcancel] at havg
    simpa only [Leveque04REAStage.nextAverage, leveque04_linearUniformStage,
      leveque04_uniformGrid] using havg

/-- The spatial integral of a translated scalar mode is its actual Godunov
coordinate update, without a boundedness assumption on the cell array. -/
theorem leveque04_linearUniformEvolution_modalAverage_of_CFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 ≤ time)
    (hCFL : ∀ p, |speeds p * time| ≤ width)
    (old : ℤ → Fin m → ℝ) (i : ℤ) (p : Fin m) :
    oneDimensionalCellAverage
      (fun x => basis.equivFun
        (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p)
      (leveque04_uniformInterface origin width (i - 1))
      (leveque04_uniformInterface origin width i) =
      basis.equivFun (old i) p - (time / width) *
        (max (speeds p) 0 *
            (basis.equivFun (old i) p - basis.equivFun (old (i - 1)) p) +
          min (speeds p) 0 *
            (basis.equivFun (old (i + 1)) p - basis.equivFun (old i) p)) := by
  let field := fun x => linearCharacteristicEvolution basis speeds
    (leveque04_uniformReconstruction origin width old) x time
  let left := leveque04_uniformInterface origin width (i - 1)
  let right := leveque04_uniformInterface origin width i
  have hint : IntervalIntegrable field volume left right :=
    leveque04_linearUniformEvolution_intervalIntegrable
      basis speeds origin width hwidth old time left right
  let coordinates := basis.equivFun.toContinuousLinearEquiv.toContinuousLinearMap
  have hcoord : IntervalIntegrable (fun x => basis.equivFun (field x)) volume left right :=
    ⟨coordinates.integrable_comp hint.1, coordinates.integrable_comp hint.2⟩
  have havg := congrArg (fun v => basis.equivFun v p)
    (leveque04_linearUniformEvolution_cellAverage_of_CFL coefficient basis speeds
      heigen origin width time hwidth htime hCFL old i)
  dsimp only at havg
  rw [leveque04_linearGodunovWaveStep_characteristic] at havg
  have hlinear := congrFun
    (oneDimensionalCellAverage_linearEquiv basis.equivFun field left right hint) p
  rw [oneDimensionalCellAverage_apply _ _ _ hcoord p] at hlinear
  have hfield : (fun x => basis.equivFun (field x) p) =
      (fun x => basis.equivFun
        (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p) := by
    funext x
    exact linearCharacteristicEvolution_coordinate basis speeds _ x time p
  rw [hfield] at hlinear
  exact hlinear.trans (by
    simpa only [field, left, right, leveque04_positiveVelocity,
      leveque04_negativeVelocity] using havg)

/-- The averaged vector contribution of a single actual translated mode has
exactly the incoming signed wave effect from the neighboring interfaces. -/
theorem leveque04_linearUniformEvolution_modalAverageEffect_of_CFL
    {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ)) (speeds : Fin m → ℝ)
    (heigen : ∀ p, coefficient.mulVec (basis p) = speeds p • basis p)
    (origin width time : ℝ) (hwidth : 0 < width) (htime : 0 ≤ time)
    (hCFL : ∀ p, |speeds p * time| ≤ width)
    (old : ℤ → Fin m → ℝ) (i : ℤ) (p : Fin m) :
    oneDimensionalCellAverage
      (fun x => basis.equivFun
        (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p • basis p)
      (leveque04_uniformInterface origin width (i - 1))
      (leveque04_uniformInterface origin width i) - basis.equivFun (old i) p • basis p =
      -(time / width) •
        (max (speeds p) 0 • leveque03_riemannWave basis (old (i - 1)) (old i) p +
          min (speeds p) 0 • leveque03_riemannWave basis (old i) (old (i + 1)) p) := by
  have hscalar := leveque04_linearUniformEvolution_modalAverage_of_CFL
    coefficient basis speeds heigen origin width time hwidth htime hCFL old i p
  have hsmul :
      oneDimensionalCellAverage
        (fun x => basis.equivFun
          (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p • basis p)
        (leveque04_uniformInterface origin width (i - 1))
        (leveque04_uniformInterface origin width i) =
      (oneDimensionalCellAverage
        (fun x => basis.equivFun
          (leveque04_uniformReconstruction origin width old (x - speeds p * time)) p)
        (leveque04_uniformInterface origin width (i - 1))
        (leveque04_uniformInterface origin width i)) • basis p := by
    simp only [oneDimensionalCellAverage, intervalIntegral.integral_smul_const,
      smul_smul, smul_eq_mul]
  rw [hsmul, hscalar]
  simp only [leveque03_riemannWave, leveque03_waveStrength,
    leveque03_characteristicVariables, leveque03_characteristicCoordinates,
    smul_smul, ← sub_smul, ← add_smul]
  congr 1
  ring

end NumStability
