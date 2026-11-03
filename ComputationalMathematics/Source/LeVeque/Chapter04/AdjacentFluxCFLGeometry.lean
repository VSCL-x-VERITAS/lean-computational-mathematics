/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.AdjacentFluxCFLGeometrySupport

/-!
# Adjacent upwind flux and actual farther-data dependence

The source-facing theorem assembles the physical integral calculations with
the actual translated reconstruction. Its upstream-step comparison keeps both
adjacent states fixed for every travel distance greater than one cell.
-/

namespace NumStability
open MeasureTheory Set

/-- Figure4.2's positive-advection geometry for the actual physical flux. -/
theorem leveque04_adjacentFluxCFLGeometry : Leveque04AdjacentFluxCFLGeometryTarget := by
  classical
  intro origin width speed dt hw hu ht
  dsimp only
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro old
    have hrectangle : IsRectangleConservationLawSolution
        (fun x t => leveque04_scalarAdvectedField
          (leveque04_uniformReconstruction origin width old) speed x t)
        (fun state => speed * state) := by
      simpa only [leveque04_scalarAdvectedField, travelingWave, smul_eq_mul] using
        travelingWave_isRectangleConservationLawSolution
          (leveque04_uniformReconstruction origin width old)
          (leveque04_uniformReconstruction_intervalIntegrable origin width hw old) speed
    refine ⟨?_, hrectangle, ?_, ?_, ?_⟩
    · intro x t
      simp only [leveque04_scalarAdvectedField, mul_zero, sub_zero, add_sub_cancel_right]
    · intro i
      simpa only [leveque04_scalarAdvectedField, mul_zero, sub_zero] using
        leveque04_uniformReconstruction_cellAverage origin width hw old i
    · intro i
      exact hrectangle.1 _ _ dt
    · intro i
      exact hrectangle.2.1 _ 0 dt
  · intro hsmall old i
    exact leveque04_positiveAdvection_smallStep_faceFlux origin width speed dt
      hw hu ht hsmall.le old i
  · intro heq old i
    exact leveque04_positiveAdvection_smallStep_faceFlux origin width speed dt
      hw hu ht heq.le old i
  · intro hlarge i
    have hzeroFlux : leveque04_scalarTimeFaceFluxAverage
        (leveque04_uniformReconstruction origin width (fun _ : ℤ => (0 : ℝ)))
        speed dt (leveque04_uniformInterface origin width (i - 1)) = 0 := by
      simp only [leveque04_scalarTimeFaceFluxAverage, leveque04_scalarPhysicalFlux,
        leveque04_scalarAdvectedField, leveque04_uniformReconstruction, mul_zero,
        intervalIntegral.integral_zero]
    have hzeroMean : leveque04_scalarNewCellAverage
        (leveque04_uniformReconstruction origin width (fun _ : ℤ => (0 : ℝ)))
        speed dt (leveque04_uniformInterface origin width (i - 1)) width = 0 := by
      simp only [leveque04_scalarNewCellAverage, leveque04_scalarAdvectedField,
        leveque04_uniformReconstruction, oneDimensionalCellAverage,
        intervalIntegral.integral_zero, smul_zero]
    have hflux := leveque04_upstreamStep_faceFlux origin width speed dt hw hu ht hlarge i
    have hmean := leveque04_upstreamStep_newMean origin width speed dt hw hlarge i
    have hfluxpos : 0 < speed - width / dt := by
      rw [sub_pos, div_lt_iff₀ ht]
      nlinarith
    have hmeanpos : 0 < min ((speed * dt - width) / width) 1 :=
      lt_min (div_pos (sub_pos.mpr hlarge) hw) zero_lt_one
    refine ⟨by simp, by simp [show ¬ i - 1 ≤ i - 2 by omega],
      by simp [show ¬ i ≤ i - 2 by omega],
      by simp [show ¬ i + 1 ≤ i - 2 by omega], hzeroFlux, hflux,
      by rwa [hflux], hzeroMean, hmean, by rwa [hmean], ?_⟩
    rintro ⟨F, hF⟩
    have hz := hF (fun _ => 0)
    have hs := hF (fun j => if j ≤ i - 2 then 1 else 0)
    rw [hzeroFlux] at hz
    rw [hflux] at hs
    simp only [show ¬ i - 1 ≤ i - 2 by omega, show ¬ i ≤ i - 2 by omega,
      if_false] at hs
    linarith

end NumStability
