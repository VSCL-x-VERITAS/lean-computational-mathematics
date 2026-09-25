/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.LongitudinalKinematicsModel

/-!
# Nonlinear constitutive normal stress for one-dimensional P-waves
-/

namespace NumStability.Leveque02Tracer

/-- An arbitrary stress-strain law evaluated at the longitudinal strain. -/
noncomputable def nonlinearPWaveStress
    (stressLaw : ℝ → ℝ) (X : ℝ → ℝ → ℝ) (x t : ℝ) : ℝ :=
  stressLaw (longitudinalStrain X x t)

end NumStability.Leveque02Tracer
