/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PressureExpansionTarget
import Mathlib.Analysis.Calculus.Deriv.Add
import Mathlib.Analysis.Calculus.Deriv.Mul

/-!
# Pressure first variation
-/

namespace NumStability.Leveque02Tracer

/-- The derivative form of the pressure expansion preceding equation (2.48). -/
theorem pressureExpansion : pressureExpansionTarget := by
  intro pressureLaw densityBackground pressureSlope densityPerturbation _hdensity hpressure
  have hline : HasDerivAt
      (fun amplitude : ℝ => densityBackground + amplitude * densityPerturbation)
      densityPerturbation 0 := by
    convert (hasDerivAt_const (0 : ℝ) densityBackground).add
      ((hasDerivAt_id (0 : ℝ)).mul_const densityPerturbation) using 1
    all_goals simp
  have hpressureAt : HasDerivAt pressureLaw pressureSlope
      (densityBackground + (0 : ℝ) * densityPerturbation) := by
    simpa using hpressure
  exact hpressureAt.comp 0 hline

end NumStability.Leveque02Tracer
