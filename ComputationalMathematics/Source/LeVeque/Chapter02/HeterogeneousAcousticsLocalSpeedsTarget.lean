/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsEigenvaluesTarget

/-!
# LeVeque Chapter 2: HeterogeneousAcousticsLocalSpeedsTarget

Target for pointwise heterogeneous-acoustic characteristic speeds.
-/

namespace NumStability.Leveque02Tracer

def heterogeneousAcousticsLocalSpeedsTarget : Prop :=
  ∀ (bulkModulus density : ℝ → ℝ) (x : ℝ),
    0 < bulkModulus x → 0 < density x →
      let soundSpeed := Real.sqrt (bulkModulus x / density x)
      Module.End.HasEigenvalue
        (Matrix.toLin' (linearAcousticsMatrix (bulkModulus x) (density x)))
        (-soundSpeed) ∧
      Module.End.HasEigenvalue
        (Matrix.toLin' (linearAcousticsMatrix (bulkModulus x) (density x)))
        soundSpeed

end NumStability.Leveque02Tracer
