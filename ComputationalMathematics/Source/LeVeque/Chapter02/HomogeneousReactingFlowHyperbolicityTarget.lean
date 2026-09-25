/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.ReactingFlow
import ComputationalMathematics.Source.LeVeque.Chapter02.SymmetricStrictHyperbolicity
import Mathlib.LinearAlgebra.Eigenspace.Matrix

/-!
# LeVeque Chapter 2: homogeneous radioactive conversion system

The two species share one advection speed. Setting the reaction rate to zero
leaves a scalar multiple of the identity as the principal matrix.
-/

namespace NumStability.Leveque02Tracer

/-- Principal matrix of the two-species system (2.29) at reaction rate zero. -/
def homogeneousReactingFlowCoefficient (velocity : ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  Matrix.diagonal (fun _ => velocity)

/-- The homogeneous two-species coefficient is symmetric hyperbolic. Its
only characteristic speed is the repeated velocity, so it is not strictly
hyperbolic in the distinct-speed sense. -/
def homogeneousReactingFlowHyperbolicityTarget : Prop :=
  ∀ velocity : ℝ,
    let coefficient := homogeneousReactingFlowCoefficient velocity
    (∀ (q : ℝ → ℝ → (Fin 2 → ℝ)) (spaceDerivative : Fin 2 → ℝ)
        (x t : ℝ),
      HasDerivAt (fun ξ => q ξ t) spaceDerivative x →
        (IsBalanceLawSolutionAt q (fun state => velocity • state) 0 x t ↔
          IsConstantCoefficientLinearSystemSolutionAt q coefficient x t)) ∧
    (∀ state : Fin 2 → ℝ,
      coefficient.mulVec state = velocity • state) ∧
      coefficient.transpose = coefficient ∧
        IsRealHyperbolicMatrix coefficient ∧
          (∀ speed : ℝ,
            Module.End.HasEigenvalue (Matrix.toLin' coefficient) speed ↔
              speed = velocity) ∧
            ¬ ∃ speeds : Fin 2 → ℝ,
              Function.Injective speeds ∧
                ∀ p, Module.End.HasEigenvalue
                  (Matrix.toLin' coefficient) (speeds p)

end NumStability.Leveque02Tracer
