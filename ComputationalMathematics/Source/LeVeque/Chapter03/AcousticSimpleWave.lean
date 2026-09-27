/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter03.AcousticInitialData
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Transport.UniformAdvection

/-!
# A right-moving acoustic simple wave

Printed page 50/raw PDF page 72. If the left-going strength is constant,
only the right-going profile varies. The translated state exists for arbitrary
initial data; differentiable data give the classical vector advection PDE.
-/

namespace NumStability

/-- Constant left strength reduces the two-wave state to a constant left
eigenvector component and a translated right eigenvector component. -/
theorem leveque03_acousticSimpleWave_formula
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (leftConstant : ℝ)
    (hleft : ∀ ξ, acousticWaveStrengths density soundSpeed
      (initialPressure ξ) (initialVelocity ξ) 0 = leftConstant)
    (x t : ℝ) :
    leveque03_acousticInitialDataSolution density soundSpeed
      initialPressure initialVelocity x t =
    leftConstant • linearAcousticsLeftEigenvector density soundSpeed +
      (acousticWaveStrengths density soundSpeed
        (initialPressure (x - soundSpeed * t))
        (initialVelocity (x - soundSpeed * t)) 1) •
        linearAcousticsRightEigenvector density soundSpeed := by
  let R := linearAcousticsEigenvectorMatrix density soundSpeed
  have hsum (a b : ℝ) : R.mulVec ![a, b] =
      a • linearAcousticsLeftEigenvector density soundSpeed +
      b • linearAcousticsRightEigenvector density soundSpeed := by
    funext j
    fin_cases j
    · simp [R, linearAcousticsEigenvectorMatrix,
        linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
        Matrix.mulVec, dotProduct, Fin.sum_univ_two]
      ring
    · simp [R, linearAcousticsEigenvectorMatrix,
        linearAcousticsLeftEigenvector, linearAcousticsRightEigenvector,
        Matrix.mulVec, dotProduct, Fin.sum_univ_two]
  change R.mulVec ![_, _] = _
  rw [hsum, hleft]

/-- The resulting state travels uniformly to the right at the sound speed,
including when the varying initial profile is nonsmooth. -/
theorem leveque03_acousticSimpleWave_uniformAdvection
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (leftConstant : ℝ)
    (hleft : ∀ ξ, acousticWaveStrengths density soundSpeed
      (initialPressure ξ) (initialVelocity ξ) 0 = leftConstant) :
    IsUniformAdvection
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity) soundSpeed := by
  intro x t
  rw [leveque03_acousticSimpleWave_formula density soundSpeed
      initialPressure initialVelocity leftConstant hleft (x + soundSpeed * t) t,
    leveque03_acousticSimpleWave_formula density soundSpeed
      initialPressure initialVelocity leftConstant hleft x 0]
  simp [show x + soundSpeed * t - soundSpeed * t = x by ring]

/-- With differentiable initial data the full acoustic state satisfies the
one-way vector equation `qₜ + c₀qₓ = 0`. -/
theorem leveque03_acousticSimpleWave_classicalAdvection
    (density soundSpeed : ℝ) (initialPressure initialVelocity : ℝ → ℝ)
    (leftConstant : ℝ)
    (hleft : ∀ ξ, acousticWaveStrengths density soundSpeed
      (initialPressure ξ) (initialVelocity ξ) 0 = leftConstant)
    (hZ : 0 < acousticImpedance density soundSpeed)
    (hdiff : Differentiable ℝ (fun ξ => ![initialPressure ξ, initialVelocity ξ])) :
    IsLinearAdvectionSolution
      (leveque03_acousticInitialDataSolution density soundSpeed
        initialPressure initialVelocity) soundSpeed := by
  have htransport := leveque03_acousticSimpleWave_uniformAdvection
    density soundSpeed initialPressure initialVelocity leftConstant hleft
  apply htransport.isLinearAdvectionSolution
  have hzero : (fun ξ => leveque03_acousticInitialDataSolution density soundSpeed
      initialPressure initialVelocity ξ 0) =
      (fun ξ => ![initialPressure ξ, initialVelocity ξ]) := by
    funext ξ
    exact leveque03_acousticInitialDataSolution_initial
      density soundSpeed initialPressure initialVelocity hZ ξ
  rw [hzero]
  exact hdiff

end NumStability
