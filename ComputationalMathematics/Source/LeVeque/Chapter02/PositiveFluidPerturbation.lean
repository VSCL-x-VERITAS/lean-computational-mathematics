/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.PositiveFluidPerturbationTarget

/-!
# Exact background and perturbation coordinates
-/

namespace NumStability.Leveque02Tracer

/-- The state decomposes into its constant background and perturbation. -/
theorem positiveFluidPerturbation : positiveFluidPerturbationTarget := by
  intro densityBackground velocityBackground state x t _hDensity
  refine ⟨?_, rfl, rfl⟩
  unfold fluidPerturbation
  rw [← add_sub_assoc, add_sub_cancel_left]

end NumStability.Leveque02Tracer
