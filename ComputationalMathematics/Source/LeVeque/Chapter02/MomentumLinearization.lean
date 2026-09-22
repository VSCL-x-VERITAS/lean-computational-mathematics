/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumExpansion
import ComputationalMathematics.Source.LeVeque.Chapter02.MomentumLinearizationTarget

/-!
# Linearized momentum perturbation
-/

namespace NumStability.Leveque02Tracer

/-- The first variation of `rho*u` is `u0*rhotilde + rho0*utilde`. -/
theorem momentumLinearization : momentumLinearizationTarget := by
  intro densityBackground velocityBackground densityPerturbation velocityPerturbation
  have hdensity : HasDerivAt
      (fun amplitude : ℝ => densityBackground + amplitude * densityPerturbation)
      densityPerturbation 0 := by
    simpa only [one_smul] using
      ((hasDerivAt_id (x := (0 : ℝ))).smul_const densityPerturbation).const_add
        densityBackground
  have hvelocity : HasDerivAt
      (fun amplitude : ℝ => velocityBackground + amplitude * velocityPerturbation)
      velocityPerturbation 0 := by
    simpa only [one_smul] using
      ((hasDerivAt_id (x := (0 : ℝ))).smul_const velocityPerturbation).const_add
        velocityBackground
  convert hdensity.mul hvelocity using 1
  all_goals ring

end NumStability.Leveque02Tracer
