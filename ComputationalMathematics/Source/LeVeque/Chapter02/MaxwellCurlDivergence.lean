/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.MaxwellConstraintPropagationModel
import Mathlib.Tactic

/-!
# Divergence of a Cartesian curl under commuting mixed partials
-/

namespace NumStability.Leveque02Tracer

/-- A scalar multiple of curl has zero divergence when the three relevant
pairs of mixed spatial partials agree. -/
theorem maxwellScaledCurl_divergence_zero
    (scale : ℝ) (field : MaxwellField) (position : MaxwellVector) (time : ℝ)
    (hmixed : HasMaxwellMixedSpatialPartialsAt field position time) :
    maxwellDivergence (maxwellScaledCurlField scale field) position time = 0 := by
  rcases hmixed with ⟨a, b, c, h21, h20, h12, h10, h02, h01⟩
  have h0 : maxwellSpatialPartial (maxwellScaledCurlField scale field)
      0 0 position time = scale * (a - b) := by
    change deriv (fun s => scale *
      (maxwellSpatialPartial field 2 1 (Function.update position 0 s) time -
        maxwellSpatialPartial field 1 2 (Function.update position 0 s) time))
      (position 0) = scale * (a - b)
    exact ((h21.sub h12).const_mul scale).deriv
  have h1 : maxwellSpatialPartial (maxwellScaledCurlField scale field)
      1 1 position time = scale * (c - a) := by
    change deriv (fun s => scale *
      (maxwellSpatialPartial field 0 2 (Function.update position 1 s) time -
        maxwellSpatialPartial field 2 0 (Function.update position 1 s) time))
      (position 1) = scale * (c - a)
    exact ((h02.sub h20).const_mul scale).deriv
  have h2 : maxwellSpatialPartial (maxwellScaledCurlField scale field)
      2 2 position time = scale * (b - c) := by
    change deriv (fun s => scale *
      (maxwellSpatialPartial field 1 0 (Function.update position 2 s) time -
        maxwellSpatialPartial field 0 1 (Function.update position 2 s) time))
      (position 2) = scale * (b - c)
    exact ((h10.sub h01).const_mul scale).deriv
  unfold maxwellDivergence
  rw [h0, h1, h2]
  ring

end NumStability.Leveque02Tracer
