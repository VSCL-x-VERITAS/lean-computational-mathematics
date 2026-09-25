/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.Hyperbolicity
import Mathlib.Analysis.Calculus.Deriv.Basic

/-!
# Frozen symbol for a nonlinear plane-wave Maxwell reduction

For scalar constitutive responses `D(E) = ε(E) E` and `B(H) = μ(H) H`,
the one-dimensional transverse equations have local quasilinear symbol
`[[0, 1 / D'(E)], [1 / B'(H), 0]]` in the `(E,H)` variables. This is a
local algebraic symbol, not a global existence assertion for the PDE.
-/

namespace NumStability.Leveque02Tracer

/-- Differential electric-displacement response at a field state. -/
noncomputable def electricConstitutiveSlope
    (permittivity : ℝ → ℝ) (electricField : ℝ) : ℝ :=
  deriv (fun e => permittivity e * e) electricField

/-- Differential magnetic-induction response at a field state. -/
noncomputable def magneticConstitutiveSlope
    (permeability : ℝ → ℝ) (magneticField : ℝ) : ℝ :=
  deriv (fun h => permeability h * h) magneticField

/-- Frozen transverse plane-wave symbol in the field variables. -/
noncomputable def frozenNonlinearMaxwellMatrix
    (permittivity permeability : ℝ → ℝ)
    (electricField magneticField : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![0, (electricConstitutiveSlope permittivity electricField)⁻¹;
     (magneticConstitutiveSlope permeability magneticField)⁻¹, 0]

end NumStability.Leveque02Tracer
