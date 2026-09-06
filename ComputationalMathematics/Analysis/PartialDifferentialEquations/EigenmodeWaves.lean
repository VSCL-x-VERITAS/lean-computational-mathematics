/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Traveling eigenmodes of constant-coefficient systems

An eigenvector-valued translated scalar profile solves the associated
constant-coefficient system, and its eigenvalue is its translation speed.
-/

namespace NumStability

/-- A scalar translated profile carried by a fixed vector. -/
def eigenmodeTravelingWave {ι : Type*}
    (profile : ℝ → ℝ) (speed : ℝ) (eigenvector : ι → ℝ) :
    ℝ → ℝ → (ι → ℝ) :=
  fun x t => travelingWave profile speed x t • eigenvector

/-- If `r` is a right eigenvector of `A` with eigenvalue `λ`, every
differentiable scalar profile translated at speed `λ` and carried by `r`
solves `q_t + A q_x = 0` at the corresponding point. -/
theorem eigenmodeTravelingWave_isConstantCoefficientSolutionAt
    {ι : Type*} [Fintype ι]
    (coefficient : Matrix ι ι ℝ)
    {profile : ℝ → ℝ} {profile' speed : ℝ}
    (eigenvector : ι → ℝ) (x t : ℝ)
    (heigen : coefficient.mulVec eigenvector = speed • eigenvector)
    (hprofile : HasDerivAt profile profile' (x - speed * t)) :
    IsConstantCoefficientLinearSystemSolutionAt
      (eigenmodeTravelingWave profile speed eigenvector)
      coefficient x t := by
  rcases travelingWave_isLinearAdvectionSolutionAt speed x t hprofile with
    ⟨qt, qx, ht, hx, hresidual⟩
  refine ⟨qt • eigenvector, qx • eigenvector, ?_, ?_, ?_⟩
  · simpa [eigenmodeTravelingWave] using ht.smul_const eigenvector
  · simpa [eigenmodeTravelingWave] using hx.smul_const eigenvector
  · have hscaled := congrArg (fun a : ℝ => a • eigenvector) hresidual
    rw [Matrix.mulVec_smul, heigen]
    simpa [add_smul, smul_smul, mul_comm] using hscaled

end NumStability
