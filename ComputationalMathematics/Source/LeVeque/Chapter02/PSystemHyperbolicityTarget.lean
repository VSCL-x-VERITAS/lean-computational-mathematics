/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.Calculus.Deriv.Basic
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.LinearAlgebra.Matrix.Notation

/-!
# Proof-free target for hyperbolicity of the p-system

For the state order `(V,u)`, the flux of `Vₜ-uₓ=0`,
`uₜ+p(V)ₓ=0` is `(-u,p(V))`. Its pointwise Jacobian is the
displayed two-by-two matrix. The positive-volume domain is the
physical gas domain on printed page 43.
-/

namespace NumStability.Leveque02Tracer

/-- A differentiable pressure law with negative slope at positive specific
volume gives the p-system's flux Jacobian a full real eigenbasis, with real
wave speeds of opposite sign. -/
def pSystemHyperbolicityTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (specificVolume pressureSlope : ℝ),
    0 < specificVolume →
    HasDerivAt pressureLaw pressureSlope specificVolume →
    pressureSlope < 0 →
    let waveSpeed := Real.sqrt (-pressureSlope)
    let fluxJacobian : Matrix (Fin 2) (Fin 2) ℝ :=
      !![0, -1; pressureSlope, 0]
    0 < waveSpeed ∧
      IsRealHyperbolicMatrix fluxJacobian

end NumStability.Leveque02Tracer
