/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellDirectionalHyperbolicityModel
import ComputationalMathematics.Analysis.PartialDifferentialEquations.HyperbolicitySimilarity
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.Tactic

/-!
# Positive symmetrization of the full directional Maxwell symbol
-/

namespace NumStability.Leveque02Tracer

/-- Cartesian cross product is represented by the displayed skew matrix. -/
theorem maxwellCrossMatrix_mulVec (direction vector : MaxwellVector) :
    (maxwellCrossMatrix direction).mulVec vector =
      crossProduct direction vector := by
  ext i
  fin_cases i <;>
    simp [maxwellCrossMatrix, cross_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_three] <;> ring

/-- The cross-product matrix is skew-symmetric in every direction. -/
theorem maxwellCrossMatrix_transpose (direction : MaxwellVector) :
    (maxwellCrossMatrix direction).transpose = -maxwellCrossMatrix direction := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [maxwellCrossMatrix, Matrix.transpose_apply]

/-- The normalized Maxwell directional matrix is real symmetric. -/
theorem maxwellNormalizedDirectionalMatrix_symm
    (permittivity permeability : ℝ) (direction : MaxwellVector) :
    (maxwellNormalizedDirectionalMatrix
      permittivity permeability direction).IsSymm := by
  unfold maxwellNormalizedDirectionalMatrix
  apply Matrix.IsSymm.fromBlocks Matrix.isSymm_zero ?_ Matrix.isSymm_zero
  simp [Matrix.transpose_neg, Matrix.transpose_smul,
    maxwellCrossMatrix_transpose]

/-- Scale electric field coordinates by the positive wave speed. -/
noncomputable def maxwellElectricScale (speed : ℝ) :
    Matrix MaxwellStateIndex MaxwellStateIndex ℝ :=
  Matrix.fromBlocks (speed • (1 : Matrix (Fin 3) (Fin 3) ℝ)) 0 0 1

/-- Inverse scaling of the electric coordinates. -/
noncomputable def maxwellElectricUnscale (speed : ℝ) :
    Matrix MaxwellStateIndex MaxwellStateIndex ℝ :=
  Matrix.fromBlocks (speed⁻¹ • (1 : Matrix (Fin 3) (Fin 3) ℝ)) 0 0 1

theorem maxwellElectricScale_mul_unscale (speed : ℝ) (hspeed : speed ≠ 0) :
    maxwellElectricScale speed * maxwellElectricUnscale speed = 1 := by
  unfold maxwellElectricScale maxwellElectricUnscale
  rw [Matrix.fromBlocks_multiply]
  simp [← Matrix.fromBlocks_one, hspeed]

theorem maxwellElectricUnscale_mul_scale (speed : ℝ) (hspeed : speed ≠ 0) :
    maxwellElectricUnscale speed * maxwellElectricScale speed = 1 := by
  unfold maxwellElectricScale maxwellElectricUnscale
  rw [Matrix.fromBlocks_multiply]
  simp [← Matrix.fromBlocks_one, hspeed]

/-- The physical six-state symbol is similar to the symmetric normalized
symbol through an invertible electric-field scaling. -/
theorem maxwellDirectionalMatrix_similarity
    (permittivity permeability : ℝ)
    (hpermittivity : 0 < permittivity) (hpermeability : 0 < permeability)
    (direction : MaxwellVector) :
    maxwellDirectionalMatrix permittivity permeability direction =
      maxwellElectricScale (maxwellDirectionalSpeed permittivity permeability) *
        maxwellNormalizedDirectionalMatrix permittivity permeability direction *
        maxwellElectricUnscale (maxwellDirectionalSpeed permittivity permeability) := by
  let speed := maxwellDirectionalSpeed permittivity permeability
  have hspeed_pos : 0 < speed := by
    dsimp [speed, maxwellDirectionalSpeed]
    exact Real.sqrt_pos.2 (by positivity)
  have hspeed_sq : speed * speed = 1 / (permittivity * permeability) := by
    dsimp [speed, maxwellDirectionalSpeed]
    nlinarith [Real.sq_sqrt (show 0 ≤ 1 / (permittivity * permeability) by positivity)]
  have hspeed_ne : speed ≠ 0 := ne_of_gt hspeed_pos
  have hspeed_sq' :
      (maxwellDirectionalSpeed permittivity permeability) ^ 2 =
        1 / (permittivity * permeability) := by
    simpa [speed, pow_two] using hspeed_sq
  have hspeed_ne' :
      maxwellDirectionalSpeed permittivity permeability ≠ 0 := hspeed_ne
  unfold maxwellDirectionalMatrix maxwellNormalizedDirectionalMatrix
    maxwellElectricScale maxwellElectricUnscale
  simp only [Matrix.fromBlocks_multiply, Matrix.mul_zero, Matrix.zero_mul,
    add_zero, zero_add, Matrix.one_mul, Matrix.mul_one]
  ext i j
  cases i <;> cases j <;>
    simp [Matrix.fromBlocks, Matrix.smul_apply, hspeed_ne',
      div_eq_mul_inv, mul_comm, mul_left_comm, mul_assoc]
  rw [← pow_two (maxwellDirectionalSpeed permittivity permeability), hspeed_sq']
  ring

end NumStability.Leveque02Tracer
