/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.CharacteristicPropagation
import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicVariablesTarget

/-!
# Target for propagation of characteristic variables
-/

namespace NumStability.Leveque02Tracer

/-- The prose following Equation (2.75): each characteristic component is
constant on its line `X(t) = x₀ + λᵢ t`, and the full system solution is the
sum of the corresponding eigenvector waves. The regularity needed for the
chain rule along each line is explicit. -/
def characteristicCurvePropagationTarget : Prop :=
  ∀ {m : ℕ}
      (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (eigenvalues : Fin m → ℝ)
      (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
    (∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p) →
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)),
        Differentiable ℝ (Function.uncurry q) →
        (∀ x t, IsConstantCoefficientLinearSystemSolutionAt
          q coefficient x t) →
        (∀ p x₀ t,
          (R⁻¹).mulVec (q (x₀ + eigenvalues p * t) t) p =
            (R⁻¹).mulVec (q x₀ 0) p) ∧
          ∀ x t, q x t =
            ∑ p, ((R⁻¹).mulVec
              (q (x - eigenvalues p * t) 0) p) • eigenbasis p

end NumStability.Leveque02Tracer
