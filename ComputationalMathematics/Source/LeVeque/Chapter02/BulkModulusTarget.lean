/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.Calculus.Deriv.Basic
import ComputationalMathematics.Source.LeVeque.Chapter02.BulkModulusModel

/-!
# Bulk modulus at a constant fluid background
-/

namespace NumStability.Leveque02Tracer

/-- Equation (2.49): at a positive background density, the bulk modulus is
the density times the actual pressure-law derivative. -/
def bulkModulusTarget : Prop :=
  ∀ (pressureLaw : ℝ → ℝ) (densityBackground pressureSlope : ℝ),
    0 < densityBackground →
    HasDerivAt pressureLaw pressureSlope densityBackground →
    acousticBulkModulus pressureLaw densityBackground =
      densityBackground * pressureSlope

end NumStability.Leveque02Tracer
