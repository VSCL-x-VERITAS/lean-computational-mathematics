/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.Matrix.Spectrum

/-!
# Target for symmetric and strict hyperbolicity criteria
-/

namespace NumStability.Leveque02Tracer

/-- The final paragraph of printed page 32: a real symmetric coefficient
matrix has a complete real eigenbasis; a real matrix with a full family of
distinct real eigenvalues and corresponding nonzero eigenvectors has linearly
independent eigenvectors and is hyperbolic. -/
def symmetricStrictHyperbolicityTarget : Prop :=
  (∀ {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ),
    coefficient.transpose = coefficient →
      IsRealHyperbolicMatrix coefficient) ∧
  (∀ {m : ℕ} (coefficient : Matrix (Fin m) (Fin m) ℝ)
      (eigenvalues : Fin m → ℝ)
      (eigenvectors : Fin m → (Fin m → ℝ)),
    Function.Injective eigenvalues →
    (∀ p, eigenvectors p ≠ 0) →
    (∀ p, coefficient.mulVec (eigenvectors p) =
      eigenvalues p • eigenvectors p) →
    LinearIndependent ℝ eigenvectors ∧
      IsRealHyperbolicMatrix coefficient)

end NumStability.Leveque02Tracer
