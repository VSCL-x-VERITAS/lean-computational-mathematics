/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.Exercise28aTarget
import Mathlib.Tactic

/-!
# Exercise 2.8(a): Eulerian isothermal acoustic speeds
-/

namespace NumStability.Leveque02Tracer

/-- The isothermal law gives bulk modulus `ρ₀a²` and the exact
characteristic roots of the convected pressure-velocity acoustic matrix. -/
theorem exercise28a : exercise28aTarget := by
  intro a densityBackground backgroundVelocity hdensity
  let pressureLaw : ℝ → ℝ := fun density => a ^ 2 * density
  let bulkModulus := acousticBulkModulus pressureLaw densityBackground
  let coefficient := convectedLinearAcousticsMatrix
    bulkModulus densityBackground backgroundVelocity
  have hpressure : HasDerivAt pressureLaw (a ^ 2) densityBackground := by
    simpa [pressureLaw] using
      (hasDerivAt_id (x := densityBackground)).const_mul (a ^ 2)
  have hbulk : bulkModulus = densityBackground * a ^ 2 := by
    simp [bulkModulus, acousticBulkModulus, hpressure.deriv]
  have hratio : (densityBackground * a ^ 2) / densityBackground = a ^ 2 := by
    field_simp [ne_of_gt hdensity]
  refine ⟨hpressure, hbulk, ?_, ?_⟩
  · change Real.sqrt (bulkModulus / densityBackground) = |a|
    rw [hbulk, hratio, Real.sqrt_sq_eq_abs]
  · intro eigenvalue
    have hdet :
        Matrix.det (coefficient - eigenvalue •
          (1 : Matrix (Fin 2) (Fin 2) ℝ)) =
        (backgroundVelocity - eigenvalue) ^ 2 - a ^ 2 := by
      simp [coefficient, convectedLinearAcousticsMatrix, hbulk,
        Matrix.det_fin_two, Matrix.sub_apply, Matrix.smul_apply,
        Matrix.cons_val_zero, Matrix.cons_val_one]
      field_simp [ne_of_gt hdensity]
    rw [hdet]
    have hfactor :
        (backgroundVelocity - eigenvalue) ^ 2 - a ^ 2 =
          (eigenvalue - (backgroundVelocity - a)) *
            (eigenvalue - (backgroundVelocity + a)) := by ring
    rw [hfactor]
    constructor
    · intro h
      rcases mul_eq_zero.mp h with h | h
      · left
        linarith
      · right
        linarith
    · intro h
      rcases h with h | h
      · rw [h]
        ring
      · rw [h]
        ring

end NumStability.Leveque02Tracer
