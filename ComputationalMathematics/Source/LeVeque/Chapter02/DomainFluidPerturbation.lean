/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.DomainFluidPerturbationTarget

/-!
# Exact background and perturbation coordinates

Reuse additive cancellation on the supplied state and space-time domains.
The second deviation is momentum, and no evolution approximation is made.
-/

namespace NumStability.Leveque02Tracer

/-- The physical-domain state decomposes into its background and perturbation. -/
theorem domainFluidPerturbation : domainFluidPerturbationTarget := by
  intro admissibleStates spaceTimeDomain densityBackground velocityBackground _hbackground state location
  refine ⟨?_, rfl, rfl⟩
  unfold fluidPerturbation
  rw [← add_sub_assoc, add_sub_cancel_left]

end NumStability.Leveque02Tracer
