/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target: field dependence does not guarantee hyperbolicity

For a transverse plane wave with `μ=1`, the scalar constitutive response
`D(e)=ε(e)e` enters the Maxwell equations as `D'(e)eₜ+hₓ=0` and
`hₜ+eₓ=0`. A positive but decreasing differential response can make its
frozen two-state symbol nonhyperbolic.
-/

namespace NumStability.Leveque02Tracer

/-- A smooth, positive, genuinely field-dependent permittivity has negative
differential response at `e=2`; the corresponding two-state plane-wave
Maxwell symbol has no complete real eigenbasis. -/
def nonlinearMaxwellHyperbolicityCounterexampleTarget : Prop :=
  let permittivity : ℝ → ℝ := fun e => 1 / (1 + e ^ 2)
  let displacement : ℝ → ℝ := fun e => permittivity e * e
  let frozenSymbol : Matrix (Fin 2) (Fin 2) ℝ :=
    !![0, 1 / deriv displacement 2; 1, 0]
  (∀ e : ℝ, 0 < permittivity e) ∧
  permittivity 0 ≠ permittivity 2 ∧
  HasDerivAt displacement (-3 / 25) 2 ∧
  deriv displacement 2 = -3 / 25 ∧
  frozenSymbol = !![0, -25 / 3; 1, 0] ∧
  ¬ NumStability.IsRealHyperbolicMatrix frozenSymbol

end NumStability.Leveque02Tracer
