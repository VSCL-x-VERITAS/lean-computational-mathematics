/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.HeterogeneousAcousticsLocalSpeedsTarget
import ComputationalMathematics.Source.LeVeque.Chapter02.StationaryAcousticsEigenvalues

/-!
# LeVeque Chapter 2: HeterogeneousAcousticsLocalSpeeds

Proof of pointwise characteristic speeds for heterogeneous acoustics.
-/

namespace NumStability.Leveque02Tracer

theorem heterogeneousAcousticsLocalSpeeds :
    heterogeneousAcousticsLocalSpeedsTarget := by
  intro bulkModulus density x hbulk hdensity
  exact stationaryAcousticsEigenvalues (bulkModulus x) (density x) hbulk hdensity

end NumStability.Leveque02Tracer
