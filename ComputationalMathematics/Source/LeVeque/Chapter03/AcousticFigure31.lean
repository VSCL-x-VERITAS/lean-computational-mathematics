/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticExample
import ComputationalMathematics.Source.LeVeque.Chapter02.AcousticSolutionFromInitialData

/-!
# Exact curves underlying Figure 3.1

Printed page 51/raw PDF page 73. The figure plots pressure and velocity at
times `0`, `0.1`, `0.5`, and `1` for the data in (3.13). This identity provides
the exact pressure and velocity curves at every time, including those four
panels. It reuses the Chapter 2 acoustic initial-data formula.
-/

namespace NumStability

/-- The two exact component curves for the Figure 3.1 example. Each is the
sum or difference of the initial pressure translated at speeds `-1/2` and
`1/2`. -/
theorem leveque03_acousticExampleEvolution (x t : ℝ) :
    (leveque03_acousticInitialDataSolution 1 (1 / 2)
      leveque03_acousticExamplePressure leveque03_acousticExampleVelocity x t) 0 =
        (leveque03_acousticExamplePressure (x + (1 / 2) * t) +
          leveque03_acousticExamplePressure (x - (1 / 2) * t)) / 2 ∧
    (leveque03_acousticInitialDataSolution 1 (1 / 2)
      leveque03_acousticExamplePressure leveque03_acousticExampleVelocity x t) 1 =
        leveque03_acousticExamplePressure (x - (1 / 2) * t) -
          leveque03_acousticExamplePressure (x + (1 / 2) * t) := by
  let q := leveque03_acousticInitialDataSolution 1 (1 / 2)
    leveque03_acousticExamplePressure leveque03_acousticExampleVelocity
  let p : ℝ → ℝ → ℝ := fun ξ τ => q ξ τ 0
  let u : ℝ → ℝ → ℝ := fun ξ τ => q ξ τ 1
  let L : ℝ → ℝ := fun ξ => acousticWaveStrengths 1 (1 / 2)
    (leveque03_acousticExamplePressure ξ) (leveque03_acousticExampleVelocity ξ) 0
  let R : ℝ → ℝ := fun ξ => acousticWaveStrengths 1 (1 / 2)
    (leveque03_acousticExamplePressure ξ) (leveque03_acousticExampleVelocity ξ) 1
  have hZ : 0 < acousticImpedance 1 (1 / 2) := by
    norm_num [acousticImpedance]
  have hform : ∀ ξ τ, linearAcousticsState p u ξ τ =
      L (ξ + (1 / 2) * τ) • linearAcousticsLeftEigenvector 1 (1 / 2) +
      R (ξ - (1 / 2) * τ) • linearAcousticsRightEigenvector 1 (1 / 2) := by
    intro ξ τ
    have hstate : linearAcousticsState p u ξ τ = q ξ τ := by
      funext j
      fin_cases j <;> rfl
    rw [hstate]
    change (linearAcousticsEigenvectorMatrix 1 (1 / 2)).mulVec
      ![L (ξ + (1 / 2) * τ), R (ξ - (1 / 2) * τ)] = _
    funext j
    fin_cases j
    · simp [linearAcousticsEigenvectorMatrix,
        linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
        Matrix.mulVec, dotProduct, Fin.sum_univ_two]
      ring
    · simp [linearAcousticsEigenvectorMatrix,
        linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
        Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  have h := Leveque02Tracer.acousticSolutionFromInitialData
    1 (1 / 2) p u L R hZ hform x t
  have hpinit (ξ : ℝ) : p ξ 0 = leveque03_acousticExamplePressure ξ := by
    exact congrFun (leveque03_acousticExampleInitialState ξ) 0
  have huinit (ξ : ℝ) : u ξ 0 = 0 := by
    exact congrFun (leveque03_acousticExampleInitialState ξ) 1
  rcases h with ⟨hp, hu⟩
  constructor
  · change p x t = _
    simpa [hpinit, huinit] using hp
  · change u x t = _
    simpa [hpinit, huinit, acousticImpedance] using hu

end NumStability
