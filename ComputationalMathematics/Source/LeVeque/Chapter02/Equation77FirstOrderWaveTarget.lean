/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.ConstantCoefficientLinearSystem
import Mathlib.Data.Fin.VecNotation
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# LeVeque Chapter 2, Equation (2.77): first-order form of the wave equation

This proof-free contract identifies the two state components with the actual
first partial derivatives of a scalar wave field. The second partials and their
mixed-partial equality are explicit hypotheses.
-/

namespace NumStability.Leveque02Tracer

/-- A scalar wave field with `pₜₜ = c₀² pₓₓ` gives the first-order system
`qₜ + Ã qₓ = 0`, where `q = (pₜ, -pₓ)` and
`Ã = !![0, c₀²; 1, 0]`. -/
def equation77FirstOrderWaveTarget : Prop :=
  ∀ (c₀ : ℝ) (pressure pressureTime pressureSpace : ℝ → ℝ → ℝ),
    0 < c₀ →
      (∀ x t,
        HasDerivAt (fun τ => pressure x τ) (pressureTime x t) t ∧
          HasDerivAt (fun ξ => pressure ξ t) (pressureSpace x t) x) →
        ∀ (x t ptt pxx ptx pxt : ℝ),
          HasDerivAt (fun τ => pressureTime x τ) ptt t →
            HasDerivAt (fun ξ => pressureSpace ξ t) pxx x →
              HasDerivAt (fun ξ => pressureTime ξ t) ptx x →
                HasDerivAt (fun τ => pressureSpace x τ) pxt t →
                  ptt = c₀ ^ 2 * pxx →
                    ptx = pxt →
                      IsConstantCoefficientLinearSystemSolutionAt
                        (fun ξ τ => ![pressureTime ξ τ, -pressureSpace ξ τ])
                        (!![0, c₀ ^ 2; 1, 0]) x t

end NumStability.Leveque02Tracer
