/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticWaveStrengths

/-!
# Acoustic Riemann strengths and intermediate state

Equation (3.31), Figure 3.6, equation (3.32), and Example 3.1 on printed
pages 56–57/raw PDF pages 78–79. These source statements specialize the
existing acoustic eigenvector and characteristic-strength definitions to a
right-minus-left Riemann jump.
-/

namespace NumStability

/-- Equation (3.31): apply the established acoustic strength transform to
the right-minus-left pressure and velocity jump. -/
theorem leveque03_acousticRiemannStrengths
    (density soundSpeed pLeft uLeft pRight uRight : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    acousticWaveStrengths density soundSpeed (pRight - pLeft) (uRight - uLeft) =
      ![(-(pRight - pLeft) + acousticImpedance density soundSpeed *
          (uRight - uLeft)) / (2 * acousticImpedance density soundSpeed),
        ((pRight - pLeft) + acousticImpedance density soundSpeed *
          (uRight - uLeft)) / (2 * acousticImpedance density soundSpeed)] := by
  exact Leveque02Tracer.acousticWaveStrengthsFormula density soundSpeed
    (pRight - pLeft) (uRight - uLeft) hZ

/-- Figure 3.6(a): the acoustic eigenvectors are symmetric about the
velocity axis in the pressure-velocity plane. -/
theorem leveque03_acousticFigure36_eigenvectors
    (density soundSpeed : ℝ) :
    linearAcousticsLeftEigenvector density soundSpeed =
      ![-acousticImpedance density soundSpeed, 1] ∧
    linearAcousticsRightEigenvector density soundSpeed =
      ![acousticImpedance density soundSpeed, 1] := by
  simp [linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
    acousticImpedance]

/-- The acoustic intermediate state reached by the first wave. -/
noncomputable def leveque03_acousticIntermediate
    (density soundSpeed pLeft uLeft pRight uRight : ℝ) : Fin 2 → ℝ :=
  ![pLeft, uLeft] +
    acousticWaveStrengths density soundSpeed (pRight - pLeft) (uRight - uLeft) 0 •
      linearAcousticsLeftEigenvector density soundSpeed

/-- Equation (3.32): the two pressure and velocity components of the
intermediate state. -/
theorem leveque03_acousticIntermediate_formula
    (density soundSpeed pLeft uLeft pRight uRight : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    leveque03_acousticIntermediate density soundSpeed pLeft uLeft pRight uRight =
      ![((pLeft + pRight) - acousticImpedance density soundSpeed *
          (uRight - uLeft)) / 2,
        (uLeft + uRight - (pRight - pLeft) /
          acousticImpedance density soundSpeed) / 2] := by
  have hne : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt hZ
  unfold leveque03_acousticIntermediate
  rw [leveque03_acousticRiemannStrengths density soundSpeed pLeft uLeft
    pRight uRight hZ]
  ext i
  fin_cases i <;>
    simp [linearAcousticsLeftEigenvector] <;>
    field_simp [hne] <;>
    simp only [acousticImpedance] <;>
    ring

/-- The same intermediate state is the right state minus the second wave. -/
theorem leveque03_acousticIntermediate_fromRight
    (density soundSpeed pLeft uLeft pRight uRight : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed) :
    leveque03_acousticIntermediate density soundSpeed pLeft uLeft pRight uRight =
      ![pRight, uRight] -
        acousticWaveStrengths density soundSpeed (pRight - pLeft) (uRight - uLeft) 1 •
          linearAcousticsRightEigenvector density soundSpeed := by
  have hne : acousticImpedance density soundSpeed ≠ 0 := ne_of_gt hZ
  rw [leveque03_acousticIntermediate_formula density soundSpeed pLeft uLeft
    pRight uRight hZ,
    leveque03_acousticRiemannStrengths density soundSpeed pLeft uLeft
      pRight uRight hZ]
  ext i
  fin_cases i <;>
    simp [linearAcousticsRightEigenvector] <;>
    field_simp [hne] <;>
    simp only [acousticImpedance] <;>
    ring

/-- Example 3.1: a pressure drop with zero endpoint velocities has
opposite-sign strengths and the displayed intermediate state. -/
theorem leveque03_acousticExample31
    (density soundSpeed pLeft pRight : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed)
    (hpressure : pRight < pLeft) :
    acousticWaveStrengths density soundSpeed (pRight - pLeft) (0 - 0) 0 =
      (pLeft - pRight) / (2 * acousticImpedance density soundSpeed) ∧
    acousticWaveStrengths density soundSpeed (pRight - pLeft) (0 - 0) 1 =
      (pRight - pLeft) / (2 * acousticImpedance density soundSpeed) ∧
    leveque03_acousticIntermediate density soundSpeed pLeft 0 pRight 0 =
      ![(pLeft + pRight) / 2,
        -(pRight - pLeft) / (2 * acousticImpedance density soundSpeed)] ∧
    0 < acousticWaveStrengths density soundSpeed (pRight - pLeft) (0 - 0) 0 ∧
    acousticWaveStrengths density soundSpeed (pRight - pLeft) (0 - 0) 1 < 0 := by
  have hs := leveque03_acousticRiemannStrengths density soundSpeed
    pLeft 0 pRight 0 hZ
  have hm := leveque03_acousticIntermediate_formula density soundSpeed
    pLeft 0 pRight 0 hZ
  have hα0 : acousticWaveStrengths density soundSpeed (pRight - pLeft) (0 - 0) 0 =
      (pLeft - pRight) / (2 * acousticImpedance density soundSpeed) := by
    have h := congrFun hs 0
    simpa only [sub_self, mul_zero, add_zero, neg_sub, Matrix.cons_val_zero] using h
  have hα1 : acousticWaveStrengths density soundSpeed (pRight - pLeft) (0 - 0) 1 =
      (pRight - pLeft) / (2 * acousticImpedance density soundSpeed) := by
    have h := congrFun hs 1
    simpa only [sub_self, mul_zero, add_zero, Matrix.cons_val_one,
      Matrix.cons_val_zero] using h
  have hdenom : 0 < 2 * acousticImpedance density soundSpeed :=
    mul_pos (by norm_num) hZ
  refine ⟨hα0, hα1, ?_, ?_, ?_⟩
  · rw [hm]
    ext i
    fin_cases i
    · simp [sub_self, sub_zero]
    · simp [sub_self, sub_zero]
      ring
  · rw [hα0]
    exact div_pos (sub_pos.mpr hpressure) hdenom
  · rw [hα1]
    exact div_neg_of_neg_of_pos (sub_neg.mpr hpressure) hdenom

/-- Figure 3.6(b): the intermediate pressure lies between the endpoint
pressures and its velocity rises above their common zero velocity. -/
theorem leveque03_acousticFigure36b
    (density soundSpeed pLeft pRight : ℝ)
    (hZ : 0 < acousticImpedance density soundSpeed)
    (hpressure : pRight < pLeft) :
    pRight < leveque03_acousticIntermediate density soundSpeed pLeft 0 pRight 0 0 ∧
    leveque03_acousticIntermediate density soundSpeed pLeft 0 pRight 0 0 < pLeft ∧
    0 < leveque03_acousticIntermediate density soundSpeed pLeft 0 pRight 0 1 := by
  have hm := (leveque03_acousticExample31 density soundSpeed pLeft pRight
    hZ hpressure).2.2.1
  have hdenom : 0 < 2 * acousticImpedance density soundSpeed :=
    mul_pos (by norm_num) hZ
  have hvelocity : 0 < -(pRight - pLeft) /
      (2 * acousticImpedance density soundSpeed) :=
    div_pos (by linarith) hdenom
  rw [hm]
  simp only [Matrix.cons_val_zero, Matrix.cons_val_one]
  constructor
  · linarith
  constructor
  · linarith
  · exact hvelocity

end NumStability
