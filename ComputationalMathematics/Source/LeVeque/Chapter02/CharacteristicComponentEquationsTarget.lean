/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.CharacteristicVariablesTarget

/-!
# Target for the component equations in characteristic variables
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.75): with `w = R⁻¹ q` and `Λ` diagonal, the vector equation
from (2.74) is equivalent to the independent scalar advection equations for
each component of `w`. -/
def characteristicComponentEquationsTarget : Prop :=
  ∀ {m : ℕ}
      (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (eigenvalues : Fin m → ℝ)
      (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
    (∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p) →
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        let w := fun ξ τ => (R⁻¹).mulVec (q ξ τ)
        IsConstantCoefficientLinearSystemSolutionAt
            w (Matrix.diagonal eigenvalues) x t ↔
          ∀ p, IsLinearAdvectionSolutionAt
            (fun ξ τ => w ξ τ p) (eigenvalues p) x t

end NumStability.Leveque02Tracer
