/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.EndpointFluxTarget

/-!
# LeVeque's signed endpoint flux convention

The left endpoint contributes positive signed rightward flux to the segment;
the right endpoint contributes its negative. The magnitude clauses reuse the
ordinary real absolute-value identities.
-/

namespace NumStability.Leveque02Tracer

/-- Signed influx and magnitude in the explanation surrounding equation (2.2). -/
theorem endpointFluxSign : endpointFluxSignTarget := by
  intro leftFlux rightFlux t
  refine ⟨rfl, rfl, ?_⟩
  intro F
  exact ⟨fun h => abs_of_pos h, fun h => abs_of_neg h⟩

end NumStability.Leveque02Tracer
