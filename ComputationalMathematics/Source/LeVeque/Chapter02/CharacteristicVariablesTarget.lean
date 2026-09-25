/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearSystems.EigenbasisCoordinates
import ComputationalMathematics.Source.LeVeque.Chapter02.RealEigenbasisDiagonalizationTarget

/-!
# Target for the characteristic-variable system
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.74): for a fixed complete real eigenbasis, the pointwise
system in `q` is equivalent to the diagonal system in the characteristic
variables `w = R⁻¹ q`, with the eigenvalues paired to the columns of `R`. -/
def characteristicVariablesTarget : Prop :=
  ∀ {m : ℕ}
      (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (eigenvalues : Fin m → ℝ)
      (eigenbasis : Module.Basis (Fin m) ℝ (Fin m → ℝ)),
    (∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p) →
      let R := (Pi.basisFun ℝ (Fin m)).toMatrix eigenbasis
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q coefficient x t ↔
          IsConstantCoefficientLinearSystemSolutionAt
            (fun ξ τ => (R⁻¹).mulVec (q ξ τ))
            (Matrix.diagonal eigenvalues) x t

end NumStability.Leveque02Tracer
