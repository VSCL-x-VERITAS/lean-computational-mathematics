/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths

/-!
# Acoustic characteristic variables in LeVeque Chapter 3

The page-48 example recalls the Chapter 2 acoustic strengths and permits
nonzero rescaling of each characteristic variable.
-/

namespace NumStability

/-- The normalized acoustic strengths are nonzero scalar multiples of
`-pressure + Z₀ velocity` and `pressure + Z₀ velocity`. -/
theorem leveque03_acousticCharacteristicVariables
    (density soundSpeed pressure velocity : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    ∃ leftScale rightScale : ℝ,
      leftScale ≠ 0 ∧ rightScale ≠ 0 ∧
        acousticWaveStrengths density soundSpeed pressure velocity =
          ![leftScale *
              (-pressure + acousticImpedance density soundSpeed * velocity),
            rightScale *
              (pressure + acousticImpedance density soundSpeed * velocity)] := by
  let Z := acousticImpedance density soundSpeed
  have hZ0 : 2 * Z ≠ 0 := mul_ne_zero (by norm_num) (ne_of_gt hZ)
  refine ⟨(2 * Z)⁻¹, (2 * Z)⁻¹, inv_ne_zero hZ0, inv_ne_zero hZ0, ?_⟩
  simpa only [Z, div_eq_mul_inv, mul_comm] using
    (Leveque02Tracer.acousticWaveStrengthsFormula
      density soundSpeed pressure velocity hZ)

end NumStability
