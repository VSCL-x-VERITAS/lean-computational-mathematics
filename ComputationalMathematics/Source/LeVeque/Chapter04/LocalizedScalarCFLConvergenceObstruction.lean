/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.TwoPointFluxScalarObservation

/-!
# LeVeque Chapter 4: localized scalar CFL convergence obstruction

The adopted scalar qualification records both failure of limiting-domain
containment and nonconvergence on continuous compactly supported data. It uses
the actual exact left-cell means and `n + 1` numerical updates for an arbitrary
fixed two-point flux. The broader printed norm-instability wording has no
arbitrary-flux norm-instability interpretation supplied by this result.
-/

open Filter
open scoped Topology

namespace NumStability

/-- The adopted scalar convergence/domain formulation of the Chapter 4 claim.
The flux precedes all initial-data quantifiers and has no additional premises. -/
def Leveque04LocalizedScalarCFLConvergenceObstructionTarget : Prop :=
  ∀ (speed origin T ratio : ℝ) (numericalFlux : ℝ → ℝ → ℝ),
    0 < speed → 0 < T → 0 < ratio → 1 < speed * ratio →
    (origin - speed * T ∉ Set.Icc (origin - T / ratio) (origin + T / ratio)) ∧
      ¬ (∀ profile : ℝ → ℝ, Continuous profile → HasCompactSupport profile →
        Tendsto (fun n =>
          centeredRefinementApproximation (twoPointFluxRefinementUpdate T ratio numericalFlux)
            (fun n f => fixedRatioLeftCellMeans origin T ratio f n) n profile)
          atTop (𝓝 (profile (origin - speed * T))))

/-- The source correspondence follows from the reusable finite-volume result. -/
theorem leveque04_localizedScalarCFLConvergenceObstruction :
    Leveque04LocalizedScalarCFLConvergenceObstructionTarget :=
  twoPointFluxScalarObservation_cflObstruction

end NumStability
