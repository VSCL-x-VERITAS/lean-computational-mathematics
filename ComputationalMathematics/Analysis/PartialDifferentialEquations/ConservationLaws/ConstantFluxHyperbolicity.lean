/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Hyperbolicity
import Mathlib.Analysis.Calculus.FDeriv.Const
import Mathlib.LinearAlgebra.StdBasis

/-!
# Hyperbolicity of constant fluxes

A constant flux has its actual zero derivative and a complete real standard eigenbasis.
The domain may be any supplied set of finite real vector states.
-/

namespace NumStability

/-- A constant flux has its actual zero derivative and a complete real
standard eigenbasis; no strict separation of wave speeds is needed. -/
theorem constantFlux_isHyperbolicOn {m : ℕ}
    (constant : Fin m → ℝ) (states : Set (Fin m → ℝ)) :
    IsHyperbolicFluxOn (fun _ : Fin m → ℝ => constant) states := by
  intro state _
  refine ⟨0, hasFDerivAt_const constant state, fun _ => 0, Pi.basisFun ℝ (Fin m), ?_⟩
  intro p
  simp [Matrix.col]
  rfl

end NumStability
