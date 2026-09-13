/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.LinearAdvection

/-!
# Straight characteristic values

LeVeque's discussion following (2.13) evaluates a translated profile on the
ray through `origin` with the prescribed constant velocity. This proof-free
target retains that ray and its value. It does not assert the PDE or a chain
rule for an arbitrary field. Applicability to nonsmooth profiles is submitted
to independent statement review.
-/

namespace NumStability.Leveque02Tracer

/-- A translated profile has its original value all along its straight ray. -/
def characteristicValueTarget : Prop :=
  ∀ (profile : ℝ → ℝ) (velocity origin t : ℝ),
    travelingWave profile velocity (origin + velocity * t) t = profile origin

end NumStability.Leveque02Tracer
