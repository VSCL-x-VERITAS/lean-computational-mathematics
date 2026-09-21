/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.IsentropicFlowTarget

/-!
# Isentropic flow
-/

namespace NumStability.Leveque02Tracer

/-- Pairwise constancy of entropy is equivalent to its range being a subsingleton. -/
theorem isIsentropic_iff_range_subsingleton : isIsentropicTarget := by
  intro State entropy
  constructor
  · intro h _ ha _ hb
    obtain ⟨a, rfl⟩ := ha
    obtain ⟨b, rfl⟩ := hb
    exact h a b
  · intro h a b
    exact h ⟨a, rfl⟩ ⟨b, rfl⟩

end NumStability.Leveque02Tracer
