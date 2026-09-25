/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.NonlinearPWaveStressModel
import ComputationalMathematics.Source.LeVeque.Chapter02.PlaneNormalStressModel
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Proof-free target for small-strain nonlinear normal-stress linearization

The local approximation uses a stress-free reference state. The source's
cross-reference to (2.90) points to the normal-stress law in (2.89).
-/

namespace NumStability.Leveque02Tracer

open scoped Topology

/-- At a stress-free reference state, a differentiable constitutive law with
positive slope `λ+2μ` has the printed linear elastic normal stress as its
first-order approximation near zero strain. -/
def nonlinearStressLinearizationTarget : Prop :=
  ∀ (stressLaw : ℝ → ℝ) (lameLambda shearModulus : ℝ),
    0 < lameLambda + 2 * shearModulus →
    stressLaw 0 = 0 →
    HasDerivAt stressLaw (lameLambda + 2 * shearModulus) 0 →
      deriv stressLaw 0 = lameLambda + 2 * shearModulus ∧
        (fun strain : ℝ =>
          stressLaw strain - (lameLambda + 2 * shearModulus) * strain)
          =o[𝓝 0] (fun strain : ℝ => strain)

end NumStability.Leveque02Tracer
