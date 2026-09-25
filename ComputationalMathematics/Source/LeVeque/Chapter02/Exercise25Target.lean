/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# Proof-free target: Exercise 2.5

The printed exercise calls the nonlinear elastic system (2.91). Its explicit
nonlinear stress closure is (2.97): strain and velocity have coefficient
`[[0,-1],[-σ'(ε)/ρ,0]]`. This target states the exact stress-slope condition
for a full real eigenbasis and the resulting signed wave speeds.
-/

namespace NumStability.Leveque02Tracer

/-- The pointwise quasilinear coefficient of the nonlinear P-wave system. -/
noncomputable def nonlinearElasticCoefficient (density stressSlope : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, -1; -(stressSlope / density), 0]

/-- For positive material density, the nonlinear elastic system has a full
real eigenbasis exactly when the actual stress derivative is positive. -/
def exercise25Target : Prop :=
  ∀ (stressLaw : ℝ → ℝ) (density strain stressSlope : ℝ),
    0 < density →
    HasDerivAt stressLaw stressSlope strain →
      let coefficient := nonlinearElasticCoefficient density stressSlope
      (IsRealHyperbolicMatrix coefficient ↔ 0 < stressSlope) ∧
      (0 < stressSlope →
        let speed := Real.sqrt (stressSlope / density)
        0 < speed ∧
        Module.End.HasEigenvalue (Matrix.toLin' coefficient) (-speed) ∧
        Module.End.HasEigenvalue (Matrix.toLin' coefficient) speed)

end NumStability.Leveque02Tracer
