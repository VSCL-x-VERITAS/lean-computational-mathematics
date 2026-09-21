/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaw
import Mathlib.Analysis.Calculus.ContDiff.Basic
import Mathlib.LinearAlgebra.Matrix.ToLin

/-!
# Smooth positive-dimensional quasilinear Jacobian form
-/

namespace NumStability.Leveque02Tracer

open scoped ContDiff

/-- Equation (2.41) for a smooth state of a nonempty conservation-law system. -/
def smoothQuasilinearMatrixTarget : Prop :=
  ∀ (m : ℕ), 0 < m → ∀ (q : ℝ → ℝ → (Fin m → ℝ))
    (flux : (Fin m → ℝ) → (Fin m → ℝ))
    (derivative : (Fin m → ℝ) →L[ℝ] (Fin m → ℝ)),
    ContDiff ℝ ∞ (Function.uncurry q) →
    ∀ (x t : ℝ) (qx : Fin m → ℝ),
    HasDerivAt (fun ξ => q ξ t) qx x →
    HasFDerivAt flux derivative (q x t) →
    (IsConservationLawSolutionAt q flux x t ↔
      ∃ qt : Fin m → ℝ, HasDerivAt (fun τ => q x τ) qt t ∧
        qt + (LinearMap.toMatrix' derivative.toLinearMap).mulVec qx = 0)

end NumStability.Leveque02Tracer
