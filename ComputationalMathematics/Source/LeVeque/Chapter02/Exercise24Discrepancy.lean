/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise24CorrectionTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.FluidJacobian
import Mathlib.LinearAlgebra.Matrix.Trace
import Mathlib.Tactic

/-!
# Exercise 2.4: printed similarity discrepancy and correction
-/

namespace NumStability.Leveque02Tracer

/-- At a nonzero background velocity, the gas and stationary acoustics
matrices have different traces, refuting the printed universal similarity. -/
theorem exercise24PrintedSimilarityCounterexample :
    ¬ exercise24PrintedSimilarityTarget := by
  intro hprinted
  have hpressure : HasDerivAt (fun r : ℝ => r) 1 1 := by
    simpa using hasDerivAt_id (1 : ℝ)
  obtain ⟨S, SInv, _, hright, hsimilar⟩ :=
    hprinted (fun r : ℝ => r) 1 1 1 (by norm_num) (by norm_num) hpressure
  have htrace := congrArg Matrix.trace hsimilar
  rw [Matrix.trace_mul_cycle, hright, one_mul] at htrace
  norm_num [fluidFluxJacobian, fluidConservedState,
    linearAcousticsMatrix, Matrix.trace, Fin.sum_univ_two] at htrace

/-- The source's gas eigenpairs are correct. Similarity with stationary
acoustics holds after adding the background velocity to its diagonal. -/
theorem exercise24Corrected : exercise24CorrectionTarget := by
  intro pressureLaw density velocity pressureSlope hdensity hslope hpressure
  let speed := Real.sqrt pressureSlope
  let bulkModulus := density * pressureSlope
  let gas := fluidFluxJacobian
    (fluidConservedState density velocity) pressureSlope
  let stationary := linearAcousticsMatrix bulkModulus density
  let left : Fin 2 → ℝ := ![1, velocity - speed]
  let right : Fin 2 → ℝ := ![1, velocity + speed]
  let T : Matrix (Fin 2) (Fin 2) ℝ :=
    !![pressureSlope⁻¹, 0; velocity * pressureSlope⁻¹, density]
  let TInv : Matrix (Fin 2) (Fin 2) ℝ :=
    !![pressureSlope, 0; -velocity * density⁻¹, density⁻¹]
  have hdensityNe : density ≠ 0 := ne_of_gt hdensity
  have hslopeNe : pressureSlope ≠ 0 := ne_of_gt hslope
  have hspeed : 0 < speed := Real.sqrt_pos.2 hslope
  have hspeedSq : speed ^ 2 = pressureSlope := Real.sq_sqrt hslope.le
  have hgas : gas =
      !![0, 1; -velocity ^ 2 + pressureSlope, 2 * velocity] :=
    (fluidJacobian pressureLaw density velocity pressureSlope
      hdensity hpressure).1
  have hleft : gas.mulVec left = (velocity - speed) • left := by
    ext i
    fin_cases i
    · simp [hgas, left, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    · simp [hgas, left, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
      nlinarith [hspeedSq]
  have hright : gas.mulVec right = (velocity + speed) • right := by
    ext i
    fin_cases i
    · simp [hgas, right, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
    · simp [hgas, right, Matrix.mulVec, dotProduct, Fin.sum_univ_two]
      nlinarith [hspeedSq]
  have hleftNe : left ≠ 0 := by
    intro hz
    have hcomponent := congrFun hz (0 : Fin 2)
    simp [left] at hcomponent
  have hrightNe : right ≠ 0 := by
    intro hz
    have hcomponent := congrFun hz (0 : Fin 2)
    simp [right] at hcomponent
  have hTleft : T * TInv = 1 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [T, TInv, Matrix.mul_apply, Fin.sum_univ_two,
        hslopeNe, hdensityNe]; field_simp [hslopeNe, hdensityNe]; ring
  have hTright : TInv * T = 1 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [T, TInv, Matrix.mul_apply, Fin.sum_univ_two,
        hslopeNe, hdensityNe]; field_simp [hslopeNe, hdensityNe]; ring
  have hshifted :
      gas = T * (stationary + velocity • (1 : Matrix (Fin 2) (Fin 2) ℝ)) * TInv := by
    rw [hgas]
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [T, TInv, stationary, linearAcousticsMatrix,
        Matrix.mul_apply, Matrix.vecMul, dotProduct,
        Fin.sum_univ_two, Matrix.add_apply, Matrix.smul_apply] <;>
      field_simp [hdensityNe, hslopeNe] <;> ring
  exact ⟨hspeed, hgas, hleft, hleftNe, hright, hrightNe,
    hTleft, hTright, hshifted⟩

end NumStability.Leveque02Tracer
