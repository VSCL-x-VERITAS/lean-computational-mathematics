/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.RigidRotationStrainTarget

/-!
# Finite rigid rotations and the small-strain approximation
-/

namespace NumStability.Leveque02Tracer

/-- Proper orthogonal planar rotations have no exact metric strain or induced
stress from a stress-free reference state. A quarter-turn exposes the domain
limit of the infinitesimal strain tensor in (2.87). -/
theorem rigidRotationStrain : rigidRotationStrainTarget := by
  constructor
  · intro R hR _ stress hstress
    have hstrain : exactPlanarStrain R = 0 := by
      simp [exactPlanarStrain, hR]
    exact ⟨hstrain, by simpa [hstrain] using hstress⟩
  · constructor
    · intro G hG
      simp [infinitesimalStrain, hG]
    · constructor
      · ext i j
        fin_cases i <;> fin_cases j <;>
          norm_num [planarQuarterTurn, Matrix.mul_apply, Fin.sum_univ_two] <;> rfl
      · constructor
        · norm_num [planarQuarterTurn, Matrix.det_fin_two_of]
          rfl
        · ext i j
          fin_cases i <;> fin_cases j <;>
            norm_num [infinitesimalStrain, planarQuarterTurn,
              Matrix.sub_apply, Matrix.add_apply, Matrix.transpose_apply,
              Matrix.smul_apply, Matrix.one_apply] <;> rfl

end NumStability.Leveque02Tracer
