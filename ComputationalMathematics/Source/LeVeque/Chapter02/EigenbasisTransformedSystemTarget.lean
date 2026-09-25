/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import ComputationalMathematics.Source.LeVeque.Chapter02.RealEigenbasisDiagonalizationTarget

/-!
# Target for the eigenbasis-transformed constant-coefficient system
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.73): at a point where the actual time and space derivatives
exist, multiply the constant-coefficient system by the inverse eigenvector
matrix and insert `R R⁻¹` next to the space derivative. -/
def eigenbasisTransformedSystemTarget : Prop :=
  ∀ {ι : Type*} [Fintype ι] [DecidableEq ι]
      (coefficient : Matrix ι ι ℝ)
      (eigenvalues : ι → ℝ)
      (eigenbasis : Module.Basis ι ℝ (ι → ℝ)),
    (∀ p, coefficient.mulVec (eigenbasis p) =
      eigenvalues p • eigenbasis p) →
      ∀ (q : ℝ → ℝ → (ι → ℝ)) (x t : ℝ),
        IsConstantCoefficientLinearSystemSolutionAt q coefficient x t ↔
          let R := (Pi.basisFun ℝ ι).toMatrix eigenbasis
          ∃ qt qx : ι → ℝ,
            HasDerivAt (fun τ => q x τ) qt t ∧
              HasDerivAt (fun ξ => q ξ t) qx x ∧
                (R⁻¹).mulVec qt +
                  (R⁻¹ * coefficient * R).mulVec
                    ((R⁻¹).mulVec qx) = 0

end NumStability.Leveque02Tracer
