/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.SpecialFunctions.ExpDeriv
import Mathlib.Analysis.SpecialFunctions.Sqrt
import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic

/-!
# One-dimensional Gaussian heat kernel

The positive-time kernel for constant diffusion coefficient `diffusion`.
Analytic statements about this formula use `0 < diffusion` and `0 < time`.
-/

namespace NumStability

/-- The normalized Gaussian heat kernel in one space dimension. -/
noncomputable def gaussianHeatKernel (diffusion time displacement : ℝ) : ℝ :=
  Real.exp (-(displacement ^ 2) / (4 * diffusion * time)) /
    Real.sqrt (4 * Real.pi * diffusion * time)

end NumStability
