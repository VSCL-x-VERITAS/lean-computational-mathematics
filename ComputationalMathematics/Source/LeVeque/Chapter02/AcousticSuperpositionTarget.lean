/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# General solution of stationary linear acoustics
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.62): within the global jointly differentiable classical
solution class, the stationary acoustic system is equivalent to a
superposition of left- and right-going scalar profiles along its two
normalized eigenvectors. -/
def acousticSuperpositionTarget : Prop :=
  ∀ (bulkModulus density : ℝ),
    0 < bulkModulus → 0 < density →
      let soundSpeed := Real.sqrt (bulkModulus / density)
      ∀ (pressure velocity : ℝ → ℝ → ℝ),
        Differentiable ℝ
            (Function.uncurry (linearAcousticsState pressure velocity)) →
          ((∀ x t, IsLinearAcousticsSolutionAt
              pressure velocity bulkModulus density x t) ↔
            ∃ leftProfile rightProfile : ℝ → ℝ,
              Differentiable ℝ leftProfile ∧
                Differentiable ℝ rightProfile ∧
                  ∀ x t,
                    linearAcousticsState pressure velocity x t =
                      leftProfile (x + soundSpeed * t) •
                          linearAcousticsLeftEigenvector density soundSpeed +
                        rightProfile (x - soundSpeed * t) •
                          linearAcousticsRightEigenvector density soundSpeed)

end NumStability.Leveque02Tracer
