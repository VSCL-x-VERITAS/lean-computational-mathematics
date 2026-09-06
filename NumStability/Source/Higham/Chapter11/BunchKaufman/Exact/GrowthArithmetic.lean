/-
Copyright (c) 2026. Released under Apache 2.0.
SPDX-License-Identifier: Apache-2.0
See LICENSES/Apache-2.0.txt.

# Exact-arithmetic completion for the literal Bunch--Kaufman producer

The rounded execution is also an exact execution when its floating-point
model has unit roundoff zero and every primitive is interpreted exactly.
This module proves that the total producer cannot take its explicit
two-by-two breakdown branch in that model.  The proof uses the nonsingularity
of the pivot selected by Algorithm 11.2, rather than assuming completion.
-/

import ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.GrowthArithmetic

/-!
Historical import path retained for compatibility.

The implementation is provided by `ComputationalMathematics.Source.Higham.Chapter11.BunchKaufman.Exact.GrowthArithmetic`.
Declaration names and mathematical terminology are unchanged.
-/
