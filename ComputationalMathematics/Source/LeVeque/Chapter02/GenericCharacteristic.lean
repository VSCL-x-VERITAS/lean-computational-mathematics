/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter02.GenericCharacteristicTarget

/-!
# Characteristic profile values

The existing polymorphic translated-profile identity supplies the audited
codomain generalization of LeVeque's scalar characteristic value statement.
This identity does not assert PDE solvability for arbitrary profile values.
-/

namespace NumStability.Leveque02Tracer

/-- The audited generalization of the source's straight-characteristic value. -/
theorem characteristicValue : genericCharacteristicValueTarget := by
  intro E profile velocity origin t
  exact travelingWave_at_translated_point profile velocity origin t

end NumStability.Leveque02Tracer
