/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcousticsWaveEquation
import ComputationalMathematics.Source.LeVeque.Chapter01.Equation05

/-!
# LeVeque Chapter 1, Equation (1.7)

Randall J. LeVeque, *Finite Volume Methods for Hyperbolic Problems*, Chapter 1,
printed page 3 (raw PDF page 25), equation (1.7).
-/

namespace NumStability

/-- Under explicit second-derivative and mixed-partial hypotheses, eliminating
velocity from (1.5) yields `p_tt = c² p_xx` for
`c = sqrt (K / ρ)`. -/
theorem leveque01_equation07_pressureWave
    {bulkModulus density : ℝ}
    (system : LinearAcousticsSolution bulkModulus density)
    (hbulkModulus : 0 < bulkModulus) (hdensity : 0 < density)
    (x t ptt pxx uxt utx : ℝ)
    (hptt : HasDerivAt
      (fun τ => partialTimeDerivative system.pressure x τ) ptt t)
    (huxt : HasDerivAt
      (fun τ => partialSpaceDerivative system.velocity x τ) uxt t)
    (hutx : HasDerivAt
      (fun ξ => partialTimeDerivative system.velocity ξ t) utx x)
    (hpxx : HasDerivAt
      (fun ξ => partialSpaceDerivative system.pressure ξ t) pxx x)
    (hmixed : uxt = utx) :
    ptt = (Real.sqrt (bulkModulus / density)) ^ 2 * pxx := by
  have hwave := system.pressureSecondOrderWaveAt
    x t ptt pxx uxt utx hptt huxt hutx hpxx hmixed
  rw [Real.sq_sqrt (div_nonneg hbulkModulus.le hdensity.le)]
  exact hwave

end NumStability
