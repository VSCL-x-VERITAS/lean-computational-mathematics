/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.BalanceLaw
import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Data.Matrix.Mul

/-!
# Matrix form of reacting species with a common velocity

All species share the same constant advective velocity. The coefficient
matrix is diagonal with that velocity in every diagonal entry, and the
chemical kinetics appear in the source vector. The actual balance equation
has the stated matrix form, whose principal matrix is real hyperbolic.
-/

namespace NumStability.Leveque02Tracer

/-- The common-velocity reacting system has a diagonal hyperbolic principal matrix. -/
def reactionMatrixTarget : Prop :=
  ∀ (m : ℕ) (velocity : ℝ),
    let coefficient : Matrix (Fin m) (Fin m) ℝ := Matrix.diagonal (fun _ => velocity)
    IsRealHyperbolicMatrix coefficient ∧
      ∀ (q : ℝ → ℝ → (Fin m → ℝ)) (production : (Fin m → ℝ) → (Fin m → ℝ))
        (spatialDerivative : Fin m → ℝ) (x t : ℝ),
        HasDerivAt (fun ξ => q ξ t) spatialDerivative x →
        (IsBalanceLawSolutionAt q (fun state => velocity • state) (production (q x t)) x t ↔
          ∃ timeDerivative : Fin m → ℝ,
            HasDerivAt (fun τ => q x τ) timeDerivative t ∧
            timeDerivative + coefficient.mulVec spatialDerivative = production (q x t))

end NumStability.Leveque02Tracer
