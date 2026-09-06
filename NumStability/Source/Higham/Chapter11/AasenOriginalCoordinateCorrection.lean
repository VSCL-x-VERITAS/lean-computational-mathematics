/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Higham (2nd ed.) equation (11.15): original-coordinate corrected endpoint

For `P A Pᵀ = L T Lᵀ`, the final coordinate return is `x = Pᵀ w`, not
the printed `x = P w`.  This file transports the unconditional actual
`DGTTRF`/`DGTTRS` correction through a genuine permutation and gives the
nearby system in the original coordinates.  It deliberately does not use the
conditional printed-radius wrapper.
-/

import ComputationalMathematics.Source.Higham.Chapter11.AasenOriginalCoordinateCorrection

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.AasenOriginalCoordinateCorrection`.
Declaration names and mathematical terminology are unchanged.
-/
