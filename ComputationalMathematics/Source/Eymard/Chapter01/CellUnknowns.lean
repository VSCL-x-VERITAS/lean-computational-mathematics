/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.Eymard.Chapter01.CellUnknownsTarget

set_option autoImplicit false

namespace NumStability.Eymard.Chapter01

/-- Section 2.2's cell data are indexed by a natural time level and a cell. -/
theorem cellUnknowns : cellUnknownsTarget := by
  intro Cell State
  rfl

end NumStability.Eymard.Chapter01
