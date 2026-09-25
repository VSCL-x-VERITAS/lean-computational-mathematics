/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAcoustics

/-!
# Target for strict hyperbolicity of stationary acoustics
-/

namespace NumStability.Leveque02Tracer

/-- The stationary linear-acoustics matrix has two distinct real sound speeds,
an independent pair of corresponding eigenvectors, and a complete real
eigenbasis when the material coefficients are positive. -/
def stationaryAcousticsStrictHyperbolicityTarget : Prop :=
  ∀ (bulkModulus density : ℝ), 0 < bulkModulus → 0 < density →
    let soundSpeed := Real.sqrt (bulkModulus / density)
    let coefficient := linearAcousticsMatrix bulkModulus density
    let eigenvalues : Fin 2 → ℝ := ![-soundSpeed, soundSpeed]
    let eigenvectors : Fin 2 → (Fin 2 → ℝ) :=
      ![linearAcousticsLeftEigenvector density soundSpeed,
        linearAcousticsRightEigenvector density soundSpeed]
    0 < soundSpeed ∧
      Function.Injective eigenvalues ∧
      (∀ p, coefficient.mulVec (eigenvectors p) =
        eigenvalues p • eigenvectors p) ∧
      LinearIndependent ℝ eigenvectors ∧
      IsRealHyperbolicMatrix coefficient

end NumStability.Leveque02Tracer
